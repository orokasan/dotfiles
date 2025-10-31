import { DduOptions, Item } from "jsr:@shougo/ddu-vim/types";
import { BaseSource } from "jsr:@shougo/ddu-vim/source";
import { Denops } from "jsr:@denops/std";
import * as fn from "jsr:@denops/std/function";
import { ActionData } from "../@ddu-kinds/himalaya.ts";
import { StringReader } from "https://deno.land/std@0.110.0/io/readers.ts";

type Params = {
  args: string[];
  page: number;
  folder: string;
};

export class Source extends BaseSource<Params> {
  override kind = "himalaya";

  gather(args: {
    denops: Denops;
    options: DduOptions;
    sourceParams: Params;
    input: string;
  }): ReadableStream<Item<ActionData>[]> {
    const abortController = new AbortController();

    const parse_json = (line: string): Item<ActionData>[] => {
      const jo = JSON.parse(line);
      return jo.map(
        (
          v: {
            flags: string[];
            has_attachment: boolean;
            from: { name: string; addr: string };
            subject: string;
            date: string;
            id: number;
            folder: string;
          },
        ) => {
          const seen = v.flags.includes("Seen") ? " " : "*";
          const answerd = v.flags.includes("Answered") ? "R" : " ";
          const att = v.has_attachment ? "A" : " ";

          const from = `<${v.from.name ?? v.from.addr}>`;
          const header =
            `[${seen}${answerd}${att}] ${v.subject} ${from} ${v.date}`;
          const word =
            `[${seen}${answerd}${att}] ${v.subject} ${from}<${v.from.addr}> ${v.date}`;
          return {
            word: word,
            display: header,
            action: {
              id: v.id,
              text: v.subject,
              date: v.date,
              address: v.from.addr,
              flag: v.flags,
              folder: args.sourceParams.folder,
            },
            highlights: [
              {
                name: "hl_himalaya_flag_start",
                hl_group: "Constant",
                col: 1,
                width: 1,
              },
              {
                name: "hl_himalaya_flag_end",
                hl_group: "Constant",
                col: 5,
                width: 1,
              },
              {
                name: "hl_himalaya_from",
                hl_group: "Comment",
                col: new StringReader(header).length -
                  new StringReader(from + v.date).length,
                width: new StringReader(from).length,
              },
              {
                name: "hl_himalaya_date",
                hl_group: "Function",
                col: new StringReader(header).length -
                  new StringReader(v.date).length + 1,
                width: new StringReader(v.date).length,
              },
            ],
          };
        },
      );
    };
    return new ReadableStream({
      async start(controller) {
        controller.enqueue([])

        const cmd = [
          "himalaya",
          "--output",
          "json",
          "envelope",
          "list",
          "--folder",
          args.sourceParams.folder,
          "--page-size",
          String(args.sourceParams.page),
          ...args.sourceParams.args,
        ];
        const cwd = await fn.getcwd(args.denops) as string;

        const proc = new Deno.Command(
          cmd[0],
          {
            args: cmd.slice(1),
            stdout: "piped",
            stderr: "piped",
            stdin: "null",
            cwd,
          },
        ).spawn();

        const { stdout } = await proc.output();
        const line = new TextDecoder().decode(stdout);
        const ret = line.length > 0 ? parse_json(line) : [];
        controller.enqueue(ret);
        controller.close();
      },

      cancel(reason): void {
        abortController.abort(reason);
      },
    });
  }

  params(): Params {
    return {
      args: [],
      folder: "INBOX",
      page: 300,
    };
  }
}

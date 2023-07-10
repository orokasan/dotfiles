import {
  BaseSource,
  DduOptions,
  Item,
} from "https://deno.land/x/ddu_vim@v2.9.0/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v2.9.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.0/file.ts";
import { join } from "https://deno.land/std@0.151.0/path/mod.ts";
import { abortable } from "https://deno.land/std@0.151.0/async/mod.ts";
import { StringReader } from "https://deno.land/std@0.110.0/io/mod.ts";
import { TextLineStream } from "https://deno.land/std@0.186.0/streams/mod.ts";

// based on https://github.com/shun/ddu-source-rg

const enqueueSize1st = 1000;

type HighlightGroup = {
  path: string;
  lineNr: string;
  word: string;
};

type Params = {
  args: string[];
  input: string;
  path: string;
  highlights: HighlightGroup;
};

async function* iterLine(r: ReadableStream<Uint8Array>): AsyncIterable<string> {
  const lines = r
    .pipeThrough(new TextDecoderStream())
    .pipeThrough(new TextLineStream());

  for await (const line of lines) {
    if ((line as string).length) {
      yield line as string;
    }
  }
}

export class Source extends BaseSource<Params> {
  kind = "file";

  gather(args: {
    denops: Denops;
    options: DduOptions;
    sourceParams: Params;
    input: string;
  }): ReadableStream<Item<ActionData>[]> {
    const abortController = new AbortController();

    const param = args.sourceParams;
    const hl_group_path = param.highlights.path ?? "";
    const hl_group_lineNr = param.highlights.lineNr ?? "";
    const hl_group_word = param.highlights.word ?? "";

    const parse_json = (line: string, cwd: string) => {
      line = line.trim();

      const jo = JSON.parse(line);
      if (jo.type !== "match") {
        return null;
      }
      const path = jo.data.path.text;
      const lineNr = jo.data.line_number;
      const col = jo.data.submatches[0].start;
      const text = jo.data.lines.text?.replace("\n", "");
      const header = `${path}:${lineNr}:${col}: `;
      return {
        word: header + text,
        action: {
          path: join(cwd, path),
          lineNr: lineNr,
          col: col + 1,
          text: text,
        },
        highlights: [
          {
            name: "path",
            "hl_group": hl_group_path,
            col: 1,
            width: new StringReader(path).length,
          },
          {
            name: "lineNr",
            "hl_group": hl_group_lineNr,
            col: path.length + 2,
            width: String(lineNr).length,
          },
          {
            name: "word",
            "hl_group": hl_group_word,
            col: header.length + col + 1,
            width: jo.data.submatches[0].end - col,
          },
        ],
      };
    };
    const re = /^([^:]+):(\d+):(\d+):(.*)$/;
    const parse_line = (line: string, cwd: string) => {
      line = line.trim();
      const result = line.match(re);
      const get_param = (ary: string[], index: number) => {
        return ary[index] ?? "";
      };

      const path = result ? get_param(result, 1) : "";
      const lineNr = result ? Number(get_param(result, 2)) : 0;
      const col = result ? Number(get_param(result, 3)) : 0;
      const text = result ? get_param(result, 4) : "";

      return {
        word: text,
        display: line,
        action: {
          path: join(cwd, path),
          lineNr: lineNr,
          col: col,
          text: text,
        },
      };
    };

    return new ReadableStream({
      async start(controller) {
        const input = args.sourceParams.input;

        if (input == "") {
          controller.close();
          return;
        }

        const cmd = [...args.sourceParams.args, input];
        const cwd = args.sourceParams.path != ""
          ? args.sourceParams.path
          : await fn.getcwd(args.denops) as string;

        let items: Item<ActionData>[] = [];
        const enqueueSize2nd = 100000;
        let enqueueSize = enqueueSize1st;
        let numChunks = 0;

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

        try {
          for await (
            const line of abortable(
              iterLine(proc.stdout),
              abortController.signal,
            )
          ) {
            if (args.sourceParams.args.includes("--json")) {
              const ret = parse_json(line, cwd);
              if (ret) {
                items.push(ret);
              }
            } else {
              items.push(parse_line(line, cwd));
            }
            if (items.length >= enqueueSize) {
              numChunks++;
              if (numChunks > 1) {
                enqueueSize = enqueueSize2nd;
              }
              controller.enqueue(items);
              items = [];
            }
          }
          if (items.length) {
            controller.enqueue(items);
          }
        } catch (e: unknown) {
          if (e instanceof DOMException) {
            proc.kill("SIGTERM");
          } else {
            console.error(e);
          }
        } finally {
          const status = await proc.status;
          if (!status.success) {
            for await (
              const mes of abortable(
                iterLine(proc.stderr),
                abortController.signal,
              )
            ) {
              console.error(mes);
            }
          }
          controller.close();
        }
      },

      cancel(reason): void {
        abortController.abort(reason);
      },
    });
  }

  params(): Params {
    return {
      args: ["rg", "--column", "--no-heading", "--color", "never"],
      input: "",
      path: "",
      highlights: {
        path: "Normal",
        lineNr: "Normal",
        word: "Search",
      },
    };
  }
}

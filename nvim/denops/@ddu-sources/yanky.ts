import { Context, Item } from "jsr:@shougo/ddu-vim/types";
import { BaseSource } from "jsr:@shougo/ddu-vim@~6.1.0/source";
import { Denops } from "jsr:@denops/std";
import type { ActionData } from "jsr:@shougo/ddu-kind-word";
import { StringReader } from "https://deno.land/std@0.110.0/io/readers.ts";

type Params = {
  "reg": string;
};

type YankedData = {
  filetype: string;
  regcontents: string;
  regtype: string;
};

export class Source extends BaseSource<Params> {
  override kind = "word";

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const items: Item<ActionData>[] = [];
        const data = await args.denops.call(
          "vimrc#yanky_history",
        ) as YankedData[];
        for (const i of data) {
          const word = i.regcontents.replace(/\r?\n/g, "").slice(0, 300)
          const regtype = (i.regtype == "v")
            ? "C"
            : (i.regtype == "V")
              ? "L"
              : "B"; // \<C-v> is Blockwise

          if (word.length == 0) continue

          items.push({
            word: word,
            display: `${regtype}: ${word}`,
            action: {
              text: i.regcontents,
              regType: i.regtype,
            },
            highlights: [
              {
                name: "attr",
                hl_group: "Function",
                col: 1,
                width: 3,
              },
            ],
          });
        }
        controller.enqueue(items);

        controller.close();
      },
    });
  }

  params(): Params {
    return {
      "reg": "",
    };
  }
}

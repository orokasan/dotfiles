import {
  BaseSource,
  Context,
  Item,
} from "https://deno.land/x/ddu_vim@v1.2.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v1.2.0/deps.ts";
import type { ActionData } from "https://raw.githubusercontent.com/Shougo/ddu-kind-word/master/denops/@ddu-kinds/word.ts";
import { StringReader } from "https://deno.land/x/std@0.110.0/io/readers.ts";

type Params = {
  "reg": string;
};

type YankedData = [[string], string, string];

export class Source extends BaseSource<Params> {
  kind = "word";

  // actions: Actions<Params> = {
  //   jump: async (args: {
  //     denops: Denops;
  //     items: DduItem[];
  //     actionParams: unknown;
  //   }) => {
  //     const action = args.items[0].action as ActionData;
  //     if (action.index < 0) {
  //       await args.denops.cmd(
  //         `execute "normal! ${-action.index}\\<C-o>"`,
  //       );
  //     } else {
  //       await args.denops.cmd(
  //         `execute "normal! ${action.index}\\<C-i>"`,
  //       );
  //     }
  //     return Promise.resolve(ActionFlags.None);
  //   },
  // };

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const items: Item<ActionData>[] = [];
        const data = await args.denops.call("miniyank#read") as YankedData[];
        for (const i of data) {
          const word = i[0].join("\\n").replace(/\r?\n/g, "");
          const regtype = (i[1] == "v") ? "c" : (i[1] == "V") ? "l" : "B"; // \<C-v> is Blockwise
          const reg = (args.sourceParams.reg ? i[2] + ": " : "");
          items.push({
            word: word,
            display: `${reg}${regtype}: ${word}`,
            action: {
              text: i[0],
              regType: i[1],
            },
            highlights: [
              {
                name: "word",
                hl_group: "Constant",
                col: 4,
                width: i[1] == "v" ? (new StringReader(word).length) : 0,
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

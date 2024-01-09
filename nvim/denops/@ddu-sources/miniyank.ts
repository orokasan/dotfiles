import {
  BaseSource,
  Context,
  Item,
} from "https://deno.land/x/ddu_vim@v2.7.1/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.7.1/deps.ts";
import type { ActionData } from "https://raw.githubusercontent.com/Shougo/ddu-kind-word/master/denops/@ddu-kinds/word.ts";
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
        const data = await args.denops.call(
          "vimrc#yanky_history",
        ) as YankedData[];
        for (const i of data) {
          const word = i.regcontents.replace(/\r?\n/g, "");
          const regtype = (i.regtype == "v") ? "c" : (i.regtype == "V") ? "l" : "B"; // \<C-v> is Blockwise
          items.push({
            word: word,
            display: `${regtype}: ${word}`,
            action: {
              text: i.regcontents,
              regType: i.regtype,
            },
            highlights: [
              {
                name: "word",
                hl_group: "Function",
                col: 1,
                width: i.regtype == "v" ? (new StringReader(word).length) + 3 : 0,
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

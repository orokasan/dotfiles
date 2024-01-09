import {
  ActionFlags,
  Actions,
  BaseSource,
  Context,
  DduItem,
  Item,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v1.13.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v1.13.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.0/file.ts";
import { fn } from "https://deno.land/x/ddu_vim@v1.13.0/deps.ts";
import { StringReader } from "https://deno.land/std@0.110.0/io/readers.ts";

type HighlightGroup = {
  level0: string;
  level1: string;
  level2: string;
  level3: string;
};

type Params = {
  path: string;
  highlights: HighlightGroup;
};

type AerialItem = {
  // children?: AerialItem[];
  col: number;
  // end_col: number;
  // end_lnum: number;
  lnum: number;
  idx: number;
  // kind: string;
  level: number;
  name: string;
  parent?: AerialItem;
  // scope: "private" | "protected" | "public" | null;
  // selection_range?: [];
};

export class Source extends BaseSource<Params> {
  kind = "file";
  word = [];
  private aerialData: AerialItem[] = [];
  actions: Actions<Params> = {
    jump: async (args: { denops: Denops; items: DduItem[] }) => {
      const action = args.items[0]?.action as ActionData;
      const lineNr = action.lineNr;
      await args.denops.call("cursor", lineNr, 0);
      await args.denops.cmd("norm! zz");
      return Promise.resolve(ActionFlags.Persist);
    },
  };

  async onInit(args: {
    denops: Denops;
  }): Promise<void> {
    this.aerialData = await args.denops.eval(
      `luaeval("require('aerial.ddu').get_labels()")`,
    ) as AerialItem[];
  }
  async checkItems(args: {
    denops: Denops;
  }): Promise<void> {
    this.aerialData = await args.denops.eval(
      `luaeval("require('aerial.ddu').get_labels()")`,
    ) as AerialItem[];
  }

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
    sourceOptions: SourceOptions;
  }): ReadableStream<Item<ActionData>[]> {
    const res = this.aerialData;
    return new ReadableStream({
      async start(controller) {
        if (res === null) {
          return controller.close();
        }
        const tree = async () => {
          const items: Item<ActionData>[] = [];
          const parent_name = (i: AerialItem): string => {
            if (!i.parent) {
              return i.name;
            } else {
              return parent_name(i.parent) + "/" + i.name;
            }
          };
          for await (const item of res) {
            const bufnr = args.context.bufNr;
            const bufname = await fn.bufname(args.denops, bufnr);
            const word = item.name;
            items.push({
              word: parent_name(item),
              display: " ".repeat(item.level) + word,
              action: {
                path: bufname,
                bufNr: bufnr,
                lineNr: item.lnum,
                col: item.col + 1,
              },
              highlights: [
                {
                  name: `aerial_level${item.level}`,
                  hl_group: args.sourceParams.highlights[`level${item.level}`],
                  col: 1,
                  width: new StringReader(word).length + 1,
                },
              ],
              // isTree: true,
              // isExpanded: args.sourceOptions.path.length === 0,
            });
          }
          // for (const i of items) {
          //   console.log(i.highlights)
          //   // .filter((v) => {
          //   //   console.log(v.hl_group.length);
          //   //   // if (v.hl_group.length == 0) {
          //   //   //   // console.log(i)
          //   //   // }
          //   // }));
          // }
          return items;
        };
        controller.enqueue(await tree());
        controller.close();
      },
    });
  }
  params(): Params {
    return {
      path: "",
      highlights: {
        level0: "Constant",
        level1: "Function",
        level2: "Normal",
        level3: "Normal",
      },
    };
  }
}

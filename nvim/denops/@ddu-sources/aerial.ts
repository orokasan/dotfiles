import {
  ActionFlags,
  Actions,
  BaseSource,
  Context,
  DduItem,
  Item,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v3.10.0/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.10.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.3/file.ts";
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
  // parent?: AerialItem;
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
    highlight: async (args: { denops: Denops; items: DduItem[] }) => {
      const action = args.items[0]?.action as ActionData;
      const bufwinid = await args.denops.call("bufwinid", action.bufNr);
      await args.denops.call("nvim_win_set_cursor", bufwinid, [
        action.lineNr,
        action.col,
      ]);
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
        const bufnr = args.context.bufNr;
        const bufname = await fn.bufname(args.denops, bufnr);

        const makeTreepath = (cur: AerialItem, items: Item<ActionData>[]) => {
          const tpath = [];

          for (let k = cur.level; k >= 0; k--) {
            if (cur.level === k) {
              tpath.unshift(cur.name);
            }
            const lastItem = items.findLast((i) => (i.level == k - 1));

            if (lastItem) {
              tpath.unshift(lastItem.treePath[lastItem.treePath.length - 1]);
            }
          }
          return ["/"].concat(tpath);
        };

        const tree = () => {
          const items: Item<ActionData>[] = [];
          for (const item of res) {
            const word = item.name;
            const lev = item.level > 3 ? 3 : item.level;
            const aerialLevel = `level${lev}`;
            items.push({
              word: makeTreepath(item, items).join(""),
              display: " ".repeat(item.level) + word,
              action: {
                path: bufname,
                bufNr: bufnr,
                lineNr: item.lnum,
                col: item.col + 1,
              },
              treePath: makeTreepath(item, items),
              highlights: [
                {
                  name: `aerial_level${item.level}`,
                  hl_group: args.sourceParams.highlights[aerialLevel],
                  col: 1,
                  width: 999,
                },
              ],
              isTree: true,
              isExpanded: true,
              level: item.level,
            });
          }
          if (args.sourceOptions.path) {
            return items.filter((i) => {
              return i.treePath.toString().startsWith(
                args.sourceOptions.path.toString(),
              ) && i.treePath.length > args.sourceOptions.path.length;
            });
          }
          return items;
        };
        controller.enqueue(tree());
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

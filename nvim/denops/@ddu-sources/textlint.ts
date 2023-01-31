import {
  ActionFlags,
  Actions,
  BaseSource,
  Context,
  DduItem,
  Item,
} from "https://deno.land/x/ddu_vim@v1.13.0/types.ts#^";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v1.13.0/deps.ts#^";
import { basename } from "https://deno.land/std@0.152.0/path/mod.ts";

type Params = Record<never, never>;

enum TYPE_DIAGNOSTICS {
  "Undefined",
  "Error",
  "Warning",
  "Information",
  "Hint",
}

enum HIGHLIGHT_DIAGNOSTICS {
  "Undefined",
  "DiagnosticError",
  "DiagnosticWarn",
  "DiagnosticInfo",
  "DiagnosticHint",
}

type DiagnosticItems = {
  lnum: number;
  col: number;
  bufnr: number;
  severity: number;
  message: string;
  source?: string;
}[] | null;

export type ActionData = {
  bufNr: number;
  col: number;
  lineNr: number;
  path: string;
  text?: string;
  before?: string;
  after?: string;
};

export class Source extends BaseSource<Params> {
  kind = "file";
  actions: Actions<Params> = {
    preview: async (args: { denops: Denops; items: DduItem[] }) => {
      const action = args.items[0]?.action as ActionData
      const lineNr = action.lineNr
      await args.denops.call("cursor", lineNr, 0);
      await args.denops.cmd("norm! zz");
      return Promise.resolve(ActionFlags.Persist);
    },

    replace: async (args: { denops: Denops; items: DduItem[] }) => {
      const action = args.items[0]?.action as ActionData
      const lineNr = action.lineNr
      const bufNr = action.bufNr
      const bufline = await args.denops.call(
        "getbufline",
        bufNr,
        lineNr,
      ) as string[];

      const after = action.after
      const before = action.before
      if (after && before){
        const rep = bufline[0].replace(before, after);
        await args.denops.call("setbufline", bufNr, lineNr, rep);
        await args.denops.call("cursor", lineNr, 0);
      }
      // await args.denops.call("win_execute",await args.denops.call("bufwinid", bufNr) ,"write")
      return Promise.resolve(ActionFlags.Persist);
    },
  };

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const res = await args.denops.eval(
          `luaeval("require'lsp_ddu'.diagnostic_buffer(${args.context.bufNr})")`,
        ) as DiagnosticItems;
        if (res === null) {
          return controller.close();
        }
        const bufline = await args.denops.call(
          "getbufline",
          args.context.bufNr,
          1,
          "$",
        ) as string[];
        const tree = async () => {
          const items: Item<ActionData>[] = [];
          for await (const item of res) {
            const bufname = await fn.bufname(args.denops, item.bufnr);
            const mes = item.message.replace(/\r?\n/g, " | ");
            const before = mes.match(/\s(.*)\s=>/)?.[1];
            const after = mes.match(/=>\s(.*)/)?.[1];

            const word = `${
              basename(bufname)
            }:${item.lnum}:${item.col} ${mes} [${
              TYPE_DIAGNOSTICS[item.severity]
            }]`;
            const lnum = item.lnum + 1;
            const col = item.col + 1;
            items.push({
              word: bufline[item.lnum],
              display: word,
              highlights: [{
                name: TYPE_DIAGNOSTICS[item.severity],
                "hl_group": HIGHLIGHT_DIAGNOSTICS[item.severity],
                col: 1,
                width:
                  (new Blob([`${basename(bufname)}:${item.lnum}:${item.col}`]))
                    .size,
              }],
              action: {
                path: bufname,
                bufNr: item.bufnr,
                lineNr: lnum,
                col: col,
                before: before,
                after: after,
              },
            });
          }
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
    };
  }
}

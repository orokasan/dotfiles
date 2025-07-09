import {
  ActionFlags,
  Actions,
  Context,
  DduItem,
  Item,
} from "jsr:@shougo/ddu-vim/types";
import { BaseSource } from "jsr:@shougo/ddu-vim/source";
import * as LSP from "npm:vscode-languageserver-types@3.17.6-next.1";
import { Denops } from "jsr:@denops/std";
import * as fn from "jsr:@denops/std/function";
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

function get_string_byte_count(str: string) {
  const blob = new Blob([str], { type: "text/plain" });
  return blob.size;
}

export type ActionData = {
  bufNr: number;
  col: number;
  lineNr: number;
  path: string;
  text?: string;
  before?: string;
  after?: string;
};

type NvimLspDiagnostic =
  & Pick<LSP.Diagnostic, "message" | "severity" | "source" | "code">
  & {
    bufnr: number;
    lnum: number;
    end_lnum: number;
    col: number;
    end_col: number;
  };

export class Source extends BaseSource<Params> {
  override kind = "file";
  override actions: Actions<Params> = {
    highlight: async (args: { denops: Denops; items: DduItem[] }) => {
      const action = args.items[0]?.action as ActionData;
      const bufwinid = await fn.bufwinid(args.denops, action.bufNr);
      await args.denops.call("nvim_win_set_cursor", bufwinid, [
        action.lineNr,
        action.col,
      ]);
      return Promise.resolve(ActionFlags.Persist);
    },

    replace: async (args: { denops: Denops; items: DduItem[] }) => {
      const action = args.items[0]?.action as ActionData;
      const lineNr = action.lineNr;
      const bufNr = action.bufNr;
      const bufline = await fn.getbufline(
        args.denops,
        bufNr,
        lineNr,
      );

      const after = action.after;
      const before = action.before;

      if (after && before) {
        const reg = new RegExp(before, "g");
        let i = 0;
        while (reg.exec(bufline[0]) !== null) {
          i = i + 1;
          if (reg?.lastIndex < action.col / 3) continue;
          const rep = bufline[0].replace(reg, (match) => {
            if (--i == 0) return after;
            else return match;
          });
          await fn.setbufline(args.denops, bufNr, lineNr, rep);
          break;
        }
      }
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
        const res = await args.denops.call(
          `luaeval`,
          `vim.diagnostic.get(${args.context.bufNr})`,
        ) as NvimLspDiagnostic[] | null;
        if (res === null) {
          return controller.close();
        }
        const bufline = await fn.getbufline(
          args.denops,
          args.context.bufNr,
          1,
          "$",
        );
        const tree = async () => {
          const items: Item<ActionData>[] = [];
          for await (const item of res) {
            const bufname = await fn.bufname(args.denops, item.bufnr);
            const mes = item.message.replace(/\r?\n/g, " | ");
            const before = mes.match(/(.*) =>/)?.[1];
            const after = mes.match(/=>\s(.*)/)?.[1].replace(/\s+\|.*$/, "");
            const severity = item.severity ?? 4;

            const word = `${
              basename(bufname)
            }:${item.lnum}:${item.col} ${mes} [${TYPE_DIAGNOSTICS[severity]}]`;
            const lnum = item.lnum + 1;
            const col = item.col + 1;
            items.push({
              word: bufline[item.lnum],
              display: word,
              highlights: [{
                name: TYPE_DIAGNOSTICS[severity],
                "hl_group": HIGHLIGHT_DIAGNOSTICS[severity],
                col: 1,
                width: get_string_byte_count(
                  `${basename(bufname)}:${item.lnum}:${item.col}`,
                ),
              }],
              action: {
                path: bufname,
                bufNr: item.bufnr,
                lineNr: lnum,
                col: col,
                before: before ?? "",
                after: after ?? "",
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

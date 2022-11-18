import {
  BaseSource,
  Item,
} from "https://deno.land/x/ddu_vim@v1.10.1/types.ts#^";
import {
  basename,
  Denops,
  fn,
} from "https://deno.land/x/ddu_vim@v1.10.1/deps.ts";
import { ActionData as FileActionData } from "https://deno.land/x/ddu_kind_file@v0.3.0/file.ts#^";
import {
  ActionFlags,
  Actions,
  DduItem,
} from "https://deno.land/x/ddu_vim@v1.10.1/types.ts";

type Params = Record<never, never>;

type ActionData = FileActionData & {
  index: number;
};

type JumpList = {
  lnum: number;
  bufnr: number;
  col: number;
  coladd: number;
};

function get_string_byte_count(str: string) {
  const blob = new Blob([str], {type: 'text/plain'});
  return blob.size;
}

export class Source extends BaseSource<Params> {
  kind = "file";
  private jumplist: JumpList[] = [];
  private pointer = 0;
  async onInit(args: { denops: Denops; sourceParams: Params }): Promise<void> {
    [this.jumplist, this.pointer] = await fn.getjumplist(args.denops) as [
      JumpList[],
      number,
    ];
  }

  actions: Actions<Params> = {
    jump: async (args: {
      denops: Denops;
      items: DduItem[];
      actionParams: unknown;
    }) => {
      const action = args.items[0].action as ActionData;
      if (action.index < 0) {
        await args.denops.cmd(
          `execute "normal! ${-action.index}\\<C-o>"`,
        );
      } else {
        await args.denops.cmd(
          `execute "normal! ${action.index}\\<C-i>"`,
        );
      }
      return Promise.resolve(ActionFlags.None);
    },
  };

  gather(args: {
    denops: Denops;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    const list = this.jumplist;
    const pointer = this.pointer;
    return new ReadableStream({
      async start(controller) {
        // Note: rviminfo! is broken in Vim8 before 8.2.2494
        if (
          await fn.has(args.denops, "nvim") ||
          await fn.has(args.denops, "patch-8.2.2494")
        ) {
          await args.denops.cmd("wviminfo | rviminfo!");
        }

        const result: [Item<ActionData>, number][] = await Promise.all(
          list.map(async (v, i) => {
            const info = await fn.getbufinfo(args.denops, v.bufnr) as [
              { bufnr: number; loaded: boolean; name: string },
              number,
            ];
            const path = info[0].name;
            const text = info[0].loaded
              ? await fn.getbufline(args.denops, v.bufnr, v.lnum)
              : "--- not loaded ---";
            const index = i - pointer;
            const index_len = String(list.length).length
            return [ {
              word: path,
              display: `${index == 0 ? ">" : " "}${
                String(Math.abs(index)).padStart(index_len)
              } ${basename(path)}:${v.lnum}:${v.col}: ${text}`,
              action: {
                path: path,
                lineNr: v.lnum,
                col: v.col,
                index: index,
              },
              highlights: [
                {
                  name: "jump_path",
                  "hl_group": "Comment",
                  col: index_len + 2,
                  width: get_string_byte_count(basename(path)) + 1,
                },
                {
                  name: "jump_lineNr",
                  "hl_group": "LineNr",
                  col: index_len + get_string_byte_count(basename(path)) + 4,
                  width: String(v.lnum).length,
                },
                {
                  name: "mark",
                  "hl_group": "Title",
                  col: 1,
                  width: index == 0 ? 1 : 0,
                },
              ],
            }, i];
          }),
        );
        controller.enqueue(
          result.sort((a, b) => a[1] - b[1]).reverse().map((v) => v[0]),
        );
        controller.close();
      },
    });
  }

  params(): Params {
    return {};
  }
}

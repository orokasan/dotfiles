import {
  ActionFlags,
  Actions,
  Context,
  DduItem,
  Item,
} from "jsr:@shougo/ddu-vim/types";
import { BaseSource } from "jsr:@shougo/ddu-vim/source";
import { Denops } from "jsr:@denops/std";
import type { ActionData } from "jsr:@shougo/ddu-kind-file";

type Params = Record<never, never>;

type SearchResult = [
  number,
  number,
  string,
][];

function get_string_byte_count(str: string) {
  const blob = new Blob([str], { type: "text/plain" });
  return blob.size;
}

export class Source extends BaseSource<Params> {
  override kind = "file";
  private lines: SearchResult = [];
  private word = "";
  override actions: Actions<Params> = {
    echo: async function (args: { denops: Denops; items: DduItem[] }) {
      const lineNr = (args.items[0].action as ActionData).lineNr;
      const bufNr = (args.items[0].action as ActionData).bufNr;
      await args.denops.call("setbufline", bufNr, lineNr, "hoge");
      return Promise.resolve(ActionFlags.RefreshItems);
    },
  };

  override async onInit(args: {
    denops: Denops;
  }): Promise<void> {
    this.word = await args.denops.eval("@/") as string;
    this.lines = await args.denops.call(
      "searchres#getsearchresult",
      this.word,
    ) as SearchResult;
  }

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    const word = this.word as string;
    const lines = this.lines;
    return new ReadableStream({
      async start(controller) {
        const bufnr = args.context.bufNr;
        const winid = args.context.winId;
        const winwidth = await args.denops.call("winwidth", winid) as number;
        const items: Item<ActionData>[] = [];
        const aword = word.replaceAll(new RegExp("\\\\\\w", "ig"), "")
          .replaceAll("\\<", "").replaceAll("\\>", "");
        const byte_word = get_string_byte_count(aword);

        for (const i of lines) {
          const paddingLineNr = i[0].toString().padStart(3);
          const searched_word_pos = `${paddingLineNr}:`.length + i[1] + 1;
          const search_word_char_pos = await args.denops.call(
            "searchres#getTrimPos",
            i[2],
            searched_word_pos,
          ) as number;
          const trimed_word = "..." + i[2].slice(search_word_char_pos - 10);
          const item = {
            word: i[2],
            display: `${paddingLineNr}: ${
              (searched_word_pos > winwidth) ? trimed_word : i[2]
            }`,
            action: {
              bufNr: bufnr,
              path: await args.denops.call("bufname", bufnr) as string,
              lineNr: i[0],
              col: i[1],
              text: aword,
            },
            highlights: [
              {
                name: "word",
                hl_group: "Error",
                col: searched_word_pos < winwidth
                  ? searched_word_pos
                  : get_string_byte_count(trimed_word.slice(0, 13)),
                width: byte_word,
              },
              {
                name: "lnum",
                hl_group: "Constant",
                col: 1,
                width: get_string_byte_count(paddingLineNr),
              },
            ],
          };
          if (searched_word_pos > winwidth) {
            item.highlights.push({
              name: "dot",
              hl_group: "Comment",
              col: 6,
              width: 3,
            });
          }
          items.push(item);
        }
        controller.enqueue(items);

        controller.close();
      },
    });
  }

  params(): Params {
    return {};
  }
}

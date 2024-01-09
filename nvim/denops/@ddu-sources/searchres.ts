import {
  ActionFlags,
  Actions,
  BaseSource,
  Context,
  DduItem,
  Item,
} from "https://deno.land/x/ddu_vim@v1.13.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v1.2.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.2/file.ts";

type Params = Record<never, never>;

function get_string_byte_count(str: string) {
  const blob = new Blob([str], { type: "text/plain" });
  return blob.size;
}

export class Source extends BaseSource<Params> {
  kind = "file";
  private lines = [0, 0, ""];
  private word = "";
  actions: Actions<Params> = {
    echo: async function(args: { denops: Denops; items: DduItem[]; }) {
      const lineNr = args.items[0].action.lineNr;
      const bufNr = args.items[0].action.bufNr;
      args.denops.call("setbufline", bufNr, lineNr, "hoge");
      return Promise.resolve(ActionFlags.RefreshItems);
    },
  };

  async onInit(args: {
    denops: Denops;
  }): Promise<void> {
    this.word = await args.denops.eval("@/") as string;
    this.lines = await args.denops.call(
      "searchres#getsearchresult",
      this.word,
    ) as [number, number, string];
  }

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    const word = this.word as string;
    const lines = this.lines as [];
    return new ReadableStream({
      async start(controller) {
        const bufnr = args.context.bufNr;
        const winid = args.context.winId
        const winwidth = await args.denops.call("winwidth", winid) as number
        const items: Item<ActionData>[] = [];
        const aword = word.replaceAll("\\<", "").replaceAll("\\>", "");
        const byte_word = get_string_byte_count(aword)

        for (const i of lines) {
        const searched_word_pos = `${i[0]}:`.length + i[1] + 1
          items.push({
            word: i[2],
            display: `${i[0]}: ${(searched_word_pos > winwidth) ? i[2].slice(searched_word_pos-10) : i[2]}`,
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
                hl_group: "Function",
                col: searched_word_pos,
                width: byte_word,
              },
              {
                name: "lnum",
                hl_group: "Constant",
                col: 1,
                width: get_string_byte_count(i[0]),
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
    return {};
  }
}

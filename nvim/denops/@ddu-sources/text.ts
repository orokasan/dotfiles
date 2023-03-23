import {
  BaseSource,
  Context,
  Item,
} from "https://deno.land/x/ddu_vim@v1.13.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v1.13.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.1/file.ts";

type Params = Record<never, never>;

function get_string_byte_count(str: string) {
  const blob = new Blob([str], {type: 'text/plain'});
  return blob.size;
}

export class Source extends BaseSource<Params> {
  kind = "file";
  private lines = [0, 0, ""];
  private word = "";

  async onInit(args: {
    denops: Denops;
    }
  ): Promise<void>{
        this.word = "^■"
        this.lines = await args.denops.call('searchres#getsearchresult', this.word) as [number, number, string]
  }

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    const word = this.word as string
    const lines = this.lines
    return new ReadableStream({
      async start(controller) {
        const bufnr = args.context.bufNr;
        const items: Item<ActionData>[] = [];
        for (const i of lines) {
            const level = (i[2] as string).match('^■\+')[0].length

          items.push({
            word: i[2],
            display: `${i[2]}`,
            action: {
              bufNr: bufnr,
              path: await args.denops.call('bufname', bufnr) as string,
              lineNr: i[0],
              col: i[1]
            },
            highlights: [
              {
                name: "header",
                hl_group: "Title",
                col: 1,
                width: level >= 3 ? 9 : 0
              },
            ],
            level: level - 1,
            isExpanded: true,
            isTree: true,
          },
                    );
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

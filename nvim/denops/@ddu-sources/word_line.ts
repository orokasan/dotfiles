import {
  BaseSource,
  Context,
  Item,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v2.2.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.2.0/deps.ts";
import type { ActionData } from "https://raw.githubusercontent.com/Shougo/ddu-kind-word/master/denops/@ddu-kinds/word.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params> {
  override kind = "word";

  override gather(args: {
    denops: Denops;
    context: Context;
    sourceOptions: SourceOptions;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const rawContent = await Deno.readFile(args.sourceOptions.path);
        const decoder = new TextDecoder("utf-8");
        const lines = decoder.decode(rawContent).split("\n");

        controller.enqueue(lines.map((line) => {
          return {
            word: line,
            action: {
              text: line,
              regType: "c",
            },
          };
        }));

        controller.close();
      },
    });
  }

  override params(): Params {
    return {};
  }
}

import * as depsTs from "https://deno.land/x/ddu_vim@v2.2.0/deps.ts";
import * as typesTs from "https://deno.land/x/ddu_vim@v2.2.0/types.ts";
import type { ActionData } from "https://raw.githubusercontent.com/Shougo/ddu-kind-word/master/denops/@ddu-kinds/word.ts";

type Params = Record<never, never>;

type NewType = depsTs.Denops;

export class Source extends typesTs.BaseSource<Params> {
  kind = "word";

  gather({ args }: {
    args: {
      denops: NewType;
      context: typesTs.Context;
      sourceOptions: typesTs.SourceOptions;
    };
  }): ReadableStream<typesTs.Item<ActionData>[]> {
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

  params(): Params {
    return {};
  }
}

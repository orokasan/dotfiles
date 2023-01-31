import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v0.13/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v0.13/deps.ts";

type Params = {
  highlightMatched: string;
};

export class Filter extends BaseFilter<Params> {
  async filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    filterParams: Params;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const input = args.input;
    if (!input) {
      return Promise.resolve(args.items);
    }
    const items = await args.denops.call(
      "matchfuzzypos",
      args.items,
      args.input,
      { "key": "matcherKey" },
    );

    const inputWidth = await fn.strwidth(args.denops, input) as number;
    return Promise.resolve(
      items[0].map(
        (item) => {
          const display = item.display ?? item.word;
          const matcherKey = args.sourceOptions.ignoreCase
            ? display.toLowerCase()
            : display;
          const start = matcherKey.indexOf(input);

          if (start >= 0) {
            const highlights = item.highlights?.filter((hl) =>
              hl.name != "matched"
            ) ?? [];
            highlights.push({
              name: "matched",
              "hl_group": args.filterParams.highlightMatched,
              col: start + 1,
              width: inputWidth,
            });
            return {
              ...item,
              highlights: highlights,
            };
          } else {
            return item;
          }
        },
      ),
    );
  }

  params(): Params {
    return {
      highlightMatched: "Title",
    };
  }
}

import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v0.14/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v0.14/deps.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    return Promise.resolve([
      ...(new Map(args.items.map((o) => [o.word, o]))).values(),
    ].reverse());
  }

  params(): Params {
    return {};
  }
}

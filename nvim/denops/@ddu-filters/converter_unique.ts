import {
  DduItem,
  SourceOptions,
} from "jsr:@shougo/ddu-vim/types";
import { BaseFilter } from "jsr:@shougo/ddu-vim/filter";
import { Denops } from "jsr:@denops/std";

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
    ]);
  }

  params(): Params {
    return {};
  }
}

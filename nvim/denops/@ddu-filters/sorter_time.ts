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
    // if (!args.input){
      return Promise.resolve(args.items.sort((SortArray)))

    // } else {
    //   return Promise.resolve(args.items)
    // };
  }

  params(): Params {
    return {};
  }
}

function SortArray(x, y){
    if (x.status.time < y.status.time) {return 1;}
    if (x.status.time > y.status.time) {return -1;}
    return 0;
}

import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v1.10.1/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v0.14/deps.ts";
import { SEP } from "https://deno.land/std@0.132.0/path/mod.ts"

type Params = {
  mes: string;
}

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    filterParams: Params;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const items = args.items
    if (items.length > 0) {
      return Promise.resolve(items)
    }
    items.push({
            word: args.filterParams.mes,
            matcherKey: "",
            kind: "file",
            __sourceName: "file",
            __sourceIndex: 0,
            __level: 0,
            __expanded: false,
            action: {
              path: args.sourceOptions.path + SEP + 'empty',
            },
    })
    return Promise.resolve(items);
  }

  params(): Params {
    return {
      mes: ""
    };
  }
}

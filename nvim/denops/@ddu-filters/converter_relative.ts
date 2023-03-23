import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v2.2.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.2.0/deps.ts";
import { relative } from "https://deno.land/std@0.145.0/path/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.0/file.ts#^";
import { fn } from "https://deno.land/x/ddu_vim@v1.8.7/deps.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  async filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const dir = await fn.getcwd(args.denops) as string;
    const items = args.items;
    items.filter((item) => {
      const action = item.action as ActionData;
      if (!action.path) return false;
      const relpath = relative(dir, action.path);
      if (item.word == action.path) {
        item.word = relpath;
        item.matcherKey = relpath;
        if (item.display) {
          const prevHighlightLength = item.display.length
          item.display = item.display.replace(action.path, relpath);
          const CurHighlightLength = item.display.length
          item.highlights?.filter( (i) => {
            const highlight_col = i.col - (prevHighlightLength - CurHighlightLength)
            i.col = highlight_col >= 0 ? highlight_col : 0
          } )
        }
      }
    });
    return Promise.resolve(items);
  }

  params(): Params {
    return {};
  }
}

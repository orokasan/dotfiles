import { BaseFilter, DduItem, SourceOptions } from "https://deno.land/x/ddu_vim@v0.1.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v0.1.0/deps.ts";

export function fuzzyEscape(str: string): string {
  // escape special letters
  let p = str.replaceAll(/[.*+?^=!:${}()|[\]\/\\]/g, "\\$&");
  p = p.replaceAll(/([a-zA-Z0-9])/g, "$1.*");
  p = p.replaceAll(/\s/g, "");
  p = p.replaceAll(/([a-zA-Z0-9_])\.\*/g, "$1[^$1]*");
  return p;
}

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const input = args.input;
    let pattern: RegExp;
    pattern = new RegExp(
      fuzzyEscape(input),
    );

    return Promise.resolve(args.items.filter(
      (item) => item.matcherKey.toLowerCase().search(pattern) != -1,
    ));
  }

  params(): Params {
    return {};
  }
}

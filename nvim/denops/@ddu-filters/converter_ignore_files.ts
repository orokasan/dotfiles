import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v1.8.7/types.ts";
import {
  basename,
  extname,
  toFileUrl,
} from "https://deno.land/std@0.149.0/path/mod.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v1.8.7/deps.ts";
import { globToRegExp, GlobOptions } from "https://deno.land/std@0.95.0/path/glob.ts";
import { assertEquals } from "https://deno.land/std/testing/asserts.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
// const glob = ".*,NTUSER*,desktop.ini,__pycache__,*.aux,*.dvi,*.bbl,*.out,*.fdb_latexmk,*.bst,*.blg,*.toc,*.ini".split(",")
  }

  params(): Params {
    return {};
  }
}
// Deno.test("sum() adds given numbers", () => {
//   const actual = BaseFilter.filter(1, 2);
//   const expected = 3;
//   assertEquals(actual, expected);
// });

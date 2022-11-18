import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v2.5.2/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.5.2/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.1/file.ts#^";
import { basename, dirname } from "https://deno.land/std@0.142.0/path/mod.ts";
import {
  globToRegExp,
} from "https://deno.land/std@0.95.0/path/glob.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  // deno-lint-ignore require-await
  async filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    // const o: GlobOptions = { caseInsensitive: true };
    const glob =
      "NTUSER*,desktop.ini,__pycache__,*.aux,*.dvi,*.bbl,*.out,*.fdb_latexmk,*.bst,*.blg,*.toc,*.ini".split(",");
    const re = glob.map((v) => globToRegExp(v, {caseInsensitive: true}));
    return Promise.resolve(args.items.filter(
      (item) => {
        const action = item.action as ActionData;
        if (!action.path) return false;
        for (const r of re) {
          if (r.test(basename(action.path))) return false;
        }
        return args.input.includes(".") ||
          (!basename(action.path).startsWith(".") &&
            !basename(dirname(action.path)).startsWith(".") &&
            !item.matcherKey.startsWith("."));
      },
    ));
  }

  params(): Params {
    return {};
  }
}

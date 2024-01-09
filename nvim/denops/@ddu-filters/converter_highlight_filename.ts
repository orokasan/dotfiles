import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v3.9.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v3.9.0/deps.ts";
import { basename } from "https://deno.land/std@0.138.0/path/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts#^";

type Params = Record<never, never>;

function get_string_byte_count(str: string) {
  const blob = new Blob([str], { type: "text/plain" });
  return blob.size;
}

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    return Promise.resolve(args.items.filter((v) => {
      const action = v.action as ActionData;
      if (!v.highlights) v.highlights = [];
      v.highlights.push(
        (!action?.isDirectory)
          ? {
            name: "hl_dirname",
            hl_group: "Function",
            col: 1,
            width: get_string_byte_count(v.display ?? v.word) -
              get_string_byte_count(basename(v.display ?? v.word)),
          }
          : {
            name: "hl_dirname",
            hl_group: "Function",
            col: 1,
            width: get_string_byte_count(v.display ?? v.word),
          },
      );
      return true;
    }));
  }

  params(): Params {
    return {};
  }
}

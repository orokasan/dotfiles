import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";
import { FilterArguments } from "https://deno.land/x/ddu_vim@v3.2.7/base/filter.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.2/file.ts#^";
import { Denops } from "https://deno.land/x/ddu_vim@v0.14/deps.ts";
import { Item } from "https://deno.land/x/ddu_vim@v1.13.0/types.ts";

type Params = Record<never, never>;

function get_string_byte_count(str: string) {
  const blob = new Blob([str], { type: "text/plain" });
  return blob.size;
}

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const items = args.items;
    return Promise.resolve(items.filter((i) => {
      const action = i.action as ActionData;
      if (!i.highlights) i.highlights = [];
      i.display = `${action?.lineNr}: ${i.word}`;
      const aword = action.text?.replaceAll("\\<", "").replaceAll("\\>", "");
      i.highlights.push(
        {
          name: "word",
          hl_group: "Function",
          col: `${action?.lineNr}:`.length + (action?.col ?? 0) + 1,
          width: get_string_byte_count(aword),
        },
        {
          name: "lnum",
          hl_group: "Constant",
          col: 1,
          width: get_string_byte_count(action?.lineNr),
        },
      );
      return true;
    }));
  }

  params(): Params {
    return {};
  }
}

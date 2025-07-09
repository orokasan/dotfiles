import { DduItem, SourceOptions } from "jsr:@shougo/ddu-vim/types";
import { BaseFilter } from "jsr:@shougo/ddu-vim/filter";
import { Denops } from "jsr:@denops/std";
import { basename } from "jsr:@std/path";
import { ActionData } from "jsr:@shougo/ddu-kind-file";

type Params = Record<never, never>;

function get_string_byte_count(str: string) {
  const blob = new Blob([str], { type: "text/plain" });
  return blob.size;
}

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    filterParams: Params;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    if (args.items.length > 1000) return Promise.resolve(args.items);

    return Promise.resolve(args.items.filter((v) => {
      const action = v.action as ActionData;
      if (!action || !action.path) return true;
      if (!v.highlights) v.highlights = [];
      const display = v.display ?? v.word;
      const width = get_string_byte_count(display) -
        get_string_byte_count(basename(display)) - 1;
      if (width > 0 || action.isDirectory) {
        v.highlights.push(
          {
            name: "hl_dirname",
            hl_group: "Function",
            col: 1,
            width: width,
          },
        );
      }
      return true;
    }));
  }

  params(): Params {
    return {};
  }
}

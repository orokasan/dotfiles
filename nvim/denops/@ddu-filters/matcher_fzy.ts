/*
MIT License

Copyright (c) 2022 Haruki Matsui

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import {
  hasMatch,
  positions,
  score,
} from "npm:fzy.js";
import {
  BaseFilter,
} from "jsr:@shougo/ddu-vim@^5.0.0/filter";
import type {
  DduItem,
  ItemHighlight,
} from "jsr:@shougo/ddu-vim@^5.0.0/types";
import type { Denops } from "jsr:@denops/core@^7.0.0";

type Params = {
  hlGroup: string;
};

type SortItem = {
  score: number;
  item: DduItem;
};

function get_string_byte_count(str: string) {
  const blob = new Blob([str], { type: "text/plain" });
  return blob.size;
}

export class Filter extends BaseFilter<Params> {
  filter(args: {
    denops: Denops;
    input: string;
    items: DduItem[];
    filterParams: Params;
  }): Promise<DduItem[]> {
    const input = args.input;

    if (!input.length) {
      return Promise.resolve(args.items.map((item) => {
        item.highlights = item.highlights?.filter((h) =>
          h.name != "ddu_fzy_hl"
        );
        return item;
      }));
    }

    // Split input for matchers
    const inputs = input.split(/(?<!\\)\s+/).filter((x) => x != "").map((x) =>
      x.replaceAll(/\\(?=\s)/g, "")
    );
    const trimedInput = input.replaceAll(/\s+/g, "");

    const filtered = inputs.reduce(
      (items, input) => items.filter((i) => hasMatch(input, i.display ?? i.word)),
      args.items,
    );

    if (filtered.length > 1000) {
      return Promise.resolve(filtered);
    }

    return Promise.resolve(
      filtered.map((
        c,
      ) => ({ score: score(trimedInput, c.display ?? c.word), item: c } as SortItem))
        .sort((a, b) => b.score - a.score).map((c) => {
          const prev = c.item.highlights?.filter((h) => h.name != "ddu_fzy_hl");
          const display = c.item.display ?? c.item.word;
          const highlights = inputs.reduce(
            (highlight: ItemHighlight[], i: string) =>
              highlight.concat(
                positions(i, display).map((p: number) => (
                  {
                    col: get_string_byte_count(display.slice(0, p)) + 1,
                    name: "ddu_fzy_hl",
                    hl_group: 'Title',
                    width: 1,
                  } as ItemHighlight
                )),
              ),
            [],
          );
          if (prev) {
            c.item.highlights = prev.concat(highlights);
          } else {
            c.item.highlights = highlights;
          }
          return c.item;
        }),
    );
  }

  params(): Params {
    return {
      hlGroup: "Title",
    };
  }
}

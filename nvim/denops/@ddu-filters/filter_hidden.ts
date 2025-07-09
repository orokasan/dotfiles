// MIT license

// Copyright (c) Shougo Matsushita <Shougo.Matsu at gmail.com>

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:

// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// https://github.com/Shougo/ddu-filter-matcher_hidden

import {
  type DduItem,
  type SourceOptions,
} from "jsr:@shougo/ddu-vim@~6.1.0/types";
import { BaseFilter } from "jsr:@shougo/ddu-vim@~6.1.0/filter";

import { type ActionData } from "jsr:@shougo/ddu-kind-file@~0.9.0";

import type { Denops } from "jsr:@denops/core@~7.0.0";

import { basename } from "jsr:@std/path@~1.0.3/basename";

type Params = {
  hiddenPath: string[];
};

export class Filter extends BaseFilter<Params> {
  override filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    filterParams: Params;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    return Promise.resolve(args.items.filter(
      (item) => {
        const action = item.action as ActionData;
        if (!action.path) return false;
        if (
          args.filterParams.hiddenPath.some((i) =>
            basename(action.path).includes(i)
          )
        ) return false;
        return args.input.includes(".") ||
          (!basename(action.path).startsWith(".") &&
            !item.matcherKey.startsWith("."));
      },
    ));
  }

  override params(): Params {
    return {
      hiddenPath: [],
    };
  }
}

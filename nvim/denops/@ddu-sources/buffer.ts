// MIT License

// Copyright (c) 2022 Shunsuke Kudo

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import {
  ActionArguments,
  ActionFlags,
  Context,
  Item,
} from "jsr:@shougo/ddu-vim@~10.3.0/types";
import { BaseSource } from "jsr:@shougo/ddu-vim/source";
import type { Denops } from "jsr:@denops/std";
import * as fn from "jsr:@denops/std@~7.5.0/function";
import { isAbsolute, relative } from "jsr:@std/path";
import { isURL } from "https://deno.land/x/is_url@v1.0.1/mod.ts";

type ActionData = {
  bufNr: number;
  path: string;
  isCurrent: boolean;
  isAlternate: boolean;
  isModified: boolean;
  isTerminal: boolean;
  bufType: string;
};

type ActionInfo = {
  word: string;
  action: ActionData;
};

type BufInfo = {
  bufnr: number;
  changed: boolean;
  lastused: number;
  listed: boolean;
  name: string;
};

type GetBufInfoReturn = {
  currentDir: string;
  alternateBufNr: number;
  buffers: BufInfo[];
};

type Params = {
  orderby: string;
};

const NO_NAME_BUFFER_DISPLAY_NAME = "[No Name]";

export class Source extends BaseSource<Params> {
  kind = "file";

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    const currentBufNr = args.context.bufNr;

    const getDisplayPath = (fullPath: string, currentDir: string): string => {
      const relPath = relative(currentDir, fullPath);
      return relPath.startsWith("..") ? fullPath : relPath;
    };

    const getActioninfo = async (
      bufinfo: BufInfo,
      curnr_: number,
      altnr_: number,
      currentDir: string,
    ): Promise<ActionInfo> => {
      const { bufnr, changed, name } = bufinfo;
      const uBufType = await fn.getbufvar(args.denops, bufnr, "&buftype");
      const bufType = (typeof uBufType == "string") ? uBufType : "";

      // Only vim has termSet, Only neovim has name "term://...".
      const isTerminal = bufType === "terminal";

      // Windows absolute paths are recognized as URL.
      const isPathName = !isTerminal && (!isURL(name) || isAbsolute(name));

      const isCurrent_ = curnr_ === bufnr;
      const isAlternate_ = altnr_ === bufnr;
      const isModified_ = changed;

      const curmarker_ = isCurrent_ ? "%" : "";
      const altmarker_ = isAlternate_ ? "#" : "";
      const modmarker_ = isModified_ ? "+" : " ";

      const bufnrstr_ = String(bufnr).padStart(2, " ");
      const bufmark_ = `${curmarker_}${altmarker_}`.padStart(2, " ");

      const displayName = name === ""
        ? NO_NAME_BUFFER_DISPLAY_NAME
        : isPathName
        ? getDisplayPath(name, currentDir)
        : name;

      return {
        word: `${bufnrstr_} ${bufmark_} ${modmarker_} ${displayName}`,
        action: {
          bufNr: bufnr,
          path: name,
          isCurrent: isCurrent_,
          isAlternate: isAlternate_,
          isModified: isModified_,
          isTerminal,
          bufType,
        },
      };
    };

    const getBuflist = async () => {
      const {
        currentDir,
        alternateBufNr,
        buffers,
      } = await args.denops.call(
        "ddu#source#buffer#getbufinfo",
      ) as GetBufInfoReturn;
      return await Promise.all(
        buffers.filter((b) => b.listed).sort((a, b) => {
          if (args.sourceParams.orderby === "desc") {
            if (a.bufnr === currentBufNr) return 1;
            if (b.bufnr === currentBufNr) return -1;
            return Number(BigInt(b.lastused) - BigInt(a.lastused));
          }

          return Number(BigInt(a.lastused) - BigInt(b.lastused));
        }).map(async (b) =>
          await getActioninfo(b, currentBufNr, alternateBufNr, currentDir)
        ),
      );
    };

    return new ReadableStream({
      async start(controller) {
        controller.enqueue(
          await getBuflist(),
        );
        controller.close();
      },
    });
  }

  actions = {
    delete: async ({ denops, items }: ActionArguments<Params>) => {
      try {
        for (const item of items) {
          const action = item.action as ActionData;
          const existed = await fn.bufexists(denops, action.bufNr);
          if (!existed) {
            throw new Error(
              `the buffer doesn't exist> ${action.bufNr}: ${action.path}`,
            );
          }

          const bufinfo = await denops.call(
            "getbufinfo",
            action.bufNr,
          ) as BufInfo[];
          if (bufinfo.length && !bufinfo[0].changed) {
            await denops.cmd(`bwipeout ${action.bufNr}`);
          } else {
            throw new Error(
              `can't delete the buffer> ${action.bufNr}: ${action.path}`,
            );
          }
        }
      } catch (err) {
        console.error(err.message);
        return Promise.resolve(ActionFlags.None);
      }

      return Promise.resolve(ActionFlags.RefreshItems);
    },
  };

  params(): Params {
    return {
      orderby: "asc",
    };
  }
}

import {
  BaseColumn,
  DduItem,
  ItemHighlight,
} from "https://deno.land/x/ddu_vim@v4.0.0/types.ts";
import { GetTextResult } from "https://deno.land/x/ddu_vim@v4.0.0/base/column.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v4.0.0/deps.ts";
import { basename, extname } from "https://deno.land/std@0.192.0/path/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.0/file.ts";

type Params = {
  padding: number;
  highlights: {
    directoryName: string;
  };
  isTree: boolean;
};

interface IconList {
  [ext: string]: string;
}

export class Column extends BaseColumn<Params> {
  private span = 2;
  private iconWidth = 3;
  private defaultIcon = "";
  private extensionPalette: IconList = {};
  private basenamePalette: IconList = {};
  private directoryPalette: IconList = {};

  async onInit(args: { denops: Denops }): Promise<void> {
    await args.denops.eval("nerdfont#find()");
    this.extensionPalette = (await args.denops.eval(
      "extend(copy(g:nerdfont#path#extension#defaults), g:nerdfont#path#extension#customs,)",
    )) as IconList;
    this.basenamePalette = (await args.denops.eval(
      "extend(copy(g:nerdfont#path#basename#defaults), g:nerdfont#path#basename#customs,)",
    )) as IconList;
    this.directoryPalette = (await args.denops.eval(
      "extend(copy(g:nerdfont#directory#defaults), g:nerdfont#directory#customs,)",
    )) as IconList;
    this.defaultIcon = (await args.denops.eval("g:nerdfont#default")) as string;
  }

  getText(args: {
    denops: Denops;
    columnParams: Params;
    startCol: number;
    endCol: number;
    item: DduItem;
  }): Promise<GetTextResult> {
    const highlights: ItemHighlight[] = args.item.highlights ?? [];

    const isDir = isDirectory(args.item);
    const prefix = this.makePrefix(args.item, args.columnParams);

    const text = prefix + (args.item.word);
    if (args.item.__level > 0) {
      highlights.push({
        name: "column-icon-padding",
        hl_group: "Comment",
        col: args.startCol + args.item.__level + args.columnParams.padding + 1,
        width: 1,
      });
    }

    if (isDir) {
      const userHighlights = args.columnParams.highlights;
      highlights.push({
        name: "column-icon",
        hl_group: userHighlights.directoryName,
        col: args.startCol +
          args.item.__level +
          args.columnParams.padding +
          this.iconWidth +
          1,
        width: charposToBytepos(text, -1),
      });
    }

    return Promise.resolve({
      text: text,
      highlights: highlights,
    });
  }

  getLength(args: {
    denops: Denops;
    columnParams: Params;
    items: DduItem[];
  }): Promise<number> {
    const widths = args.items.map((item) => {
      const filename = getFilename(item);

      if (args.columnParams.isTree) {
        return item.__level + args.columnParams.padding +
          this.iconWidth + this.span +
          charposToBytepos(filename, -1);
      } else {
        return this.iconWidth + filename.length;
      }
    });
    return Promise.resolve(Math.max(...widths));
  }

  private makePrefix(item: DduItem, columnParams: Params): string {
    const action = item.action as ActionData;
    const fname: string = getFilename(item);
    const extention: string = extname(fname).substring(1) ?? "";

    const getIcon = () => {
      if (isDirectory(item) || item.isTree) {
        return item.__expanded
          ? this.directoryPalette.open
          : action.isLink
          ? this.directoryPalette.symlink
          : this.directoryPalette.close;
      } else {
        return (fname in this.basenamePalette)
          ? this.basenamePalette[fname]
          : (extention in this.extensionPalette)
          ? this.extensionPalette[extention]
          : this.defaultIcon;
      }
    };
    const icon = getIcon();

    const whitespace = (count: number) => " ".repeat(Math.max(0, count));
    const span = whitespace(this.span);

    if (columnParams.isTree) {
      const indent = item.__level > 0
        ? whitespace(item.__level + columnParams.padding - 1) + "  " //│
        : whitespace(columnParams.padding);
      return indent + icon + span;
    } else {
      return icon + span;
    }
  }
  params(): Params {
    return {
      padding: 0,
      highlights: {
        directoryName: "Function",
      },
      isTree: false,
    };
  }
}

function getFilename(item: DduItem): string {
  const path = (item?.action as ActionData).path ?? item.word;
  return basename(path) + (isDirectory(item) ? "/" : "");
}

function isDirectory(item: DduItem): boolean {
  const path = (item?.action as ActionData).path ?? item.word;
  return ((item?.action as ActionData).isDirectory) ||
    (path[path.length - 1] == "/");
}

// Shougo\ddc.vim\denops\ddc\ddc.ts
function charposToBytepos(input: string, pos: number): number {
  return (new TextEncoder()).encode(input.slice(0, pos)).length;
}

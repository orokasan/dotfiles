import {
  BaseColumn,
  DduItem,
  ItemHighlight,
} from "https://deno.land/x/ddu_vim@v1.13.0/types.ts";
import { GetTextResult } from "https://deno.land/x/ddu_vim@v1.13.0/base/column.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v1.13.0/deps.ts";
import { basename, extname } from "https://deno.land/std@0.149.0/path/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.1/file.ts";

type Params = {
  padding: number;
  highlights: HighlightGroup;
  filer: boolean;
  ignoreMatcherHighlight: string[];
  kind: string[];
};

type HighlightGroup = {
  directoryIcon?: string;
  directoryName?: string;
};

interface IconList {
  [ext: string]: string;
}

export class Column extends BaseColumn<Params> {
  private span = 1;
  private iconWidth = 3;
  private defaultIcon = "";
  private extensionPalette: IconList = {};
  private basenamePalette: IconList = {};
  private directoryPalette: IconList = {};

  async onInit(args: { denops: Denops }): Promise<void> {
    await args.denops.eval("nerdfont#find()")
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

    const word = args.item.display ?? args.item.word;
    const isDir = isDirectory(args.item);

    if (!args.columnParams.kind.includes(args.item.kind ?? "base")) {
      return Promise.resolve({ text: word, highlights: highlights });
    }

    const mergin = this.iconWidth + this.span +
      args.columnParams.padding;

    const initialized = highlights.some((hi) => hi.name == "column-icon");

    // 既存のハイライトの位置を、アイコンの分だけずらす
    if (!initialized) {
      highlights?.filter((p) => {
        p.col += mergin;
      });
    } else {
      // 処理済みアイテムがある場合スキップ
      highlights?.filter((p) => {
        // 一部のハイライトは動的に位置が変化する
        if (args.columnParams.ignoreMatcherHighlight.includes(p.name)) {
          p.col += mergin;
        }
      });
      return Promise.resolve({ text: word, highlights: highlights });
    }

    const prefix = this.makePrefix(args.item, args.columnParams);

    let text: string;

    if (args.columnParams.filer) {
      text = prefix + args.item.word;
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
          hl_group: userHighlights.directoryName ?? "function",
          col: args.startCol +
            args.item.__level +
            args.columnParams.padding +
            this.iconWidth +
            1,
          width: charposToBytepos(text, -1),
        });
      }
    } else {
      text = prefix + (args.item.display ?? args.item.word);

      highlights.push({
        name: "column-icon",
        hl_group: "",
        col: 0,
        width: 0,
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

      if (args.columnParams.filer) {
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
    let icon = "";
    const action = item.action as ActionData;
    const fname: string = getFilename(item);
    const extention: string = extname(fname).substring(1) ?? "";

    if (isDirectory(item)) {
      icon = item.__expanded
        ? this.directoryPalette.open
        : action.isLink
        ? this.directoryPalette.symlink
        : this.directoryPalette.close;
    } else if (item.__sourceName == "markdown") {
      icon = item.__expanded
        ? this.directoryPalette.open
        : action.isLink
        ? this.directoryPalette.symlink
        : this.directoryPalette.close;
    } else {
      icon = (fname in this.basenamePalette)
        ? icon = this.basenamePalette[fname]
        : (extention in this.extensionPalette)
        ? icon = this.extensionPalette[extention]
        : icon = this.defaultIcon;
    }

    const whitespace = (count: number) => " ".repeat(Math.max(0, count));
    const span = whitespace(this.span);

    let prefix = "";
    if (columnParams.filer) {
      const indent = item.__level > 0
        ? whitespace(item.__level + columnParams.padding - 1) + "├ " //│
        : whitespace(columnParams.padding);
      prefix = indent + icon + span;
    } else {
      prefix = icon + span;
    }
    return prefix;
  }
  params(): Params {
    return {
      padding: 0,
      highlights: {},
      filer: true,
      ignoreMatcherHighlight: [],
      kind: ["file"],
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

import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v4.0.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v4.0.0/deps.ts";
import { basename, extname } from "https://deno.land/std@0.224.0/path/mod.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts";

type Params = {
  padding: number;
  highlights: {
    directoryName: string;
  };
};

interface IconList {
  [ext: string]: string;
}

export class Filter extends BaseFilter<Params> {
  private span = 2;
  private iconWidth = 3;
  private defaultIcon = "";
  private initialized: boolean = false;
  private extensionPalette: IconList = {};
  private basenamePalette: IconList = {};
  private directoryPalette: IconList = {};

  async onInit(args: { denops: Denops }): Promise<void> {
    if (this.initialized) return

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
    this.initialized = true
  }

  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    filterParams: Params;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const items = args.items.filter((item) => {
      const action = item.action as ActionData
      if (!action || !action.path || !item.word) return true

      const prefix = this.makePrefix(action, action.path, args.filterParams);

      if (!item.highlights) item.highlights = [];

      const text = prefix + (item.display ?? item.word);

      item.highlights.filter((i) =>
        i.col = i.col + args.filterParams.padding + this.iconWidth + this.span
      );

      item.display = text;
      return true;
    });
    return Promise.resolve(items);
  }

  private makePrefix(action: ActionData, path: string,  columnParams: Params): string {
    const isDir = isDirectory(action)
    const fname: string = getFilename(path, isDir);
    const extention: string = extname(fname).substring(1) ?? "";

    const getIcon = () => {
      if (isDirectory(action)) {
        return action.isLink
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
    const padding = whitespace(columnParams.padding);

    return padding + icon + span;
  }

  params(): Params {
    return {
      padding: 2,
      highlights: {
        directoryName: "Function",
      },
    };
  }
}

function getFilename(path: string, isDir: boolean): string {
  return basename(path) + (isDir ? "/" : "");
}

function isDirectory(action: ActionData): boolean {
  if (!action.path) return false
  return (action.isDirectory) ||
    (action.path[action.path.length - 1] == "/");
}

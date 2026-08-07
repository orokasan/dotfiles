import { DduItem, SourceOptions } from "jsr:@shougo/ddu-vim/types";
import { basename, extname } from "jsr:@std/path";
import { BaseFilter } from "jsr:@shougo/ddu-vim/filter";
import { ActionData } from "jsr:@shougo/ddu-kind-file";
import { Denops } from "jsr:@denops/std";

type Params = {
  padding: number;
  span: number;
  highlights: {
    directoryName: string;
  };
};

interface IconList {
  [ext: string]: string;
}

export class Filter extends BaseFilter<Params> {
  private defaultIcon: string = "";
  private iconWidth: number = 1;
  private extensionPalette: IconList = {};
  private basenamePalette: IconList = {};
  private directoryPalette: IconList = {};

  override async onInit(args: { denops: Denops }): Promise<void> {
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
    this.iconWidth = new Blob([this.defaultIcon]).size;
  }

  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    filterParams: Params;
    items: DduItem[];
  }): Promise<DduItem[]> {
    return Promise.resolve(
      args.items.map((item) => {
        const action = item.action as ActionData;

        if (!action || !action.path || !item.word) return item;
        // console.log(item)

        const indent = " ".repeat(Math.max(0, item.__level));
        const prefix = this.makePrefix(action, action.path, args.filterParams);

        return {
          ...item,
          display: indent + prefix + (item.display ?? item.word),
          highlights: (item.highlights ?? []).map((i) => {
            return {
              ...i,
              col: i.col + args.filterParams.padding +
                this.iconWidth +
                args.filterParams.span,
            };
          }),
        };
      }),
    );
  }

  private makePrefix(
    action: ActionData,
    path: string,
    filterParams: Params,
  ): string {
    const isDir = isDirectory(action);
    const fname: string = getFilename(path, isDir);
    const extention: string = extname(fname).substring(1) ?? "";

    const icon = (() => {
      if (isDirectory(action)) {
        if (action.isLink) {
          return this.directoryPalette.symlink;
        } else {
          return this.directoryPalette.close;
        }
      } else {
        if (fname in this.basenamePalette) {
          return this.basenamePalette[fname];
        } else if (extention in this.extensionPalette) {
          return this.extensionPalette[extention];
        } else {
          return this.defaultIcon;
        }
      }
    })();

    const whitespace = (count: number) => " ".repeat(Math.max(0, count));
    const span = whitespace(filterParams.span);
    const padding = whitespace(filterParams.padding);

    return padding + icon + span;
  }

  params(): Params {
    return {
      span: 2,
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
  if (!action.path) return false;
  return (action.isDirectory) ||
    (/\/|\\/.test(action.path[action.path.length - 1]));
}

import {
  DduItem,
  SourceOptions,
} from "jsr:@shougo/ddu-vim/types";
import { basename, extname } from "jsr:@std/path";
import { BaseFilter } from "jsr:@shougo/ddu-vim/filter";
import { ActionData } from "jsr:@shougo/ddu-kind-file";
import { Denops } from "jsr:@denops/std";

type Params = Record<never, never>;
interface IconList {
  [ext: string]: string;
}

export class Filter extends BaseFilter<Params> {
  private defaultIcon = "";
  private extensionPalette = {} as IconList;
  private basenamePalette = {} as IconList;
  private directoryPalette = {} as IconList;
  override async onInit(args: {
    denops: Denops;
  }): Promise<void> {
    this.extensionPalette = await args.denops.eval(
      " extend( copy(g:nerdfont#path#extension#defaults), g:nerdfont#path#extension#customs,)",
    ) as IconList;
    this.basenamePalette = await args.denops.eval(
      " extend( copy(g:nerdfont#path#basename#defaults), g:nerdfont#path#basename#customs,)",
    ) as IconList;
    this.directoryPalette = await args.denops.eval(
      " extend( copy(g:nerdfont#directory#defaults), g:nerdfont#directory#customs,)",
    ) as IconList;
    this.defaultIcon = await args.denops.eval("g:nerdfont#default") as string;
  }
  filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    return Promise.resolve(args.items.filter((v) => {
      if (v.action?.__has_icon) {
        const prev = v.highlights?.filter((h) => h.name == "ddu_fzy_hl");
        prev?.map((p) => {
          p.col = p.col + 4;
        });
        return true;
      }

      const action = v.action as ActionData;
      const isDirectory = action.isDirectory;
      const path = basename(action.path ?? v.word) +
        (isDirectory ? "/" : "");

      const filetype = extname(path).substring(1) ?? "";
      let icon = "";
      if (isDirectory) {
        icon = this.directoryPalette.close;
      } else if (path in this.basenamePalette) {
        icon = this.basenamePalette[path];
      } else if (filetype in this.extensionPalette) {
        icon = this.extensionPalette[filetype];
      } else {
        icon = this.defaultIcon;
      }
      const text = icon + " " + v.word;

      if (!v["highlights"]) v["highlights"] = [];
      v.display = text;
      v.action.__has_icon = true;
      v.highlights?.map((p) => {
        p.col = p.col + 3;
      });
      return true;
    }));
  }
  params(): Params {
    return {};
  }
}

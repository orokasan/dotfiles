import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v2.2.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.2.0/deps.ts";
import { relative, resolve } from "https://deno.land/std@0.181.0/path/mod.ts";

type Params = {
  force: boolean;
};

export class Filter extends BaseFilter<Params> {
  async filter(args: {
    denops: Denops;
    filterParams: Params;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const items = (args.filterParams.force) ? await Promise.all(args.items.map(async (i) => {
        const fullPath = resolve(Deno.cwd(), i.word);
        const stat = await tryGetStat(fullPath);
        i.status = {
          size: stat?.size,
          time: stat?.atime?.getTime(),
        };
      console.log(i)
        return i
      }
    )) : args.items
      // console.log(items.sort((a, b) => {
    //   if (a.status?.time || b.status?.time) {
    //     if ((a.status?.time ?? 0) < (b.status?.time ?? 0)) return 1
    //       else return -1;
    //   }
    //   return 0;
    // }))
    return Promise.resolve(items.sort((a, b) => {
      if (a.status?.time || b.status?.time) {
        if ((a.status?.time ?? 0) < (b.status?.time ?? 0)) return 1
          else return -1;
      }
      return 0;
    }));
  }

  params(): Params {
    return {
      force: false,
    };
  }
}

async function tryGetStat(path: string): Promise<Deno.FileInfo | null> {
  // Note: Deno.stat() may fail
  try {
    const stat = await Deno.stat(path);
    if (stat.isDirectory || stat.isFile || stat.isSymlink) {
      return stat;
    }
  } catch (_: unknown) {
    // Ignore stat exception
  }

  return null;
}

import {
  BaseSource,
  Item,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v3.6.0/types.ts";
import { Denops, fn, vars } from "https://deno.land/x/ddu_vim@v3.6.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts";
import {
  basename,
  join,
  relative,
  resolve,
} from "https://deno.land/std@0.204.0/path/mod.ts";

type Params = Record<string, never>;

export class Source extends BaseSource<Params> {
  override kind = "file";

  override gather(args: {
    denops: Denops;
    sourceParams: Params;
    sourceOptions: SourceOptions;
    input: string;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        await args.denops.call("junkfile#init");

        const dir = args.sourceOptions.path ||
          await fn.getcwd(args.denops);

        const tree = async (root: string) => {
          let items: Item<ActionData>[] = [];

          for await (const entry of Deno.readDir(root)) {
            const path = join(root, entry.name);
            if (!entry.isDirectory) {
              items.push({
                word: relative(dir, path),
                action: {
                  path: path,
                },
              });
            }

            if (entry.isDirectory) {
              items = items.concat(await tree(path));
            }
          }

          return items;
        };

        let items: Item<ActionData>[] = [];
        items = items.concat((await tree(dir)).sort(
          (a, b) => a.word < b.word ? 1 : a.word == b.word ? 0 : -1,
        ));

        controller.enqueue(items);

        controller.close();
      },
    });
  }

  override params(): Params {
    return {};
  }
}

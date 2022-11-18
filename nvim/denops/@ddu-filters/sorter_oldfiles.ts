import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v0.14/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v0.14/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.0/file.ts#^";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  async filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    const result = await args.denops.call(`mr#mru#list`) as string[];
    const mapped = args.items.map((vl) => {
      const action = vl.action as ActionData;
      const i = result.flatMap((item, id) => (item == action.path) ? id : []);
      return { index: i[0] ?? [Infinity], value: vl };
    });
    mapped.sort((a, b) => (a.index - b.index));
    return Promise.resolve(mapped.map((el) => el.value));
  }

  params(): Params {
    return {};
  }
}

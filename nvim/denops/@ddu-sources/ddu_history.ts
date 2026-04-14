import {
  ActionFlags,
  Actions,
  Context,
  DduItem,
  DduOptions,
  Item,
} from "jsr:@shougo/ddu-vim/types";
import { BaseSource } from "jsr:@shougo/ddu-vim/source";
import { Denops } from "jsr:@denops/std";

type Params = {
  source: string;
};

export type ActionData = {
  context: DduOptions;
};

type HistoryData = {
  timestamp: number;
  option: DduOptions;
};

export class Source extends BaseSource<Params> {
  override kind = "word";

  override actions: Actions<Params> = {
    start: async (args: { denops: Denops; items: DduItem[] }) => {
      for (const item of args.items) {
        const ddu_context = (item.action as ActionData).context;
        await args.denops.call("ddu#start", ddu_context);
      }
      return Promise.resolve(ActionFlags.None);
    },
  };

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      async start(controller) {
        const items: Item<ActionData>[] = [];
        const param = args.sourceParams;

        const data = await args.denops.call(
          "ddu_history#get_history",
        ) as HistoryData[];
        let i = 0;
        for (const v of data) {
          const source = v.option.sources[0];
          const source_name = typeof source === "string" ? source : source.name;
          if (source_name === "ddu_history") continue;

          if (param.source.length > 0){
              if ( param.source !== source_name ) continue
          }

          const path = typeof source !== "string" ? source.options?.path : "";
          const word = `Source: ${source_name.padEnd(15, " ")}  Path: ${
            path ? await args.denops.call("fnamemodify", path, ":~") : ""
          }`;
          i += 1;
          items.push({
            word: word,
            display: word,
            action: {
              context: v.option,
            },
            highlights: [{
              name: "ddu_history_source_name",
              hl_group: "Constant",
              col: 8,
              width: source_name.length + 1,
            }],
          });
        }
        controller.enqueue(items);

        controller.close();
      },
    });
  }

  params(): Params {
    return {
      source: "",
    };
  }
}

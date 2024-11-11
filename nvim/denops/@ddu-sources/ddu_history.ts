import {
  ActionFlags,
  Actions,
  BaseSource,
  Context,
  DduItem,
  Item,
  DduOptions
} from "https://deno.land/x/ddu_vim@v4.0.0/types.ts#^";
import { Denops } from "https://deno.land/x/ddu_vim@v4.0.0/deps.ts";
import {type  ActionData } from "jsr:@shougo/ddu-kind-word";
import { difference } from "https://deno.land/std@0.224.0/datetime/difference.ts";
import { type DifferenceFormat } from "https://deno.land/std@0.224.0/datetime/difference.ts";

type Params = Record<number | string | symbol, never>;

type HistoryData = {
  timestamp: number;
  option: DduOptions;
};

export class Source extends BaseSource<Params> {
  override kind = "word";

  override actions: Actions<Params> = {
    start: async (args: { denops: Denops; items: DduItem[] }) => {

      for (const item of args.items) {
        const action = item.action?.text as ActionData;
        await args.denops.call("ddu#start", action);
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
        const data = await args.denops.call(
          "ddu_history#get_history",
        ) as HistoryData[];
        let i = 0;
        for (const v of data) {
          const gettime = (start: number) => {
            const diff = difference(
              new Date(),
              new Date(Number(start) * 1000),
              {
                units: ["hours", "minutes", "seconds"],
              },
            ) as DifferenceFormat;
            const h = diff.hours ?? 0;
            const m = diff.minutes ? diff.minutes - h * 60 : 0;
            const s = diff.seconds
              ? diff.seconds - (diff.minutes ?? 0) * 60
              : 0;
            const time = h > 0
              ? m > 0 ? `${h}h${m}` : `${s}s`
              : m > 0
              ? `${m}m${s}s`
              : `${s}s`;

            return time;
          };
          const source_name: string = v.option.sources[0]?.name;
          if (source_name === 'ddu_history') continue
          const path = v.option.sources[0]?.options?.path
          const word = `[${
            String(i).padStart(2, " ")
          }] Source: ${source_name.padEnd(15, ' ')}  Path: ${
            path ? await args.denops.call('fnamemodify', path , ':~' ) : "--"
          } Name: ${v.option.name}, ${gettime(v.timestamp)}`;
          i += 1;
          items.push({
            word: word,
            display: word,
            action: {
              text: v.option,
            },
            highlights: [{
              name: "ddu_history_source_name",
              hl_group: "Constant",
              col: 13,
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
    return {};
  }
}

import {
  ActionFlags,
  type Actions,
  type BaseParams,
  type DduItem,
  type PreviewContext,
  type Previewer,
} from "jsr:@shougo/ddu-vim@~6.1.0/types";
import { BaseKind } from "jsr:@shougo/ddu-vim@~6.1.0/kind";

import type { Denops } from "jsr:@denops/std@~7.1.0";

export type ActionData = {
  id: number;
  text: string;
  folder: string;
  date?: string;
  address?: string;
  flags?: string[];
  has_attachment : boolean
};

export const HimalayaActions: Actions<Params> = {
  open: {
    description: "It is same with |ddu-kind-word-action-feedkeys| ",
    callback: async (
      args: { denops: Denops; items: DduItem[]; actionParams: BaseParams },
    ) => {
      const params = args.actionParams;
      const action = args.items[0].action as ActionData;
      await args.denops.call(
        "himalaya#domain#email#read",
        action.id,
        action.folder,
        params.command ?? "edit",
      );
      return ActionFlags.None;
    },
  },
  reply: {
    description: "It is same with |ddu-kind-word-action-feedkeys| ",
    callback: async (args: { denops: Denops; items: DduItem[] }) => {
      await args.denops.call(
        "himalaya#domain#email#reply_all",
        (args.items[0].action as ActionData).id,
        '',
        args.items[0].action.folder
      );
      return ActionFlags.None;
    },
  },
  reload: {
    description: "It is same with |ddu-kind-word-action-feedkeys| ",
    callback: () => {
      return ActionFlags.RefreshItems;
    },
  },
};

type Params = Record<string, never>;

export class Kind extends BaseKind<Params> {
  override actions = HimalayaActions;

  override getPreviewer(args: {
    denops: Denops;
    item: DduItem;
    actionParams: BaseParams;
    previewContext: PreviewContext;
  }): Promise<Previewer | undefined> {
    const action = args.item.action as ActionData;
    if (!action) {
      return Promise.resolve(undefined);
    }

    return Promise.resolve({
      kind: "terminal",
      cmds: [
        "himalaya",
        "--quiet",
        "message",
        "read",
        "--no-headers",
        "--folder",
        action.folder,
        String(action.id),
      ],
      filetype: "mail",
    });
  }

  override params(): Params {
    return {
      command: "",
    };
  }
}

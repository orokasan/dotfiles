import {
  BaseSource,
  Context,
  Item,
} from "https://deno.land/x/ddu_vim@v1.13.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v1.13.0/deps.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.0/file.ts";

type RawItems = {
  lnum: number;
  end_lnum: number;
  name: string;
  col: number;
  end_col: number;
  level: number;
  kind: string;
  children: RawItems[] | undefined;
  parent: RawItems | undefined;
};

type Params = {
  maxLevel: number;
};

const LSP_KINDS = [
  "Text",
  "Method",
  "Function",
  "Constructor",
  "Field",
  "Variable",
  "Class",
  "Interface",
  "Module",
  "Property",
  "Unit",
  "Value",
  "Enum",
  "Keyword",
  "Snippet",
  "Color",
  "File",
  "Reference",
  "Folder",
  "EnumMember",
  "Constant",
  "Struct",
  "Event",
  "Operator",
  "TypeParameter",
];

const SymbolsIcon: Record<string, Record<string, string>> = {
  File: { icon: "", hl: "TSURI" },
  Module: { icon: "", hl: "TSNamespace" },
  Namespace: { icon: "", hl: "TSNamespace" },
  Package: { icon: "", hl: "TSNamespace" },
  Class: { icon: "𝓒", hl: "TSType" },
  Method: { icon: "ƒ", hl: "TSMethod" },
  Property: { icon: "", hl: "TSMethod" },
  Field: { icon: "", hl: "TSField" },
  Constructor: { icon: "", hl: "TSConstructor" },
  Enum: { icon: "ℰ", hl: "TSType" },
  Interface: { icon: "ﰮ", hl: "TSType" },
  Function: { icon: "", hl: "TSFunction" },
  Variable: { icon: "", hl: "TSConstant" },
  Constant: { icon: "", hl: "TSConstant" },
  String: { icon: "𝓐", hl: "TSString" },
  Number: { icon: "#", hl: "TSNumber" },
  Boolean: { icon: "⊨", hl: "TSBoolean" },
  Array: { icon: "", hl: "TSConstant" },
  Object: { icon: "⦿", hl: "TSType" },
  Key: { icon: "🔐", hl: "TSType" },
  Null: { icon: "NULL", hl: "TSType" },
  EnumMember: { icon: "", hl: "TSField" },
  Struct: { icon: "𝓢", hl: "TSType" },
  Event: { icon: "🗲", hl: "TSType" },
  Operator: { icon: "+", hl: "TSOperator" },
  TypeParameter: { icon: "𝙏", hl: "TSParameter" },
  Component: { icon: "", hl: "TSFunction" },
  Fragment: { icon: "", hl: "TSConstant" },
};

function get_string_byte_count(str: string) {
  const blob = new Blob([str], { type: "text/plain" });
  return blob.size;
}

export class Source extends BaseSource<Params> {
  kind = "file";
  raw = [] as RawItems[];

  async onInit(args: {
    denops: Denops;
  }): Promise<void> {
    try {
      this.raw = await args.denops.eval(
        `luaeval("require('aerial.fzf').get_labels()")`,
      ) as RawItems[];
    } catch (e: unknown) {
      console.error(e);
    }
  }
  async checkUpdated(args: {
    denops: Denops;
  }): Promise<void> {
    try {
      this.raw = await args.denops.eval(
        `luaeval("require('aerial.fzf').get_labels()")`,
      ) as RawItems[];
    } catch (e: unknown) {
      console.error(e);
    }
  }

  gather(args: {
    denops: Denops;
    context: Context;
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    const raw = this.raw;
    return new ReadableStream({
      async start(controller) {
        const bufnr = args.context.bufNr;
        const items: Item<ActionData>[] = [];
        const push = async (v: RawItems[], level: number) => {
          if (
            args.sourceParams.maxLevel > 0 && level > args.sourceParams.maxLevel
          ) return;
          const makeItem = async (raw: RawItems): Promise<Item<ActionData>> => {
            const i = {
              word: SymbolsIcon[raw.kind].icon + ": " + raw.name,
              display: raw.kind + ": " + raw.name,
              __level: raw.level,
              __expanded: raw.children ? true : false,
              parent: raw.parent ? makeItem(raw.parent) : {},
              action: {
                bufNr: bufnr,
                path: await args.denops.call("bufname", bufnr) as string,
                lineNr: raw.lnum,
                col: raw.col,
              },
              isTree: true,
            };

            return i;
          };

          for (const i of v) {
            items.push(
              await makeItem(i),
            );
            // if (i.children) {
            //   await push(i.children, level + 1);
            // }
          }
        };

        await push(raw, 0);
        controller.enqueue(items);

        controller.close();
      },
    });
  }

  params(): Params {
    return {
      maxLevel: -1,
    };
  }
}

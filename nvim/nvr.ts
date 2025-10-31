// =============================================================================
// File        : base.ts
// Author      : yukimemi
// Last Change : 2025/01/02 18:01:13.
// =============================================================================

import { Command } from "jsr:@cliffy/command@1.0.0-rc.7";
import { isAbsolute } from "jsr:@std/path/is-absolute";
import { join } from "jsr:@std/path/join";

const PIPE = "\\\\.\\pipe\\neovide";

function isListening(): boolean {
  // running check.
  try {
    const pipe = Boolean(Deno.openSync(PIPE));
    return pipe;
  } catch (e) {
    if (e instanceof Deno.errors.NotFound) {
      return false;
    } else {
      console.error("Unknown Error");
      return false;
    }
  }
}

function openVim(cmd: string[], args: string[]) {
  // console.log({ cmd, args });
  const cmdHead = cmd[0];
  const cmdTail = cmd.slice(1);
  // console.log({ cmdHead, cmdTail, escapeArgs });
  const command = new Deno.Command(cmdHead, {
    args: cmdTail.concat(args),
    detached: true,
    stdout: "null",
    stderr: "null",
  });
  command.output();
}

function main() {
  return new Command()
    .name("nvr")
    .version("0.1.0")
    .useRawArgs()
    .action((_: never, ...args: string[]) => {
      // console.log({ cmd, denoArgs, options, args });
      const filename = args.map((v) => {
        return isAbsolute(v) ? v : join(Deno.cwd(), v);
      });
      if (isListening()) {
        if (args.length > 0) {
          openVim(["nvim", "--server", PIPE, "--remote-tab"], filename);
          openVim([
            "nvim",
            "--server",
            PIPE,
            "--remote-send",
            "<C-\><C-N>:NeovideFocus<CR>",
          ], []);
          Deno.exit();
        } else {
          openVim([
            "nvim",
            "--server",
            PIPE,
            "--remote-send",
            "<C-\><C-N>:echo 'No args'<CR>",
          ], filename);
          openVim([
            "nvim",
            "--server",
            PIPE,
            "--remote-send",
            "<C-\><C-N>:NeovideFocus<CR>",
          ], []);
          Deno.exit();
        }
      } else {
        openVim(
          ["neovide", "--no-fork", "--", "--listen", PIPE],
          filename,
        );
        Deno.exit();
      }
    })
    .parse(Deno.args);
}

main();

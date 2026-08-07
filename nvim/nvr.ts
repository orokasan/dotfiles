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
  // console.log({ cmdHead, cmdTail,  });
  const command = new Deno.Command(cmdHead, {
    args: cmdTail.concat(args),
    detached: true,
    stdout: "null",
    stderr: "null",
  });
  try {
    // Spawn without awaiting; log PID for debugging.
    const child = command.spawn();
    if (child && typeof (child as any).pid === "number") {
      console.log(`${cmdHead} started (pid=${(child as any).pid})`);
    }
  } catch (e) {
    console.error(`Failed to start ${cmdHead}:`, e);
  }
}

function main() {
  return new Command()
    .name("nvr")
    .version("0.1.0")
    .useRawArgs()
    .action((_: never, ...args: string[]) => {
      // console.log({  args });
      const filename = args.map((v) => {
        return isAbsolute(v) ? v : join(Deno.cwd(), v);
      });

      if (isListening()) {
        if (args.length > 0) {
          openVim(["nvim", "--server", PIPE, "--remote-send", `<C-\><C-N>:tabnew ${filename}<CR>`]);
          // openVim([
          //   "nvim",
          //   "--server",
          //   PIPE,
          //   "--remote-send",
          //   "<C-\><C-N>:NeovideFocus<CR>",
          // ], []);
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

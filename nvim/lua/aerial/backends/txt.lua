-- ref. https://github.com/stevearc/aerial.nvim/blob/master/lua/aerial/fzf.lua
-- MIT License
-- Copyright (c) 2020 Steven Arcangeli

local backends = require("aerial.backends")
local backend_util = require("aerial.backends.util")
local util = require("aerial.util")

local M = {}

M.is_supported = function(bufnr)
  if not vim.tbl_contains(util.get_filetypes(bufnr), "txt") then
    return false, "Filetype is not markdown"
  end
  return true, nil
end

local function get_line_len(bufnr, lnum)
  return vim.api.nvim_strwidth(vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, true)[1])
end

local function set_end_range(bufnr, items, last_line)
  if not items then
    return
  end
  if not last_line then
    last_line = vim.api.nvim_buf_line_count(bufnr)
  end
  local prev = nil
  for _, item in ipairs(items) do
    if prev then
      prev.end_lnum = item.lnum - 1
      prev.end_col = get_line_len(bufnr, prev.end_lnum)
      set_end_range(bufnr, prev.children, prev.end_lnum)
    end
    prev = item
  end
  if prev then
    prev.end_lnum = last_line
    prev.end_col = get_line_len(bufnr, last_line)
    set_end_range(bufnr, prev.children, last_line)
  end
end

local function postprocess_symbols(bufnr, items)
  set_end_range(bufnr, items)
end

M.fetch_symbols_sync = function(bufnr)
  bufnr = bufnr or 0
  local extensions = require("aerial.backends.treesitter.extensions")
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
  local items = {}
  local stack = {}
  local inside_code_block = false
  local maxlevel = 0
  for lnum, line in ipairs(lines) do
    local matched = vim.startswith(line,"■")
    if matched and not inside_code_block then
      local idx, len, word = string.find(line, "^([■]+)%s*")
      local level = (string.len(word) / 3)
    if maxlevel < level then
      maxlevel = level
    end
    end
  end
  for lnum, line in ipairs(lines) do
    local matched = vim.startswith(line,"■")
    if matched and not inside_code_block then
      local idx, len, word = string.find(line, "^([■]+)%s*")
      local level = maxlevel - (string.len(word) / 3 - 1)
      local parent = stack[math.min(level, #stack)]
      local item = {
        kind = level < 2 and "Method" or "Interface",
        name = string.sub(line, len + 1),
        level = level,
        parent = parent,
        lnum = lnum,
        col = 0,
      }
      if parent then
        if not parent.children then
          parent.children = {}
        end
        table.insert(parent.children, item)
      else
        table.insert(items, item)
      end
      while #stack > level and #stack > 0 do
        table.remove(stack, #stack)
      end
      table.insert(stack, item)
    elseif string.find(line, "```") == 1 then
      inside_code_block = not inside_code_block
    end
  end
  -- This sets the proper end_lnum and end_col
  postprocess_symbols(bufnr, items)
  backends.set_symbols(bufnr, items, {backend_name = "txt"} )
end

M.fetch_symbols = M.fetch_symbols_sync

M.attach = function(bufnr)
  backend_util.add_change_watcher(bufnr, "txt")
end

M.detach = function(bufnr)
  backend_util.remove_change_watcher(bufnr, "txt")
end

return M

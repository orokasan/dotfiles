-- ref. https://github.com/stevearc/aerial.nvim/blob/master/lua/aerial/fzf.lua
-- MIT License
-- Copyright (c) 2020 Steven Arcangeli

local data = require("aerial.data")
local navigation = require("aerial.navigation")
local M = {}

M.get_labels = function(opts)
  opts = opts or {}
  local results = {}
  if data.has_symbols(0) then
    for _, item in data.get_or_create(0):iter({ skip_hidden = false }) do
      table.insert(results, {idx = item.idx, name = item.name, level = item.level, col= item.col, lnum = item.lnum, id = item.id, parent = item.parent})
    end
  end
  return results
end

M.goto_symbol = function(symbol)
  local idx = tonumber(symbol:match("^(%d+)"))
  -- FIXME this fails if the symbol is currently hidden in the tree
  for i, _, symbol_idx in data.get_or_create(0):iter({ skip_hidden = true }) do
    if idx == i then
      navigation.select({
        index = symbol_idx,
      })
      break
    end
  end
end

return M

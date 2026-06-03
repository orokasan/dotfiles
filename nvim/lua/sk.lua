local M = {}

local function find_terminal_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_option(b, 'buftype') == 'terminal' then
      return b
    end
  end
  return nil
end

function M.open_compose()
  local buf = vim.api.nvim_create_buf(false, true) -- scratch buffer
  local w = math.floor(vim.o.columns * 0.6)
  local opts = {
    relative = 'cursor',
    row = -1, col = 0, width = w, height = 1,
    style = 'minimal', border = 'rounded'
  }
  vim.api.nvim_open_win(buf, true, opts)
  vim.bo[buf].bufhidden = 'wipe'
  vim.wo.signcolumn = 'yes'
  vim.bo[buf].filetype = 'text' -- skkeleton が通常バッファで動く前提
  vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', '<Esc>:lua require("sk").send_compose()<CR>', {noremap=true, silent=true})
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua require("sk").send_compose()<CR>', {noremap=true, silent=true})
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', {noremap=true, silent=true})
  vim.g.sk_compose_buf = buf
  vim.cmd('startinsert')
end

function M.send_compose(target_term_bufnr)
  local buf = vim.g.sk_compose_buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    print('compose buffer が見つからない')
    return
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local text = table.concat(lines, '\n')
  local term_buf = target_term_bufnr or find_terminal_buf()
  if not term_buf then
    print('terminal バッファが見つからない')
    return
  end
  local ok, job = pcall(vim.api.nvim_buf_get_var, term_buf, 'terminal_job_id')
  if not ok or not job then
    print('terminal_job_id が取得できない')
    return
  end
  vim.fn.chansend(job, text)
  vim.fn.chansend(job, '\n')
  -- ウィンドウを閉じる
  local wins = vim.fn.win_findbuf(buf)
  for _, w in ipairs(wins) do pcall(vim.api.nvim_win_close, w, true) end
  if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, {force=true}) end
  vim.g.sk_compose_buf = nil
end

return M

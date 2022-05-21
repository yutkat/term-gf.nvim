local M = {}

local c = require("term-gf.config")

function M.setup(user_config)
	local keymaps = c.set(user_config).keymaps

	local group_name = "term-gf"
	vim.api.nvim_create_augroup(group_name, { clear = true })

	vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
		group = group_name,
		pattern = "term://*",
		callback = function()
			vim.keymap.set("n", keymaps.goto_file, function()
				local file = vim.fn.expand("<cfile>")
				local word = vim.fn.expand("<cWORD>")
				local f = vim.fn.findfile(file)
				local num = string.match(word, ":(%d*)")
				if vim.fn.filereadable(f) == 1 then
					vim.cmd("wincmd p")
					vim.cmd("e " .. f)
					if num ~= nil then
						vim.cmd(num)
						local col = string.match(word, ":%d*:(%d*)")
						if col ~= nil then
							vim.cmd("normal! " .. col .. "|")
						end
					end
				end
			end, { noremap = true, silent = true, buffer = true })
		end,
		once = false,
	})
end

return M

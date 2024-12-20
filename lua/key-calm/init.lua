-- ~/.config/nvim/lua/plugins/cowboy.lua
local M = {}

-- Default settings
M.options = {
	delay = 2000, -- Delay time in milliseconds
	keys = { "h", "j", "k", "l", "+", "-" }, -- Keys to track
	icon = "🤠", -- Default icon
	message = "Hold it Cowboy!", -- Default message
	skip_key = "<Esc>", -- Key to skip the delay
	lp_icon = 7, -- Left padding for the icon
	rp_icon = 0, -- Right padding for the icon
	lp_text = 7, -- Left padding for the message text
	rp_text = 7, -- Right padding for the message text
}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.format_notification(icon, message)
	-- Add configurable spaces to the icon and message
	local formatted_icon = string.rep(" ", M.options.lp_icon) .. icon .. string.rep(" ", M.options.rp_icon)
	local formatted_message = string.rep(" ", M.options.lp_text) .. message .. string.rep(" ", M.options.rp_text)
	return formatted_icon, formatted_message
end

function M.cowboy()
	---@type table?
	local id
	local ok = true
	local skip_key_active = false -- Tracks if skip key was pressed

	for _, key in ipairs(M.options.keys) do
		local count = 0
		local timer = assert(vim.loop.new_timer())
		local map = key
		vim.keymap.set("n", key, function()
			if skip_key_active then
				skip_key_active = false
				return map
			end

			if vim.v.count > 0 then
				count = 0 -- Reset count if a prefix argument is used (e.g., 3h)
			end

			if count >= 10 then
				-- Show a warning when the count exceeds 10
				local icon, message = M.format_notification(M.options.icon, M.options.message)
				ok, id = pcall(vim.notify, message, vim.log.levels.WARN, {
					icon = icon, -- Notification icon
					replace = id, -- Replace the previous notification if it is still active
					keep = function()
						return count >= 10 -- Keep the notification active while count >= 10
					end,
				})
				if not ok then
					id = nil -- Reset id if there was an error with the notification
					return map -- Return the original key mapping
				end
			else
				count = count + 1 -- Increment the count
				-- Start a timer to reset the count after the delay
				timer:start(M.options.delay, 0, function()
					count = 0
				end)
				return map -- Return the original key mapping
			end
		end, { expr = true, silent = true }) -- `expr` to handle returning the key as a command
	end

	-- Function to skip the delay
	vim.keymap.set("n", M.options.skip_key, function()
		skip_key_active = true
		for _, key in ipairs(M.options.keys) do
			vim.api.nvim_del_keymap("n", key)
		end
		local icon, message = M.format_notification(M.options.icon, "Delay skipped with key: " .. M.options.skip_key)
		vim.notify(message, vim.log.levels.INFO, { icon = icon })
	end, { noremap = true, silent = true })
end

-- Automatically call the cowboy function on load
M.cowboy()

return M

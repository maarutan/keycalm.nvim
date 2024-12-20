local M = {}

-- Default settings
M.options = {
	delay = 2000, -- Delay time in milliseconds
	keys = { "h", "j", "k", "l", "+", "-" }, -- Keys to track
	icon = "🤠", -- Default icon
	message = "Hold it Cowboy!", -- Default message
	keySkip = "<Esc>", -- Key to skip the delay (default is Esc)
	lpIcon = 7, -- Left padding for the icon
	rpIcon = 0, -- Right padding for the icon
	lpText = 7, -- Left padding for the message text
	rpText = 7, -- Right padding for the message text
}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.formatNotification(icon, message)
	-- Add configurable spaces to the icon and message
	local formattedIcon = string.rep(" ", M.options.lpIcon) .. icon .. string.rep(" ", M.options.rpIcon)
	local formattedMessage = string.rep(" ", M.options.lpText) .. message .. string.rep(" ", M.options.rpText)
	return formattedIcon, formattedMessage
end

function M.cowboy()
	---@type table?
	local id
	local ok = true

	for _, key in ipairs(M.options.keys) do
		local count = 0
		local timer = assert(vim.loop.new_timer())
		local map = key
		vim.keymap.set("n", key, function()
			if vim.v.count > 0 then
				count = 0 -- Reset count if a prefix argument is used (e.g., 3h)
			end
			if count >= 10 then
				-- Show a warning when the count exceeds 10
				local icon, message = M.formatNotification(M.options.icon, M.options.message)
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
	vim.keymap.set("n", M.options.keySkip, function()
		for _, key in ipairs(M.options.keys) do
			vim.api.nvim_del_keymap("n", key)
		end
		local icon, message = M.formatNotification(M.options.icon, "Delay skipped with key: " .. M.options.keySkip)
		vim.notify(message, vim.log.levels.INFO, { icon = icon })
	end, { noremap = true, silent = true })
end

-- Automatically call the cowboy function on load
M.cowboy()

return M

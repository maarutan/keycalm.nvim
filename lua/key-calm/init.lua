-- ~/.config/nvim/lua/plugins/cowboy.lua
local M = {}

-- Default settings
M.options = {
	delay = 2000, -- Delay time in milliseconds
	timeout = 1000, -- Timeout for resetting counts
	keys = { "h", "j", "k", "l", "+", "-" }, -- Keys to track
	max_count = 10, -- Number of repetitions before triggering block
	icon = "🤠", -- Default icon
	message = "Hold it Cowboy!", -- Default message
	lp_icon = 7, -- Left padding for the icon
	rp_icon = 0, -- Right padding for the icon
	lp_text = 7, -- Left padding for the message text
	rp_text = 7, -- Right padding for the message text
	ignored_filetypes = { "neo-tree", "NvimTree", "TelescopePrompt", "help" }, -- Filetypes to ignore
}

local counts = {} -- Track counts for each key
local timers = {} -- Store timers for each key
local reset_timers = {} -- Timers to reset counts
local notifications_shown = {} -- Track if notification has been shown for a key
local blocked_keys = {} -- Track blocked keys

-- Check if the current buffer should be ignored
local function should_ignore()
	local filetype = vim.bo.filetype
	return vim.tbl_contains(M.options.ignored_filetypes, filetype)
end

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.format_notification(icon, message)
	local formatted_icon = string.rep(" ", M.options.lp_icon) .. icon .. string.rep(" ", M.options.rp_icon)
	local formatted_message = string.rep(" ", M.options.lp_text) .. message .. string.rep(" ", M.options.rp_text)
	return formatted_icon, formatted_message
end

function M.cowboy()
	for _, key in ipairs(M.options.keys) do
		counts[key] = 0
		timers[key] = nil
		reset_timers[key] = nil
		blocked_keys[key] = false
		notifications_shown[key] = false

		vim.keymap.set("n", key, function()
			if should_ignore() then
				return key -- Just pass the key if it's an ignored buffer
			end

			if blocked_keys[key] then
				return ""
			end

			counts[key] = counts[key] + 1

			-- Reset the timeout timer for this key
			if reset_timers[key] then
				reset_timers[key]:stop()
				reset_timers[key]:close()
			end

			reset_timers[key] = vim.loop.new_timer()
			reset_timers[key]:start(M.options.timeout, 0, function()
				counts[key] = 0
				reset_timers[key]:close()
				reset_timers[key] = nil
			end)

			if counts[key] >= M.options.max_count then
				if not notifications_shown[key] then
					local icon, message = M.format_notification(M.options.icon, M.options.message)
					vim.notify(message, vim.log.levels.WARN, { icon = icon })
					notifications_shown[key] = true
				end

				blocked_keys[key] = true

				-- Start timer to reset count and unblock the key after delay
				if timers[key] then
					timers[key]:stop()
					timers[key]:close()
				end

				timers[key] = vim.loop.new_timer()
				timers[key]:start(M.options.delay, 0, function()
					counts[key] = 0
					blocked_keys[key] = false
					notifications_shown[key] = false
					timers[key]:close()
					timers[key] = nil
				end)

				return ""
			end

			return key
		end, { noremap = true, silent = true, expr = true })
	end

	-- Keymap to reset the delay and counts
	vim.api.nvim_create_user_command("KeyCalmResetDelay", function()
		for key, _ in pairs(counts) do
			counts[key] = 0
			if timers[key] then
				timers[key]:stop()
				timers[key]:close()
				timers[key] = nil
			end
			if reset_timers[key] then
				reset_timers[key]:stop()
				reset_timers[key]:close()
				reset_timers[key] = nil
			end
			blocked_keys[key] = false
			notifications_shown[key] = false
		end

		local icon, message = M.format_notification(M.options.icon, "Delay reset for all keys!")
		vim.notify(message, vim.log.levels.INFO, { icon = icon })
	end, { nargs = 0 })
end

-- Automatically call the cowboy function on load
M.cowboy()

return M

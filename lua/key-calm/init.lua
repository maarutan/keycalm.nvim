-- ~/.config/nvim/lua/plugins/cowboy.lua
local M = {}

-- Default settings
M.options = {
	delay = 2000, -- Delay time in milliseconds
	keys = { "h", "j", "k", "l", "+", "-" }, -- Keys to track
	max_count = 10, -- Number of repetitions before triggering block
	icon = "🤠", -- Default icon
	message = "Hold it Cowboy!", -- Default message
	skip_key = "<Esc>", -- Key to reset the delay
	lp_icon = 7, -- Left padding for the icon
	rp_icon = 0, -- Right padding for the icon
	lp_text = 7, -- Left padding for the message text
	rp_text = 7, -- Right padding for the message text
}

local counts = {} -- Track counts for each key
local timers = {} -- Store timers for each key
local notifications_shown = {} -- Track if notification has been shown for a key
local blocked_keys = {} -- Track blocked keys

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
		blocked_keys[key] = false
		notifications_shown[key] = false

		vim.keymap.set("n", key, function()
			if blocked_keys[key] then
				return ""
			end

			counts[key] = counts[key] + 1

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
	vim.keymap.set("n", M.options.skip_key, function()
		for key, _ in pairs(counts) do
			counts[key] = 0
			if timers[key] then
				timers[key]:stop()
				timers[key]:close()
				timers[key] = nil
			end
			blocked_keys[key] = false
			notifications_shown[key] = false
		end

		local icon, message = M.format_notification(M.options.icon, "Delay reset for all keys!")
		vim.notify(message, vim.log.levels.INFO, { icon = icon })
	end, { noremap = true, silent = true })
end

-- Automatically call the cowboy function on load
M.cowboy()

return M

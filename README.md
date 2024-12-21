# KeyCalm.nvim

![KeyCalm Demo](./.github/keycalm.gif)

**KeyCalm.nvim** is a Neovim plugin designed to help you manage frequent keypresses. If you press certain keys too quickly, it gently reminds you to "calm down" with customizable notifications.

---

## Features

- **Monitor keypresses**: Track specific keys to detect frequent usage.
- **Custom notifications**: Fully configurable messages and icons.
- **Smart delay reset**: Automatically resets counters after a customizable delay.
- **Skip functionality**: Quickly bypass delays with a shortcut key.
- **Lightweight and fast**: Minimal impact on your Neovim setup.

---

## Installation

Use your preferred plugin manager to install KeyCalm.nvim. For example:

### With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'maarutan/keycalm.nvim',
    config = function()
      require('keycalm').setup({
	    delay = 2000, -- Delay time in milliseconds
	    timeout = 1000, -- Timeout for resetting counts
	    keys = { "h", "j", "k", "l", "+", "-" }, -- Keys to track
	    max_count = 10, -- Number of repetitions before triggering block
	    icon = "🤠", -- Default icon
	    message = "Hold it Cowboy!", -- Default message
	    skip_key = "<Esc>", -- Key to reset the delay
	    lp_icon = 7, -- Left padding for the icon
	    rp_icon = 0, -- Right padding for the icon
	    lp_text = 7, -- Left padding for the message text
	    rp_text = 7, -- Right padding for the message text
        })
    end
```

### With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'maarutan/keycalm.nvim',
  config = function()
      require('keycalm').setup({
	    delay = 2000, -- Delay time in milliseconds
	    timeout = 1000, -- Timeout for resetting counts
	    keys = { "h", "j", "k", "l", "+", "-" }, -- Keys to track
	    max_count = 10, -- Number of repetitions before triggering block
	    icon = "🤠", -- Default icon
	    message = "Hold it Cowboy!", -- Default message
	    skip_key = "<Esc>", -- Key to reset the delay
	    lp_icon = 7, -- Left padding for the icon
	    rp_icon = 0, -- Right padding for the icon
	    lp_text = 7, -- Left padding for the message text
	    rp_text = 7, -- Right padding for the message text
        })
  end
}
```

---

## Configuration

KeyCalm.nvim is fully configurable via the `setup` function. Below is an example configuration:

```lua
require('keycalm').setup({
  delay = 3000,            -- Delay time in milliseconds
  timeout = 1000,          -- Timeout for resetting counts
  keys = { "h", "j", "k" },-- Keys to monitor
  max_count = 10,          -- Number of repetitions before triggering block
  icon = "😎",             -- Icon for notifications
  message = "Take it easy!", -- Notification message
  skip_key = "<C-s>",      -- Key to skip the delay
  lp_icon = 5,             -- Left padding for icon
  rp_icon = 2,             -- Right padding for icon
  lp_text = 10,            -- Left padding for text
  rp_text = 10,            -- Right padding for text
})
```

### Default Options

```lua
{
  delay = 2000,            -- Delay time in milliseconds
  timeout = 1000,          -- Timeout for resetting counts
  keys = { "h", "j", "k", "l", "+", "-" }, -- Monitored keys
  icon = "🤠",             -- Default notification icon
  max_count = 10, -- Number of repetitions before triggering block
  message = "Hold it Cowboy!", -- Default notification message
  skip_key = "<Esc>",      -- Default skip key
  lp_icon = 7,             -- Left padding for icon
  rp_icon = 0,             -- Right padding for icon
  lp_text = 7,             -- Left padding for text
  rp_text = 7,             -- Right padding for text
}
```

---

## How It Works

1. **Monitor Keypresses**: Tracks keys specified in the `keys` option.
2. **Notify on Excessive Use**: Triggers a notification after 10 rapid keypresses.
3. **Reset Automatically**: Resets the keypress counter after the specified delay.
4. **Skip the Delay**: Use the `skip_key` shortcut to clear delays instantly.

---

## Troubleshooting

### Notifications Not Showing
- Ensure that `vim.notify` is available in your Neovim setup.
- Verify the configuration with the `setup` function.

### Keys Not Responding
- Check if the `max_count` is reached for the key. If yes, use the `skip_key` to reset the delay.

### Customization Not Working
- Ensure the options are passed correctly in the `setup` function.

---

## License

KeyCalm.nvim is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests at [KeyCalm.nvim Repository](https://github.com/maarutan/keycalm.nvim).

---

Enjoy a calmer coding experience with **KeyCalm.nvim**! 🎉

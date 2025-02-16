# KeyCalm.nvim

![KeyCalm Demo](./.github/keycalm.gif)

**KeyCalm.nvim** is a Neovim plugin designed to help you manage frequent keypresses. If you press certain keys too quickly, it gently reminds you to "calm down" with customizable notifications and behavior.

---

## Features

- **Monitor keypresses**: Track specific keys to detect frequent usage.
- **Custom notifications**: Fully configurable messages, icons, and padding for a personalized experience.
- **Smart delay and timeout**: Automatically resets counters after a customizable timeout and temporarily blocks keys after excessive use.
- **Ignored filetypes**: Avoid monitoring in specific filetypes like `help`, `Telescope`, and others.
- **Reset functionality**: Quickly reset all counts and delays with a customizable shortcut key.
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
      delay = 2000,           -- Delay time in milliseconds
      timeout = 1000,         -- Timeout for resetting counts
      keys = { "h", "j", "k", "l", "+", "-" }, -- Keys to track
      max_count = 10,         -- Number of repetitions before triggering block
      icon = "🤠",           -- Default icon
      message = "Hold it Cowboy!", -- Default message
      lp_icon = 7,            -- Left padding for the icon
      rp_icon = 0,            -- Right padding for the icon
      lp_text = 7,            -- Left padding for the message text
      rp_text = 7,            -- Right padding for the message text
      ignored_filetypes = { "neo-tree", "NvimTree", "TelescopePrompt", "help" }, -- Filetypes to ignore
    })
  end
}
```

### With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'maarutan/keycalm.nvim',
  config = function()
    require('keycalm').setup({
      delay = 2000,           -- Delay time in milliseconds
      timeout = 1000,         -- Timeout for resetting counts
      keys = { "h", "j", "k", "l", "+", "-" }, -- Keys to track
      max_count = 10,         -- Number of repetitions before triggering block
      icon = "🤠",           -- Default icon
      message = "Hold it Cowboy!", -- Default message
      lp_icon = 7,            -- Left padding for the icon
      rp_icon = 0,            -- Right padding for the icon
      lp_text = 7,            -- Left padding for the message text
      rp_text = 7,            -- Right padding for the message text
      ignored_filetypes = { "neo-tree", "NvimTree", "TelescopePrompt", "help" }, -- Filetypes to ignore
    })
  end
}
```

---

## Configuration

KeyCalm.nvim is fully configurable via the `setup` function. Below is an example configuration:

```lua
require('keycalm').setup({
  delay = 3000,             -- Delay time in milliseconds
  timeout = 1000,           -- Timeout for resetting counts
  keys = { "h", "j", "k" }, -- Keys to monitor
  max_count = 10,           -- Number of repetitions before triggering block
  icon = "😎",              -- Icon for notifications
  message = "Take it easy!", -- Notification message
  lp_icon = 5,              -- Left padding for icon
  rp_icon = 2,              -- Right padding for icon
  lp_text = 10,             -- Left padding for text
  rp_text = 10,             -- Right padding for text
  ignored_filetypes = { "help", "TelescopePrompt" }, -- Filetypes to ignore
})

vim.keymap.set("n", "R", "<cmd>KeyCalmResetDelay<CR>", { noremap = true, silent = true }) -- Reset the delay
```

### Default Options

```lua
{
  delay = 2000,            -- Delay time in milliseconds
  timeout = 1000,          -- Timeout for resetting counts
  keys = { "h", "j", "k", "l", "+", "-" }, -- Monitored keys
  max_count = 10,          -- Number of repetitions before triggering block
  icon = "🤠",            -- Default notification icon
  message = "Hold it Cowboy!", -- Default notification message
  lp_icon = 7,             -- Left padding for icon
  rp_icon = 0,             -- Right padding for icon
  lp_text = 7,             -- Left padding for text
  rp_text = 7,             -- Right padding for text
  ignored_filetypes = { "neo-tree", "NvimTree", "TelescopePrompt", "help" }, -- Filetypes to ignore
}
```

---

## How It Works

1. **Monitor Keypresses**: Tracks keys specified in the `keys` option.
2. **Notify on Excessive Use**: Triggers a notification after the configured number of rapid keypresses.
3. **Reset Automatically**: Resets the keypress counter after the specified timeout.
4. **Temporarily Block Keys**: Blocks monitored keys temporarily to encourage a pause.
5. **Skip Delays**: Use the command `KeyCalmResetDelay` shortcut to instantly reset counts and unblock keys.
6. **Ignored Filetypes**: Automatically skips monitoring in ignored filetypes for seamless experience.

---

## Troubleshooting

### Notifications Not Showing

- Ensure that `vim.notify` is available in your Neovim setup.
- Verify the configuration in the `setup` function.

### Keys Not Responding

- Check if the `max_count` limit is reached for the key. If so, use the `skip_key` to reset the delay.

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

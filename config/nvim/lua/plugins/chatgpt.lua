require("chatgpt").setup({
  api_key_cmd = "echo $GPT_API_KEY",
  edit_with_instructions = {
    diff = false,
    keymaps = {
      close = "<C-q>",
    },
  },
  chat = {
    keymaps = {
      close = "<C-q>",
    },
  },
})


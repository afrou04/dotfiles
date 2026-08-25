-- markdownをバッファ内でレンダリングする
-- @see: https://github.com/MeanderingProgrammer/render-markdown.nvim
--
-- markdown/markdown_inlineのparserはNeovim 0.12本体に同梱されているのでそのまま使える。
-- html/latex/yamlのparserは同梱されておらず未導入なので無効にする。
-- 使いたくなったらnvim-treesitterを入れて :TSInstall html latex yaml した上でここをtrueにする。
require('render-markdown').setup({
  html = { enabled = false },
  latex = { enabled = false },
  yaml = { enabled = false },
})

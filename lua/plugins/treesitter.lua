return {
  "nvim-treesitter/nvim-treesitter", 
  build = ":TSUpdate",
  config = function()
    local tsConfig = require("nvim-treesitter.configs")
    tsConfig.setup({
      auto_install = true,
      highlight = {enabled = true},
      indent = {enabled = true}
    })
  end
}

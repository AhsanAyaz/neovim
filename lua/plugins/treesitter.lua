return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	build = ":TSUpdate",
	config = function()
		local tsConfig = require("nvim-treesitter.configs")
		tsConfig.setup({
			auto_install = true,
			highlight = { enabled = true },
			indent = { enabled = true },
		})
		vim.filetype.add({
			pattern = {
				[".*%.component%.html"] = "angular.html", -- Sets the filetype to `angular.html` if it matches the pattern
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "angular.html",
			callback = function()
				vim.treesitter.language.register("angular", "angular.html") -- Register the filetype with treesitter for the `angular` language/parser
			end,
		})
		require("nvim-ts-autotag").setup({})
	end,
}

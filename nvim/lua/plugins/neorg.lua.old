-- TODO: Would be nice to configure core.esupports.metagen to create upper case titles
return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    cmd = "Neorg",
    ft = "norg",
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.esupports.metagen"] = {},
        ["core.summary"] = {}, -- Loads default behaviour
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader>n",
          },
        },
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/Notes/norg/",
            },
            default_workspace = "notes",
          },
        },
      },
    },
  },
}

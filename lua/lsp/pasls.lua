local M = {}
local configs = require("lspconfig/configs")
local util = require("lspconfig/util")

configs.pascal = {
  default_config = {
    cmd = {
      "pasls",
      -- Uncomment for debugging:
      --"--save-log", "pasls-log", "--save-replay", "pasls-replay"
    };
    filetypes = {"pascal"};
    root_dir = util.root_pattern(".git", "Makefile.fpc");
    init_options = {}
  };
  docs = {
    description = [[
https://github.com/Isopod/pascal-language-server

`pascal-language-server`, a language server for Pascal, based on fpc.
]];
    default_config = {
      root_dir = [[root_pattern(".git", "Makefile.fpc")]];
    };
  };
};

-- environment variables
-- PP — Path to the FPC compiler executable
-- FPCDIR — Path of the source code of the FPC standard library
-- LAZARUSDIR — Path of your Lazarus installation
-- FPCTARGET — Target OS (e.g. Linux, Darwin, ...)
-- FPCTARGETCPU — Target architecture (e.g. x86_64, AARCH64, ...)
M.pasls = {
    rootmarks = {".git", "xmake.lua", "*.lpi"},
}

return M

local M = {}

---@brief
---
--- https://clangd.llvm.org/installation.html
---
--- - **NOTE:** Clang >= 11 is recommended! See [#23](https://github.com/neovim/nvim-lspconfig/issues/23).
--- - If `compile_commands.json` lives in a build directory, you should
---   symlink it to the root of your source tree.
---   ```
---   ln -s /path/to/myproject/build/compile_commands.json /path/to/myproject/
---   ```
--- - clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html)
---   specified as compile_commands.json, see https://clangd.llvm.org/installation#compile_commandsjson

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
    local method_name = 'textDocument/switchSourceHeader'
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
    if not client then
        return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    client:request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            vim.notify('corresponding file cannot be determined')
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

local function symbol_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local clangd_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
    if not clangd_client or not clangd_client:supports_method 'textDocument/symbolInfo' then
        return vim.notify('Clangd client not found', vim.log.levels.ERROR)
    end
    local win = vim.api.nvim_get_current_win()
    local params = vim.lsp.util.make_position_params(win, clangd_client.offset_encoding)
    clangd_client:request('textDocument/symbolInfo', params, function(err, res)
        if err or #res == 0 then
            -- Clangd always returns an error, there is not reason to parse it
            return
        end
        local container = string.format('container: %s', res[1].containerName) ---@type string
        local name = string.format('name: %s', res[1].name) ---@type string
        vim.lsp.util.open_floating_preview({ name, container }, '', {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            focus = false,
            border = 'single',
            title = 'Symbol Info',
        })
    end, bufnr)
end

---@class ClangdInitializeResult: lsp.InitializeResult
---@field offsetEncoding? string

M.clangd = {
    cmd = {
        'clangd',
        "--offset-encoding=utf-16",
        -- "--all-scopes-completion", -- 全局补全(补全建议会给出在当前作用域不可见的索引,插入后自动补充作用域标识符),例如在main()中直接写cout,即使没有`#include <iostream>`,也会给出`std::cout`的建议,配合"--header-insertion=iwyu",还可自动插入缺失的头文件
        "--background-index", -- 后台分析并保存索引文件
        "--clang-tidy", -- 启用 Clang-Tidy 以提供「静态检查」，下面设置 clang tidy 规则
        -- "--clang-tidy-checks=performance-*, bugprone-*, misc-*, google-*, modernize-*, readability-*, portability-*",
        "--compile-commands-dir=${workspaceFolder}", -- 编译数据库(例如 compile_commands.json 文件)的目录位置
        "--completion-parse=auto", -- 当 clangd 准备就绪时，用它来分析建议
        "--completion-style=detailed", -- 建议风格：打包(重载函数只会给出一个建议);还可以设置为 detailed
        -- "--query-driver=/usr/bin/clang++", -- MacOS 上需要设定 clang 编译器的路径，homebrew 安装的clang 是 /usr/local/opt/llvm/bin/clang++
        -- 启用配置文件(YAML格式)项目配置文件是在项目文件夹里的“.clangd”,用户配置文件是“clangd/config.yaml”,该文件来自:Windows: %USERPROFILE%\AppData\Local || MacOS: ~/Library/Preferences/ || Others: $XDG_CONFIG_HOME, usually ~/.config
        "--enable-config",
        "--fallback-style=google", -- 默认格式化风格: 在没找到 .clang-format 文件时采用,可用的有 LLVM, Google, Chromium, Mozilla, Webkit, Microsoft, GNU
        "--function-arg-placeholders=true", -- 补全函数时，将会给参数提供占位符，键入后按 Tab 可以切换到下一占位符，乃至函数末
        "--header-insertion-decorators", -- 输入建议中，已包含头文件的项与还未包含头文件的项会以圆点加以区分
        "--header-insertion=never", -- 插入建议时自动引入头文件 iwyu
        -- "--include-cleaner-stdlib", -- 为标准库头文件启用清理功能(不成熟!!!)
        -- "--log=verbose", -- 让 Clangd 生成更详细的日志
        "--pch-storage=memory", -- pch 优化的位置(Memory 或 Disk,前者会增加内存开销，但会提升性能)
        "--pretty", -- 输出的 JSON 文件更美观
        "--ranking-model=decision_forest", -- 建议的排序方案：hueristics (启发式), decision_forest (决策树)
        "-j=8", -- 同时开启的任务数量
    },
    filetypes = {"c", "cpp", "objc", "objcpp", "cuda"},
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { 'utf-8', 'utf-16' },
    },
    ---@param client vim.lsp.Client
    ---@param init_result ClangdInitializeResult
    on_init = function(client, init_result)
        if init_result.offsetEncoding then
            client.offset_encoding = init_result.offsetEncoding
        end
    end,
    on_attach = function()
        vim.api.nvim_buf_create_user_command(0, 'LspClangdSwitchSourceHeader', function()
            switch_source_header(0)
        end, { desc = 'Switch between source/header' })

        vim.api.nvim_buf_create_user_command(0, 'LspClangdShowSymbolInfo', function()
            symbol_info()
        end, { desc = 'Show symbol info' })
    end,
    settings = {
        clangd = {
            InlayHints = {
                Designators = true,
                Enabled = true,
                ParameterNames = true,
                DeducedTypes = true,
            },
            fallbackFlags = { "-std=c++20" },
        }
    }
}

M.neocmake = {
    cmd = { 'neocmakelsp', '--stdio' },
    filetypes = { 'cmake' },
    root_markers = { '.git', 'build', 'cmake' },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = false
                }
            }
        },
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
                relative_pattern_support = true,
            },

        }
    }
}

return M

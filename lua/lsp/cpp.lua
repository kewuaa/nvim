local M = {}

M.clangd = {
    rootmarks = {".clangd", ".git"},
    filetypes = {"c", "cpp", "objc", "objcpp", "cuda"},
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

if require("utils").has_cargo then
    M.neocmake = {
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
else
    M.cmake = {}
end

return M

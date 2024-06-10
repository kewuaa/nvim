-- Made with 'mini.colors' module of https://github.com/echasnovski/mini.nvim

if vim.g.colors_name ~= nil then vim.cmd('highlight clear') end
vim.g.colors_name = "tokyonight"

-- Highlight groups
local hi = vim.api.nvim_set_hl

hi(0, "@annotation", { link = "PreProc" })
hi(0, "@attribute", { link = "PreProc" })
hi(0, "@character.printf", { link = "SpecialChar" })
hi(0, "@character.special", { link = "SpecialChar" })
hi(0, "@comment.error", { fg = "#c53b53" })
hi(0, "@comment.hint", { fg = "#4fd6be" })
hi(0, "@comment.info", { fg = "#0db9d7" })
hi(0, "@comment.note", { fg = "#4fd6be" })
hi(0, "@comment.todo", { fg = "#82aaff" })
hi(0, "@comment.warning", { fg = "#ffc777" })
hi(0, "@constant.builtin", { link = "Special" })
hi(0, "@constant.macro", { link = "Define" })
hi(0, "@constructor", { fg = "#c099ff" })
hi(0, "@constructor.tsx", { fg = "#65bcff" })
hi(0, "@diff.delta", { link = "DiffChange" })
hi(0, "@diff.minus", { link = "DiffDelete" })
hi(0, "@diff.plus", { link = "DiffAdd" })
hi(0, "@function.builtin", { link = "Special" })
hi(0, "@function.call", { link = "@function" })
hi(0, "@function.macro", { link = "Macro" })
hi(0, "@function.method", { link = "Function" })
hi(0, "@function.method.call", { link = "@function.method" })
hi(0, "@keyword", { fg = "#fca7ea", italic = true })
hi(0, "@keyword.conditional", { link = "Conditional" })
hi(0, "@keyword.coroutine", { link = "@keyword" })
hi(0, "@keyword.debug", { link = "Debug" })
hi(0, "@keyword.directive", { link = "PreProc" })
hi(0, "@keyword.directive.define", { link = "Define" })
hi(0, "@keyword.exception", { link = "Exception" })
hi(0, "@keyword.function", { fg = "#c099ff" })
hi(0, "@keyword.import", { link = "Include" })
hi(0, "@keyword.operator", { link = "@operator" })
hi(0, "@keyword.repeat", { link = "Repeat" })
hi(0, "@keyword.return", { link = "@keyword" })
hi(0, "@keyword.storage", { link = "StorageClass" })
hi(0, "@label", { fg = "#82aaff" })
hi(0, "@lsp.type.boolean", { link = "@boolean" })
hi(0, "@lsp.type.builtinType", { link = "@type.builtin" })
hi(0, "@lsp.type.comment", { link = "@comment" })
hi(0, "@lsp.type.decorator", { link = "@attribute" })
hi(0, "@lsp.type.deriveHelper", { link = "@attribute" })
hi(0, "@lsp.type.enum", { link = "@type" })
hi(0, "@lsp.type.enumMember", { link = "@constant" })
hi(0, "@lsp.type.escapeSequence", { link = "@string.escape" })
hi(0, "@lsp.type.formatSpecifier", { link = "@markup.list" })
hi(0, "@lsp.type.generic", { link = "@variable" })
hi(0, "@lsp.type.interface", { fg = "#93d0ff" })
hi(0, "@lsp.type.keyword", { link = "@keyword" })
hi(0, "@lsp.type.lifetime", { link = "@keyword.storage" })
hi(0, "@lsp.type.namespace", { link = "@module" })
hi(0, "@lsp.type.namespace.python", { link = "@variable" })
hi(0, "@lsp.type.number", { link = "@number" })
hi(0, "@lsp.type.operator", { link = "@operator" })
hi(0, "@lsp.type.parameter", { link = "@variable.parameter" })
hi(0, "@lsp.type.property", { link = "@property" })
hi(0, "@lsp.type.selfKeyword", { link = "@variable.builtin" })
hi(0, "@lsp.type.selfTypeKeyword", { link = "@variable.builtin" })
hi(0, "@lsp.type.string", { link = "@string" })
hi(0, "@lsp.type.typeAlias", { link = "@type.definition" })
hi(0, "@lsp.type.unresolvedReference", { sp = "#c53b53", undercurl = true })
hi(0, "@lsp.type.variable", {})
hi(0, "@lsp.typemod.class.defaultLibrary", { link = "@type.builtin" })
hi(0, "@lsp.typemod.enum.defaultLibrary", { link = "@type.builtin" })
hi(0, "@lsp.typemod.enumMember.defaultLibrary", { link = "@constant.builtin" })
hi(0, "@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
hi(0, "@lsp.typemod.keyword.async", { link = "@keyword.coroutine" })
hi(0, "@lsp.typemod.keyword.injected", { link = "@keyword" })
hi(0, "@lsp.typemod.macro.defaultLibrary", { link = "@function.builtin" })
hi(0, "@lsp.typemod.method.defaultLibrary", { link = "@function.builtin" })
hi(0, "@lsp.typemod.operator.injected", { link = "@operator" })
hi(0, "@lsp.typemod.string.injected", { link = "@string" })
hi(0, "@lsp.typemod.struct.defaultLibrary", { link = "@type.builtin" })
hi(0, "@lsp.typemod.type.defaultLibrary", { fg = "#589ed7" })
hi(0, "@lsp.typemod.typeAlias.defaultLibrary", { fg = "#589ed7" })
hi(0, "@lsp.typemod.variable.callable", { link = "@function" })
hi(0, "@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
hi(0, "@lsp.typemod.variable.injected", { link = "@variable" })
hi(0, "@lsp.typemod.variable.static", { link = "@constant" })
hi(0, "@markup", { link = "@none" })
hi(0, "@markup.emphasis", { italic = true })
hi(0, "@markup.environment", { link = "Macro" })
hi(0, "@markup.environment.name", { link = "Type" })
hi(0, "@markup.heading", { link = "Title" })
hi(0, "@markup.heading.1.markdown", { bold = true, fg = "#82aaff" })
hi(0, "@markup.heading.2.markdown", { bold = true, fg = "#ffc777" })
hi(0, "@markup.heading.3.markdown", { bold = true, fg = "#c3e88d" })
hi(0, "@markup.heading.4.markdown", { bold = true, fg = "#4fd6be" })
hi(0, "@markup.heading.5.markdown", { bold = true, fg = "#c099ff" })
hi(0, "@markup.heading.6.markdown", { bold = true, fg = "#fca7ea" })
hi(0, "@markup.link", { fg = "#4fd6be" })
hi(0, "@markup.link.label", { link = "SpecialChar" })
hi(0, "@markup.link.label.symbol", { link = "Identifier" })
hi(0, "@markup.link.url", { link = "Underlined" })
hi(0, "@markup.list", { fg = "#89ddff" })
hi(0, "@markup.list.checked", { fg = "#4fd6be" })
hi(0, "@markup.list.markdown", { bold = true, fg = "#ff966c" })
hi(0, "@markup.list.unchecked", { fg = "#82aaff" })
hi(0, "@markup.math", { link = "Special" })
hi(0, "@markup.raw", { link = "String" })
hi(0, "@markup.raw.markdown_inline", { bg = "#444a73", fg = "#82aaff" })
hi(0, "@module", { link = "Include" })
hi(0, "@module.builtin", { fg = "#ff757f" })
hi(0, "@namespace.builtin", { link = "@variable.builtin" })
hi(0, "@number.float", { link = "Float" })
hi(0, "@operator", { fg = "#89ddff" })
hi(0, "@property", { fg = "#4fd6be" })
hi(0, "@punctuation.bracket", { fg = "#828bb8" })
hi(0, "@punctuation.delimiter", { fg = "#89ddff" })
hi(0, "@punctuation.special", { fg = "#89ddff" })
hi(0, "@string.documentation", { fg = "#ffc777" })
hi(0, "@string.escape", { fg = "#c099ff" })
hi(0, "@string.regexp", { fg = "#b4f9f8" })
hi(0, "@tag", { link = "Label" })
hi(0, "@tag.attribute", { link = "@property" })
hi(0, "@tag.delimiter", { link = "Delimiter" })
hi(0, "@tag.delimiter.tsx", { fg = "#6582c3" })
hi(0, "@tag.tsx", { fg = "#ff757f" })
hi(0, "@type.builtin", { fg = "#589ed7" })
hi(0, "@type.definition", { link = "Typedef" })
hi(0, "@type.qualifier", { link = "@keyword" })
hi(0, "@variable", { fg = "#c8d3f5" })
hi(0, "@variable.builtin", { fg = "#ff757f" })
hi(0, "@variable.member", { fg = "#4fd6be" })
hi(0, "@variable.parameter", { fg = "#ffc777" })
hi(0, "@variable.parameter.builtin", { fg = "#ffd292" })
hi(0, "Bold", { bold = true, fg = "#c8d3f5" })
hi(0, "BqfSign", { ctermfg = 14, fg = "#00ffff" })
hi(0, "Character", { fg = "#c3e88d" })
hi(0, "CodeBlock", { bg = "#1e2030" })
hi(0, "ColorColumn", { bg = "#1b1d2b" })
hi(0, "Comment", { fg = "#636da6", italic = true })
hi(0, "Conceal", { fg = "#737aa2" })
hi(0, "Constant", { fg = "#ff966c" })
hi(0, "CurSearch", { link = "IncSearch" })
hi(0, "Cursor", { bg = "#c8d3f5", fg = "#222436" })
hi(0, "CursorColumn", { bg = "#2f334d" })
hi(0, "CursorIM", { bg = "#c8d3f5", fg = "#222436" })
hi(0, "CursorLine", { bg = "#2f334d" })
hi(0, "CursorLineNr", { bold = true, fg = "#ff966c" })
hi(0, "DapStoppedLine", { bg = "#38343d" })
hi(0, "Debug", { fg = "#ff966c" })
hi(0, "DefinitionCount", { fg = "#fca7ea" })
hi(0, "DefinitionIcon", { fg = "#82aaff" })
hi(0, "Delimiter", { link = "Special" })
hi(0, "DiagnosticError", { fg = "#c53b53" })
hi(0, "DiagnosticHint", { fg = "#4fd6be" })
hi(0, "DiagnosticInfo", { fg = "#0db9d7" })
hi(0, "DiagnosticInformation", { link = "DiagnosticInfo" })
hi(0, "DiagnosticUnderlineError", { sp = "#c53b53", undercurl = true })
hi(0, "DiagnosticUnderlineHint", { sp = "#4fd6be", undercurl = true })
hi(0, "DiagnosticUnderlineInfo", { sp = "#0db9d7", undercurl = true })
hi(0, "DiagnosticUnderlineWarn", { sp = "#ffc777", undercurl = true })
hi(0, "DiagnosticUnnecessary", { fg = "#444a73" })
hi(0, "DiagnosticVirtualTextError", { bg = "#322639", fg = "#c53b53" })
hi(0, "DiagnosticVirtualTextHint", { bg = "#273644", fg = "#4fd6be" })
hi(0, "DiagnosticVirtualTextInfo", { bg = "#203346", fg = "#0db9d7" })
hi(0, "DiagnosticVirtualTextWarn", { bg = "#38343d", fg = "#ffc777" })
hi(0, "DiagnosticWarn", { fg = "#ffc777" })
hi(0, "DiagnosticWarning", { link = "DiagnosticWarn" })
hi(0, "DiffAdd", { bg = "#273849" })
hi(0, "DiffChange", { bg = "#252a3f" })
hi(0, "DiffDelete", { bg = "#3a273a" })
hi(0, "DiffText", { bg = "#394b70" })
hi(0, "DiffviewDiffAddAsDelete", { bg = "#3a273a" })
hi(0, "DiffviewDim1", { fg = "#636da6" })
hi(0, "DiffviewFilePanelCounter", { bold = true, fg = "#c099ff" })
hi(0, "DiffviewFilePanelFileName", { fg = "#c8d3f5" })
hi(0, "DiffviewFilePanelTitle", { bold = true, fg = "#c099ff" })
hi(0, "DiffviewPrimary", { fg = "#82aaff" })
hi(0, "DiffviewSecondary", { fg = "#c3e88d" })
hi(0, "Directory", { fg = "#82aaff" })
hi(0, "DressingSelectIdx", { link = "Special" })
hi(0, "EndOfBuffer", { fg = "#222436" })
hi(0, "Error", { fg = "#c53b53" })
hi(0, "ErrorMsg", { fg = "#c53b53" })
hi(0, "FernBranchText", { fg = "#82aaff" })
hi(0, "FloatBorder", { bg = "#1e2030", fg = "#589ed7" })
hi(0, "FloatTitle", { bg = "#1e2030", fg = "#589ed7" })
hi(0, "FoldColumn", { bg = "#222436", fg = "#636da6" })
hi(0, "Folded", { bg = "#3b4261", fg = "#82aaff" })
hi(0, "Foo", { bg = "#ff007c", fg = "#c8d3f5" })
hi(0, "Function", { fg = "#82aaff" })
hi(0, "GitSignsAdd", { fg = "#627259" })
hi(0, "GitSignsChange", { fg = "#485a86" })
hi(0, "GitSignsDelete", { fg = "#b55a67" })
hi(0, "GitSignsStagedAdd", { fg = "#31392c" })
hi(0, "GitSignsStagedAddLn", { bg = "#273849" })
hi(0, "GitSignsStagedAddNr", { fg = "#31392c" })
hi(0, "GitSignsStagedChange", { fg = "#242d43" })
hi(0, "GitSignsStagedChangeLn", { bg = "#252a3f" })
hi(0, "GitSignsStagedChangeNr", { fg = "#242d43" })
hi(0, "GitSignsStagedChangedelete", { fg = "#242d43" })
hi(0, "GitSignsStagedChangedeleteLn", { bg = "#252a3f" })
hi(0, "GitSignsStagedChangedeleteNr", { fg = "#242d43" })
hi(0, "GitSignsStagedDelete", { fg = "#5a2d33" })
hi(0, "GitSignsStagedDeleteNr", { fg = "#5a2d33" })
hi(0, "GitSignsStagedTopdelete", { fg = "#5a2d33" })
hi(0, "GitSignsStagedTopdeleteNr", { fg = "#5a2d33" })
hi(0, "GlyphPalette1", { fg = "#c53b53" })
hi(0, "GlyphPalette2", { fg = "#c3e88d" })
hi(0, "GlyphPalette3", { fg = "#ffc777" })
hi(0, "GlyphPalette4", { fg = "#82aaff" })
hi(0, "GlyphPalette6", { fg = "#4fd6be" })
hi(0, "GlyphPalette7", { fg = "#c8d3f5" })
hi(0, "GlyphPalette9", { fg = "#ff757f" })
hi(0, "Headline", { link = "Headline1" })
hi(0, "Headline1", { bg = "#272b40" })
hi(0, "Headline2", { bg = "#2d2c39" })
hi(0, "Headline3", { bg = "#2a2e3a" })
hi(0, "Headline4", { bg = "#242d3d" })
hi(0, "Headline5", { bg = "#2a2a40" })
hi(0, "Headline6", { bg = "#2d2b3f" })
hi(0, "Hlargs", { fg = "#ffc777" })
hi(0, "Identifier", { fg = "#c099ff" })
hi(0, "IlluminatedWordRead", { bg = "#3b4261" })
hi(0, "IlluminatedWordText", { bg = "#3b4261" })
hi(0, "IlluminatedWordWrite", { bg = "#3b4261" })
hi(0, "IncSearch", { bg = "#ff966c", fg = "#1b1d2b" })
hi(0, "IndentBlanklineChar", { fg = "#3b4261", nocombine = true })
hi(0, "IndentBlanklineContextChar", { fg = "#65bcff", nocombine = true })
hi(0, "IndentLine", { fg = "#3b4261", nocombine = true })
hi(0, "IndentLineCurrent", { fg = "#ffc0cb" })
hi(0, "Italic", { fg = "#c8d3f5", italic = true })
hi(0, "Keyword", { fg = "#86e1fc", italic = true })
hi(0, "LineNr", { fg = "#3b4261" })
hi(0, "LineNrAbove", { fg = "#3b4261" })
hi(0, "LineNrBelow", { fg = "#3b4261" })
hi(0, "LspCodeLens", { fg = "#636da6" })
hi(0, "LspFloatWinBorder", { fg = "#589ed7" })
hi(0, "LspFloatWinNormal", { bg = "#1e2030" })
hi(0, "LspInfoBorder", { bg = "#1e2030", fg = "#589ed7" })
hi(0, "LspInlayHint", { bg = "#24283c", fg = "#545c7e" })
hi(0, "LspKindArray", { link = "@punctuation.bracket" })
hi(0, "LspKindBoolean", { link = "@boolean" })
hi(0, "LspKindClass", { link = "@type" })
hi(0, "LspKindColor", { link = "Special" })
hi(0, "LspKindConstant", { link = "@constant" })
hi(0, "LspKindConstructor", { link = "@constructor" })
hi(0, "LspKindEnum", { link = "@lsp.type.enum" })
hi(0, "LspKindEnumMember", { link = "@lsp.type.enumMember" })
hi(0, "LspKindEvent", { link = "Special" })
hi(0, "LspKindField", { link = "@variable.member" })
hi(0, "LspKindFile", { link = "Normal" })
hi(0, "LspKindFolder", { link = "Directory" })
hi(0, "LspKindFunction", { link = "@function" })
hi(0, "LspKindInterface", { link = "@lsp.type.interface" })
hi(0, "LspKindKey", { link = "@variable.member" })
hi(0, "LspKindKeyword", { link = "@lsp.type.keyword" })
hi(0, "LspKindMethod", { link = "@function.method" })
hi(0, "LspKindModule", { link = "@module" })
hi(0, "LspKindNamespace", { link = "@module" })
hi(0, "LspKindNull", { link = "@constant.builtin" })
hi(0, "LspKindNumber", { link = "@number" })
hi(0, "LspKindObject", { link = "@constant" })
hi(0, "LspKindOperator", { link = "@operator" })
hi(0, "LspKindPackage", { link = "@module" })
hi(0, "LspKindProperty", { link = "@property" })
hi(0, "LspKindReference", { link = "@markup.link" })
hi(0, "LspKindSnippet", { link = "Conceal" })
hi(0, "LspKindString", { link = "@string" })
hi(0, "LspKindStruct", { link = "@lsp.type.struct" })
hi(0, "LspKindText", { link = "@markup" })
hi(0, "LspKindTypeParameter", { link = "@lsp.type.typeParameter" })
hi(0, "LspKindUnit", { link = "@lsp.type.struct" })
hi(0, "LspKindValue", { link = "@string" })
hi(0, "LspKindVariable", { link = "@variable" })
hi(0, "LspReferenceRead", { bg = "#3b4261" })
hi(0, "LspReferenceText", { bg = "#3b4261" })
hi(0, "LspReferenceWrite", { bg = "#3b4261" })
hi(0, "LspSignatureActiveParameter", { bg = "#262f50", bold = true })
hi(0, "MatchParen", { bold = true, fg = "#ff966c" })
hi(0, "MiniCompletionActiveParameter", { underline = true })
hi(0, "MiniCursorword", { bg = "#3b4261" })
hi(0, "MiniCursorwordCurrent", { bg = "#3b4261" })
hi(0, "MiniDiffSignAdd", { fg = "#627259" })
hi(0, "MiniDiffSignChange", { fg = "#485a86" })
hi(0, "MiniDiffSignDelete", { fg = "#b55a67" })
hi(0, "MiniIndentscopePrefix", { nocombine = true })
hi(0, "MiniIndentscopeSymbol", { fg = "#65bcff", nocombine = true })
hi(0, "MiniJump", { bg = "#ff007c", fg = "#ffffff" })
hi(0, "MiniJump2dSpot", { bold = true, fg = "#ff007c", nocombine = true })
hi(0, "MiniStarterCurrent", { nocombine = true })
hi(0, "MiniStarterFooter", { fg = "#ffc777", italic = true })
hi(0, "MiniStarterHeader", { fg = "#82aaff" })
hi(0, "MiniStarterInactive", { fg = "#636da6", italic = true })
hi(0, "MiniStarterItem", { bg = "#222436", fg = "#c8d3f5" })
hi(0, "MiniStarterItemBullet", { fg = "#589ed7" })
hi(0, "MiniStarterItemPrefix", { fg = "#ffc777" })
hi(0, "MiniStarterQuery", { fg = "#0db9d7" })
hi(0, "MiniStarterSection", { fg = "#65bcff" })
hi(0, "MiniStatuslineDevinfo", { bg = "#2f334d", fg = "#828bb8" })
hi(0, "MiniStatuslineFileinfo", { bg = "#2f334d", fg = "#828bb8" })
hi(0, "MiniStatuslineFilename", { bg = "#3b4261", fg = "#828bb8" })
hi(0, "MiniStatuslineInactive", { bg = "#1e2030", fg = "#82aaff" })
hi(0, "MiniStatuslineModeCommand", { bg = "#ffc777", bold = true, fg = "#1b1d2b" })
hi(0, "MiniStatuslineModeInsert", { bg = "#c3e88d", bold = true, fg = "#1b1d2b" })
hi(0, "MiniStatuslineModeNormal", { bg = "#82aaff", bold = true, fg = "#1b1d2b" })
hi(0, "MiniStatuslineModeOther", { bg = "#4fd6be", bold = true, fg = "#1b1d2b" })
hi(0, "MiniStatuslineModeReplace", { bg = "#ff757f", bold = true, fg = "#1b1d2b" })
hi(0, "MiniStatuslineModeVisual", { bg = "#c099ff", bold = true, fg = "#1b1d2b" })
hi(0, "MiniSurround", { bg = "#ff966c", fg = "#1b1d2b" })
hi(0, "MiniTablineCurrent", { bg = "#3b4261", fg = "#c8d3f5" })
hi(0, "MiniTablineFill", { bg = "#1b1d2b" })
hi(0, "MiniTablineHidden", { bg = "#1e2030", fg = "#737aa2" })
hi(0, "MiniTablineModifiedCurrent", { bg = "#3b4261", fg = "#ffc777" })
hi(0, "MiniTablineModifiedHidden", { bg = "#1e2030", fg = "#bd9664" })
hi(0, "MiniTablineModifiedVisible", { bg = "#1e2030", fg = "#ffc777" })
hi(0, "MiniTablineTabpagesection", { bg = "#1e2030" })
hi(0, "MiniTablineVisible", { bg = "#1e2030", fg = "#c8d3f5" })
hi(0, "MiniTestEmphasis", { bold = true })
hi(0, "MiniTestFail", { bold = true, fg = "#ff757f" })
hi(0, "MiniTestPass", { bold = true, fg = "#c3e88d" })
hi(0, "MiniTrailspace", { bg = "#ff757f" })
hi(0, "ModeMsg", { bold = true, fg = "#828bb8" })
hi(0, "MoreMsg", { fg = "#82aaff" })
hi(0, "MsgArea", { fg = "#828bb8" })
hi(0, "NonText", { fg = "#545c7e" })
hi(0, "Normal", { bg = "#222436", fg = "#c8d3f5" })
hi(0, "NormalFloat", { bg = "#1e2030", fg = "#c8d3f5" })
hi(0, "NormalNC", { bg = "#222436", fg = "#c8d3f5" })
hi(0, "NormalSB", { bg = "#1e2030", fg = "#828bb8" })
hi(0, "OctoDetailsLabel", { bold = true, fg = "#65bcff" })
hi(0, "OctoDetailsValue", { link = "@variable.member" })
hi(0, "OctoDirty", { bold = true, fg = "#ff966c" })
hi(0, "OctoIssueTitle", { bold = true, fg = "#fca7ea" })
hi(0, "OctoStateChangesRequested", { link = "DiagnosticVirtualTextWarn" })
hi(0, "OctoStateClosed", { link = "DiagnosticVirtualTextError" })
hi(0, "OctoStateMerged", { bg = "#32304a", fg = "#c099ff" })
hi(0, "OctoStateOpen", { link = "DiagnosticVirtualTextHint" })
hi(0, "OctoStatePending", { link = "DiagnosticVirtualTextWarn" })
hi(0, "OctoStatusColumn", { fg = "#65bcff" })
hi(0, "Operator", { fg = "#89ddff" })
hi(0, "Pmenu", { bg = "#1e2030", fg = "#c8d3f5" })
hi(0, "PmenuSbar", { bg = "#292b3a" })
hi(0, "PmenuSel", { bg = "#363c58" })
hi(0, "PmenuThumb", { bg = "#3b4261" })
hi(0, "PreProc", { fg = "#86e1fc" })
hi(0, "Question", { fg = "#82aaff" })
hi(0, "QuickFixLine", { bg = "#2d3f76", bold = true })
hi(0, "RainbowDelimiterBlue", { fg = "#82aaff" })
hi(0, "RainbowDelimiterCyan", { fg = "#86e1fc" })
hi(0, "RainbowDelimiterGreen", { fg = "#c3e88d" })
hi(0, "RainbowDelimiterOrange", { fg = "#ff966c" })
hi(0, "RainbowDelimiterRed", { fg = "#ff757f" })
hi(0, "RainbowDelimiterViolet", { fg = "#fca7ea" })
hi(0, "RainbowDelimiterYellow", { fg = "#ffc777" })
hi(0, "ReferencesCount", { fg = "#fca7ea" })
hi(0, "ReferencesIcon", { fg = "#82aaff" })
hi(0, "Search", { bg = "#3e68d7", fg = "#c8d3f5" })
hi(0, "SignColumn", { bg = "#222436", fg = "#3b4261" })
hi(0, "SignColumnSB", { bg = "#1e2030", fg = "#3b4261" })
hi(0, "Sneak", { bg = "#c099ff", fg = "#2f334d" })
hi(0, "SneakScope", { bg = "#2d3f76" })
hi(0, "Special", { fg = "#65bcff" })
hi(0, "SpecialKey", { fg = "#545c7e" })
hi(0, "SpellBad", { sp = "#c53b53", undercurl = true })
hi(0, "SpellCap", { sp = "#ffc777", undercurl = true })
hi(0, "SpellLocal", { sp = "#0db9d7", undercurl = true })
hi(0, "SpellRare", { sp = "#4fd6be", undercurl = true })
hi(0, "Statement", { fg = "#c099ff" })
hi(0, "StatusLine", { bg = "#1e2030", fg = "#828bb8" })
hi(0, "StatusLineNC", { bg = "#1e2030", fg = "#3b4261" })
hi(0, "String", { fg = "#c3e88d" })
hi(0, "Substitute", { bg = "#ff757f", fg = "#1b1d2b" })
hi(0, "TSNodeKey", { bold = true, fg = "#ff007c" })
hi(0, "TSNodeUnmatched", { fg = "#545c7e" })
hi(0, "TSRainbowBlue", { fg = "#82aaff" })
hi(0, "TSRainbowCyan", { fg = "#86e1fc" })
hi(0, "TSRainbowGreen", { fg = "#c3e88d" })
hi(0, "TSRainbowOrange", { fg = "#ff966c" })
hi(0, "TSRainbowRed", { fg = "#ff757f" })
hi(0, "TSRainbowViolet", { fg = "#fca7ea" })
hi(0, "TSRainbowYellow", { fg = "#ffc777" })
hi(0, "TabLine", { bg = "#1e2030", fg = "#3b4261" })
hi(0, "TabLineFill", { bg = "#1b1d2b" })
hi(0, "TabLineSel", { bg = "#82aaff", fg = "#1b1d2b" })
hi(0, "TargetWord", { fg = "#86e1fc" })
hi(0, "Title", { bold = true, fg = "#82aaff" })
hi(0, "Todo", { bg = "#ffc777", fg = "#222436" })
hi(0, "TreesitterContext", { bg = "#363c58" })
hi(0, "Type", { fg = "#65bcff" })
hi(0, "VertSplit", { fg = "#1b1d2b" })
hi(0, "Visual", { bg = "#2d3f76" })
hi(0, "VisualNOS", { bg = "#2d3f76" })
hi(0, "WarningMsg", { fg = "#ffc777" })
hi(0, "Whitespace", { fg = "#3b4261" })
hi(0, "WildMenu", { bg = "#2d3f76" })
hi(0, "WinBar", { link = "StatusLine" })
hi(0, "WinBarNC", { link = "StatusLineNC" })
hi(0, "WinSeparator", { bold = true, fg = "#1b1d2b" })
hi(0, "YankyPut", { link = "IncSearch" })
hi(0, "YankyYanked", { link = "IncSearch" })
hi(0, "debugBreakpoint", { bg = "#203346", fg = "#0db9d7" })
hi(0, "debugPC", { bg = "#1e2030" })
hi(0, "diffAdded", { fg = "#b8db87" })
hi(0, "diffChanged", { fg = "#7ca1f2" })
hi(0, "diffFile", { fg = "#82aaff" })
hi(0, "diffIndexLine", { fg = "#c099ff" })
hi(0, "diffLine", { fg = "#636da6" })
hi(0, "diffNewFile", { fg = "#ff966c" })
hi(0, "diffOldFile", { fg = "#ffc777" })
hi(0, "diffRemoved", { fg = "#e26a75" })
hi(0, "dosIniLabel", { link = "@property" })
hi(0, "healthError", { fg = "#c53b53" })
hi(0, "healthSuccess", { fg = "#4fd6be" })
hi(0, "healthWarning", { fg = "#ffc777" })
hi(0, "helpCommand", { bg = "#444a73", fg = "#82aaff" })
hi(0, "htmlBold", { bold = true })
hi(0, "htmlBoldItalic", { bold = true, italic = true })
hi(0, "htmlBoldUnderline", { bold = true, underline = true })
hi(0, "htmlBoldUnderlineItalic", { bold = true, italic = true, underline = true })
hi(0, "htmlH1", { bold = true, fg = "#c099ff" })
hi(0, "htmlH2", { bold = true, fg = "#82aaff" })
hi(0, "htmlItalic", { italic = true })
hi(0, "htmlStrike", { strikethrough = true })
hi(0, "htmlUnderline", { underline = true })
hi(0, "htmlUnderlineItalic", { italic = true, underline = true })
hi(0, "illuminatedCurWord", { bg = "#3b4261" })
hi(0, "illuminatedWord", { bg = "#3b4261" })
hi(0, "lCursor", { bg = "#c8d3f5", fg = "#222436" })
hi(0, "markdownCode", { fg = "#4fd6be" })
hi(0, "markdownCodeBlock", { fg = "#4fd6be" })
hi(0, "markdownH1", { bold = true, fg = "#c099ff" })
hi(0, "markdownH2", { bold = true, fg = "#82aaff" })
hi(0, "markdownHeadingDelimiter", { bold = true, fg = "#ff966c" })
hi(0, "markdownLinkText", { fg = "#82aaff", underline = true })
hi(0, "mkdCodeDelimiter", { bg = "#444a73", fg = "#c8d3f5" })
hi(0, "mkdCodeEnd", { bold = true, fg = "#4fd6be" })
hi(0, "mkdCodeStart", { bold = true, fg = "#4fd6be" })
hi(0, "pythonVenv", { ctermfg = 214, fg = "#ffbc03" })
hi(0, "qfFileName", { fg = "#82aaff" })
hi(0, "qfLineNr", { fg = "#737aa2" })
hi(0, "rainbowcol1", { fg = "#ff757f" })
hi(0, "rainbowcol2", { fg = "#ffc777" })
hi(0, "rainbowcol3", { fg = "#c3e88d" })
hi(0, "rainbowcol4", { fg = "#4fd6be" })
hi(0, "rainbowcol5", { fg = "#82aaff" })
hi(0, "rainbowcol6", { fg = "#c099ff" })
hi(0, "rainbowcol7", { fg = "#fca7ea" })

-- Terminal colors
local g = vim.g

g.terminal_color_0 = "#1b1d2b"
g.terminal_color_1 = "#ff757f"
g.terminal_color_2 = "#c3e88d"
g.terminal_color_3 = "#ffc777"
g.terminal_color_4 = "#82aaff"
g.terminal_color_5 = "#c099ff"
g.terminal_color_6 = "#86e1fc"
g.terminal_color_7 = "#828bb8"
g.terminal_color_8 = "#444a73"
g.terminal_color_9 = "#ff757f"
g.terminal_color_10 = "#c3e88d"
g.terminal_color_11 = "#ffc777"
g.terminal_color_12 = "#82aaff"
g.terminal_color_13 = "#c099ff"
g.terminal_color_14 = "#86e1fc"
g.terminal_color_15 = "#c8d3f5"

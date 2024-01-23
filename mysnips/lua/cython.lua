local ok, snip = pcall(require, "python")
if ok then
    return snip
end
package.path = package.path .. (";%s/mysnips/lua/?.lua"):format(vim.fn.stdpath("config"))
return require("python")

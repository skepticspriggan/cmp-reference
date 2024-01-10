local source = {}

local cmp = require 'cmp'

function source:new()
  return setmetatable({}, {__index = source})
end

function source:get_keyword_pattern()
  return [[@\k\+]]
end

function source:is_available()
  return vim.o.filetype == 'markdown'
end

local function normalize(text)
  if text then
    return text:gsub('\n', ' '):gsub('}', ''):gsub('{', ''):gsub('%s%s+', ' ')
  end
  return text
end

local function parse_reference(lines)
  local fields = {}
  for line in lines:gmatch('([^\n]*)\n?') do
    if line:sub(1, 1) == '@' then
      fields.type = string.match(line, '^@(.-){')
      fields.key = string.match(line, '^@.+{(.-),$')
    end
    for name, value in string.gmatch(line, '(%w+)%s*=%s*["{]*(.-)["}],?$') do
      fields[name] = normalize(value)
    end
  end
  return fields
end

local function print_reference(fields, format)
  local text = format

  for k, v in pairs(fields) do
    text = text:gsub('{{' .. k .. '}}', v)
  end

  -- delete missing fields
  text = text:gsub('{{.-}}', '')

  return text
end

local function parse_bibliography(file, format)
  local items = {}

  local f = assert( io.open(file, 'r') )
  local references = f:read('*all')
  f:close()
  for reference in references:gmatch('@.-\n}\n') do
    local item = {}

    local fields = parse_reference(reference)

    item.documentation = {
      kind = cmp.lsp.MarkupKind.Markdown,
      value = print_reference(fields, format)
    }

    item.label = '@' .. fields.key or ""
    item.kind = cmp.lsp.CompletionItemKind.Reference

    table.insert(items, item)
  end

  return items
end

function source:complete(params, callback)
  local items = {}

  local defaults = {
    file = "~/.pandoc/bibliography.bib",
    format =
      [[
        **{{title}}**
        *{{year}}*
        {{author}}
      ]]
  }

  local option = vim.tbl_deep_extend('keep', params.option, defaults)
 
  items = parse_bibliography(option.file, option.format)
  
  callback(items)
end

return source

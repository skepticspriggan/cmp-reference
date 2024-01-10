# nvim-reference

A source for [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) that provides completion for bibliography reference keys.

## Features

- _Global bibliography definition:_ set the bibliography source file only once for all files
- _Format reference preview:_ define how the selected reference is shown in the preview

## Installation

Make the plugin available to nvim with [Lazy](https://github.com/folke/lazy.nvim) by specifying it as a dependency to `nvim-cmp`:

```lua
{
  'hrsh7th/nvim-cmp',
  ...
  dependencies = {
    ...
    'skepticspriggan/cmp-reference'
  }
}
```

Add the plugin as completion source for `nvim-cmp`: 

```lua
require('cmp').setup({
  sources = {
    ...
    { name = 'reference' },
  },
})
```
 
## Configuration

Add a table to the `option` field in the definition of the completion source:

```lua
cmp.setup {
  ...
  sources = {
    {
      name = 'reference',
      option = {
        file = "/path/to/bibliography.bib"
        format =
          [[
            **{{title}}**
            *{{year}}*
            {{author}}
          ]]
      }
    }
  }
}
```

The available parameters are:

**file**

The path to the file of the bibliography source.

_Default:_ "~/.pandoc/bibliography.bib"

_Examples:_ "/path/to/bibliography.bib"

**format**

The template used to print citation information in the documentation hover menu. The citation fields can be specified as `{{field}}`. 

Missing fields will be removed.

_Default:_

```
[[
  **{{title}}**
  *{{year}}*
  {{author}}
]]
```

## Todo

- Multiple bibliography file types
- Local bibliography file definition in YAML frontmatter

## Credits

The package was inspired by:

- [nvim-telescope/telescope-bibtex](https://github.com/nvim-telescope/telescope-bibtex.nvim)
- [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path/blob/main/lua/cmp_path/init.lua)

## Similar Projects

- [aspeddro/cmp-pandoc](https://github.com/aspeddro/cmp-pandoc.nvim)
- [jc-doyle/cmp-pandoc-references](https://github.com/jc-doyle/cmp-pandoc-references/)

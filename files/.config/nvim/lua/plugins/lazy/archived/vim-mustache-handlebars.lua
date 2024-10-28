-- This plugin seems to be loaded on any filetype on startup, so lets archive it for now

--- A vim plugin for working with mustache and handlebars templates.
--- https://github.com/mustache/vim-mustache-handlebars
-- au BufNewFile,BufRead *.handlebars,*.hdbs,*.hbs,*.hb set filetype=html.handlebars
-- au BufNewFile,BufRead *.mustache,*.hogan,*.hulk,*.hjs set filetype=html.mustache
return {
  "mustache/vim-mustache-handlebars",
  ft = { "mustache", "handlebars" },
}

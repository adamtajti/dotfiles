" Fallback to setting up the plugin automatically
if !exists("g:deus_has_setup")
lua << EOF
  require("deus")
EOF
endif

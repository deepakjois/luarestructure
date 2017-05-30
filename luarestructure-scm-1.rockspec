package = "luarestructure"
version = "scm-1"
source = {
   url = "git+https://github.com/deepakjois/luarestructure.git"
}
description = {
   summary = "Declaratively encode and decode binary data",
   detailed = [[
luarestructure is a nearly line-by-line port of [restructure] (including this README)
from Javascript to Lua.]],
   homepage = "https://github.com/deepakjois/luarestructure",
   license = "MIT"
}
dependencies = {
   "lua >= 5.2, < 5.4"
}
build = {
   type = "builtin",
   modules = {}
}

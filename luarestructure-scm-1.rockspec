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
   "lua >= 5.2, < 5.4",
   "vstruct >= 2.0.1"
}
build = {
   type = "builtin",
   modules = {
     restructure = "src/restructure/init.lua",
     ["restructure.Array"] = "src/restructure/Array.lua",
     ["restructure.Bitfield"] = "src/restructure/Bitfield.lua",
     ["restructure.Boolean"] = "src/restructure/Boolean.lua",
     ["restructure.Buffer"] = "src/restructure/Buffer.lua",
     ["restructure.DecodeStream"] = "src/restructure/DecodeStream.lua",
     ["restructure.EncodeStream"] = "src/restructure/EncodeStream.lua",
     ["restructure.Enum"] = "src/restructure/Enum.lua",
     ["restructure.LazyArray"] = "src/restructure/LazyArray.lua",
     ["restructure.Number"] = "src/restructure/Number.lua",
     ["restructure.Optional"] = "src/restructure/Optional.lua",
     ["restructure.Pointer"] = "src/restructure/Pointer.lua",
     ["restructure.Reserved"] = "src/restructure/Reserved.lua",
     ["restructure.String"] = "src/restructure/String.lua",
     ["restructure.Struct"] = "src/restructure/Struct.lua",
     ["restructure.VersionedStruct"] = "src/restructure/VersionedStruct.lua",
     ["restructure.utils"] = "src/restructure/utils.lua"
   }
}

local exports = {}

exports.EncodeStream = require ('restructure.EncodeStream')
exports.DecodeStream = require('restructure.DecodeStream')
-- exports.Array           = require './src/Array'
-- exports.LazyArray       = require './src/LazyArray'
exports.Bitfield = require('restructure.Bitfield')
exports.Boolean = require('restructure.Boolean')
-- exports.Buffer          = require './src/Buffer'
exports.Enum = require('restructure.Enum')
exports.Optional = require('restructure.Optional')
exports.Reserved = require('restructure.Reserved')
-- exports.String          = require './src/String'
-- exports.Struct          = require './src/Struct'
-- exports.VersionedStruct = require './src/VersionedStruct'



local Number = require("restructure.Number")

for k,v in pairs(Number) do
  exports[k] = v
end

-- for key, val of require './src/Pointer'
--   exports[key] = val


return exports
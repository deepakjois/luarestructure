local exports = {}

exports.EncodeStream = require ('restructure.EncodeStream')
exports.DecodeStream = require('restructure.DecodeStream')
exports.Array = require('restructure.Array')
exports.LazyArray = require('restructure.LazyArray')
exports.Bitfield = require('restructure.Bitfield')
exports.Boolean = require('restructure.Boolean')
exports.Buffer = require('restructure.Buffer')
exports.Enum = require('restructure.Enum')
exports.Optional = require('restructure.Optional')
exports.Reserved = require('restructure.Reserved')
exports.String = require('restructure.String')
exports.Struct = require('restructure.Struct')
-- exports.VersionedStruct = require './src/VersionedStruct'

local Number = require("restructure.Number")

for k,v in pairs(Number) do
  exports[k] = v
end

-- for key, val of require './src/Pointer'
--   exports[key] = val

return exports
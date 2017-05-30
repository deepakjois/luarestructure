local exports = {}

exports.EncodeStream = require ('restructure.EncodeStream')
exports.DecodeStream = require('restructure.DecodeStream')
-- exports.Array           = require './src/Array'
-- exports.LazyArray       = require './src/LazyArray'
-- exports.Bitfield        = require './src/Bitfield'
-- exports.Boolean         = require './src/Boolean'
-- exports.Buffer          = require './src/Buffer'
-- exports.Enum            = require './src/Enum'
-- exports.Optional        = require './src/Optional'
-- exports.Reserved        = require './src/Reserved'
-- exports.String          = require './src/String'
-- exports.Struct          = require './src/Struct'
-- exports.VersionedStruct = require './src/VersionedStruct'



local Number = require("restructure.Number")

for k,v in ipairs(Number) do
  exports[k] = v
end

-- for key, val of require './src/Pointer'
--   exports[key] = val


return exports
local DecodeStream = require("restructure").DecodeStream

describe('DecodeStream', function()
  it("should read a buffer", function()
    local buf = "abc"
    local stream = DecodeStream.new(buf)
    assert.are_equal(stream:readBuffer(#buf), buf)
  end)

  it("should read a string", function()
    local buf = "abc"
    local stream = DecodeStream.new(buf)
    assert.are_equal(stream:readString(#buf), buf)
  end)

 it('should readUInt16BE', function()
   local buf = string.char(0xab, 0xcd)
   local stream = DecodeStream.new(buf)
   assert.are_equal(stream:readUInt16BE(), 0xabcd)
 end)

 it('should readUInt16LE', function()
   local buf = string.char(0xab, 0xcd)
   local stream = DecodeStream.new(buf)
   assert.are_equal(stream:readUInt16LE(), 0xcdab)
 end)

 it('should readUInt24BE', function()
   local buf = string.char(0xab, 0xcd, 0xef)
   local stream = DecodeStream.new(buf)
   assert.are_equal(stream:readUInt24BE(), 0xabcdef)
 end)

 it('should readUInt24LE', function()
   local buf = string.char(0xab, 0xcd, 0xef)
   local stream = DecodeStream.new(buf)
   assert.are_equal(stream:readUInt24LE(), 0xefcdab)
 end)

 it('should readInt24BE', function()
   local buf = string.char(0xff, 0xab, 0x24)
   local stream = DecodeStream.new(buf)
   assert.are_equal(stream:readInt24BE(), -21724)
 end)

 it('should readInt24LE', function()
   local buf = string.char(0x24, 0xab, 0xff)
   local stream = DecodeStream.new(buf)
   assert.are_equal(stream:readInt24LE(), -21724)
 end)

end)

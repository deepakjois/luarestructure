local r = require("restructure")
local StringT = r.String

describe('String', function()
  describe('decode', function()
    it('should decode fixed length', function()
      local stream = r.DecodeStream.new('testing')
      local string = StringT.new(7)
      assert.are_equal('testing',string:decode(stream))
    end)

    it('should decode length from parent key', function()
      local stream = r.DecodeStream.new('testing')
      local string = StringT.new('len')
      assert.are_equal('testing',string:decode(stream, {len = 7}))
    end)

    it('should decode length as number before string', function()
      local stream = r.DecodeStream.new('\x07testing')
      local string = StringT.new(r.uint8)
      assert.are_equal('testing',string:decode(stream))
    end)

    it('should decode utf8', function()
      local stream = r.DecodeStream.new('🍻')
      local string = StringT.new(4, 'utf8')
      assert.are_equal('🍻',string:decode(stream))
    end)

    it('should decode nil-terminated string and read past terminator', function()
      local stream = r.DecodeStream.new('🍻\x00')
      local string = StringT.new(nil, 'utf8')
      assert.are_equal('🍻',string:decode(stream))
    end)

    it('should decode remainder of buffer when nil-byte missing', function()
      local stream = r.DecodeStream.new('🍻')
      local string = StringT.new(nil, 'utf8')
      assert.are_equal('🍻',string:decode(stream))
    end)
  end)

  describe('size', function()
    it('should use string length', function()
      local string = StringT.new(7)
      assert.are_equal(7,string:size('testing'))
    end)

    it('should add size of length field before string', function()
      local string = StringT.new(r.uint8, 'utf8')
      assert.are_equal(5,string:size('🍻'))
    end)

    it('should take nil-byte into account', function()
      local string = StringT.new(nil, 'utf8')
      assert.are_equal(5,string:size('🍻'))
    end)

    it('should use defined length if no value given', function()
      local array = StringT.new(10)
      assert.are_equal(10,array:size())
    end)
  end)

  describe('encode', function()
    it('should encode using string length', function()
      local stream = r.EncodeStream.new()
      local string = StringT.new(7)
      string:encode(stream, 'testing')
      assert.are_equal('testing',stream:getContents())
    end)

    it('should encode length as number before string', function()
      local stream = r.EncodeStream.new()
      local string = StringT.new(r.uint8)
      string:encode(stream, 'testing')
      assert.are_equal('\x07testing',stream:getContents())
    end)

    it('should encode length as number before string utf8', function()
      local stream = r.EncodeStream.new()
      local string = StringT.new(r.uint8, 'utf8')
      string:encode(stream, 'testing 😜')
      assert.are_equal('\x0ctesting 😜', stream:getContents())
    end)

    it('should encode utf8', function()
      local stream = r.EncodeStream.new()
      local string = StringT.new(4, 'utf8')
      string:encode(stream, '🍻')
      assert.are_equal('🍻',stream:getContents())
    end)

    it('should encode nil-terminated string', function()
      local stream = r.EncodeStream.new()
      local string = StringT.new(nil, 'utf8')
      string:encode(stream, '🍻')
      assert.are_equal('🍻\x00',stream:getContents())
    end)
  end)
end)

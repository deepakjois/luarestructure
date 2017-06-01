local r = require("restructure")

describe('Buffer', function()
  describe('decode', function()
    it('should decode', function()
      local stream = r.DecodeStream.new(string.char(0xab, 0xff, 0x1f, 0xb6))
      local buf = r.Buffer.new(2)
      assert.are_equal(string.char(0xab, 0xff), buf:decode(stream))
      assert.are_equal(string.char(0x1f, 0xb6), buf:decode(stream))
    end)

    it('should decode with parent key length', function()
      local stream = r.DecodeStream.new(string.char(0xab, 0xff, 0x1f, 0xb6))
      local buf = r.Buffer.new('len')
      assert.are_equal(string.char(0xab, 0xff, 0x1f), buf:decode(stream, {len = 3}))
      assert.are_equal(string.char(0xb6), buf:decode(stream, {len = 1}))
    end)
  end)

  describe('size', function()
    it('should return size', function()
      local buf = r.Buffer.new(2)
      assert.are_equal(2, buf:size(string.char(0xab, 0xff)))
    end)

    it('should use defined length if no value given', function()
      local array = r.Buffer.new(10)
      assert.are_equal(10, array:size())
    end)
  end)

  describe('encode', function()
    it('should encode', function()
      local stream = r.EncodeStream.new()
      local buf = r.Buffer.new(2)
      buf:encode(stream, string.char(0xab, 0xff))
      buf:encode(stream, string.char(0x1f, 0xb6))
      assert.are_equal(string.char(0xab, 0xff, 0x1f, 0xb6), stream:getContents())
    end)

    it('should encode length before buffer', function()
      local stream = r.EncodeStream.new()
      local buf = r.Buffer.new(r.uint8)
      buf:encode(stream, string.char(0xab, 0xff))
      assert.are_equal(string.char(2, 0xab, 0xff), stream:getContents())
    end)
  end)
end)
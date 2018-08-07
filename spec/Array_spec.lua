local r = require('restructure')
local ArrayT = r.Array

describe('Array', function()
  describe('decode', function()
    it( 'should decode fixed length', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint8, 4)
      assert.are.same({1, 2, 3, 4}, array:decode(stream))
    end)

    it( 'should decode fixed amount of bytes', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint16, 4, 'bytes')
      assert.are.same({258, 772}, array:decode(stream))
    end)

    it( 'should decode length from parent key', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint8, 'len')
      assert.are.same({1, 2, 3, 4}, array:decode(stream, { len = 4 }))
    end)

    it( 'should decode amount of bytes from parent key', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint16, 'len', 'bytes')
      assert.are.same({258, 772}, array:decode(stream, { len = 4 }))
    end)

    it( 'should decode length as number before array', function()
      local stream = r.DecodeStream.new(string.char(4, 1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint8, r.uint8)
      local val = array:decode(stream)
      local exp = {1,2,3,4}
      for i, v in ipairs(val) do
        assert.are_equal(exp[i], v)
      end
    end)

    it( 'should decode amount of bytes as number before array', function()
      local stream = r.DecodeStream.new(string.char(4, 1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint16, r.uint8, 'bytes')
      local val = array:decode(stream)
      local exp = {258, 772}
      for i, v in ipairs(val) do
        assert.are_equal(exp[i], v)
      end
    end)

    it( 'should decode length from function', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint8, function() return 4 end)
      assert.are.same({1, 2, 3, 4}, array:decode(stream))
    end)

    it( 'should decode amount of bytes from function', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint16, function() return 4 end, 'bytes')
      assert.are.same({258, 772}, array:decode(stream))
    end)

    it( 'should decode to the end of the parent if no length is given', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 3, 4, 5))
      local array = ArrayT.new(r.uint8)
      assert.are.same({1, 2, 3, 4}, array:decode(stream, {_length = 4, _startOffset = 0}))
    end)

    it( 'should decode to the end of the stream if no parent and length is given', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 3, 4))
      local array = ArrayT.new(r.uint8)
      assert.are.same({1, 2, 3, 4}, array:decode(stream))
    end)
  end)

  describe('size', function()
    it( 'should use array length', function()
      local array = ArrayT.new(r.uint8, 10)
      assert.are_equal(4, array:size({1, 2, 3, 4}))
    end)

    it( 'should add size of length field before string', function()
      local array = ArrayT.new(r.uint8, r.uint8)
      assert.are_equal(5, array:size({1, 2, 3, 4}))
    end)

    it( 'should use defined length if no value given', function()
      local array = ArrayT.new(r.uint8, 10)
      assert.are_equal(10, array:size())
    end)
  end)

  describe('encode', function()
    it( 'should encode using array length', function()
      local stream = r.EncodeStream.new()
      local array = ArrayT.new(r.uint8, 10)
      array:encode(stream, {1, 2, 3, 4})
      assert.are.same((string.char(1, 2, 3, 4)), stream:getContents())
    end)

    it( 'should encode length as number before array', function()
      local stream = r.EncodeStream.new()
      local array = ArrayT.new(r.uint8, r.uint8)
      array:encode(stream, {1, 2, 3, 4})
      assert.are.same((string.char(4, 1, 2, 3, 4)), stream:getContents())
    end)

    it( 'should add pointers after array if length is encoded at start', function()
      local stream = r.EncodeStream.new()
      local array = ArrayT.new(r.Pointer.new(r.uint8, r.uint8), r.uint8)
      array:encode(stream, {1, 2, 3, 4})
      assert.are.same((string.char(4,5, 6, 7, 8, 1, 2, 3, 4)), stream:getContents())
    end)
  end)
end)
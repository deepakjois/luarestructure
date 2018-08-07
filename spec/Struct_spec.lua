local r = require('restructure')
local StringT = r.String

describe('Struct', function()
  describe('decode', function()
    it('should decode into an object', function()
      local stream = r.DecodeStream.new("\x05devon\x15")
      local struct = r.Struct.new({
        { name = StringT.new(r.uint8) },
        { age = r.uint8 }
      })

      assert.are.same({name = "devon", age = 21}, struct:decode(stream))
    end)

    it('should support process hook', function()
      local stream = r.DecodeStream.new("\x05devon\x20")
      local struct = r.Struct.new({
        {name = StringT.new(r.uint8)},
        {age = r.uint8}
      })

      struct.process = function(res)
        res.canDrink = res.age >= 21
      end

      assert.are.same({name = "devon", age = 32, canDrink = true}, struct:decode(stream))
    end)

    it('should support function keys', function()
      local stream = r.DecodeStream.new("\x05devon\x20")
      local struct = r.Struct.new({
        { name = StringT.new(r.uint8) },
        { age = r.uint8 },
        { canDrink = function(res) return res.age >= 21 end }
      })

      assert.are.same({ name = 'devon', age = 32, canDrink = true }, struct:decode(stream))
    end)
  end)

  describe('size', function()
    it('should compute the correct size', function()
      local struct = r.Struct.new({
        {name = StringT.new(r.uint8)},
        {age = r.uint8}
      })

      assert.are_equal(7, struct:size({name = 'devon', age = 21}))
    end)

    -- it 'should compute the correct size with pointers', function()
    --   local struct = r.Struct.new
    --     name: StringT.new(r.uint8)
    --     age: r.uint8
    --     ptr: new Pointer r.uint8, StringT.new(r.uint8)
    --
    --   size = struct.size
    --     name: 'devon'
    --     age: 21
    --     ptr: 'hello'
    --
    --   size.should.equal 14

    it('should get the correct size when no value is given', function()
      local struct = r.Struct.new({
        { name = StringT.new(4) },
        { age = r.uint8 }
      })

      assert.are_equal(5, struct:size())
    end)

    it('should throw when getting non-fixed length size and no value is given', function()
      local struct = r.Struct.new({
        {name = StringT.new(r.uint8)},
        {age  = r.uint8}
      })
      assert.has_error(function() struct:size() end, "Not a fixed size")
    end)
  end)

  describe('encode', function()
    it('should encode objects to buffers', function()
      local stream = r.EncodeStream.new()

      local struct = r.Struct.new({
        {name = StringT.new(r.uint8)},
        {age  = r.uint8}
      })

      struct:encode(stream, { name = 'devon', age = 21 })

      assert.are_equal("\x05devon\x15", stream:getContents())
    end)

    it('should support preEncode hook', function()
      local stream = r.EncodeStream.new()

      local struct = r.Struct.new({
        {nameLength = r.uint8},
        {name = StringT.new('nameLength')},
        {age = r.uint8}
      })

      struct.preEncode = function(res)
        res.nameLength = #res.name
      end

      struct:encode(stream, {name = 'devon', age = 21})
      assert.are_equal("\x05devon\x15", stream:getContents())
    end)

    it('should encode pointer data after structure', function()
      local stream = r.EncodeStream.new()
      local struct = r.Struct.new({
        { name = StringT.new(r.uint8) },
        { age = r.uint8 },
        { ptr = r.Pointer.new(r.uint8, StringT.new(r.uint8)) }
      })

      struct:encode(stream, {
        name = 'devon',
        age = 21,
        ptr = 'hello'
      })

      assert.are_equal("\x05devon\x15\x08\x05hello", stream:getContents())
    end)

  end)
end)



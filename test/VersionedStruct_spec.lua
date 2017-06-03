local r = require("restructure")
local VersionedStruct = require("restructure.VersionedStruct")

describe('VersionedStruct', function()
  describe('decode', function()
    it('should get version from number type', function()
      local struct = VersionedStruct.new(r.uint8, {
        [0] = {
          { name = r.String.new(r.uint8, 'ascii') },
          { age = r.uint8 }
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8 }
        }
      })

      local stream = r.DecodeStream.new("\x00\x05devon\x15")
      assert.are.same({
        version = 0,
        name = 'devon',
        age = 21
      }, struct:decode(stream))

      stream = r.DecodeStream.new("\x01\x0adevon 👍\x15\x00")
      assert.are.same({
        version = 1,
        name = 'devon 👍',
        age = 21,
        gender = 0
      }, struct:decode(stream))
    end)

    it('should throw for unknown version', function()
      local struct = VersionedStruct.new(r.uint8,{
        [0] = {
          { name = r.String.new(r.uint8, 'ascii') },
          { age = r.uint8 }
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8}
        }
      })

      local stream = r.DecodeStream.new("\x05\x05devon\x15")
      assert.has_error(function() struct:decode(stream) end, "Unknown version 5")
    end)

    it('should support common header block', function()
      local struct = VersionedStruct.new(r.uint8, {
        header = {
          {age = r.uint8},
          {alive = r.uint8}
        },
        [0] = {
          { name = r.String.new(r.uint8, 'ascii') }
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { gender = r.uint8 }
        }
      })

      local stream = r.DecodeStream.new("\x00\x15\x01\x05devon")
      assert.are.same({
        version = 0,
        age = 21,
        alive = 1,
        name = 'devon'
      }, struct:decode(stream))

      stream = r.DecodeStream.new("\x01\x15\x01\x0adevon 👍\x00", 'utf8')
      assert.are.same({
        version = 1,
        age = 21,
        alive = 1,
        name = 'devon 👍',
        gender = 0
      }, struct:decode(stream))
    end)

    it('should support parent version key', function()
      local struct = VersionedStruct.new('version',{
        [0] = {
          { name = r.String.new(r.uint8, 'ascii') },
          { age = r.uint8 }
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8}
        }
      })

      local stream = r.DecodeStream.new("\x05devon\x15")
      assert.are.same({
        version = 0,
        name = 'devon',
        age = 21
      }, struct:decode(stream, {version = 0}))

      stream = r.DecodeStream.new("\x0adevon 👍\x15\x00", 'utf8')
      assert.are_same({
        version = 1,
        name = 'devon 👍',
        age = 21,
        gender = 0
      }, struct:decode(stream, {version = 1}))

    end)

    it('should support sub versioned structs', function()
      local struct = VersionedStruct.new(r.uint8,{
        [0] = {
          {name = r.String.new(r.uint8, 'ascii')},
          {age = r.uint8}
        },
        [1] = VersionedStruct.new(r.uint8, {
          [0] = {
            { name = r.String.new(r.uint8) }
          },
          [1] = {
            { name = r.String.new(r.uint8) },
            { isDesert = r.uint8 }
          }
        })
      })

      local stream = r.DecodeStream.new("\x00\x05devon\x15")
      assert.are.same({
        version = 0,
        name = 'devon',
        age = 21
      }, struct:decode(stream, {version = 0}))

      stream = r.DecodeStream.new("\x01\x00\x05pasta")
      assert.are.same({
        version = 0,
        name = 'pasta'
      },struct:decode(stream, {version = 0}))

      stream = r.DecodeStream.new("\x01\x01\x09ice cream\x01")
      assert.are.same({
        version = 1,
        name = 'ice cream',
        isDesert = 1
      }, struct:decode(stream, {version = 0}))

    end)

    it('should support process hook', function()
      local struct = VersionedStruct.new(r.uint8,{
        [0] = {
          { name = r.String.new(r.uint8, 'ascii') },
          { age = r.uint8}
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8 }
        }
      })

      struct.process = function(res)
        res.processed = true
      end

      local stream = r.DecodeStream.new("\x00\x05devon\x15")
      assert.are.same({
        version = 0,
        name = 'devon',
        age = 21,
        processed = true
      },struct:decode(stream))
    end)
  end)

  describe('size', function()
    it('should compute the correct size', function()
      local struct = VersionedStruct.new(r.uint8,{
        [0] = {
          { name = r.String.new(r.uint8, 'ascii')},
          { age = r.uint8 }
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8}
        }
      })

      local size = struct:size({
        version = 0,
        name = 'devon',
        age = 21
      })

      assert.are_equal(8, size)

      size = struct:size({
        version = 1,
        name = 'devon 👍',
        age = 21,
        gender = 0
      })

      assert.are_equal(14, size)
    end)

    it('should throw for unknown version', function()
      local struct = VersionedStruct.new(r.uint8,{
        [0] = {
          { name = r.String.new(r.uint8, 'ascii')},
          { age = r.uint8}
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8}
        }
      })

      assert.has_error(function() struct:size({
        version = 5,
        name = "devon",
        age = 21
      }) end,
      "Unknown version 5")
    end)

    it('should support common header block', function()
      local struct = VersionedStruct.new(r.uint8,{
        header = {
          {age = r.uint8},
          {alive = r.uint8}
        },
        [0] = {
          {name = r.String.new(r.uint8, 'ascii')}
        },
        [1] = {
          {name = r.String.new(r.uint8, 'utf8')},
          {gender = r.uint8}
        }
      })

      local size = struct:size({
        version = 0,
        age = 21,
        alive = 1,
        name = 'devon'
      })

      assert.are_equal(9, size)

      size = struct:size({
        version = 1,
        age = 21,
        alive = 1,
        name = 'devon 👍',
        gender = 0
      })

      assert.are_equal(15, size)

    end)

    -- it'should compute the correct size with pointers', function()
    --   local struct = VersionedStruct.newr.uint8,{
    --     [0] = {
    --       name = r.String.new(r.uint8, 'ascii'),
    --       age: r.uint8
    --     }
    --     [1] = {
    --       name = r.String.new(r.uint8, 'utf8'),
    --       age: r.uint8
    --       ptr: new Pointer r.uint8, r.String.new(r.uint8)
    --
    --   size = struct.size
    --     version: 1
    --     name: 'devon'
    --     age: 21
    --     ptr: 'hello'
    --
    --   size.should.equal 15

    it('should throw if no value is given', function()
      local struct = VersionedStruct.new(r.uint8,{
        [0] = {
          { name = r.String.new(4, 'ascii') },
          { age = r.uint8 }
        },
        [1] = {
          { name = r.String.new(4, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8 }
        }
      })

      assert.has_error(function() struct:size() end, "Not a fixed size")
      end)
    end)

  describe('encode', function()
    it('should encode objects to buffers', function()
      local struct = VersionedStruct.new(r.uint8,{
        [0] = {
          { name = r.String.new(r.uint8, 'ascii') },
          { age = r.uint8 }
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8 }
        }
      })

      local stream = r.EncodeStream.new()

      struct:encode(stream,{
        version = 0,
        name = 'devon',
        age = 21
      })

      struct:encode(stream,{
        version = 1,
        name = 'devon 👍',
        age = 21,
        gender = 0
      })
      assert.are_equal("\x00\x05devon\x15\x01\x0adevon 👍\x15\x00", stream:getContents())
    end)

    it('should throw for unknown version', function()
      local struct = VersionedStruct.new(r.uint8,{
        [0] = {
          { name = r.String.new(r.uint8, 'ascii') },
          { age = r.uint8 }
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8 }
        }
      })

      local stream = r.EncodeStream.new()

      assert.has_error( function()
        struct:encode(stream,{ version = 5, name = 'devon', age = 21 })
      end,
      "Unknown version 5")
    end)


    it('should support common header block', function()
      local struct = VersionedStruct.new(r.uint8,{
        header = {
          { age = r.uint8 },
          { alive = r.uint8 }
        },
        [0] = {
          { name = r.String.new(r.uint8, 'ascii') }
        },
        [1] = {
          {name = r.String.new(r.uint8, 'utf8')},
          {gender = r.uint8}
        }
      })

      local stream = r.EncodeStream.new()

      struct:encode(stream,{
        version = 0,
        age = 21,
        alive = 1,
        name = 'devon'
      })

      struct:encode(stream,{
        version = 1,
        age = 21,
        alive = 1,
        name = 'devon 👍',
        gender = 0
      })

      assert.are_equal("\x00\x15\x01\x05devon\x01\x15\x01\x0adevon 👍\x00", stream:getContents())
    end)

    -- it('should encode pointer data after structure', function()
    --   local struct = VersionedStruct.new(r.uint8,{
    --     [0] = {
    --       { name = r.String.new(r.uint8, 'ascii') },
    --       { age = r.uint8 }
    --     },
    --     [1] = {
    --       { name: r.String.new(r.uint8, 'utf8') },
    --       { age: r.uint8 },
    --       { ptr = new Pointer r.uint8, r.String.new(r.uint8) }
    --     }
    --   })
    --
    --   local stream = r.EncodeStream.new()
    --   stream.pipe concat (buf) function()
    --     buf.should.deep.equal "\x01\x05devon\x15\x09\x05hello", 'utf8'
    --     done()
    --
    --   struct:encode stream,
    --     version: 1
    --     name: 'devon'
    --     age: 21
    --     ptr: 'hello'
    --
    --   stream.end()

    it('should support preEncode hook', function()
      local struct = VersionedStruct.new(r.uint8, {
        [0] = {
          {name = r.String.new(r.uint8, 'ascii')},
          {age = r.uint8}
        },
        [1] = {
          { name = r.String.new(r.uint8, 'utf8') },
          { age = r.uint8 },
          { gender = r.uint8 }
        }
      })

      struct.preEncode = function(res)
        if res.gender then
          res.version = 1
        else
          res.version =  0
        end
      end

      local stream = r.EncodeStream.new()

      struct:encode(stream,{
        name = 'devon',
        age = 21
      })

      struct:encode(stream,{
        name = 'devon 👍',
        age = 21,
        gender = 0
      })

      assert.are_equal("\x00\x05devon\x15\x01\x0adevon 👍\x15\x00", stream:getContents())
    end)
  end)
end)

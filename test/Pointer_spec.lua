local r = require("restructure")
local VoidPointer = r.VoidPointer

describe('Pointer', function()
  describe('decode', function()
    it('should handle null pointers', function()
      local stream = r.DecodeStream.new(string.char(0))
      local pointer = r.Pointer.new(r.uint8, r.uint8)
      assert.is_nil(pointer:decode(stream, {_startOffset = 50}))
    end)

    it('should use local offsets from start of parent by default', function()
      local stream = r.DecodeStream.new(string.char(1, 53))
      local pointer = r.Pointer.new(r.uint8, r.uint8)
      assert.are_equal(53,pointer:decode(stream, {_startOffset = 0}))
    end)

    it('should support immediate offsets', function()
      local stream = r.DecodeStream.new(string.char(1, 53))
      local pointer = r.Pointer.new(r.uint8, r.uint8, {type = 'immediate'})
      assert.are_equal(53,pointer:decode(stream))
    end)

    it('should support offsets relative to the parent', function()
      local stream = r.DecodeStream.new(string.char(0, 0, 1, 53))
      stream.buffer.pos = 2
      local pointer = r.Pointer.new(r.uint8, r.uint8, {type = 'parent'})
      assert.are_equal(53,pointer:decode(stream, {parent = { _startOffset = 2}}))
    end)

    it('should support global offsets', function()
      local stream = r.DecodeStream.new(string.char(1, 2, 4, 0, 0, 0, 53))
      local pointer = r.Pointer.new(r.uint8, r.uint8, {type = 'global'})
      stream.buffer.pos = 2
      assert.are_equal(53,pointer:decode(stream, { parent = { parent = {_startOffset = 2 } } }))
    end)

    it('should support offsets relative to a property on the parent', function()
      local stream = r.DecodeStream.new(string.char(1, 0, 0, 0, 0, 53))
      local pointer = r.Pointer.new(r.uint8, r.uint8, {relativeTo = 'parent.ptr'})
      assert.are_equal(53,pointer:decode(stream, {_startOffset = 0, parent = { ptr = 4 }}))
    end)

    it('should support returning pointer if there is no decode type', function()
      local stream = r.DecodeStream.new(string.char(4))
      local pointer = r.Pointer.new(r.uint8, 'void')
      assert.are_equal(4,pointer:decode(stream, { _startOffset = 0 }))
    end)

    it('should support decoding pointers lazily #debug', function()
      local stream = r.DecodeStream.new(string.char(1, 53))
      local struct = r.Struct.new({
        { ptr = r.Pointer.new(r.uint8, r.uint8, {lazy = true}) }
      })

      local res = struct:decode(stream)
      -- Object.getOwnPropertyDescriptor(res, 'ptr').get.should.be.a('function')
      -- Object.getOwnPropertyDescriptor(res, 'ptr').enumerable.should.equal(true)
      assert.are_equal(53,res.ptr)
    end)
  end)

  describe('size', function()
    it('should add to local pointerSize', function()
      local pointer = r.Pointer.new(r.uint8, r.uint8)
      local ctx = { pointerSize = 0}
      assert.are_equal(1,pointer:size(10, ctx))
      assert.are_equal(1,ctx.pointerSize)
    end)

    it('should add to immediate pointerSize', function()
      local pointer = r.Pointer.new(r.uint8, r.uint8, {type = 'immediate'})
      local ctx = {pointerSize = 0}
      assert.are_equal(1,pointer:size(10, ctx))
      assert.are_equal(1,ctx.pointerSize)
    end)

    it('should add to parent pointerSize', function()
      local pointer = r.Pointer.new(r.uint8, r.uint8, {type = 'parent'})
      local ctx = { parent = { pointerSize = 0 } }
      assert.are_equal(1,pointer:size(10, ctx))
      assert.are_equal(1,ctx.parent.pointerSize)
    end)

    it('should add to global pointerSize', function()
      local pointer = r.Pointer.new(r.uint8, r.uint8, {type = 'global'})
      local ctx = { parent = { parent =  { parent = { pointerSize = 0 }}}}
      assert.are_equal(1,pointer:size(10, ctx))
      assert.are_equal(1,ctx.parent.parent.parent.pointerSize)
    end)

    it('should handle void pointers', function()
      local pointer = r.Pointer.new(r.uint8, 'void')
      local ctx = { pointerSize = 0 }
      assert.are_equal(1,pointer:size(VoidPointer.new(r.uint8, 50), ctx))
      assert.are_equal(1,ctx.pointerSize)
    end)

    it('should throw if no type and not a void pointer', function()
      local pointer = r.Pointer.new(r.uint8, 'void')
      local ctx = {pointerSize = 0}
      assert.has_error(function() pointer:size(30, ctx) end, "Must be a VoidPointer")
    end)

    it('should return a fixed size without a value', function()
      local pointer = r.Pointer.new(r.uint8, r.uint8)
      assert.are_equal(1,pointer:size())
    end)
  end)

  describe('encode', function()
    it('should handle null pointers', function()
      local stream = r.EncodeStream.new()
      local ptr = r.Pointer.new(r.uint8, r.uint8)
      local ctx = {
        pointerSize = 0,
        startOffset = 0,
        pointerOffset = 0,
        pointers = {}
      }

      ptr:encode(stream, nil, ctx)
      assert.are_equal(string.char(0), stream:getContents())
      assert.are_equal(0,ctx.pointerSize)
    end)

    it('should handle local offsets', function()
      local stream = r.EncodeStream.new()
      local ptr = r.Pointer.new(r.uint8, r.uint8)
      local ctx = {
        pointerSize = 0,
        startOffset = 0,
        pointerOffset = 1,
        pointers = {}
      }

      ptr:encode(stream, 10, ctx)
      assert.are_equal(2,ctx.pointerOffset)
      assert.are_equal(string.char(1), stream:getContents())
      assert.are.same({
        { type = r.uint8, val = 10, parent = ctx }
      }, ctx.pointers)
    end)

    it('should handle immediate offsets', function()
      local stream = r.EncodeStream.new()
      local ptr = r.Pointer.new(r.uint8, r.uint8, {type = 'immediate'})
      local ctx = {
        pointerSize = 0,
        startOffset = 0,
        pointerOffset = 1,
        pointers = {}
      }

      ptr:encode(stream, 10, ctx)
      assert.are_equal(2,ctx.pointerOffset)
      assert.are.same({
        { type = r.uint8, val = 10, parent = ctx }
      }, ctx.pointers)
      assert.are_equal(string.char(0), stream:getContents())
    end)

    it('should handle immediate offsets', function()
      local stream = r.EncodeStream.new()

      local ptr = r.Pointer.new(r.uint8, r.uint8, {type = 'immediate'})
      local ctx = {
        pointerSize= 0,
        startOffset= 0,
        pointerOffset= 1,
        pointers= {}
      }

      ptr:encode(stream, 10, ctx)
      assert.are_equal(2,ctx.pointerOffset)
      assert.are_same({
        { type = r.uint8, val = 10, parent = ctx }
      },ctx.pointers)
      assert.are_equal(string.char(0),stream:getContents())
    end)

    it('should handle offsets relative to parent', function()
      local stream = r.EncodeStream.new()
      local ptr = r.Pointer.new(r.uint8, r.uint8, {type = 'parent'})
      local ctx = {
        parent = {
          pointerSize = 0,
          startOffset = 3,
          pointerOffset = 5,
          pointers = {}
        }
      }

      ptr:encode(stream, 10, ctx)
      assert.are_equal(6,ctx.parent.pointerOffset)
      assert.are.same(ctx.parent.pointers, {
        { type = r.uint8, val = 10, parent = ctx }
      })
      assert.are_equal(string.char(2), stream:getContents())
    end)

    it('should handle global offsets', function()
      local stream = r.EncodeStream.new()
      local ptr = r.Pointer.new(r.uint8, r.uint8, {type = 'global'})
      local ctx = {
        parent = {
          parent = {
            parent = {
              pointerSize = 0,
              startOffset = 3,
              pointerOffset = 5,
              pointers = {}
            }
          }
        }
      }

      ptr:encode(stream, 10, ctx)
      assert.are_equal(6,ctx.parent.parent.parent.pointerOffset)
      assert.are.same({
        { type = r.uint8, val = 10, parent = ctx }
      },ctx.parent.parent.parent.pointers)
      assert.are_equal(string.char(5), stream:getContents())
    end)

    it('should support offsets relative to a property on the parent', function()
      local stream = r.EncodeStream.new()
      local ptr = r.Pointer.new(r.uint8, r.uint8, {relativeTo = 'ptr'})
      local ctx = {
        pointerSize = 0,
        startOffset = 0,
        pointerOffset = 10,
        pointers = {},
        val = {
          ptr = 4
        }
      }

      ptr:encode(stream, 10, ctx)
      assert.are_equal(11,ctx.pointerOffset)
      assert.are.same({
        { type = r.uint8, val = 10, parent = ctx }
      },ctx.pointers)
      assert.are_equal(string.char(6), stream:getContents())
    end)

    it('should support void pointers', function()
      local stream = r.EncodeStream.new()
      local ptr = r.Pointer.new(r.uint8, 'void')
      local ctx = {
        pointerSize = 0,
        startOffset = 0,
        pointerOffset = 1,
        pointers = {}
      }

      ptr:encode(stream, VoidPointer.new(r.uint8, 55), ctx)
      assert.are_equal(2,ctx.pointerOffset)
      assert.are.same({
        { type = r.uint8, val = 55, parent = ctx }
      },ctx.pointers)
      assert.are_equal(string.char(1), stream:getContents())
    end)

    it('should throw if not a void pointer instance', function()
      local stream = r.EncodeStream.new()
      local ptr = r.Pointer.new(r.uint8, 'void')
      local ctx = {
        pointerSize = 0,
        startOffset = 0,
        pointerOffset = 1,
        pointers = {}
      }

      assert.has_error(function() ptr:encode(stream, 44, ctx) end, "Must be a VoidPointer")
    end)
  end)
end)



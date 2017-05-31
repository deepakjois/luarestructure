local DecodeStream = require("restructure").DecodeStream
local EncodeStream = require("restructure").EncodeStream
local uint8 = require("restructure").uint8
local uint16 = require("restructure").uint16
local uint16be = require("restructure").uint16be
local uint16le = require("restructure").uint16le
local uint24be = require("restructure").uint24be
local uint24le = require("restructure").uint24le
local uint32 = require("restructure").uint32
local uint32be = require("restructure").uint32be
local uint32le = require("restructure").uint32le
local int8 = require("restructure").int8
local int16 = require("restructure").int16
local int16be = require("restructure").int16be
local int16le = require("restructure").int16le
local int24 = require("restructure").int24
local int24be = require("restructure").int24be
local int24le = require("restructure").int24le
local int32 = require("restructure").int32
local int32be = require("restructure").int32be
local int32le = require("restructure").int32le
local float = require("restructure").float
local floatbe = require("restructure").floatbe
local floatle = require("restructure").floatle
local double = require("restructure").double
local doublebe = require("restructure").doublebe
local doublele = require("restructure").doublele
local fixed16 = require("restructure").fixed16
local fixed16be = require("restructure").fixed16be
local fixed16le = require("restructure").fixed16le
local fixed32 = require("restructure").fixed32
local fixed32be = require("restructure").fixed32be
local fixed32le = require("restructure").fixed32le


describe('Number', function()
  describe('uint8', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xab, 0xff))
      assert.are_equal(0xab, uint8:decode(stream))
      assert.are_equal(0xff, uint8:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(1, uint8:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      uint8:encode(stream, 0xab)
      uint8:encode(stream, 0xff)
      assert.are_equal(string.char(0xab, 0xff), stream:getContents())
    end)
  end)

  describe('uint16', function()
    it("is an alias for int16be", function()
      assert.are_equal(uint16, uint16be)
    end)
  end)

  describe('uint16be', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xab, 0xff))
      assert.are_equal(0xabff, uint16be:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(2, uint16be:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      uint16be:encode(stream, 0xabff)
      assert.are_equal(string.char(0xab, 0xff), stream:getContents())
    end)
  end)

  describe('uint16le', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xff, 0xab))
      assert.are_equal(0xabff, uint16le:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(2, uint16le:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      uint16le:encode(stream, 0xabff)
      assert.are_equal(string.char(0xff, 0xab), stream:getContents())
    end)
  end)

  describe('uint24be', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xff, 0xab, 0x24))
      assert.are_equal(0xffab24, uint24be:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(3, uint24be:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      uint24be:encode(stream, 0xffab24)
      assert.are_equal(string.char(0xff, 0xab, 0x24), stream:getContents())
    end)
  end)

  describe('uint24le', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x24, 0xab, 0xff))
      assert.are_equal(0xffab24, uint24le:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(3, uint24le:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      uint24le:encode(stream, 0xffab24)
      assert.are_equal(string.char(0x24, 0xab, 0xff), stream:getContents())
    end)
  end)

  describe('uint32', function()
    it("is an alias for uint32be", function()
      assert.are_equal(uint32, uint32be)
    end)
  end)

  describe('uint32be', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xff, 0xab, 0x24, 0xbf))
      assert.are_equal(0xffab24bf, uint32be:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(4, uint32be:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      uint32be:encode(stream, 0xffab24bf)
      assert.are_equal(string.char(0xff, 0xab, 0x24, 0xbf), stream:getContents())
    end)
  end)

  describe('uint32le', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xbf, 0x24, 0xab, 0xff))
      assert.are_equal(0xffab24bf, uint32le:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(4, uint32le:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      uint32le:encode(stream, 0xffab24bf)
      assert.are_equal(string.char(0xbf, 0x24, 0xab, 0xff), stream:getContents())
    end)
  end)

  describe('int8', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x7f, 0xff))
      assert.are_equal(127, int8:decode(stream))
      assert.are_equal(-1, int8:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(1, int8:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      int8:encode(stream, 127)
      int8:encode(stream, -1)
      assert.are_equal(string.char(0x7f, 0xff), stream:getContents())
    end)
  end)

  describe('int16', function()
    it("is an alias for int16be", function()
      assert.are_equal(int16, int16be)
    end)
  end)

  describe('int16be', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xff, 0xab))
      assert.are_equal(-85, int16be:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(2, int16be:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      int16be:encode(stream, -85)
      assert.are_equal(string.char(0xff, 0xab), stream:getContents())
    end)
  end)

  describe('int16le', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xab, 0xff))
      assert.are_equal(-85, int16le:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(2, int16le:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      int16le:encode(stream, -85)
      assert.are_equal(string.char(0xab, 0xff), stream:getContents())
    end)
  end)

  describe('int24', function()
    it("is an alias for int24be", function()
      assert.are_equal(int24, int24be)
    end)
  end)

  describe('int24be', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xff, 0xab, 0x24))
      assert.are_equal(-21724, int24be:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(3, int24be:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      int24be:encode(stream, -21724)
      assert.are_equal(string.char(0xff, 0xab, 0x24), stream:getContents())
    end)
  end)

  describe('int24le', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x24, 0xab, 0xff))
      assert.are_equal(-21724, int24le:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(3, int24le:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      int24le:encode(stream, -21724)
      assert.are_equal(string.char(0x24, 0xab, 0xff), stream:getContents())
    end)
  end)

  describe('int32', function()
    it("is an alias for int32be", function()
      assert.are_equal(int32, int32be)
    end)
  end)

  describe('int32be', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xff, 0xab, 0x24, 0xbf))
      assert.are_equal(-5561153, int32be:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(4, int32be:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      int32be:encode(stream, -5561153)
      assert.are_equal(string.char(0xff, 0xab, 0x24, 0xbf), stream:getContents())
    end)
  end)

  describe('int32le', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xbf,0x24, 0xab, 0xff))
      assert.are_equal(-5561153, int32le:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(4, int32le:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      int32le:encode(stream, -5561153)
      assert.are_equal(string.char(0xbf, 0x24, 0xab, 0xff), stream:getContents())
    end)
  end)

  describe('float', function()
    it("is an alias for floatbe", function()
      assert.are_equal(float, floatbe)
    end)
  end)

  describe('floatbe', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x43, 0x7a, 0x8c, 0xcd))
      assert.is_true(math.abs(floatbe:decode(stream) - 250.55) < 0.005)
    end)

    it("should have a size", function()
      assert.are_equal(4, floatbe:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      floatbe:encode(stream, 250.55)
      assert.are_equal(string.char(0x43, 0x7a, 0x8c, 0xcd), stream:getContents())
    end)
  end)

  describe('floatle', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xcd, 0x8c, 0x7a, 0x43))
      assert.is_true(math.abs(floatle:decode(stream) - 250.55) < 0.005)
    end)

    it("should have a size", function()
      assert.are_equal(4, floatle:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      floatle:encode(stream, 250.55)
      assert.are_equal(string.char(0xcd, 0x8c, 0x7a, 0x43), stream:getContents())
    end)
  end)

  describe('double', function()
    it("is an alias for doublebe", function()
      assert.are_equal(double, doublebe)
    end)
  end)

  describe('doublebe', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x40, 0x93, 0x4a, 0x3d, 0x70, 0xa3, 0xd7, 0x0a))
      assert.are_equal(1234.56,doublebe:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(8, doublebe:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      doublebe:encode(stream, 1234.56)
      assert.are_equal(string.char(0x40, 0x93, 0x4a, 0x3d, 0x70, 0xa3, 0xd7, 0x0a), stream:getContents())
    end)
  end)

  describe('doublele', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x0a, 0xd7, 0xa3, 0x70, 0x3d, 0x4a, 0x93, 0x40))
      assert.are_equal(1234.56,doublele:decode(stream))
    end)

    it("should have a size", function()
      assert.are_equal(8, doublele:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      doublele:encode(stream, 1234.56)
      assert.are_equal(string.char(0x0a, 0xd7, 0xa3, 0x70, 0x3d, 0x4a, 0x93, 0x40), stream:getContents())
    end)
  end)

  describe('fixed16', function()
    it("is an alias for fixed16be", function()
      assert.are_equal(fixed16, fixed16be)
    end)
  end)

  describe('fixed16be', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x19, 0x57))
      assert.is_true(math.abs(fixed16be:decode(stream) - 25.34) < 0.005)
    end)

    it("should have a size", function()
      assert.are_equal(2, fixed16be:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      fixed16be:encode(stream, 25.34)
      assert.are_equal(string.char(0x19, 0x57), stream:getContents())
    end)
  end)

  describe('fixed16le', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x57, 0x19))
      assert.is_true(math.abs(fixed16le:decode(stream) - 25.34) < 0.005)
    end)

    it("should have a size", function()
      assert.are_equal(2, fixed16le:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      fixed16le:encode(stream, 25.34)
      assert.are_equal(string.char(0x57, 0x19), stream:getContents())
    end)
  end)

  describe('fixed32', function()
    it("is an alias for fixed32be", function()
      assert.are_equal(fixed32, fixed32be)
    end)
  end)

  describe('fixed32be', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0x00, 0xfa, 0x8c, 0xcc))
      assert.is_true(math.abs(fixed32be:decode(stream) - 250.55) < 0.005)
    end)

    it("should have a size", function()
      assert.are_equal(4, fixed32be:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      fixed32be:encode(stream, 250.55)
      assert.are_equal(string.char(0x00, 0xfa, 0x8c, 0xcc), stream:getContents())
    end)
  end)

  describe('fixed32le', function()
    it('should decode', function()
      local stream = DecodeStream.new(string.char(0xcc, 0x8c, 0xfa, 0x00))
      assert.is_true(math.abs(fixed32le:decode(stream) - 250.55) < 0.005)
    end)

    it("should have a size", function()
      assert.are_equal(4, fixed32le:size())
    end)

    it("should encode", function()
      local stream = EncodeStream.new()
      fixed32le:encode(stream, 250.55)
      assert.are_equal(string.char(0xcc, 0x8c, 0xfa, 0x00), stream:getContents())
    end)
  end)
end)

local EncodeStream = require("restructure").EncodeStream

describe('EncodeStream', function()

  it('should write a buffer', function()
    local contents = string.char(1, 2, 3)
    local stream = EncodeStream.new()
    stream:writeBuffer(contents)
    assert.are_equal(contents, stream:getContents())
  end)

  it('should writeUInt16BE', function()
    local stream = EncodeStream.new()
    stream:writeUInt16BE(0xabcd)
    assert.are_equal(string.char(0xab, 0xcd), stream:getContents())
  end)

  it('should writeUInt16LE', function()
    local stream = EncodeStream.new()
    stream:writeUInt16LE(0xabcd)
    assert.are_equal(string.char(0xcd, 0xab), stream:getContents())
  end)

  it('should writeUInt24BE', function()
    local stream = EncodeStream.new()
    stream:writeUInt24BE(0xabcdef)
    assert.are_equal(string.char(0xab, 0xcd, 0xef), stream:getContents())
  end)

  it('should writeUInt24LE', function()
    local stream = EncodeStream.new()
    stream:writeUInt24LE(0xabcdef)
    assert.are_equal(string.char(0xef, 0xcd, 0xab), stream:getContents())
  end)

  it('should writeInt24BE', function()
    local stream = EncodeStream.new()
    stream:writeInt24BE(-21724)
    stream:writeInt24BE(0xabcdef)
    assert.are_equal(string.char(0xff, 0xab, 0x24, 0xab, 0xcd, 0xef), stream:getContents())
  end)

  it('should writeUInt24LE', function()
    local stream = EncodeStream.new()
    stream:writeInt24LE(-21724)
    stream:writeInt24LE(0xabcdef)
    assert.are_equal(string.char(0x24, 0xab, 0xff, 0xef, 0xcd, 0xab), stream:getContents())
  end)

  it('should fill', function()
    local stream = EncodeStream.new()
    stream:fill(10, 5)
    assert.are_equal(string.char(10, 10, 10, 10, 10), stream:getContents())
  end)

  it('should write a string', function()
    local contents = "abc"
    local stream = EncodeStream.new()
    stream:writeString(contents)
    assert.are_equal(contents, stream:getContents())
  end)
end)
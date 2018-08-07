local r = require('restructure')

describe('Enum', function()
  local e = r.Enum.new(r.uint8, {'foo', 'bar', 'baz'})

  it('should have the right size', function()
    assert.are_equal(1,e:size())
  end)

  it('should decode', function()
    local stream = r.DecodeStream.new(string.char(1, 2, 0))
    assert.are_equal('bar', e:decode(stream))
    assert.are_equal('baz', e:decode(stream))
    assert.are_equal('foo', e:decode(stream))
  end)

  it('should encode', function()
    local stream = r.EncodeStream.new()
    e:encode(stream, 'bar')
    e:encode(stream, 'baz')
    e:encode(stream, 'foo')
    assert.are_equal(string.char(1,2,0), stream:getContents())
  end)

  it('should throw on unknown option', function()
    local stream = r.EncodeStream.new()
    assert.has_error(function() e:encode(stream, "unknown") end)
  end)
end)
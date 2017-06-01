local r = require('restructure')

local function deepcompare(t1,t2,ignore_mt)
  local ty1 = type(t1)
  local ty2 = type(t2)
  if ty1 ~= ty2 then return false end
  -- non-table types can be directly compared
  if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
  -- as well as tables which have the metamethod __eq
  local mt = getmetatable(t1)
  if not ignore_mt and mt and mt.__eq then return t1 == t2 end
  for k1,v1 in pairs(t1) do
  local v2 = t2[k1]
  if v2 == nil or not deepcompare(v1,v2) then return false end
  end
  for k2,v2 in pairs(t2) do
  local v1 = t1[k2]
  if v1 == nil or not deepcompare(v1,v2) then return false end
  end
  return true
end

describe('Bitfield', function()
  local bitfield = r.Bitfield.new(r.uint8, {'Jack', 'Kack', 'Lack', 'Mack', 'Nack', 'Oack', 'Pack', 'Quack'})
  local JACK  = bit32.lshift(1, 0)
  -- local KACK  = bit32.lshift(1, 1)
  -- local LACK  = bit32.lshift(1, 2)
  local MACK  = bit32.lshift(1, 3)
  local NACK  = bit32.lshift(1, 4)
  -- local OACK  = bit32.lshift(1, 5)
  local PACK  = bit32.lshift(1, 6)
  local QUACK = bit32.lshift(1, 7)

  it('should have the right size', function()
    assert.are_equal(1, bitfield:size())
  end)

  it('should decode', function()
    local stream = r.DecodeStream.new(string.char(bit32.bor(JACK, MACK, PACK, NACK, QUACK)))
    local v = bitfield:decode(stream)
    assert.True(deepcompare({Jack= true, Kack= false, Lack= false, Mack= true, Nack= true, Oack= false, Pack= true, Quack= true}, v))
  end)

  it('should encode', function()
    local stream = r.EncodeStream.new()
    bitfield:encode(stream, { Jack= true, Kack= false, Lack= false, Mack= true, Nack= true, Oack= false, Pack= true, Quack= true})
    assert.are_equal(string.char(bit32.bor(JACK, MACK, PACK, NACK, QUACK)), stream:getContents())
  end)
end)

local NumberT = require('restructure.Number').Number

local function instanceOf (subject, super)
	super = tostring(super)
	local mt = getmetatable(subject)

	while true do
		if mt == nil then return false end
		if tostring(mt) == super then return true end
		mt = getmetatable(mt)
	end
end

local function resolveLength(length, stream, parent)
  local res
  if type(length) == "number" then
    res = length
  elseif type(length) == "function" then
    res = length(parent)
  elseif parent and type(length) == "string" then
    res = parent[length]
  elseif stream and instanceOf(length, NumberT) then
    res = length:decode(stream)
  end
  if type(res) ~= "number" then error("Not a fixed size") end
  return res
end


local exports = {
  instanceOf = instanceOf,
  resolveLength = resolveLength
}

return exports
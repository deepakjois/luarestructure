local function resolveLength(length)
  if type(length) == "number" then return length end
end

local exports = {
  resolveLength = resolveLength
}

return exports
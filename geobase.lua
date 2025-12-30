--TODO: move this to DI

require "util"

function merge(old, new)
	old = table.deepcopy(old)

	for k, v in pairs(new) do
		if v == "nil" then
			old[k] = nil
		else
			old[k] = v
		end
	end

	return old
end

function addDerivativeFull(template, overrides)
	local merged = merge(template, overrides)
	data:extend({merged})
end

function addDerivative(type, name, overrides)
	if not data.raw[type] then error("No such prototype type '" .. type .. "' to add a derivative of '" .. name .. "'!") end
	addDerivativeFull(data.raw[type][name], overrides)
end
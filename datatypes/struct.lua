Struct = {}
function Struct:new(address, decl)
    obj = {address=address,decl=decl}
    setmetatable(obj, self)
    self.__index = self

    for name,field in pairs(decl) do
        offset = field[1]
        type = field[2]
        obj[name] = type:at(address + offset)
    end

    return obj
end

function Struct:print()
    for name,field in pairs(self.decl) do
        printf("%s = %s", name, self[name]:get())
    end
end
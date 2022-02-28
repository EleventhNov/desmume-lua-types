DataUnit = {}
function DataUnit:new(type, addr)
    local object = {type=type, addr=addr}
    setmetatable(object, self)
    self.__index = self
    return object
end

function DataUnit:get()
    return self.type.read(self.addr)
end

function DataUnit:set(value)
    return self.type.write(self.addr, value)
end

function DataUnit:on_read(callback)
    memory.registerread(self.addr, self.size, function()
        callback(self:get())
    end)
end

function DataUnit:on_write(callback)
    memory.registerwrite(self.addr, self.type.size, function()
        callback(self:get())
    end)
end

function DataUnit:string()
    return self.type.string(self)
end
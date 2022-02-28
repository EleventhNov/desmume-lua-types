Function = {}
function Function:new(address, args)
    local object = {address=address, args=args}
    object.on_call_callbacks = {}
    object.on_return_callbacks = {}
    setmetatable(object, self)
    self.__index = self

    memory.registerexecute(address, function()
        arg_values = {}
        for i,arg in ipairs(object.args) do
            arg_values[i] = stdcall_get(arg, i - 1)
        end
        for i,callback in ipairs(object.on_call_callbacks) do
            callback(unpack(arg_values))
        end
        ret_addr = memory.getregister("r14")
        memory.registerexecute(ret_addr, function()
            memory.registerexecute(ret_addr, nil)
            for i,callback in ipairs(object.on_return_callbacks) do
                callback()
            end
        end)
    end)

    return object
end

function Function:on_call(callback)
    table.insert(self.on_call_callbacks, callback)
end

function Function:on_return(callback)
    table.insert(self.on_return_callbacks, callback)
end

function stdcall_get(type, index)
    if index <= 3 then
        value = memory.getregister("r"..index)
    else
        value = u32:read(memory.getregister("r13") + index * 4)
    end
    return type:from_register(value)
end

require "datatypes/int"

function ptr(datatype)
    local object = datatype_int(4, false)
    
    object.from_reg = function(value) return datatype:at(value) end
    return object
end
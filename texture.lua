require "std"

texture_data = Struct:new({
    matrix={2, u16}
})

Function:new(0x1ff8728, {ptr(texture_data)}):on_call(function(data)
    printf("%x", data.matrix:get())
end)
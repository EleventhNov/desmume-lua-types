require "std"

submechanic = Struct:new({
    group_id={0, u32},
    entry_func={4, ptr(nil)},
    free_func={8, ptr(nil)},
    update_func={12, ptr(nil)}
})

submechanic_sys_struct = Struct:new({
    current_state={0xd4, u32},
    payload_state={0x24, u32}
}):at(u32.read(0x20afdb8))

submechanic_sys_struct.current_state:on_write(function(state)
    --printf("(%x) CHANGED SUB-MECHANIC STATE TO %d", curaddr(), state)
end)

submechanic_sys_struct.payload_state:on_write(function(state)
    printf("(%x) CHANGED SUB-MECHANIC PAYLOAD STATE TO %d", curaddr(), state)
end)

Function:new(0x230cc28, {}):on_call(function()
    print("QUEUED SPINDA SUB-MECHANIC 1")
end)

Function:new(0x230cc4c, {}):on_call(function()
    print("QUEUED SPINDA SUB-MECHANIC 2")
end)

Function:new(0x20348e4, {ptr(submechanic)}):on_call(function(sbm)
    sbm:print()
end)

Function:new(0x20347f0, {}):on_call(function()
    printf("QUEUED UNLOAD AT %x", memory.getregister("r14"))
end)

memory.registerexecute(0x2034b80, function()
    --printf("RESULT OF UPDATE FUNC = %d", memory.getregister("r0"))
end)

memory.registerexecute(0x2034b44, function()
    printf("RESULT OF ENTRY FUNC = %d", memory.getregister("r0"))
end)
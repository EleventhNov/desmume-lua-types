function printf(format, ...)
	print(string.format(format, unpack(arg)))
end

require "datatypes/struct"
require "datatypes/int"

function create_struct(struct_decl)
    return function(address)
        return Struct:new(address, struct_decl)
    end
end

u8 = datatype_int(1, false)

struct_canvas = create_struct({
    tile_x={4,u8},
	tile_y={5,u8},
	tile_w={6,u8},
	tile_h={7,u8},
	upper_screen={8,u8},
	active={0xb6,u8}
})

my_variable = struct_canvas(0x22a88dc) -- pmd.struct_canvas is predefined somehow
my_variable:print() -- pretty-print the struct field values from memory
print(my_variable.active:get()) -- get the value of the active field from memory
my_variable.active:set(2) -- set the value of the active field in memory
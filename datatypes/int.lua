require "datatypes/type"

function datatype_int(bytes, signed)
    local read = function(address) return read_integer_memory(address, bytes, signed) end
	local write = function(address, value) return write_integer_memory(address, value, bytes, signed) end
    local from_reg = function(value)
		if signed then
			value = to_signed(value, bytes)
		end return value
	end
	local string = function(integer) return string.format("%d", integer:get()) end
	return DataType:new(read, write, from_reg, string, bytes)
end

u8 = datatype_int(1, false)
u16 = datatype_int(2, false)
u32 = datatype_int(4, false)

function to_signed(value, bytes)
	if value >= (1 * 2 ^ ((bytes * 8) - 1)) then
		value = value - 1 * 2 ^ (bytes * 8)
	end return value
end

function read_integer_memory(address, bytes, signed)
	local result = 0
	for i=1,bytes,1 do
		result = result * 0x100 + memory.readbyte(address + bytes - i)
	end
	
	if signed then
		result = to_signed(result, bytes)
	end
	
	return result
end

function write_integer_memory(address, value, bytes, signed)
	if signed and value < 0 then
		value = value + 1 * 2 ^ (bytes * 8)
	end
	
	for i=1,bytes,1 do
		memory.writebyte(address + i - 1, bit.band(value, 0xFF))
		value = bit.rshift(value, 8)
	end
end

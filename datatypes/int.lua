require "datatypes/type"

function read_integer_memory(address, bytes, signed)
	local result = 0
	for i=1,bytes,1 do
		result = result * 0x100 + memory.readbyte(address + bytes - i)
	end
	
	if signed and result >= (1 * 2 ^ ((bytes * 8) - 1)) then
		result = result - 1 * 2 ^ (bytes * 8)
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

function datatype_int(bytes, signed)
    local read = function(address) return read_integer_memory(address, bytes, signed) end
	local write = function(address, value) return write_integer_memory(address, value, bytes, signed) end
    return DataType:new(read, write, bytes)
end
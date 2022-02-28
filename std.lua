function printf(format, ...)
	print(string.format(format, unpack(arg)))
end

require "datatypes/struct"
require "datatypes/int"
require "datatypes/func"
require "datatypes/ptr"


function curaddr() return memory.getregister("r15") - 8 end
function retaddr() return memory.getregister("r14") end
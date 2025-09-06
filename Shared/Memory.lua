local Memory = {}

--// Memory Types
Memory.Byte         = gg.TYPE_BYTE
Memory.Word         = gg.TYPE_WORD
Memory.Dword        = gg.TYPE_DWORD
Memory.Qword        = gg.TYPE_QWORD
Memory.Float        = gg.TYPE_FLOAT
Memory.Double       = gg.TYPE_DOUBLE
Memory.Auto         = gg.TYPE_AUTO
--//

--// Memory Regions
Memory.Anonymous    = gg.REGION_ANONYMOUS
Memory.CAlloc       = gg.REGION_C_ALLOC
Memory.CBss         = gg.REGION_C_BSS
Memory.CData        = gg.REGION_C_DATA
Memory.CHeap        = gg.REGION_C_HEAP
Memory.CodeApp      = gg.REGION_CODE_APP
Memory.CodeSys      = gg.REGION_CODE_SYS
Memory.Java         = gg.REGION_JAVA
Memory.Ashmem       = gg.REGION_ASHMEM
Memory.Stack        = gg.REGION_STACK
Memory.Other        = gg.REGION_OTHER
Memory.Bad          = gg.REGION_BAD
Memory.Xa           = gg.REGION_XA
Memory.Xs           = gg.REGION_XS
--//

--// Memory Signs
Memory.SignedByte   = gg.TYPE_SIGNED_BYTE
Memory.SignedWord   = gg.TYPE_SIGNED_WORD
Memory.SignedDword  = gg.TYPE_SIGNED_DWORD
Memory.SignedQword  = gg.TYPE_SIGNED_QWORD
Memory.Equal        = gg.SIGN_EQUAL
--//

local Lib name = nil;
local StartAddr = 0;
local EndAddr = 0;

function Memory.SetRanges(Ranges)
    gg.setRanges(Ranges)
end

function Memory.SetValues(...)
	gg.setValues(...)
end

function Memory.Search(Value, Type)
    gg.searchNumber(Value, Type or Memory.Auto, false, Memory.Equal, 0, -1)
end

function Memory.GetResults(Count)
    return gg.getResults(Count or 100)
end

function Memory.Clear()
    gg.clearResults()
    gg.setVisible(false)
end

function Memory.Write(Value, Type, Toast)
    local Results = Memory.GetResults()
    gg.editAll(Value, Type or Memory.Byte)
    if #Results > 0 then
    gg.toast(Toast or 'Succesfully Writing The Value')
    Memory.Clear()
  end
end

function Memory.Patch(Lib,Offset,Value)
    if LibName == Lib then
        return StartAddr, EndAddr
    end
    
    local Ranges = gg.getRangesList(Lib or 'libil2cpp.so')
    
    for i, v in ipairs(Ranges) do
        if v.state == "Xa" then
            StartAddr = v.start
            EndAddr = Ranges[#Ranges]['end']
            break
        end
    end
    
    local k,v = {}, 0
    for x in string.gmatch(Value, "%S%S") do
	    table.insert(k, {
	        address = StartAddr + Offset + v,
	        flags = Memory.Byte,
	        value = x .. "r"
	    })
        v = v + 1 -- total 
    end
    local Patch = gg.setValues(k)
    if type(Patch) ~= 'string' then
        return true
    else
        gg.alert(Patch)
        return false
    end
end

return Memory

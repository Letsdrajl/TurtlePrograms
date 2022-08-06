

--Returns an advanced monitor
function getAdvMonitor()
    local mon = peripheral.find("monitor",
    function (name, object)
        return object.isColour()                
    end
    )
    return mon
end

--Returns a monitor 
function getMonitor()
    local mon = peripheral.find("monitor")
    return mon
end


function getCenter(mon)
    local xmid, ymid = mon.getSize()
    xmid = xmid / 2
    ymid = (ymid / 2) - 2

    return xmid, ymid
end
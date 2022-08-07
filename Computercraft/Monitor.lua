Monitor = {}

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

function drawGraph(mon, x1, y1, x2, y2, fillValue)
    local oldx, oldy = term.getCursorPos()
    term.redirect(mon)

    term.setBackgroundColor(colours.grey)

    for j = y1, y2 do
        for i = x1, x2 do
            term.setCursorPos(i, j)
            term.write(" ")
        end
    end

    term.setBackgroundColor(colours.green)

    local fillX = math.floor((x2 - x1) * fillValue)

    for j = y1, y2 do
        for i = x1, fillX do
            term.setCursorPos(i, j)
            term.write(" ")
        end
    end

    term.setBackgroundColor(colours.black)
    term.redirect(term.native())
    term.setCursorPos(oldx, oldy)
end
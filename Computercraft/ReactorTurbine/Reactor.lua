shell.run("Button")
shell.run("EventListener")

os.loadAPI("Button")
os.loadAPI("EventListener")

local reactorString = "BigReactors-Reactor_0"

local reactor = peripheral.wrap(reactorString)

local mon = peripheral.find("monitor",
    function (name, object)
        return object.isColour()                
    end
)

if not mon then
    print("No monitor connected")
    print("Requires Advanced Monitor")
    shell.exit()
end

local rightAlign, _ = mon.getSize()
rightAlign = rightAlign - 22

local function drawStaticText()
    mon.setCursorPos(1,1)
    mon.write("Status:")
    mon.setCursorPos(1,3)
    mon.write("Fuel:")
    mon.setCursorPos(1,4)
    mon.write("Fuel Temp:")

    mon.setCursorPos(rightAlign,1)
    mon.write("Time:")
    mon.setCursorPos(rightAlign,2)
    mon.write("Waste:")
    mon.setCursorPos(rightAlign,3)
    mon.write("Case Temp:")
end

local function drawText()
    for i = 1, 4 do
        mon.setCursorPos(12, i)
        mon.write("            ")
        mon.setCursorPos(rightAlign + 12, i)
        mon.write("            ")
    end

    mon.setCursorPos(12, 1)
    if reactor.getConnected() then
        mon.setTextColour(colours.green)
        mon.write("Connected")
        mon.setCursorPos(12, 2)
        
        if reactor.getActive() then
          mon.setTextColour(colours.green)
          mon.write("Online")
        else
          mon.setTextColour(colours.red)
          mon.write("Offline")
        end
    
        mon.setTextColour(colours.white)
        mon.setCursorPos(12, 3)
        mon.write(reactor.getFuelAmount() / 1000 .. "B")
        mon.setCursorPos(12, 4)
        mon.write(reactor.getFuelTemperature() .. " C")
    
        mon.setCursorPos(rightAlign + 12, 1)
        mon.write(os.time())
        mon.setCursorPos(rightAlign + 12, 2)
        mon.write(reactor.getWasteAmount() / 1000 .. "B")
        mon.setCursorPos(rightAlign + 12, 3)
        mon.write(reactor.getCasingTemperature() .. " C")
    
        mon.setCursorPos(24, 4)
        mon.setTextColour(colours.white)
      else
        mon.setTextColour(colours.red)
        mon.write("Disconected")
      end
end

local xmid, ymid = mon.getSize()
xmid = xmid / 2
ymid = ymid / 2 - 2

-- Buttons

reactorControl = {
    width = 13,
    x = 4,
    y = ymid,
    height = 3,
    monitor = mon,
    text = "Reactor",
    state = false,
    toggle = true,
    colourOn = colours.green,
    colourOff = colours.red,
    onClick = function(s)
        reactor.setActive(s)
    end
}

quit = {
    x = term.getSize() - 12,
    text = "Quit",
    colourOn = colors.red,
    colourOff = colors.green,
    onClick = function()
        reactor.setActive(false)
        stop = true
        mon.clear()
        term.clear()
    end
}

reboot = {
    x = term.getSize() - 12,
    y = 2,
    text = "Restart",
    colourOn = colors.red,
    colourOff = colors.green,
    onClick = function()
        reactor.setActive(false)
        stop = true
        mon.clear()
        term.clear()
        shell.run("reboot")
    end
}

function main()
    mon.clear()
    term.clear()
    redstone.setBundledOutput("bottom", 0)
    reactor.setActive(false)
    print("Drawing Static Text")
    drawStaticText()

    print("Adding Buttons")
    Button.new(reactorControl)
    Button.new(quit)
    Button.new(reboot)
    Button.drawAll()

    print("Adding EventListeners")
    EventListener.add("monitor_touch", "ButtonTouch", Button.eventHandler)
    EventListener.add("mouse_click", "ButtonClick", Button.eventHandler)

    EventListener.add("timer", "Automatic Shut Down", function()
        if not reactor then
            reactor = peripheral.wrap(reactorString)
            end 
        end
    )

    EventListener.updateLoop(1, stop, function()
        drawText()
        end
    )
end

main()
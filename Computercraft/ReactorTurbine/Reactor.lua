shell.run("Button")
shell.run("EventListener")
shell.run("Monitor")

os.loadAPI("Button")
os.loadAPI("EventListener")
os.loadAPI("Monitor")

local reactorString = "BigReactors-Reactor_0"

local reactor = peripheral.wrap(reactorString)

if not reactor then
    print("No Reactor connected")
    shell.exit()
end

local mon = Monitor.getAdvMonitor()

if not mon then
    print("No monitor connected")
    print("Requires Advanced Monitor")
    shell.exit()
end

local rightAlign, _ = mon.getSize()
rightAlign = rightAlign - 22

local stop = false

local function drawStaticText()
    mon.setCursorPos(1,1)
    mon.write("Reactor:")
    mon.setCursorPos(1,2)
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
    mon.write(math.floor(reactor.getFuelTemperature()) .. " C")

    mon.setCursorPos(rightAlign + 12, 1)
    mon.write(os.time())
    mon.setCursorPos(rightAlign + 12, 2)
    mon.write(reactor.getWasteAmount() / 1000 .. "B")
    mon.setCursorPos(rightAlign + 12, 3)
    mon.write(math.floor(reactor.getCasingTemperature()) .. " C")

    mon.setCursorPos(24, 4)
    mon.setTextColour(colours.white)
      
end

local function setStop(value)
    stop = value    
end

xmid, ymid = Monitor.getCenter(mon)

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

turbinePage = {
    width = 13,
    x = 19,
    y = ymid,
    height = 3,
    monitor = mon,
    text = "To Turbines",
    state = true,
    toggle = false,
    colourOn = colours.green,
    colourOff = colours.red,
    onClick = function(s)
        setStop(true)
        shell.run("Turbine")
    end
}

quit = {
    x = term.getSize() - 12,
    text = "Quit",
    colourOn = colors.red,
    colourOff = colors.green,
    onClick = function()
        reactor.setActive(false)
        setStop(true)
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
        setStop(true)
        mon.clear()
        term.clear()
        shell.run("reboot")
    end
}

function main()
    mon.clear()
    term.clear()
    reactor.setActive(false)
    print("Drawing Static Text")
    drawStaticText()

    print("Adding Buttons")
    Button.new(reactorControl)
    Button.new(quit)
    Button.new(reboot)
    Button.new(turbinePage)
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
    
    while not stop do
        drawText()
        os.startTimer(1)
        EventListener.runEvent({os.pullEvent()})
    end
    print("Loop ended")
end

main()
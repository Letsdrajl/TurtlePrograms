shell.run("Button")
shell.run("EventListener")
shell.run("Monitor")

os.loadAPI("Button")
os.loadAPI("EventListener")
os.loadAPI("Monitor")

local currentTurbine = 1

local turbines = {}

local turbine = peripheral.wrap("BigReactors-Turbine_" .. #turbines)
while turbine do
    turbines[#turbines+1] = turbine
    turbine = peripheral.wrap("BigReactors-Turbine_" .. #turbines)
end

if #turbines == 0 then
    print("No turbines connected")
end

local mon = Monitor.getAdvMonitor()

if not mon then
    print("No monitor connected")
    print("Requires Advanced Monitor")
    shell.exit()
end

local rightAlign, _ = mon.getSize()
rightAlign = rightAlign - 22

--Draws static text used for all Turbines
local function drawStaticText()
    mon.setCursorPos(1,1)
    mon.write("Turbine:")
    mon.setCursorPos(1,2)
    mon.write("Status:")
    mon.setCursorPos(1,3)
    mon.write("Steam:")
    mon.setCursorPos(1,4)
    mon.write("RPM:")

    mon.setCursorPos(rightAlign,1)
    mon.write("Time:")
    mon.setCursorPos(rightAlign,2)
    mon.write("Coil:")
    mon.setCursorPos(rightAlign,3)
    mon.write("Energy/t:")
end

local function isEngaged(turbine)
    if turbine.getInductorEngaged() then
        return "Engaged"
    else
        return "Disengaged"
    end
end

local function drawText()
    for i = 1, 4 do
        mon.setCursorPos(12, i)
        mon.write("            ")
        mon.setCursorPos(rightAlign + 12, i)
        mon.write("            ")
    end

    local turbine = turbines[currentTurbine]

    mon.setCursorPos(12, 1)

    if turbine.mbIsConnected() then
        mon.setTextColour(colours.green)
        mon.write("Connected")
    else
        mon.setTextColour(colours.red)
        mon.write("Disconnected")
    end
    mon.setCursorPos(12, 2)

    if turbine.getActive() then
        mon.setTextColour(colours.green)
        mon.write("Online")
    else
        mon.setTextColour(colours.red)
        mon.write("Offline")
    end

    mon.setTextColour(colours.white)
    mon.setCursorPos(12, 3)
    mon.write(turbine.getInputAmount() / 1000 .. "B")
    mon.setCursorPos(12, 4)
    mon.write(turbine.getRotorSpeed() .. " RPM")

    mon.setCursorPos(rightAlign + 12, 1)
    mon.write(os.time())
    mon.setCursorPos(rightAlign + 12, 2)
    mon.write(isEngaged(turbine))
    mon.setCursorPos(rightAlign + 12, 3)
    mon.write(turbine.getEnergyProducedLastTick() .. " FE/t")

    mon.setCursorPos(24, 4)
    mon.setTextColour(colours.white)
end


xmid, ymid = Monitor.getCenter(mon)

nextTurbine = {
    width = 13,
    x = 4,
    y = ymid,
    height = 3,
    monitor = mon,
    text = ">",
    state = true,
    toggle = false,
    colourOn = colours.green,
    colourOff = colours.red,
    onClick = function(s)
        if currentTurbine < #turbines then
            currentTurbine = currentTurbine + 1
        else
            currentTurbine = 1
        end
    end
}

previousTurbine = {
    width = 13,
    x = 4,
    y = ymid,
    height = 3,
    monitor = mon,
    text = ">",
    state = true,
    toggle = false,
    colourOn = colours.green,
    colourOff = colours.red,
    onClick = function(s)
        if currentTurbine > 1 then
            currentTurbine = currentTurbine - 1
        else
            currentTurbine = #turbines
        end
    end
}

reactorPage = {
    width = 13,
    x = 19,
    y = ymid,
    height = 3,
    monitor = mon,
    text = "To Reactors",
    state = true,
    toggle = false,
    colourOn = colours.green,
    colourOff = colours.red,
    onClick = function(s)
        stop = true
        shell.run("ReactorControl")
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

    print("Drawing static text")
    drawStaticText()

    print("Adding Buttons")
    Button.new(nextTurbine)
    Button.new(previousTurbine)
    Button.new(reboot)
    Button.new(quit)
    Button.drawAll()

    print("Adding EventListeners")
    EventListener.add("monitor_touch", "ButtonTouch", Button.eventHandler)
    EventListener.add("mouse_click", "ButtonClick", Button.eventHandler)

    EventListener.add("timer", "Automatic Shut Down", function()
        if not TURBINE then
            TURBINE = peripheral.wrap("BigReactors-Turbine_" .. currentTurbine)
            end 
        end
    )


    while not stop do
        drawText()
        os.startTimer(1)
        runEvent({os.pullEvent()})
    end
    print("Loop ended")
end

main()
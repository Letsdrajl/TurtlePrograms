shell.run("Button")
shell.run("EventListener")
shell.run("Monitor")

os.loadAPI("Button")
os.loadAPI("EventListener")
os.loadAPI("Monitor")

local currentTurbine = 1

local turbines = {}

local stop = false

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

--Max RPM for turbines
local maxRPM = 2000

--Variables to start a new prog after loop ended
local startNew = false
local prog = ""

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

--Returns a string if the Inductor is engaged
local function isEngaged(turbine)
    if turbine.getInductorEngaged() then
        return "Engaged"
    else
        return "Disengaged"
    end
end

--Draws text based on current turbine values
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
        mon.setTextColour(colours.white)
        mon.setCursorPos(12, 3)
        mon.write(turbine.getInputAmount() / 1000 .. "B")
        mon.setCursorPos(12, 4)
        mon.write(math.floor(turbine.getRotorSpeed()) .. " RPM")

        mon.setCursorPos(rightAlign + 12, 1)
        mon.write(os.time())
        mon.setCursorPos(rightAlign + 12, 2)
        mon.write(isEngaged(turbine))
        mon.setCursorPos(rightAlign + 12, 3)
        mon.write(math.floor(turbine.getEnergyProducedLastTick()) .. " FE/t")
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

    mon.setCursorPos(24, 4)
    mon.setTextColour(colours.white)
end

--Returns percentage of rpm based on maxRPM
local function rpmPercent()
    local rpm = turbines[currentTurbine].getRotorSpeed()

    local percent = rpm / maxRPM
    if percent >= 1 then
        return 1
    else
        return percent
    end
end

local function setStop(value)
    stop = value    
end

xmid, ymid = Monitor.getCenter(mon)

nextTurbine = {
    width = 3,
    x = 4,
    y = ymid - 3,
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
    width = 3,
    x = 1,
    y = ymid - 3,
    height = 3,
    monitor = mon,
    text = "<",
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
        setStop(true)
        startNew = true
        prog = "ReactorControl"
    end
}

quit = {
    x = term.getSize() - 12,
    text = "Quit",
    colourOn = colors.red,
    colourOff = colors.green,
    onClick = function()
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
        setStop(true)
        mon.clear()
        term.clear()
        startNew = true
        prog = "reboot"
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
    Button.new(reactorPage)
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
        Monitor.drawGraph(mon, 1, 10, ymid + 5, ymid + 8, rpmPercent())
        os.startTimer(1)
        EventListener.runEvent({os.pullEvent()})
    end
    print("Loop ended")
    if startNew then
        shell.run(prog)
    end
end

main()
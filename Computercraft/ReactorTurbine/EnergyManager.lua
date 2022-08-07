local matrixEnergyPerc = nil
local turbines = {}
local reactor

local matrix = peripheral.wrap("inductionPort_0")

if matrix then
    matrixEnergyPerc = matrix.getEnergyFilledPercentage()
end

EnergyManager = {}

function addReactor(o)
    reactor = o
end

function addTurbines(o)
    turbines = o
end

function manageReactor()
    if not reactor or not matrix then
        return
    end

    if matrixEnergyPerc > 95 then
        reactor.setActive(false)
    elseif matrixEnergyPerc < 10 then
        reactor.setActive(true)
    end
end

function manageTurbines()
    if not turbines or not matrix then
        return
    end

    for _, turbine in pairs(turbines) do
        if matrixEnergyPerc > 95 then
            turbine.setInductorEngaged(false)
            turbine.setActive(false)
        elseif matrixEnergyPerc < 10 then
            turbine.setActive(true)
        end

        if not turbine.getInductorEngaged() and turbine.getRotorSpeed() > 1800 then
            turbine.setInductorEngaged(true)
        end
    end
end
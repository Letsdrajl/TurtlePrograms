--Programm to Stripmine

local length
local eChest

local function turnAround()
  turtle.turnLeft()
  turtle.turnLeft()
end

local function moveForward(moveLength)
  for i = 1,moveLength do
    turtle.forward()
  end
end

--Function to clear screen
local function cls()

  term.clear()
  term.setCursorPos(1,1)

end

--Clearing a full inventory
local function clearInv()

  turnAround()
  turtle.select(1)
  turtle.place()

  for i = 4,16 do
    turtle.select(i)
    turtle.drop()
  end

  turtle.select(1)
  if eChest then
    turtle.dig()
  end
  turnAround()
end

--Checking for full inventory
local function checkInv()
  for i = 4,14 do
    if turtle.getItemDetail(i) == nil then
      return false
    end
  end
  return true

end

  --Checking for eventual falling block
local function blockCheck()

  while turtle.detect() do
    turtle.dig()
    sleep(0,5)
  end
end

--Place block below for crossing i.e. lava
local function placeBelow()
  if not turtle.detectDown() then
    turtle.select(3)
    local data = turtle.getItemDetail()

    if data.name == "minecraft:cobblestone" then
      turtle.placeDown()
    end
  end
end

--Dig forward
local function digForward(digLength)
  for i = 1,digLength do
    blockCheck()
    turtle.forward()
    placeBelow()
    turtle.digUp()
  end
end

--Place torch if available
local function placeTorch()

  turtle.select(2)
  local data = turtle.getItemDetail()

  if data.name == "minecraft:torch" then
    turnAround()
    moveForward(2)
    turtle.place()
    turnAround()
    moveForward(2)
  end

end



--Dig Function
local function digTunnel(tunnelLength)

  for i = 1,tunnelLength do
    digForward(3)
    placeTorch()

    turtle.turnLeft()
    digForward(5)

    turnAround()
    moveForward(5)

    digForward(5)
    turnAround()
    moveForward(5)
    turtle.turnRight()

    if checkInv() then
      clearInv()
    end

  end
end

--Main function
local function main()
  cls()

  print("1. Slot Chests/EChest")
  print("2. Slot Fackeln")
  print("3. Slot Cobblestone(!)")
  print("Für genug Fuel sorgen!")
  write("EnderChest?(y): ")
  if read() == "y" then
    eChest = true
  end

  --Firstly automate to length = 64
  write("Länge automatisch 64!")
  length = 64

  digTunnel(length)

end



--Function to restart the programm
local function restart()
  main()
end

main()

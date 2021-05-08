--Programm for digging out a room

--Starting with variables for the dimensions
local length
local width
local height
local eChest

local valNum = "Please enter a valid number"

local widthCount
local direction = true

local fuelLevel


--Function to clear screen
local function cls()

  term.clear()
  term.setCursorPos(1,1)

end

--Clearing a full inventory
local function clearInv()

  turtle.turnLeft()
  turtle.turnLeft()
  turtle.select(1)
  turtle.place()
  for i = 2,16 do
    turtle.select(i)
    turtle.drop()
  end
  turtle.select(1)
  if eChest == "y" then
    turtle.dig()
  end
  turtle.turnLeft()
  turtle.turnLeft()

end

--Checking for full inventory
local function checkInv()
  local full
  for i = 2,16 do
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
  if checkInv() then
    clearInv()
  end

end

--Calculating fuel usage
local function fuelUsage(h, l, w)

  fuelLevel = h * l * w
  if turtle.getFuelLevel() <= fuelLevel - 50 then
    print("Add more Fuel!")
    print("You have: " .. turtle.getFuelLevel() .. " Fuel")
    print("You need: " .. fuelLevel+100 .. " Fuel")
  end

end


--Main move  function
local function moveForward()

  for x = 1, height do
    widthCount = width
    for y = 1, width do
      for z = 1, length-1 do
        blockCheck()
        turtle.forward()
      end
      if widthCount == 1 then

      else
        if direction == true then
          turtle.turnLeft()
          blockCheck()
          turtle.forward()
          turtle.turnLeft()
          direction = false
        else
          turtle.turnRight()
          blockCheck()
          turtle.forward()
          turtle.turnRight()
          direction = true
        end
      end
      widthCount = widthCount - 1
    end
    turtle.digDown()
    turtle.down()
    turtle.turnRight()
    turtle.turnRight()
  end

end
---------------------------------------------------------------------
--Function for the programm itself
local function main()
  cls()
  write("Welcome to the room creator (digging to the left)")
  term.setCursorPos(1,2)
  write("Make sure to have enough fuel!")
  term.setCursorPos(1,3)
  write("Put a Chests in the first slot!")
  term.setCursorPos(1,4)
  write("Wich length should the room have: ")
  length = read()
  if tonumber(length) == nil then
    cls()
    print(valNum)
    sleep(5)
    restart()
  end
  term.setCursorPos(1,5)
  write("Wich width should the room have: ")
  width = read()
  if tonumber(width) == nil then
    cls()
    print(valNum)
    sleep(5)
    restart()
  end
  term.setCursorPos(1,6)
  write("Wich height should the room have: ")
  height = read()
  if tonumber(height) == nil then
    cls()
    print(valNum)
    sleep(5)
    restart()
  end
  term.setCursorPos(1,7)
  write("Do you use an ender chest?(y): ")
  eChest = read()
  cls()
  fuelUsage(height, length, width)
  moveForward()
end

--Function to restart the programm
local function restart()
  main()
end

main()

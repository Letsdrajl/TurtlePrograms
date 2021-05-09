--Programm to Stripmine

local length
local eChest


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
  for i = 3,16 do
    turtle.select(i)
    turtle.drop()
  end
  turtle.select(1)
  if eChest == "y" then
    turtle.dig()
  end
  turtle.turnLeft()
  turtle.turnLeft()

  --Checking for full inventory
  local function checkInv()
    local full
    for i = 3,14 do
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

--Main function
local function main()

  print("1. Slot Chests/EChest")
  print("2. Slot Fackeln")
  print("Für genug Fuel sorgen!")
  write("EnderChest?(y): ")
  if read() == "y" then
    eChest = true
  end
  write("Länge automatisch 64!")

end

  --Function to restart the programm
  local function restart()
    main()
  end

  main()

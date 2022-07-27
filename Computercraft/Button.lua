--Heavily inspired by Jack "Jiggins" Higgins
--Updated to be more user friendly

buttons = {}

Button = {}
prototype = {
  x = 1, y = 1, 
  width = 12, height = 1,
  
  text = "Button",
  textOn = "On",
  textOff = "Off",
  monitor = nil,
  
  state = true,
  toggle = false,
  colourOff  = colors.red,
  colourOn   = colors.green,
  textColour = colors.white, 
  
  onClick = function()
    print("No onClick function defined")
  end
}

-- Button Metatable
-- Used for default values
mt = {}
mt.__index = function (table, key)
  return prototype[key]
end

function new(o)
  o = o or {}
  setmetatable(o, Button.mt)
  buttons[#buttons+1] = o
  return o
end

function draw(button)
  local oldx, oldy = term.getCursorPos()
  if button.monitor then
    term.redirect(button.monitor)
  else
    term.redirect(term.native())
  end
  
  if button.state then
    term.setBackgroundColor(button.colourOn)
  else
    term.setBackgroundColor(button.colourOff)
  end
  print("Draw1")
  term.setCursorPos(button.x, button.y)

  x1, y1, x2, y2 = getBounds(button)
  for j = y1, y2 do
    for i = x1, x2 do
      term.setCursorPos(i, j)
      term.write(" ")
    end
  end

  local xmid = math.floor(((x2 + x1) - string.len(button.text)) / 2)
  local ymid = math.floor((y2 + y1) / 2)
  print("Draw2")
  term.setCursorPos(xmid, ymid)
  term.write(button.text)
  print("Draw3")
  term.setBackgroundColor(colours.black)
  term.redirect(term.native())
  print("Draw4")
  term.setCursorPos(oldx, oldy)
end

function click(button)
  if not button.toggle then
    button.state = false
    Button.draw(button)
    button.onClick()
    button.state = true
    Button.draw(button)
  else
    button.state = not button.state
    button.onClick(button.state)
    Button.draw(button)
  end
end

-- Returns the four corner coordinates of the button
function getBounds(button)
  return button.x, button.y, (button.x + button.width), (button.y + button.height - 1)
end

function inBounds(button, x, y)
  x1, y1, x2, y2 = getBounds(button)
  return (x >= x1) and (x <= x2) and (y >= y1) and (y <= y2)
end

function updateLoop()
  while true do
    for i, button in pairs(buttons) do
      draw(button)
    end
    
    -- Wait for a click event
    event, side, x, y = os.pullEvent()
    if event == "mouse_click" or event == "monitor_touch" then
      for i, button in pairs(buttons) do
        if inBounds(button, x, y) then
          click(button)
        end
      end
    end
  end
end

-- Function to be used with EventListener.lua
-- When called, it checks the buttons table to see if any buttons have been
-- clicked, if so, it calls click on that function
function eventHandler(event)
  drawAll()

  eventType, side, x, y = unpack(event)
  if eventType == "mouse_click" or eventType == "monitor_touch" then
    for i, button in pairs(buttons) do
      if inBounds(button, x, y) then
        click(button)
        break
      end
    end
  end
end

function drawAll()
  for i, button in pairs(buttons) do
    draw(button)
  end
end
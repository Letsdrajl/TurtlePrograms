--Heavily inspired by Jack "Jiggins" Higgins
--Updated to be more user friendly

EventListener = {}
-- events :: [Event -> IO ()]
-- events :: A list of functions that take an event as the parameter and
--           do something on that event.
function init()
  events = {
    key = {},
    char = {},
    disk = {},
    paste = {},
    timer = {},
    alarm = {},
    key_up = {},
    redstone = {},
    terminate = {},
    disk_eject = {},
    peripheral = {},
    term_resize = {},
    mouse_click = {},
    mouse_scroll = {},
    http_success = {},
    http_failure = {},
    modem_message = {},
    monitor_touch = {},
    monitor_resize = {},
    rednet_message = {},
    turtle_inventory = {},
    peripheral_detach = {}
  }
end

function add(eventType, eventName, eventFunction)
  if not events then
    init()
  end

  if events[eventType] then
    table.insert(events[eventType], {name = eventName, func = eventFunction})
  else
    print("Invalid event type: " .. eventType)
  end
end

function remove(eventType, eventName)
  for i, event in ipairs(events[eventType]) do
    if event["name"] == eventName then
      table.remove(events[eventType], i)
    end
  end 
end

-- Recieves an os.pullEvent() and calls the event function on each function in
-- the eventType table
-- for example:
-- add("redstone", "redstoneInput", function() print("rs in") end)
-- runEvent(os.pullEvent())

-- This will only call events on the redstone table if a redstone event is 
-- captured.
function runEvent(event)
  print(event[1])
    for _, functionTable in pairs(events[event[1]]) do
      functionTable["func"](event)
    end
end

function updateLoop(updateFequency, stop, fun)
  while not stop do
    fun()
    os.startTimer(updateFequency)
    runEvent({os.pullEvent()})
    
    
  end
  print("Loop ended")
end
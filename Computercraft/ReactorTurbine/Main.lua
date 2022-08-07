


urls = {
    {"Button",          "https://raw.githubusercontent.com/Letsdrajl/TurtlePrograms/main/Computercraft/Button.lua"},
    {"Main",            "https://raw.githubusercontent.com/Letsdrajl/TurtlePrograms/main/Computercraft/ReactorTurbine/Main.lua"},
    {"EventListener",   "https://raw.githubusercontent.com/Letsdrajl/TurtlePrograms/main/Computercraft/EventListener.lua"},
    {"ReactorControl",  "https://raw.githubusercontent.com/Letsdrajl/TurtlePrograms/main/Computercraft/ReactorTurbine/Reactor.lua"},
    {"Turbine",         "https://raw.githubusercontent.com/Letsdrajl/TurtlePrograms/main/Computercraft/ReactorTurbine/Turbine.lua"},
    {"Monitor",         "https://raw.githubusercontent.com/Letsdrajl/TurtlePrograms/main/Computercraft/Monitor.lua"},
    {"EnergyManager",   "https://raw.githubusercontent.com/Letsdrajl/TurtlePrograms/main/Computercraft/ReactorTurbine/EnergyManager.lua"}
}


-- Credits to Jiggins
function download(name, url)
    print("Updating " .. name)
   
    request = http.get(url)
    data = request.readAll()
   
    if fs.exists(name) then
      fs.delete(name)
      file = fs.open(name, "w")
      file.write(data)
      file.close()
    else
      file = fs.open(name, "w")
      file.write(data)
      file.close()
    end
   
    print("Successfully downloaded " .. name .. "\n")
end
  
for key, value in ipairs(urls) do
    download(unpack(value))
end
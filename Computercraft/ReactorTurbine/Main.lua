


urls = {
    {"Button",  "https://raw.githubusercontent.com/Jiggins/ComputerCraft/master/Button.lua"},
    {"Main",  "https://raw.githubusercontent.com/Letsdrajl/Turtleprograms/main/Main.lua"}
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
  
  term.clear()
  term.setCursorPos()
local module = {}

local function wifi_wait_ip()
 
 	wifi.sta.autoconnect(1)
 	
    print("\n====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is "..wifi.sta.getip())
    print("====================================")

    Initialize()

end

function Initialize()

  --Connect to web service and get config settings

  print("Connecting to Mosquitto..")
  mosquitto.start()
  dofile("nodemgmt.lua")
  loadApps()
end

function loadApps()

  if config.apps then
    tmrNumber = 3
    for key,value in pairs(config.apps) do
      print(key .. " - " ..value)
      app = require(value)
      app.start(tmrNumber, config.Sensor_Interval)
      tmrNumber = tmrNumber + 1
    end
  end

end

local function wifi_start(list_aps)
  if list_aps then

    local foundWiFi = false

    for key,value in pairs(list_aps) do

      print ("SSID - " .. key .. " Value - " .. value)

      if config.SSID and config.SSID[key] then
        wifi.setmode(wifi.STATION);
        wifi.sta.config(key,config.SSID[key])
        wifi.sta.connect()
        print("Connecting to " .. key .. " ...")
        
        wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_wait_ip)
        
        foundWiFi = true
      	
      	break
      	
      end

    end

    if foundWiFi == false then
      print("Wifi SSID " .. config.params["wifissid"] .. " not found")
    end

  else
    print("Error getting AP list")
    node.restart()
  end
end

function module.start()
  --Check every 30 seconds if connected to WiFi. If not reboot
  tmr.stop(0)
  tmr.alarm(0,30000, 1,
    function()
      tmr.wdclr()
      if wifi.sta.getip()== nil then
        node.restart()
      end
    end)
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATION);
  wifi.sta.getap(wifi_start)
end

return module

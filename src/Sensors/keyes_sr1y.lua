local module = {}

relay_pin = 5 -- scl pin, GPIO014
isRelaySubscribed = false

function relayTest(data)
  print ("command recvd - " .. data)
  
  if data == "1" then
      print("Relay ON")
      gpio.write(relay_pin, gpio.HIGH)
  else 
    if data == "0" then
      print("Relay OFF")  
      gpio.write(relay_pin, gpio.LOW)
    end 
  end
  
end


function subscribeRelay()
    if isRelaySubscribed == false then
      isRelaySubscribed = mosquitto.subscribe(config.MQTT_SensorTopic .. "lamp/command", "relayTest")
    end
end

function module.start(tmrNumber, tmrInterval)  

  print("relay start")
  gpio.mode(relay_pin, gpio.INPUT)
  
  tmr.stop(tmrNumber)
  tmr.alarm(tmrNumber,tmrInterval, 1, 
    function()
      subscribeRelay()
    end)

  
end

return module

--GND - purple
--ADD - Blue
--SDA - Green
--SCL - Yellow
--VCC - Orange

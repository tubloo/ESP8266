local module = {}

pin = 4

local function getDHTdata()

--  status = dht.OK
--  temp = 21.1
--  humi = 90.2
--  temp_dec = 1
--  humi_dec = 2

  status, temp, humi, temp_dec, humi_dec = dht.read(pin)
  if status == dht.OK then
    -- Integer firmware using this example
    print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
        math.floor(temp),
        temp_dec,
        math.floor(humi),
        humi_dec
      ))

    -- Float firmware using this example
    print("DHT Temperature:"..temp..";".."Humidity:"..humi)

    return status, temp, humi, temp_dec, humi_dec

  elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
    return -1
  elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
    return -1
  end

end 

local function sendData(topic)

  status, temp, humi, temp_dec, humi_dec = getDHTdata()


  mosquitto.publish(config.MQTT_SensorTopic .. "temperature",temp)
  mosquitto.publish(config.MQTT_SensorTopic .. "humidity",humi)


end

function module.start(tmrNumber, tmrInterval)  
  tmr.stop(tmrNumber)
  tmr.alarm(tmrNumber,tmrInterval, 1, 
    function()
      sendData()
    end)
end

return module
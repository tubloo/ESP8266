local module = {}

inpin = 6

start= tmr.time()

function motionStart()
  start=tmr.time()
  print('Motion Started!')
  sendData("1")    
  gpio.trig(inpin, "down", motionStop)
end

function motionStop()
  duration = tmr.time() - start
  print('Motion ended after '..duration..' seconds.')
  sendData("0")
  gpio.trig(inpin, "up", motionStart)
end



function sendData(msg)  
    mosquitto.publish(config.MQTT_SensorTopic .. "motion/state",msg)
end


function module.start(tmrNumber, tmrInterval)  
  print("hcsr start")
  gpio.mode(inpin, gpio.INT)
  gpio.trig(inpin, "up", motionStart)

end

return module
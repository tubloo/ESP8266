local module = {}

inpin = 6

start= tmr.time()
lastEnd = 0

function motionStart()
  sendData("1")
  start=tmr.time()
  print('Motion detected!')
--  print('[DEBUG] start: '..start..', last: '..lastEnd..
--    ', break: '..start - lastEnd)
--  sendData("1")
  tmr.delay(2000)
  gpio.trig(inpin, "down", motionStop)
end

function motionStop()
  duration = tmr.time() - start
--  print('motion ended after '..duration..' seconds.')
--  print('[DEBUG] start: '..start..', duration: '..duration)
--  sendData("0")
  tmr.delay(2000)
  lastEnd=start + duration
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
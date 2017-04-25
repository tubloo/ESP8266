local module = {}

module.params = {}

module.SSID = {}  

module.MQTT_Host = ""  
module.MQTT_Port = 0  
module.MQTT_ID = node.chipid()
module.MQTT_NodeTopic = "home/nodemcu/"  
module.MQTT_SensorTopic = "home/livingroom/"  

module.Node_Interval = 5000
module.Sensor_Interval = 10000

module.apps = {}
module.apps["DHT22"] = "dht22"
module.apps["BH1750"] = "bh1750"
module.apps["HCSR501PR"] = "hcsr501pr"
module.apps["KEYES_SR1Y"] = "keyes_sr1y"

return module  

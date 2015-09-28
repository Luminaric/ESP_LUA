dht22 = require("dht22")



function sendData()
  	dht22.read(4)
  	h=dht22.getHumidity()
  	t=dht22.getTemperature()

  if t > 0 then

    humidity=(h/10).."."..(h%10)
    temperature=(t/10).."."..(t%10)
  	fare=(t*9/5+32).."."..(t9/5%10)
  	print("Humidity:    "..humidity.."%")
  	print("Temperature: "..temperature.." deg C")
  	print("Temperature: "..fare.." deg F")

    -- conection to thingspeak.com
    print("Sending data to thingspeak.com")
    conn=net.createConnection(net.TCP, 0) 
    conn:on("receive", function(conn, payload) print(payload) end)
    -- api.thingspeak.com 184.106.153.149
    conn:connect(80,'184.106.153.149') 
    conn:send("GET /update?key=B34V6DS7CPZOWDP0&field2="..temperature.."&field3="..humidity.." HTTP/1.1\r\n") 
    --print("GET /update?key=B34V6DS7CPZOWDP0&field1=0"..temperature.."&field2=0"..humidity.." HTTP/1.1\r\n")
    conn:send("Host: api.thingspeak.com\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
    conn:send("\r\n")
    conn:on("sent",function(conn)
                          print("Closing connection")
                          conn:close()
                      end)
    conn:on("disconnection", function(conn)
              print("Got disconnection...")
      end)



    -- conection to MySQL Server
    print("Sending data to MySQL Server")
    conn=net.createConnection(net.TCP, 0) 
    conn:on("receive", function(conn, payload) print(payload) end)

    conn:connect(80,'10.1.1.24') 
    conn:send("Get /a/add2.php?sensorID=ESP03&t="..temperature.."&h="..humidity.."&p=0 \r\n") 
    conn:send("Host: 10.1.1.24 Connection: close\r\n") 
    conn:send("\r\n") 
    conn:send("\r\n")
    conn:on("sent",function(conn)
                          print("Closing connection")
                          conn:close()
                      end)
    conn:on("disconnection", function(conn)
              print("Got disconnection...")
      end)

  else
    print(t)
    tmr.alarm(1, 6000, 0, function() sendData() end )
  end
  
end
print("10 minutes to next upload")
-- send data every X ms to thing speak
tmr.alarm(0, 600000, 1, function() sendData() end )
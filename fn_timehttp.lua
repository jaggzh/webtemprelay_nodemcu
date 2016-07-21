local c=net.createConnection(net.TCP, 0) 
 
c:on("connection",function(c, payload)
 c:send("HEAD / HTTP/1.1\r\nHost: earthquake.usgs.gov\r\n\r\n")
end)
            
c:on("receive", function(c, payload)
 time=string.sub(payload,string.find(payload,"Date: ")+6,string.find(payload,"Date: ")+35)
 print("Received TIME "..time)
 c:close()
end) 
--t = tmr.now()    
c:connect(80,'earthquake.usgs.gov')

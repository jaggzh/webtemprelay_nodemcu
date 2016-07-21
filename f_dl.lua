host,port,dir,src,dst=...
print("Loading: "..host..":"..port.."/"..dir.."/"..src.." -> "..dst)
file.open(dst, "w")
payloadFound = false
local conn = net.createConnection(net.TCP, 0)
conn:on("connection", function(conn)
 conn:send("GET /"..dir.."/"..src.." HTTP/1.0\r\n".."Host: "..host.."\r\nConnection: close\r\nAccept: */*\r\n\r\n") end)
conn:on("receive", function(conn, payload)
 if(payloadFound)then
  file.write(payload)
  file.flush()
 else
  payloadOffset = string.find(payload, "\r\n\r\n")
  if(payloadOffset)then
   file.write(string.sub(payload, payloadOffset + 4))
   file.flush()
   payloadFound = true
  end
 end
end)
conn:on("disconnection", function(conn)
 file.close() -- dofile(src)
end)
conn:connect(port,host)
-- vim:et:ts=4:sw=1

local conn=...
local cat_end=0

local function cat_sender(conn) -- callback
 print("cat_sender")
 if(cat_end==1)then
  print("Closing connection")
  conn:close()
 else
  print("Reading chunk from file")
  local data=file.read(HTML_MAX)
  if(data==nil)then
   print("Sending footer")
   cat_end=1
   conn:send("</pre>\n")
  else
   print("Sending data")
   print("Data: {{"..data.."}}")
   data=string.gsub(data, "&", "&amp;")
   data=string.gsub(data, "<", "&lt;")
   data=string.gsub(data, ">", "&gt;")
   conn:send(data)
  end
 end
end

if(_FORM.f==nil)then
 resp="Missing f<br />"
 print(resp)
else
 if(file.open(_FORM.f)==nil)then
  resp="File ".._FORM.f.." not found<br />"
  print(resp)
 else
  print("Opened ".._FORM.f)
  conn:on("sent", cat_sender)
  conn:send(http200().."<html><head><link rel='shortcut icon' href='data:image/x-icon;,' type='image/x-icon'></head><body><pre>")
  print("Sent HTML header...")
 end
end

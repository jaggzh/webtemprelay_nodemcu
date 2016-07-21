local c,str=...
local send_end,sz,cnt,len=0,1459,0,string.len(str)
local function sender(c)
 local st=sz*cnt
 local s=string.sub(str,st+1,st+sz)
 cnt=cnt+1
 --print("Sending {{"..s.."}}")
 c:send(s)
 if(st+sz >= len)then
  --print("Closing connection")
  c:close()
 end
end
c:on("sent", sender)
sender(c)
-- vim:et:ts=1:sw=1

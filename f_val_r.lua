k=...
if(file.open(k)~=nil)then
 local l=file.readline()
 if(l~=nil)then
  result=string.sub(l, 1, -2) -- chop
  file.close()
  return result
 end
end
return nil

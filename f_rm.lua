if(_FORM.f==nil)then
 resp="Missing f<br />"
else
 file.remove(_FORM.f)
 resp="Removed ".._FORM.f.."<br />"
end

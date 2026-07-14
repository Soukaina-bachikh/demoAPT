// Lists active staff members, optionally filtered by specialty

#DECLARE($params : Object) : Object

var $result : Object:={staff: []}

Try
	var $staffList : cs.StaffSelection

	If ($params#Null) && ($params.specialty#Null) && ($params.specialty#"")
		$staffList:=ds.Staff.query("isActive = :1 and specialty = :2"; True; $params.specialty)
	Else
		$staffList:=ds.Staff.query("isActive = :1"; True)
	End if

	var $s : cs.StaffEntity
	For each ($s; $staffList)
		$result.staff.push({\
			staffID: $s.staffID;\
			firstName: $s.firstName;\
			lastName: $s.lastName;\
			specialty: $s.specialty;\
			slotDuration: $s.slotDuration\
		})
	End for each
Catch
	$result.error:=Last errors.first().message
End try

return $result
// Lists free appointment slots for a date, optionally filtered to one staff member

#DECLARE($params : Object) : Object

var $result : Object:={date: $params.date; slots: []}

Try
	var $date : Date
	$date:=Date($params.date)

	var $staffList : cs.StaffSelection
	If ($params.staffID#Null) && ($params.staffID#"")
		$staffList:=ds.Staff.query("staffID = :1 and isActive = :2"; $params.staffID; True)
	Else
		$staffList:=ds.Staff.query("isActive = :1"; True)
	End if

	var $staff : cs.StaffEntity
	For each ($staff; $staffList)
		var $freeSlots : Collection
		$freeSlots:=APT_ComputeFreeSlots($staff; $date)

		var $slotTime : Time
		For each ($slotTime; $freeSlots)
			$result.slots.push({\
				staffID: $staff.staffID;\
				staffName: $staff.firstName+" "+$staff.lastName;\
				time: String($slotTime; "HH:mm")\
			})
		End for each
	End for each
Catch
	$result.error:=Last errors.first().message
End try

return $result
// Finds the next free slot for a specific staff member, searching forward from a date (14-day window)

#DECLARE($params : Object) : Object

var $result : Object:={found: False}

Try
	var $staff : cs.StaffEntity
	$staff:=ds.Staff.query("staffID = :1"; $params.staffID).first()

	If ($staff=Null)
		$result.error:="Staff not found"
		return $result
	End if

	var $searchDate : Date
	If ($params.fromDate#Null) && ($params.fromDate#"")
		$searchDate:=Date($params.fromDate)
	Else
		$searchDate:=Current date
	End if

	var $daysChecked : Integer
	$daysChecked:=0

	While (Not($result.found)) && ($daysChecked<14)
		var $freeSlots : Collection
		$freeSlots:=APT_ComputeFreeSlots($staff; $searchDate)

		If ($freeSlots.length>0)
			$result.found:=True
			$result.staffID:=$staff.staffID
			$result.staffName:=$staff.firstName+" "+$staff.lastName
			$result.date:=String($searchDate; "yyyy-MM-dd")
			$result.time:=String($freeSlots[0]; "HH:mm")
		End if

		$searchDate:=$searchDate+1
		$daysChecked:=$daysChecked+1
	End while
Catch
	$result.error:=Last errors.first().message
End try

return $result
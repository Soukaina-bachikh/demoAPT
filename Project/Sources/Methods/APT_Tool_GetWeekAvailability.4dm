// Lists free slots for a staff member across the next 7 days from a given date,
// so the assistant can proactively offer alternatives when a specific day is full.

#DECLARE($params : Object) : Object

var $result : Object:={days: []}

Try
	If ($params.staffID=Null) || ($params.staffID="")
		$result.error:="staffID is required"
		return $result
	End if

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

	var $dayNames : Collection:=["Sunday"; "Monday"; "Tuesday"; "Wednesday"; "Thursday"; "Friday"; "Saturday"]

	var $i : Integer
	For ($i; 0; 6)
		var $freeSlots : Collection
		$freeSlots:=APT_ComputeFreeSlots($staff; $searchDate)

		If ($freeSlots.length>0)
			var $slotTexts : Collection:=[]
			var $slot : Time
			For each ($slot; $freeSlots)
				$slotTexts.push(String($slot; "HH:mm"))
			End for each

			$result.days.push({\
				date: String($searchDate; "yyyy-MM-dd");\
				dayName: $dayNames[Day number($searchDate)-1];\
				slots: $slotTexts\
			})
		End if

		$searchDate:=$searchDate+1
	End for

	$result.staffName:=$staff.firstName+" "+$staff.lastName
Catch
	$result.error:=Last errors.first().message
End try

return $result

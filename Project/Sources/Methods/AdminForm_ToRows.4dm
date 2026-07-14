// Converts an AppointmentSelection into flat rows suitable for the listbox dataSource

#DECLARE($appts : cs.AppointmentSelection) : Collection

var $rows : Collection:=[]

var $appt : cs.AppointmentEntity
For each ($appt; $appts)
	var $client : cs.ClientEntity
	$client:=ds.Client.query("clientID = :1"; $appt.clientID).first()

	var $staff : cs.StaffEntity
	$staff:=ds.Staff.query("staffID = :1"; $appt.staffID).first()

	var $clientName : Text
	$clientName:=""
	If ($client#Null)
		$clientName:=$client.firstName+" "+$client.lastName
	End if

	var $staffName : Text
	$staffName:=""
	If ($staff#Null)
		$staffName:=$staff.firstName+" "+$staff.lastName
	End if

	$rows.push({\
		appointmentID: $appt.appointmentID;\
		confirmationCode: $appt.confirmationCode;\
		date: String($appt.date; ISO date);\
		time: String($appt.time);\
		clientName: $clientName;\
		staffName: $staffName;\
		status: $appt.status;\
		reason: $appt.reason\
	})
End for each

return $rows

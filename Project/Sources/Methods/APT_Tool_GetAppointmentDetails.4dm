// Retrieves full details for one appointment by its internal appointment ID

#DECLARE($params : Object) : Object

var $result : Object:={found: False}

Try
	var $appt : cs.AppointmentEntity
	$appt:=ds.Appointment.query("appointmentID = :1"; $params.appointmentID).first()

	If ($appt=Null)
		return $result
	End if

	var $client : cs.ClientEntity
	$client:=ds.Client.query("clientID = :1"; $appt.clientID).first()

	var $staff : cs.StaffEntity
	$staff:=ds.Staff.query("staffID = :1"; $appt.staffID).first()

	$result.found:=True
	$result.appointmentID:=$appt.appointmentID
	$result.confirmationCode:=$appt.confirmationCode
	$result.date:=String($appt.date; ISO date)
	$result.time:=String($appt.time)
	$result.duration:=$appt.duration
	$result.reason:=$appt.reason
	$result.status:=$appt.status

	If ($client#Null)
		$result.clientName:=$client.firstName+" "+$client.lastName
	End if

	If ($staff#Null)
		$result.staffName:=$staff.firstName+" "+$staff.lastName
	End if
Catch
	$result.error:=Last errors.first().message
End try

return $result
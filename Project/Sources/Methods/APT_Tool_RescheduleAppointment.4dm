// Moves an existing appointment to a new date/time, after verifying the new slot is free

#DECLARE($params : Object) : Object

var $result : Object:={success: False}

Try
	var $appt : cs.AppointmentEntity
	$appt:=ds.Appointment.query("appointmentID = :1"; $params.appointmentID).first()

	If ($appt=Null)
		$result.error:="Appointment not found"
		return $result
	End if

	var $newDate : Date
	var $newTime : Time
	$newDate:=Date($params.newDate)
	$newTime:=Time($params.newTime)

	var $conflict : cs.AppointmentSelection
	$conflict:=ds.Appointment.query("staffID = :1 and date = :2 and time = :3 and status != :4 and appointmentID != :5"; \
		$appt.staffID; $newDate; $newTime; "cancelled"; $appt.appointmentID)

	If ($conflict.length>0)
		$result.error:="This slot is no longer available. Please choose another time."
		return $result
	End if

	$appt.date:=$newDate
	$appt.time:=$newTime

	var $status : Object
	$status:=$appt.save()

	If ($status.success)
		$result.success:=True
		$result.confirmationCode:=$appt.confirmationCode
		$result.date:=String($appt.date; "yyyy-MM-dd")
		$result.time:=String($appt.time; "HH:mm")
	Else
		$result.error:="Failed to reschedule appointment: "+$status.statusText
	End if
Catch
	$result.error:=Last errors.first().message
End try

return $result
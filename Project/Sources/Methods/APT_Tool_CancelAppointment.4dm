// Cancels an existing appointment by its internal appointment ID

#DECLARE($params : Object) : Object

var $result : Object:={success: False}

Try
	var $appt : cs.AppointmentEntity
	$appt:=ds.Appointment.query("appointmentID = :1"; $params.appointmentID).first()

	If ($appt=Null)
		$result.error:="Appointment not found"
		return $result
	End if

	$appt.status:="cancelled"

	var $status : Object
	$status:=$appt.save()

	If ($status.success)
		$result.success:=True
		$result.confirmationCode:=$appt.confirmationCode
	Else
		$result.error:="Failed to cancel appointment: "+$status.statusText
	End if
Catch
	$result.error:=Last errors.first().message
End try

return $result
// Looks up an appointment by its human-readable APT-XXXXXX confirmation code

#DECLARE($params : Object) : Object

var $result : Object:={found: False}

Try
	var $appt : cs.AppointmentEntity
	$appt:=ds.Appointment.query("confirmationCode = :1"; Uppercase(String($params.confirmationCode))).first()

	If ($appt=Null)
		return $result
	End if

	return APT_Tool_GetAppointmentDetails({appointmentID: $appt.appointmentID})
Catch
	$result.error:=Last errors.first().message
End try

return $result
// Books an appointment slot and generates a confirmation code. findClient must have run first.

#DECLARE($params : Object) : Object

var $result : Object:={success: False}

Try
	var $requestedDate : Date
	var $requestedTime : Time
	$requestedDate:=Date($params.date)
	$requestedTime:=Time($params.time)

	var $existing : cs.AppointmentSelection
	$existing:=ds.Appointment.query("staffID = :1 and date = :2 and time = :3 and status != :4"; \
		$params.staffID; $requestedDate; $requestedTime; "cancelled")

	If ($existing.length>0)
		$result.error:="This slot is no longer available. Please choose another time."
		return $result
	End if

	var $staff : cs.StaffEntity
	$staff:=ds.Staff.query("staffID = :1"; $params.staffID).first()

	If ($staff=Null)
		$result.error:="Staff member not found"
		return $result
	End if

	var $code : Text
	var $isUnique : Boolean
	$isUnique:=False
	While (Not($isUnique))
		$code:="APT-"+Uppercase(Substring(Generate UUID; 1; 6))
		$isUnique:=(ds.Appointment.query("confirmationCode = :1"; $code).length=0)
	End while

	var $appt : cs.AppointmentEntity
	$appt:=ds.Appointment.new()
	$appt.confirmationCode:=$code
	$appt.clientID:=$params.clientID
	$appt.staffID:=$params.staffID
	$appt.date:=$requestedDate
	$appt.time:=$requestedTime
	$appt.duration:=$staff.slotDuration
	$appt.reason:=APT_TextOrEmpty($params.reason)
	$appt.status:="confirmed"
	$appt.createdAt:=Current date

	var $status : Object
	$status:=$appt.save()

	If ($status.success)
		$result.success:=True
		$result.appointmentID:=$appt.appointmentID
		$result.confirmationCode:=$appt.confirmationCode
		$result.date:=String($appt.date; "yyyy-MM-dd")
		$result.time:=String($appt.time; "HH:mm")
		$result.staffName:=$staff.firstName+" "+$staff.lastName
	Else
		$result.error:="Failed to create appointment: "+$status.statusText
	End if
Catch
	$result.error:=Last errors.first().message
End try

return $result
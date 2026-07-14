// Lists a client's appointments: upcoming (default), past, or all

#DECLARE($params : Object) : Object

var $result : Object:={appointments: []}

Try
	var $filter : Text
	$filter:=APT_TextOrEmpty($params.filter)

	var $appts : cs.AppointmentSelection
	Case of
		: ($filter="past")
			$appts:=ds.Appointment.query("clientID = :1 and date < :2"; $params.clientID; Current date)
		: ($filter="all")
			$appts:=ds.Appointment.query("clientID = :1"; $params.clientID)
		Else
			$appts:=ds.Appointment.query("clientID = :1 and date >= :2 and status != :3"; $params.clientID; Current date; "cancelled")
	End case

	$appts:=$appts.orderBy("date asc, time asc")

	var $appt : cs.AppointmentEntity
	For each ($appt; $appts)
		var $staff : cs.StaffEntity
		$staff:=ds.Staff.query("staffID = :1"; $appt.staffID).first()

		var $staffName : Text
		$staffName:=""
		If ($staff#Null)
			$staffName:=$staff.firstName+" "+$staff.lastName
		End if

		$result.appointments.push({\
			confirmationCode: $appt.confirmationCode;\
			date: String($appt.date; "yyyy-MM-dd");\
			time: String($appt.time; "HH:mm");\
			staffName: $staffName;\
			status: $appt.status;\
			reason: $appt.reason\
		})
	End for each
Catch
	$result.error:=Last errors.first().message
End try

return $result
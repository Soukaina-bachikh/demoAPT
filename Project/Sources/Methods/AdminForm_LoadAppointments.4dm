// Loads the appointment list for a given filter: upcoming (default), past, all, cancelled

#DECLARE($filter : Text)

Form.activeFilter:=$filter

var $appts : cs.AppointmentSelection
Case of
	: ($filter="past")
		$appts:=ds.Appointment.query("date < :1"; Current date).orderBy("date desc, time desc")
	: ($filter="cancelled")
		$appts:=ds.Appointment.query("status = :1"; "cancelled").orderBy("date desc, time desc")
	: ($filter="all")
		$appts:=ds.Appointment.all().orderBy("date desc, time desc")
	Else
		$appts:=ds.Appointment.query("date >= :1 and status != :2"; Current date; "cancelled").orderBy("date asc, time asc")
End case

Form.appointments:=AdminForm_ToRows($appts)
Form.currentAppointment:=Null

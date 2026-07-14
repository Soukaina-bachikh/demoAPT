// Searches appointments by confirmation code or client name, using Form.searchQuery

#DECLARE()

If (Form.searchQuery="")
	AdminForm_LoadAppointments(Form.activeFilter)
	return
End if

var $appts : cs.AppointmentSelection
$appts:=ds.Appointment.query("confirmationCode = :1"; Uppercase(Form.searchQuery))

If ($appts.length=0)
	var $clients : cs.ClientSelection
	$clients:=ds.Client.query("firstName = :1 or lastName = :1 or (firstName+' '+lastName) = :1"; Form.searchQuery)

	If ($clients.length>0)
		$appts:=ds.Appointment.query("clientID IN :1"; $clients.extract("clientID"))
	End if
End if

Form.appointments:=AdminForm_ToRows($appts.orderBy("date desc, time desc"))
Form.currentAppointment:=Null

// Searches appointments by confirmation code or client name, using Form.searchQuery

#DECLARE()

If (Form.searchQuery="")
	AdminForm_LoadAppointments(Form.activeFilter)
	return
End if

var $query : Text
$query:=Trim(Form.searchQuery)

var $appts : cs.AppointmentSelection
$appts:=ds.Appointment.query("confirmationCode = :1"; "@"+Uppercase($query)+"@")

If ($appts.length=0)
	// ORDA's query() mini-language doesn't support inline concatenation expressions
	// like (firstName+' '+lastName), so a full name has to be split and matched
	// against both fields with separate placeholders. "@" is the wildcard for
	// partial/contains matching.
	var $clients : cs.ClientSelection
	var $nameParts : Collection
	$nameParts:=Split string($query; " ")

	If ($nameParts.length>=2)
		$clients:=ds.Client.query("firstName = :1 and lastName = :2"; "@"+$nameParts[0]+"@"; "@"+$nameParts[$nameParts.length-1]+"@")
	Else
		$clients:=ds.Client.query("firstName = :1 or lastName = :1"; "@"+$query+"@")
	End if

	If ($clients.length>0)
		$appts:=ds.Appointment.query("clientID IN :1"; $clients.extract("clientID"))
	End if
End if

Form.appointments:=AdminForm_ToRows($appts.orderBy("date desc, time desc"))
Form.currentAppointment:=Null

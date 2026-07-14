// Cancels the currently selected appointment in the listbox

#DECLARE()

If (Form.currentAppointment=Null)
	ALERT("Select an appointment first.")
	return
End if

var $status : Object
$status:=APT_Tool_CancelAppointment({appointmentID: Form.currentAppointment.appointmentID})

If ($status.success)
	AdminForm_LoadAppointments(Form.activeFilter)
Else
	ALERT($status.error)
End if

// Application entry point. Pass "" for the client chat window, "admin" for the staff panel.

#DECLARE($role : Text)

If ($role="admin")
	Open form window("Admin"; Plain form window; Horizontally centered; Vertically centered; *)
Else
	Open form window("Chat"; Plain form window; Horizontally centered; Vertically centered; *)
End if
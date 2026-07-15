// Registers a new client. Only called when findClient has returned no match.

#DECLARE($params : Object) : Object

var $result : Object:={success: False}

Try
	var $firstName : Text
	var $lastName : Text
	$firstName:=APT_TitleCase($params.firstName)
	$lastName:=APT_TitleCase($params.lastName)

	If ($firstName="") || ($lastName="")
		$result.error:="Both firstName and lastName are required to create a client - ask the user for whichever is missing."
		return $result
	End if

	var $client : cs.ClientEntity
	$client:=ds.Client.new()
	$client.firstName:=$firstName
	$client.lastName:=$lastName
	$client.email:=Lowercase(APT_TextOrEmpty($params.email))
	$client.phone:=APT_TextOrEmpty($params.phone)
	$client.createdAt:=Current date

	var $status : Object
	$status:=$client.save()

	If ($status.success)
		$result.success:=True
		$result.client:={\
			clientID: $client.clientID;\
			firstName: $client.firstName;\
			lastName: $client.lastName\
		}
	Else
		$result.error:="Failed to create client: "+$status.statusText
	End if
Catch
	$result.error:=Last errors.first().message
End try

return $result

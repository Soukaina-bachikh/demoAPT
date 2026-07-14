// Registers a new client. Only called when findClient has returned no match.

#DECLARE($params : Object) : Object

var $result : Object:={success: False}

Try
	var $client : cs.ClientEntity
	$client:=ds.Client.new()
	$client.firstName:=$params.firstName
	$client.lastName:=$params.lastName
	$client.email:=String($params.email)
	$client.phone:=String($params.phone)
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
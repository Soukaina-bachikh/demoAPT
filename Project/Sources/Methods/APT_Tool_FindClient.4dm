// Searches for an existing client by name, email, or phone

#DECLARE($params : Object) : Object

var $result : Object:={found: False; client: Null}

Try
	var $match : cs.ClientEntity
	$match:=APT_FindClientEntity($params)

	If ($match#Null)
		$result.found:=True
		$result.client:={\
			clientID: $match.clientID;\
			firstName: $match.firstName;\
			lastName: $match.lastName;\
			email: $match.email;\
			phone: $match.phone\
		}
	End if
Catch
	$result.error:=Last errors.first().message
End try

return $result

// Searches for an existing client by name, email, or phone

#DECLARE($params : Object) : Object

var $result : Object:={found: False; client: Null}

Try
	var $clients : cs.ClientSelection

	If ($params.email#Null) && ($params.email#"")
		$clients:=ds.Client.query("email = :1"; $params.email)
	Else If ($params.phone#Null) && ($params.phone#"")
		$clients:=ds.Client.query("phone = :1"; $params.phone)
	Else If ($params.name#Null) && ($params.name#"")
		$clients:=ds.Client.query("firstName = :1 or lastName = :1 or (firstName+' '+lastName) = :1"; $params.name)
	End if

	If ($clients#Null) && ($clients.length>0)
		var $client : cs.ClientEntity
		$client:=$clients.first()
		$result.found:=True
		$result.client:={\
			clientID: $client.clientID;\
			firstName: $client.firstName;\
			lastName: $client.lastName;\
			email: $client.email;\
			phone: $client.phone\
		}
	End if
Catch
	$result.error:=Last errors.first().message
End try

return $result
// Finds a client entity by email, phone, or full name. Matching is done in plain
// 4D code with explicit Uppercase() comparisons on both sides, rather than the
// ORDA query() string DSL - see APT_Tool_FindClient for why.
// Shared by APT_Tool_FindClient and APT_Tool_CreateClient's duplicate check.

#DECLARE($params : Object) : cs.ClientEntity

var $match : cs.ClientEntity
$match:=Null

var $c : cs.ClientEntity

If ($params.email#Null) && ($params.email#"")
	var $searchEmail : Text
	$searchEmail:=Uppercase(Trim($params.email))

	For each ($c; ds.Client.all())
		If (Uppercase(String($c.email))=$searchEmail)
			$match:=$c
		End if
	End for each

Else If ($params.phone#Null) && ($params.phone#"")
	var $searchPhone : Text
	$searchPhone:=Uppercase(Trim($params.phone))

	For each ($c; ds.Client.all())
		If (Uppercase(String($c.phone))=$searchPhone)
			$match:=$c
		End if
	End for each

Else If ($params.name#Null) && ($params.name#"")
	var $nameParts : Collection
	$nameParts:=Split string(Uppercase(Trim($params.name)); " ")

	For each ($c; ds.Client.all())
		If ($nameParts.length>=2)
			If ((Uppercase($c.firstName)=$nameParts[0]) && (Uppercase($c.lastName)=$nameParts[$nameParts.length-1]))
				$match:=$c
			End if
		Else
			If ((Uppercase($c.firstName)=$nameParts[0]) || (Uppercase($c.lastName)=$nameParts[0]))
				$match:=$c
			End if
		End if
	End for each
End if

return $match

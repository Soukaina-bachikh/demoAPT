// Capitalizes the first letter of each word, lowercasing the rest.
// Used to normalize client-provided names for consistent display/storage,
// regardless of how the user typed them ("soukaina" -> "Soukaina").
// Accepts Variant (not Text) since callers may pass a Null value straight
// from a tool argument the model omitted, despite it being "required".

#DECLARE($value : Variant) : Text

If ($value=Null)
	return ""
End if

var $words : Collection
$words:=Split string(Trim(String($value)); " ")

var $result : Collection:=[]
var $word : Text
For each ($word; $words)
	If ($word#"")
		$result.push(Uppercase(Substring($word; 1; 1))+Lowercase(Substring($word; 2)))
	End if
End for each

return $result.join(" ")

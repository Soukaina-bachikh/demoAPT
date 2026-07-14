// Reads the OpenAI API key from Resources/AIProvider.json (gitignored, never committed).
// Copy Resources/AIProvider.example.json to Resources/AIProvider.json and set your own key.

#DECLARE() : Text

var $config : Object

Try
	$config:=JSON Parse(Folder(fk resources folder).file("AIProvider.json").getText())
Catch
	ALERT("Missing or unreadable Resources/AIProvider.json. Copy AIProvider.example.json to AIProvider.json and set your API key.")
	return ""
End try

return String($config.apiKey)

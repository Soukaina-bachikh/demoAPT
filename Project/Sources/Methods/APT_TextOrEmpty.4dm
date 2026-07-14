// Returns the text value of $1, or "" if $1 is Null.
// Guards against 4D's String(Null) returning the literal text "null".

#DECLARE($value : Variant) : Text

If ($value=Null)
	return ""
End if

return String($value)

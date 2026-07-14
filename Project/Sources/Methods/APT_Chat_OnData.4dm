// Called by AIKit for each streamed chunk while the assistant is replying

#DECLARE($chunk : cs.AIKit.OpenAIChatCompletionsStreamResult)

If ($chunk.success)
	var $delta : Text
	$delta:=String($chunk.choice.delta.content)

	If ($delta#"")
		APT_Chat_AppendChunk($delta)

		var $jsResult : Variant
		WA EXECUTE JAVASCRIPT FUNCTION(*; "webArea"; "streamChunk"; $jsResult; $delta)
	End if
End if

// Marks the current form's conversation record as closed, if one is open

#DECLARE()

If (Form.conversationID#Null) && (Form.conversationID#"")
	var $conv : cs.ConversationEntity
	$conv:=ds.Conversation.query("conversationID = :1"; Form.conversationID).first()
	If ($conv#Null)
		$conv.closedAt:=String(Current date; "yyyy-MM-dd")+"T"+String(Current time; "HH:mm:ss")
		$conv.save()
	End if
End if

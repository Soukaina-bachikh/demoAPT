// Entry point for a user message coming from the native message input.
// Renders the user's bubble in the web area, then kicks off the AI reply.

#DECLARE($userMessage : Text)

var $jsResult : Variant
WA EXECUTE JAVASCRIPT FUNCTION(*; "webArea"; "addUserBubble"; $jsResult; $userMessage)

APT_Chat_ResetChunk
APT_Chat_Send($userMessage)

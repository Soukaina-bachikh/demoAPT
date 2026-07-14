// Closes the current conversation record (if any), starts a fresh one, and
// clears the message bubbles shown in the web area.

#DECLARE()

APT_Chat_CloseConversation
APT_Chat_StartConversation

var $jsResult : Variant
WA EXECUTE JAVASCRIPT FUNCTION(*; "webArea"; "resetMessages"; $jsResult)

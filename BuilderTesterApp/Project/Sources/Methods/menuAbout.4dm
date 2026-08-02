//%attributes = {}
#DECLARE($fromMenu : Boolean)

var $proc : Integer

If ($fromMenu)
	
	openAboutDialog
	
Else 
	
	$proc:=New process(Current method name; 0; "about"; True)
	
End if 

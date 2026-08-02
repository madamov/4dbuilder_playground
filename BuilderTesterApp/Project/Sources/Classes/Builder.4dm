Class constructor($options : Object)
	
	This._command:=$options.action
	This._projectName:=Folder("/PROJECT").files(fk ignore invisible).query("extension = :1"; ".4DProject").first().name
	
	
Function getProjectName()->$projectName : Text
	$projectName:=This._projectName
	
Function checkSyntax($checkSyntaxOptions)->$status : Object
	
	var $errorLog : 4D.File
	
	$checkSyntaxOptions.targets:=$checkSyntaxOptions.targets || New collection()
	
	$status:=Compile project($checkSyntaxOptions)
	
	$errorLog:=Folder(fk logs folder).file(This.getProjectName()+"_errors.xml")
	
	If ($errorLog.exists)
		
		$status.artifact:=$errorLog.getText()
		
	End if 
	
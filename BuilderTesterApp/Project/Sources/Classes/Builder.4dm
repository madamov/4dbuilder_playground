Class constructor($options : Object)
	
	This._command:=$options.action
	This._projectName:=Folder("/PROJECT").files(fk ignore invisible).query("extension = :1"; ".4DProject").first().name
	
	
Function getProjectName()->$projectName : Text
	$projectName:=This._projectName
	
Function checkSyntax($checkSyntaxOptions : Object; $exportErrorsTo : Text)->$status : Object
	
	var $errorLog : 4D.File
	var $fileStatus : Boolean
	
	$checkSyntaxOptions.targets:=$checkSyntaxOptions.targets || New collection()  // to chekc syntax, we pass empty colelction of targets
	
	$status:=Compile project($checkSyntaxOptions)
	
	// Compiler project doesn't creates error log XML file unlike when checking syntax through menus
	
	If (Not($status.success))
		
		If ($exportErrorsTo="")
			$errorLog:=Folder(fk logs folder).file(This.getProjectName()+"_errors.json")
		Else 
			$errorLog:=Folder($exportErrorsTo; fk platform path).file(This.getProjectName()+"_errors.json")
		End if 
		
		$fileStatus:=$errorLog.create()
		
		$fileStatus:=$errorLog.setText(JSON Stringify($status))
		
	End if 
	
	
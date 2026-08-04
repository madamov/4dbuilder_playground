Class constructor
	
	var $startupParam : Text  // JSON user parameters
	var $getDBParValue : Real
	
	This._projectName:=Folder("/PROJECT").files(fk ignore invisible).query("extension = :1"; ".4DProject").first().name
	This._inHeadless:=Get application info.headless
	If (This._inHeadless)
		LOG EVENT(Into system standard outputs; "running in headless mode\n")
		$getDBParValue:=Get database parameter(User param value; $startupParam)
		If ($startupParam#"")
			This._userParams:=JSON Parse($startupParam)
			If (This._userParams.errorFolderPath#Null) && (This._userParams.errorFolderPath#"")
				This._errorFolder:=Folder(This._userParams.errorFolderPath; fk posix path)
				LOG EVENT(Into system standard outputs; "custom error folder detected\n")
				LOG EVENT(Into system standard outputs; "Set to:"+This._errorFolder.platformPath+"\n")
			Else 
				This._errorFolder:=Folder(fk documents folder)
				LOG EVENT(Into system standard outputs; "error folder in documents\n")
			End if 
		End if 
	End if 
	
	
Function getProjectName() : Text
	return This._projectName
	
Function getErrorFolder() : 4D.Folder
	return This._errorFolder
	
Function checkSyntax($checkSyntaxOptions : Object; $exportErrorsTo : Text)->$status : Object
	
	var $errorLog : 4D.File
	var $fileStatus : Boolean
	
	$checkSyntaxOptions.targets:=$checkSyntaxOptions.targets || New collection()  // to check syntax, we pass empty colelction of targets
	
	LOG EVENT(Into system standard outputs; "checking syntax\n")
	
	$status:=Compile project($checkSyntaxOptions)
	
	// Compiler project doesn't create error log XML file unlike when checking syntax through menus
	// so we will dump resulting JSON if there is error
	
	If (Not($status.success))
		
		LOG EVENT(Into system standard outputs; "checking syntax FAILED\n")
		
	Else 
		
		LOG EVENT(Into system standard outputs; "checking syntax OK\n")
		
	End if 
	
	// always create log
	
	$errorLog:=This.getErrorFolder().file(This.getProjectName()+"_errors.json")
	
	$fileStatus:=$errorLog.create()
	$fileStatus:=$errorLog.setText(JSON Stringify($status))
	
Class constructor($quitInHeadless : Boolean)
	
	var $startupParam : Text  // JSON user parameters
	var $getDBParValue : Real
	
	This._projectName:=Folder("/PROJECT").files(fk ignore invisible).query("extension = :1"; ".4DProject").first().name
	This._inHeadless:=Get application info.headless
	If (This._inHeadless)
		LOG EVENT(Into system standard outputs; "running in headless mode\n")
		This._quitAfterHeadlessRun:=$quitInHeadless
		$getDBParValue:=Get database parameter(User param value; $startupParam)
		If ($startupParam#"")
			This._userParams:=JSON Parse($startupParam)
			If (This._userParams.errorFolderPath#Null) && (This._userParams.errorFolderPath#"")
				If (Is Windows)
					This._errorFolder:=Folder(This._userParams.errorFolderPath; fk platform path)
				Else 
					This._errorFolder:=Folder(This._userParams.errorFolderPath; fk posix path)
				End if 
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
	
	
Function getUserParams() : Object
	return This._userParams
	
	
Function run($whatToDo : Object) : Object
	
	var $status : Object
	$status:=New object
	$status.success:=False
	$status.msg:="No action requested"
	
	If ($whatToDo#Null) && ($whatToDo.action#Null)
		
		Case of 
				
			: ($whatToDo.action="checksyntax")
				
				$status:=This.checkSyntax()
				
			: ($whatToDo.action="compile")
				
				If (This._userParams.compilerOptions=Null)
					$status:=This.compile()
				Else 
					$status:=This.compile(This._userParams.compilerOptions)
				End if 
				
			: ($whatToDo.action="build")
				
				If (This._userParams.compilerOptions=Null)
					$status:=This.compile()
				Else 
					$status:=This.compile(This._userParams.compilerOptions)
				End if 
				
				If ($status.success)
					If ($whatToDo.buildSettingsPath#Null) && ($whatToDo.buildSettingsPath#"")
						LOG EVENT(Into system standard outputs; "using build settings XML file from run call (override of user params)\n")
						$status:=This.build($whatToDo.buildSettingsPath)
					Else 
						If ((This._userParams.buildSettingsPath#Null) && (This._userParams.buildSettingsPath#""))
							LOG EVENT(Into system standard outputs; "using user defined build settings XML file\n")
							$status:=This.build(This._userParams.buildSettingsPath)
						Else 
							LOG EVENT(Into system standard outputs; "using default build settings XML file in project Settings folder\n")
							$status:=This.build()
						End if 
					End if 
				End if 
				
		End case 
		
	End if 
	
	If (This._inHeadless && This._quitAfterHeadlessRun)
		QUIT 4D
	End if 
	
	return $status
	
	
Function checkSyntax()->$status : Object
	
	var $errorLog : 4D.File
	var $fileStatus : Boolean
	var $checkSyntaxOptions : Object
	
	$checkSyntaxOptions:=New object
	$checkSyntaxOptions.targets:=New collection()  // to check syntax, we pass empty collection of targets
	
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
	
	return $status
	
	
Function compile($compileOptions : Object) : Object
	
	var $status : Object
	
	If ($compileOptions=Null)
		
		LOG EVENT(Into system standard outputs; "using default compiler options\n")
		$compileOptions:=New object
		$compileOptions.targets:=New collection("x86_64_generic"; "arm64_macOS_lib")
		
	Else 
		
		LOG EVENT(Into system standard outputs; "using user defined compiler options\n")
		
	End if 
	
	$status:=Compile project($compileOptions)
	
	return $status
	
	
	
Function build($settingsPOSIXFilePath : Text) : Object
	
	var $status; $compileStatus : Object
	var $settingsFile : 4D.File
	
	LOG EVENT(Into system standard outputs; "build initiated\n")
	
	$status:=New object
	$status.success:=False
	$status.settingsFile:=$settingsPOSIXFilePath
	
	If ($settingsPOSIXFilePath#"")
		
		$settingsFile:=File($settingsPOSIXFilePath; fk posix path)
		
		If ($settingsFile.exists)
			$status.settingsFileEists:=True
			LOG EVENT(Into system standard outputs; "settings file present\n")
			BUILD APPLICATION($settingsFile.platformPath)
			
			If (OK=1)
				$status.success:=True
			Else 
				
			End if 
			
		End if 
		
	End if 
	
	return $status
	
//%attributes = {}
var $builder : cs.Builder
var $options; $status; $params : Object
var $inHeadless : Boolean
var $startupParam : Text  // JSON user parameters
var $errorFolder : 4D.Folder

$inHeadless:=Get application info.headless

$options:=New object
$options.action:="checksyntax"

$builder:=cs.Builder.new($options)

If ($inHeadless)
	
	LOG EVENT(Into system standard outputs; "in headless\n")
	
	$getDBParValue:=Get database parameter(User param value; $startupParam)
	
	If ($startupParam#"")
		
		LOG EVENT(Into system standard outputs; "user params detected\n")
		
		$params:=JSON Parse($startupParam)
		
		If ($params.errorFolderPath#Null) && ($params.errorFolderPath#"")
			
			LOG EVENT(Into system standard outputs; "custom error folder detected\n")
			
			$errorFolder:=Folder($params.errorFolderPath; fk posix path)
			
		Else 
			LOG EVENT(Into system standard outputs; "error folder in documents\n")
			
			
			$errorFolder:=Folder(fk documents folder)
			
		End if 
		
	End if 
	
Else 
	
	LOG EVENT(Into system standard outputs; "error folder next to data file\n")
	
	$errorFolder:=Folder(fk data folder)
	
End if 

$status:=$builder.checkSyntax(New object(); $errorFolder.platformPath)

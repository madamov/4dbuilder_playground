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
	
	$getDBParValue:=Get database parameter(User param value; $startupParam)
	
	If ($startupParam#"")
		
		$params:=JSON Parse($startupParam)
		
		If ($params.errorFolderPath#Null) && ($params.errorFolderPath#"")
			
			$errorFolder:=Folder($params.errorFolderPath; fk posix path)
			
		Else 
			
			$errorFolder:=Folder(fk documents folder)
			
		End if 
		
	End if 
	
Else 
	
	$errorFolder:=Folder(fk data folder)
	
End if 

$status:=$builder.checkSyntax(New object(); $errorFolder.platformPath)

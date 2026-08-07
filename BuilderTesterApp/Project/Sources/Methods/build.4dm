//%attributes = {}
var $builder : cs.Builder
var $options; $status : Object

$options:=New object
$options.action:="build"

// override setting path passed in user-params if running headless
$options.buildSettingsPath:="/Volumes/Radni/madamov/Documents_local/Dev/4D/BuilderTraining/buildApp.4DSettings"

$builder:=cs.Builder.new()

$status:=$builder.run($options)


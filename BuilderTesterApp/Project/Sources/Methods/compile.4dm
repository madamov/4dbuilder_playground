//%attributes = {}
var $builder : cs.Builder
var $options; $status : Object

$options:=New object
$options.action:="compile"

$builder:=cs.Builder.new()

$status:=$builder.run($options)


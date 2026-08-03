//%attributes = {}
var $builder : cs.Builder
var $options; $status : Object

$options:=New object
$options.action:="checksyntax"

$builder:=cs.Builder.new($options)

$status:=$builder.checkSyntax(New object())


//%attributes = {}
var $links : Collection
var $oneLink : Object
var $baseURL : Text

$baseURL:="https://product-download.4d.com/release/"

$links:=New collection

$oneLink:=New object
$oneLink.version:="20.8"
$oneLink.build:="101985"
$oneLink.os:="mac"
$oneLink.target:="arm64"
$links.push($oneLink)

$oneLink:=New object
$oneLink.version:="20.8"
$oneLink.build:="101985"
$oneLink.os:="mac"
$oneLink.target:="x86_64"
$links.push($oneLink)

$oneLink:=New object
$oneLink.version:="20.8"
$oneLink.build:="101985"
$oneLink.os:="win"
$oneLink.target:="x86_64"
$links.push($oneLink)

$oneLink:=New object
$oneLink.version:="21.1"
$oneLink.build:="100301"
$oneLink.os:="win"
$oneLink.target:="x86_64"
$links.push($oneLink)

$oneLink:=New object
$oneLink.version:="21.1"
$oneLink.build:="100301"
$oneLink.os:="mac"
$oneLink.target:="x86_64"
$links.push($oneLink)

$oneLink:=New object
$oneLink.version:="21.1"
$oneLink.build:="100301"
$oneLink.os:="mac"
$oneLink.target:="arm64"
$links.push($oneLink)

$oneLink:=New object
$oneLink.version:="20.8 HF3"
$oneLink.build:="hotfix"
$oneLink.os:="mac"
$oneLink.target:="arm64"
$links.push($oneLink)

$oneLink:=New object
$oneLink.version:="20.8 HF3"
$oneLink.build:="hotfix"
$oneLink.os:="mac"
$oneLink.target:="x86_64"
$links.push($oneLink)

$oneLink:=New object
$oneLink.version:="20.8 HF3"
$oneLink.build:="hotfix"
$oneLink.os:="win"
$oneLink.target:="x86_64"
$links.push($oneLink)

SET TEXT TO PASTEBOARD(JSON Stringify($links))

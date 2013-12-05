[CmdletBinding()]
param(
	[string] $environmentConfigurationFilePath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "deployment_configuration.xml" ),
	[string] $productConfigurationFilePath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "configuration.xml" )
)

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Import-Module $scriptPath\PowershellModules\CommonDeploy.psm1 -Force

$rootPath = Split-Path -parent $scriptPath

$e = $environmentConfiguration = Read-ConfigurationTokens $environmentConfigurationFilePath
$p = $productConfiguration = Get-Configuration $environmentConfigurationFilePath $productConfigurationFilePath

Write-Host "Updating configuration at $rootPath using $environmentConfigurationFilePath"

Update-XmlConfig `
	-xmlFile $servicePath\Configuration\riakConfig.config `
	-xPath "/riakConfig/nodes/node[@name='riak']" `
	-attributeName "hostAddress" `
	-value $e.Riak.HostAddress

Update-XmlConfig `
	-xmlFile $servicePath\Configuration\tracing.config `
	-xPath "/system.diagnostics/sharedListeners/add[@name='IdentityModelListener']" `
	-attributeName "initializeData" `
	-value "$$(e.Tracing.LogPath)\systemIdentityModel.svclog"

Update-XmlConfig `
	-xmlFile $servicePath\Configuration\tracing.config `
	-xPath "/system.diagnostics/sharedListeners/add[@name='ServiceModelMessageLoggingListener']" `
	-attributeName "initializeData" `
	-value "$$(e.Tracing.LogPath)\wcfMessages.svclog"

Update-XmlConfig `
	-xmlFile $servicePath\Configuration\tracing.config `
	-xPath "/system.diagnostics/sharedListeners/add[@name='ServiceModelTraceListener']" `
	-attributeName "initializeData" `
	-value "$$(e.Tracing.LogPath)\wcfTrace.svclog"

Update-XmlConfig `
	-xmlFile $servicePath\Configuration\tracing.config `
	-xPath "/system.diagnostics/sharedListeners/add[@name='ThinktectureListener']" `
	-attributeName "initializeData" `
	-value "$$(e.Tracing.LogPath)\thinktectureIdentityServer.svclog"
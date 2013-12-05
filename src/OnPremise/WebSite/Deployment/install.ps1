﻿[CmdletBinding()]
param(
	[string] $environmentConfigurationFilePath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "deployment_configuration.xml" ),
	[string] $productConfigurationFilePath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "configuration.xml" )
)

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Import-Module $scriptPath\PowershellModules\CommonDeploy.psm1 -Force

$rootPath = Split-Path -parent $scriptPath

#Ensure that certificate has been extracted from config
#Install certificate if required
#Add user permissions to certificate

# Setup the configuration
$updateConfiguration = Join-Path $scriptPath "UpdateConfiguration.ps1"
if(Test-Path $updateConfiguration) {
	&$updateConfiguration $environmentConfigurationFilePath $productConfigurationFilePath
}

Install-All `
	-rootPath $rootPath `
	-environmentConfigurationFilePath $environmentConfigurationFilePath `
	-productConfigurationFilePath $productConfigurationFilePath

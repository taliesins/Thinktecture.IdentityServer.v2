[CmdletBinding()]
param(
	[string] $environmentConfigurationFilePath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "deployment_configuration.json" ),
	[string] $productConfigurationFilePath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) "configuration.xml" )
)

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Import-Module $scriptPath\PowershellModules\CommonDeploy.psm1 -Force

$rootPath = Split-Path -parent $scriptPath

#Ensure that certificate has been extracted from config

$httpsCertificate = $environmentConfigurationFilePath.Certificates | ?{$_.Name == "HttpsCertificate"} | %{$_.Certificate}
$httpsCertificatePassword = $environmentConfigurationFilePath.Certificates | ?{$_.Name == "HttpsCertificate"} | %{$_.Password}
$tokenCertificate = $environmentConfigurationFilePath.Certificates | ?{$_.Name == "TokenCertificate"} | %{$_.Certificate}
$tokenCertificatePassword = $environmentConfigurationFilePath.Certificates | ?{$_.Name == "TokenCertificate"} | %{$_.Password}

#Install certificate if required

#Add user permissions to certificate

# security access needs to be unlocked
%windir%\system32\inetsrv\appcmd.exe unlock -section:system.webServer/security/access

# Setup the configuration
$updateConfiguration = Join-Path $scriptPath "UpdateConfiguration.ps1"
if(Test-Path $updateConfiguration) {
	&$updateConfiguration $environmentConfigurationFilePath $productConfigurationFilePath
}

Install-All `
	-rootPath $rootPath `
	-environmentConfigurationFilePath $environmentConfigurationFilePath `
	-productConfigurationFilePath $productConfigurationFilePath

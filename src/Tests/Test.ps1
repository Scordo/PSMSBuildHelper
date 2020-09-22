Import-Module (Join-Path $PSScriptRoot '..\PSMSBuildHelper\PSMSBuildHelper.psd1') -Force

Write-Host "Simple Test:"

Get-EvaluatedMSBuildProperty    -ProjectFilePath (Join-Path $PSScriptRoot 'TestMSBuildFile1.proj') `
                                -PropertyName 'FullVersion', 'Version' `
                                -Properties @{ MajorVersion='2' } 
# Make sure all errors will stop the module logic
$ErrorActionPreference = 'Stop'

# Make sure missing Properties or Variables are not treated as $null
Set-StrictMode -Version Latest

Set-Variable -name Const_VSWhereExecutablePath -value (Join-Path $PSScriptRoot "vswhere.exe") -option Constant
Set-Variable -name MSBuildExecutable -value ([string] $null) -Option AllScope

#region Internal Module Functions

function Invoke-MSBuild {
  [CmdletBinding()]
	param
	(
    [Parameter(Mandatory=$true)]
    [string]
    $ProjectFilePath,

    [Parameter(Mandatory=$true)]
    [string]
    $MSBuildExecutablePath,

    [Parameter(Mandatory=$false)]
    [string]
    $TargetName,

    [Parameter(Mandatory=$false)]
    [System.Collections.Generic.Dictionary[[string], [string]]]
    $Properties = (New-Object 'system.collections.generic.dictionary[[string],[string]]')
  )

  $propertyArguments = @($Properties.GetEnumerator() | %{ "/p:$($_.Key)=`"$($_.Value)`"" })

  $arguments = @(
    '-verbosity:minimal',
    '-nologo',
    '-interactive:False'
  )

  if ($TargetName) {
    $arguments += "-target:$TargetName"
  }

  $arguments += $propertyArguments + "`"$ProjectFilePath`""
  $msBuildOutput = & $MSBuildExecutablePath $arguments

  if ($LASTEXITCODE -ne 0) {
    $message = "MSBuild failed with exit code $LASTEXITCODE. Output: `n$($msBuildOutput -join '`n')"
    Write-Error $message
  }

  return @($msBuildOutput)
}

function Get-PropertyFromMSBuildResultLine {
  [CmdletBinding()]
	param
	(
    [Parameter(Mandatory=$true)]
    [string]
    $Line
  )

  $nameAndValue = $Line.Split('|');
  $propertyName = ConvertFrom-Base64Utf8String -Base64String $nameAndValue[0]

  if ($nameAndValue[1]) {
    $propertyValue = ConvertFrom-Base64Utf8String -Base64String $nameAndValue[1]    
  } else {
    $propertyValue = ''
  }
  
  return [System.Collections.Generic.KeyValuePair[[string], [string]]]::new($propertyName, $propertyValue)
}

function ConvertFrom-Base64Utf8String {
  [CmdletBinding()]
	param
	(
    [Parameter(Mandatory=$true)]
    [string]
    $Base64String
  )

  return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Base64String))
}

function ConvertTo-Base64Utf8String {
  [CmdletBinding()]
	param
	(
    [Parameter(Mandatory=$true)]
    [string]
    $Text
  )
  
  return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Text))
}

#endregion

#region Exported Module Functions

<#
.SYNOPSIS

Gets the path to the latest msbuild executable.

.DESCRIPTION

Uses vswhere under the covers to find the path to the latest msbuild executable.

.OUTPUTS

System.String. The path to the latest msbuidl executable

.EXAMPLE

PS> Get-LatestMSBuildExecutablePath
C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe

#>
function Get-LatestMSBuildExecutablePath {
    [OutputType([String])] 
    param(

    )
    
    # if the path has been determined, dont do it again!
    if ($Script:MSBuildExecutable){
      return $Script:MSBuildExecutable
    }

    $vsWhereOutput = (& $Const_VSWhereExecutablePath -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe).Trim()

    if ([string]::IsNullOrWhiteSpace($vsWhereOutput)){
      throw "MSBuild was not found"
    }

    $msBuildExecutablePath = ($vsWhereOutput -split "`n" | Select -First 1).Trim()

    if (!(Test-Path $msBuildExecutablePath)){
        throw "MSBuild path `"$($msBuildExecutablePath)`" does not exist"
    }

    return ($Script:MSBuildExecutable = $msBuildExecutablePath)
}

<#
.SYNOPSIS
Evaluates MSBuild properties in a provided msbuild script file.

.DESCRIPTION
This function can evaluate MSBuild properties in a provided msbuild script file.

You must:
- pass a path to an msbuild script file for which properties should be evaluated (ProjectFilePath)
- pass one ore multiple property-names to evaluate (PropertyName)

You can:
- provide the path to msbuild.exe yourself or let the function use the latest version (MSBuildExecutablePath)
- provide properties with values to pass to the msbuild script for initialization purposes (Properties)
- configure the output to only the valaues of the evaluated properties instead of a hashtable (OnlyValues)

.PARAMETER ProjectFilePath
Specifies the path to the msbuild project file 

.PARAMETER PropertyName
Specifies one ore multiple properties to evaluate

.PARAMETER MSBuildExecutablePath
Specifies an optional the path to msbuild.exe. If not provided, the function uses the latest version on the system

.PARAMETER Properties
Specifies an optional hashtable containing properties with values used to initialize other properties of the msbuild project file

.PARAMETER OnlyValues
Switches the standard output from hashtable (property names and values) to an array of strings (only property values)

.INPUTS
None. You cannot pipe objects to Get-EvaluatedMSBuildProperty

.OUTPUTS
hashtable. if no "OnlyValues" switch is used.
System.String. If "OnlyValues" switch is used.

.EXAMPLE
PS> Get-EvaluatedMSBuildProperty -ProjectFilePath C:\myproject\myproject.csproj -PropertyName AssemblyName
Evaluates the property 'AssemblyName' of msbuild script ' C:\myproject\myproject.csproj'

.EXAMPLE
PS> Get-EvaluatedMSBuildProperty -ProjectFilePath C:\myproject\myproject.csproj -PropertyName AssemblyName, RootNamespace
Evaluates the properties 'AssemblyName' and 'RootNamespace' of msbuild script ' C:\myproject\myproject.csproj'

PS> Get-EvaluatedMSBuildProperty -ProjectFilePath C:\myproject\myproject.csproj -PropertyName AssemblyName, RootNamespace -OnlyValues
Evaluates the properties 'AssemblyName' and 'RootNamespace' of msbuild script ' C:\myproject\myproject.csproj' and returns the property values as a string array instead of a hashtable

.EXAMPLE
PS> Get-EvaluatedMSBuildProperty -ProjectFilePath C:\myproject\myproject.csproj -PropertyName AssemblyName -MSBuildExecutablePath 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe'
Evaluates the property 'AssemblyName' of msbuild script ' C:\myproject\myproject.csproj' using msbuild.exe from 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe'

.EXAMPLE
PS> Get-EvaluatedMSBuildProperty -ProjectFilePath C:\myproject\myproject.csproj -PropertyName Version -Properties @{ 'MajorVersion'='5', 'MinorVersion'='2' }
Evaluates the property 'Version' of msbuild script ' C:\myproject\myproject.csproj' by initializing the properties 'MajorVersion' with value '5' and 'MinorVersion' with value '2'. If the Version property is a calculated property like '$(MajorVersion).$(MinorVersion)' the result woul be '5.2'

#>
function Get-EvaluatedMSBuildProperty {
  [CmdletBinding()]
	param
	(
    [Parameter(Mandatory=$true)]
    [string]
    $ProjectFilePath,

    [Parameter(Mandatory=$true)]
    [string[]]
    $PropertyName,

    [Parameter(Mandatory=$false)]
    [string]
    $MSBuildExecutablePath = (Get-LatestMSBuildExecutablePath),

    [Parameter(Mandatory=$false)]
    [hashtable]
    $Properties = [hashtable]::new(),

    [Switch]
    $OnlyValues
  )

  [system.collections.generic.dictionary[[string],[string]]] $msbuildProperties = [system.collections.generic.dictionary[[string],[string]]]::new()
  $msbuildProperties['ProjectFilePath'] = $ProjectFilePath
  $msbuildProperties['PropertiesToInitialize'] = ($Properties.GetEnumerator() | %{ "$(ConvertTo-Base64Utf8String -Text $_.Key)|$(ConvertTo-Base64Utf8String -Text $_.Value)" }) -join ';'
  $msbuildProperties['PropertiesToEvaluate'] = ($PropertyName | %{ ConvertTo-Base64Utf8String -Text $_ }) -join ';'
  
  $msbuildResultLines = Invoke-MSBuild  -ProjectFilePath (Join-Path $PSScriptRoot 'PSMSBuildHelper.proj') `
                                        -TargetName 'PSMSBuildHelper_EvaluateProperties' `
                                        -MSBuildExecutablePath $MSBuildExecutablePath `
                                        -Properties $msbuildProperties

  [system.collections.generic.dictionary[[string],[string]]] $evaluatedProperties = [system.collections.generic.dictionary[[string],[string]]]::new()
  $msbuildResultLines | ? { $_ } | %{
    $property = Get-PropertyFromMSBuildResultLine -Line $_

    $evaluatedProperties[$property.Key] = $property.Value
  }

  if ($OnlyValues) {
    return $PropertyName | % { $evaluatedProperties[$_] }
  }

  return [hashtable]::new($evaluatedProperties)
}

#endregion

#region Exports

Export-ModuleMember -Function Get-EvaluatedMSBuildProperty, Get-LatestMSBuildExecutablePath

#endregion
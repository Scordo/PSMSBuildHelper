@{

    # Die diesem Manifest zugeordnete Skript- oder Binärmoduldatei.
    RootModule = 'PSMSBuildHelper.psm1'

    # Die Versionsnummer dieses Moduls
    ModuleVersion = '0.1'

    # Unterstützte PSEditions
    CompatiblePSEditions = @('Desktop')

    # ID zur eindeutigen Kennzeichnung dieses Moduls
    GUID = '2f314b7e-fc75-4447-805a-85b42068b0b6'

    # Autor dieses Moduls
    Author = 'Jens Hofmann'

    # Company or vendor of this module
    CompanyName = 'DotNetExpert'

    # Urheberrechtserklärung für dieses Modul
    Copyright = '(c) Jens Hofmann'

    # Beschreibung der von diesem Modul bereitgestellten Funktionen
    Description = 'Powershell Module containing MSBuild helper functions.'

    # Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Moduls
    PowerShellVersion = '5.1'

    # Aus diesem Modul zu exportierende Funktionen. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Funktionen vorhanden sind.
    FunctionsToExport = '*'

    # Aus diesem Modul zu exportierende Cmdlets. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Cmdlets vorhanden sind.
    CmdletsToExport = @()

    # Die aus diesem Modul zu exportierenden Variablen
    VariablesToExport = '*'

    # Aus diesem Modul zu exportierende Aliase. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Aliase vorhanden sind.
    AliasesToExport = @()

    # Die für dieses Modul mindestens erforderliche Microsoft .NET Framework-Version. Diese erforderliche Komponente ist nur für die PowerShell Desktop-Edition gültig.
    # DotNetFrameworkVersion = ''

    # Die Module, die vor dem Importieren dieses Moduls in die globale Umgebung geladen werden müssen
    # RequiredModules = @()

    # Die Assemblys, die vor dem Importieren dieses Moduls geladen werden müssen
    # RequiredAssemblies = @()

    # Die Skriptdateien (PS1-Dateien), die vor dem Importieren dieses Moduls in der Umgebung des Aufrufers ausgeführt werden.
    #ScriptsToProcess = @('')

    # Die Typdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
    # TypesToProcess = @()

    # Die Formatdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
    # FormatsToProcess = @()

    # Die Module, die als geschachtelte Module des in "RootModule/ModuleToProcess" angegebenen Moduls importiert werden sollen.
    # NestedModules = @()

    # Aus diesem Modul zu exportierende DSC-Ressourcen
    # DscResourcesToExport = @()

    # Liste aller Module in diesem Modulpaket
    # ModuleList = @()

    # Liste aller Dateien in diesem Modulpaket
    # FileList = @()

    # Die privaten Daten, die an das in "RootModule/ModuleToProcess" angegebene Modul übergeben werden sollen. Diese können auch eine PSData-Hashtabelle mit zusätzlichen von PowerShell verwendeten Modulmetadaten enthalten.
    PrivateData = @{

        PSData = @{

            # 'Tags' wurde auf das Modul angewendet und unterstützt die Modulermittlung in Onlinekatalogen.
            # Tags = @('PowerShell', 'MSBuild')

            # Eine URL zur Lizenz für dieses Modul.
            # LicenseUri = 'https://github.com/Scordo/PSMSBuildHelper/blob/master/LICENSE'

            # Eine URL zur Hauptwebsite für dieses Projekt.
            # ProjectUri = 'https://github.com/Scordo/PSMSBuildHelper'

            # Eine URL zu einem Symbol, das das Modul darstellt.
            # IconUri = ''

            # 'ReleaseNotes' des Moduls
            # ReleaseNotes = 'First public release'

        } # Ende der PSData-Hashtabelle

    } # Ende der PrivateData-Hashtabelle

    # HelpInfo-URI dieses Moduls
    # HelpInfoURI = ''

    # Standardpräfix für Befehle, die aus diesem Modul exportiert werden. Das Standardpräfix kann mit "Import-Module -Prefix" überschrieben werden.
    # DefaultCommandPrefix = ''

    }
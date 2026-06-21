$Host.UI.RawUI.WindowTitle = "Active Directory Tool"
function Show-Menu {
    Clear-Host
    Write-Host "==================== Active Directory Tool ====================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Verify Current Domain and Server Configuration "
    Write-Host "2. Perform Domain Health Check "
    Write-Host "3. Verify Permissions "
    Write-Host "4. Perform Systems Dependency Check on Domain Controller "
    Write-Host "5. Perform Domain Routing and Verification Check "    
    Write-Host "6. Perform System Backup "
    Write-Host "7. Schema Preparation"
    Write-Host "Q. Quit Tool"
    Write-Host ""
    Write-Host "=============== Created by vbdianco@gmail.com ================" -ForegroundColor Cyan
    Write-Host ""
}

do {
    Show-Menu
    $selection = Read-Host "Please select an option"

    switch ($selection) {
        '1' {
            Clear-Host
            Write-Host "Getting Domain Details:" -ForegroundColor Cyan
                Get-ADDomain
            Write-Host "Getting Forest Configuration:" -ForegroundColor Cyan
                Get-ADForest
            Write-Host "Getting Current Domain Controllers and Roles:" -ForegroundColor Cyan
                (Get-ADDomain).PDCEmulator
                (Get-ADDomain).RIDMaster
                (Get-ADDomain).InfrastructureMaster
                (Get-ADForest).SchemaMaster
                (Get-ADForest).DomainNamingMaster
            Write-Host "Viewing RootDSE:" -ForegroundColor Cyan
                Get-ADRootDSE
        }
        '2' {
            Clear-Host
            Write-Host "Getting Schema Version:" -ForegroundColor Cyan
                Get-ADRootDSE | Select-Object ObjectVersion
            Write-Host "Performing Domain Controller Diagnostic:" -ForegroundColor Cyan
                dcdiag /c /v | Select-String "failed"
            Write-Host "Performing Replication Status Check:" -ForegroundColor Cyan
                repadmin /replsummary
            Write-Host "Performing Vital Service Status Auditing:" -ForegroundColor Cyan
                $services = 'DNS', 'NTDS', 'NetLogon', 'kdc', 'DFS Replication' 
                Get-Service -Name $services | Select-Object Name, Status, DisplayName
            Write-Host "Performing Folder Validation:" -ForegroundColor Cyan
                Get-ADObject
        }
        '3' {
            Clear-Host
            Write-Host "Getting Direct Access Control List:" -ForegroundColor Cyan
                $OUPath = "AD:OU=Finance,OU=Departments,DC=domain,DC=local" 
                Get-Acl -Path $OUPath | Select-Object -ExpandProperty Access | Where-Object { $_.IsInherited -eq $false } | Select-Object @{Name="Object";Expression={$OUPath}}, IdentityReference, ActiveDirectoryRights, AccessControlType | Export-Csv -Path "C:\Direct_OU_Permissions.csv" -NoTypeInformation
        }
        '4' {
            Clear-Host
            Write-Host "Identifying LDAP-Bound Apps:" -ForegroundColor Cyan
                Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 -Property Name, CPU, Id
            Write-Host "Getting Lists of Applications via SPN:" -ForegroundColor Cyan
                Get-ADObject -Filter "servicePrincipalName -like '*'" -Properties servicePrincipalName | Select-Object Name, ObjectClass, @{Name="ConnectedApps"; Expression={$_.servicePrincipalName}} | Format-List
            Write-Host "Getting Lists of Connected Federation Apps:" -ForegroundColor Cyan
                Import-Module ADFS
                Get-AdfsRelyingPartyTrust | Select-Object Name, Identifier, Enabled
            Write-Host "Getting Lists of Integrated Apps in AD LDS:" -ForegroundColor Cyan
                Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 -Property Name, CPU, Id

        }
        '5' {
            Clear-Host
            Write-Host "Verify UPN Suffixes in the Forest:" -ForegroundColor Cyan
                Get-ADForest | Select-Object -ExpandProperty AlternativeUpnSuffixes
            Write-Host "Verify Users with Non-Routable UPNs:" -ForegroundColor Cyan
                Get-ADUser -Filter * -Properties UserPrincipalName | Where-Object { $_.UserPrincipalName -like "*.local" -or $_.UserPrincipalName -like "*.internal" } | Select-Object Name, UserPrincipalName
            Write-Host "Verify Azure Endpoint  Connectivity:" -ForegroundColor Cyan
                $Endpoints = @("://microsoftonline.com", "://microsoftonline.com", "://microsoftonline.com") 
                foreach ($Server in $Endpoints) { 
                    $Test = Test-NetConnection -ComputerName $Server -Port 443 
                    [PSCustomObject]@{ 
                        Endpoint = $Server 
                        DNS_Match = $Test.NameResolutionSucceeded 
                        Port_443 = $Test.TcpTestSucceeded 
                    } 
                }
        }
        '6' {
            Clear-Host
            Write-Host "Perform System Backup:" -ForegroundColor Cyan
                $BackupTarget = "E:"
                $Policy = New-WBPolicy

                Add-WBSystemState -Policy $Policy

                $TargetLocation = New-WBBackupTarget -VolumePath $BackupTarget
                Add-WBBackupTarget -Policy $Policy -Target $TargetLocation

                Start-WBBackup -Policy $Policy
        }
        '7' {
            Clear-Host
            Write-Host "Perform Forest Preparation:" -ForegroundColor Cyan
                adprep.exe /forestprep
            Write-Host "Perform Domain Preparation:" -ForegroundColor Cyan
                adprep.exe /domainprep
        }
        'q' {
            Clear-Host
            Write-Host "Exiting tool. Goodbye!" -ForegroundColor Cyan
            $Host.UI.RawUI.WindowTitle = "PowerShell"
            Exit
        }
        Default {
            Write-Host "Invalid choice! Please select 1,2,3... or Q" -ForegroundColor Cyan
        }
    }
    Write-Host ""
    Read-Host "Please Enter to return to menu"

} until ($selection -eq 'q')
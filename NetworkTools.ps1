$Host.UI.RawUI.WindowTitle = "Active Directory Tool"
function Show-Menu {
    Clear-Host
    Write-Host "==================== Windows Networking Tool ====================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Show Full IP Configuration "
    Write-Host "2. Ping Google "
    Write-Host "3. Flush DNS Cache "
    Write-Host "4. Release IP Address "
    Write-Host "5. Renew IP Address "    
    Write-Host "6. Reset Winsock "
    Write-Host "7. Reset TCP/IP Stack"
    Write-Host "8. Open Network Connections"
    Write-Host "9. Open Wifi Settings"
    Write-Host "10. Open Device Manager"
    Write-Host "11. Open Network Troubleshooter"
    Write-Host "12. Speed Test Ping"
    Write-Host "13. Restart Explorer"
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
            Write-Host "Getting IP Address Details:" -ForegroundColor Cyan
                ipconfig /all
        }
        '2' {
            Clear-Host
            Write-Host "Ping Google.com:" -ForegroundColor Cyan
                ping google.com
        }
        '3' {
            Clear-Host
            Write-Host "Removing DNS Cache:" -ForegroundColor Cyan
                ipconfig /flushdns
        }
        '4' {
            Clear-Host
            Write-Host "Releasing IP Address:" -ForegroundColor Cyan
                ipconfig /release
        }
        '5' {
            Clear-Host
            Write-Host "Renew IP Address:" -ForegroundColor Cyan
                ipconfig /renew
        }
        '6' {
            Clear-Host
            Write-Host "Resetting Winsock:" -ForegroundColor Cyan
                netsh winsock reset
        }
        '7' {
            Clear-Host
            Write-Host "resetting TCP/IP Stack:" -ForegroundColor Cyan
                netsh int ip reset
        }
        '8' {
            Clear-Host
            Write-Host "Opening Network Connections:" -ForegroundColor Cyan
                control ncpa.cpl
        }
        '9' {
            Clear-Host
            Write-Host "Opening Wifi Settings:" -ForegroundColor Cyan
                control ms-settings:network-wifi
        }
        '10' {
            Clear-Host
            Write-Host "Opening Device Manager:" -ForegroundColor Cyan
                devmgmt.msc
        }
        '11' {
            Clear-Host
            Write-Host "Opening Network Troubleshooter:" -ForegroundColor Cyan
                msdt.exe /id NetworkDiagnosticsNetworkAdapter
        }
        '12' {
            Clear-Host
            Write-Host "Ping 8.8.8.8:" -ForegroundColor Cyan
                ping 8.8.8.8
        }
        '13' {
            Clear-Host
            Write-Host "Restarting Explorer:" -ForegroundColor Cyan
                taskkill.exe /f /im explorer.exe & Start-Process explorer.exe
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
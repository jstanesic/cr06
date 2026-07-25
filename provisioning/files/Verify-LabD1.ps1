#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$ok = $true

# 1 — The Private firewall profile must enforce DefaultInboundAction: Block
try {
    $private = Get-NetFirewallProfile -Profile Private | Select-Object DefaultInboundAction
    if ($private.DefaultInboundAction -eq 'Block') {
        Write-Host '[PASS] Private firewall profile enforces DefaultInboundAction: Block'
    } else {
        Write-Host "[FAIL] Private profile DefaultInboundAction: $($private.DefaultInboundAction)"
        $ok = $false
    }
} catch {
    Write-Host "[FAIL] Cannot check Private firewall profile: $_"
    $ok = $false
}

# 2 — The Sysmon64 service must be installed and running
try {
    $sysmon = Get-Service -Name 'Sysmon64' -ErrorAction Stop
    if ($sysmon.Status -eq 'Running') {
        Write-Host '[PASS] Sysmon64 service is installed and running'
    } else {
        Write-Host "[FAIL] Sysmon64 service status: $($sysmon.Status)"
        $ok = $false
    }
} catch {
    Write-Host '[FAIL] Sysmon64 service is not installed'
    $ok = $false
}

if ($ok) {
    Write-Host ''
    Write-Host 'Passkey: detection-verified'
}

#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$ok = $true

# 1 — All three Windows Defender Firewall profiles must enforce DefaultInboundAction: Block
try {
    $profiles = Get-NetFirewallProfile | Select-Object Name, DefaultInboundAction
    $notBlocked = $profiles | Where-Object { $_.DefaultInboundAction -ne 'Block' }
    if (-not $notBlocked) {
        Write-Host '[PASS] All firewall profiles enforce DefaultInboundAction: Block'
    } else {
        Write-Host "[FAIL] Profiles not enforcing Block: $($notBlocked.Name -join ', ')"
        $ok = $false
    }
} catch {
    Write-Host "[FAIL] Cannot check firewall profiles: $_"
    $ok = $false
}

# 2 — The built-in Guest account must be disabled
try {
    $guest = Get-LocalUser -Name 'Guest'
    if (-not $guest.Enabled) {
        Write-Host '[PASS] Guest account is disabled'
    } else {
        Write-Host '[FAIL] Guest account is still enabled'
        $ok = $false
    }
} catch {
    Write-Host "[FAIL] Cannot check Guest account: $_"
    $ok = $false
}

if ($ok) {
    Write-Host ''
    Write-Host 'Passkey: workstation-hardened'
}

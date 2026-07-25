#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$ok = $true

# 1 — SMB Signing must be required
try {
    $smb = Get-SmbServerConfiguration | Select-Object RequireSecuritySignature
    if ($smb.RequireSecuritySignature) {
        Write-Host '[PASS] SMB Signing is required (RequireSecuritySignature: True)'
    } else {
        Write-Host '[FAIL] RequireSecuritySignature is False'
        $ok = $false
    }
} catch {
    Write-Host "[FAIL] Cannot check SMB server configuration: $_"
    $ok = $false
}

# 2 — Domain and Private firewall profiles must enforce DefaultInboundAction: Block
try {
    $profiles = Get-NetFirewallProfile -Profile Domain, Private | Select-Object Name, DefaultInboundAction
    $notBlocked = $profiles | Where-Object { $_.DefaultInboundAction -ne 'Block' }
    if (-not $notBlocked) {
        Write-Host '[PASS] Domain and Private firewall profiles enforce DefaultInboundAction: Block'
    } else {
        Write-Host "[FAIL] Profiles not enforcing Block: $($notBlocked.Name -join ', ')"
        $ok = $false
    }
} catch {
    Write-Host "[FAIL] Cannot check firewall profiles: $_"
    $ok = $false
}

if ($ok) {
    Write-Host ''
    Write-Host 'Passkey: server-hardened'
}

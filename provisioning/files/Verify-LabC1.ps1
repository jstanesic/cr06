#Requires -Version 5.1
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory -ErrorAction SilentlyContinue

$ok = $true

# 1 — Domain minimum password length must be 14 characters or more
try {
    $policy = Get-ADDefaultDomainPasswordPolicy
    if ($policy.MinPasswordLength -ge 14) {
        Write-Host "[PASS] MinPasswordLength is $($policy.MinPasswordLength) (>= 14)"
    } else {
        Write-Host "[FAIL] MinPasswordLength is $($policy.MinPasswordLength) (< 14)"
        $ok = $false
    }
} catch {
    Write-Host "[FAIL] Cannot check domain password policy: $_"
    $ok = $false
}

# 2 — Administrator must be a member of Protected Users
try {
    $members = Get-ADGroupMember -Identity 'Protected Users' | Select-Object -ExpandProperty SamAccountName
    if ($members -contains 'Administrator') {
        Write-Host '[PASS] Administrator is a member of Protected Users'
    } else {
        Write-Host '[FAIL] Administrator is not a member of Protected Users'
        $ok = $false
    }
} catch {
    Write-Host "[FAIL] Cannot check Protected Users membership: $_"
    $ok = $false
}

if ($ok) {
    Write-Host ''
    Write-Host 'Passkey: ad-hardened'
}

param (
[string]$nom,
[string]$prenom
)
if (-not $nom) {
$nom = Read-Host "nom="
$prenom = Read-Host "prenom="
} else {
$nom
$prenom
}
if ([string]::IsNullOrEmpty($prenom)) {
$filter = "Name -like '*$nom*'"
} else {
# filtre utilisant nom et prenom
$filter = "Name -like '*$prenom*' -and Name -like '*$nom*'"
}
Get-ADUser -Filter $filter -Properties SamAccountName, MemberOf, Description, mail, Manager | ForEach-Object {
    Write-Host "# Name :"
    Write-Host "$($_.Name)"

    Write-Host "# Description :"
    Write-Host "$($_.Description)"

    Write-Host "# Login :"
    Write-Host "$($_.SamAccountName)"

    Write-Host "# Mail :"
    Write-Host "$($_.mail)"

        Write-Host "# Responsable :"
    $managerDN = $_.Manager
        if ($managerDN) {
                $manager = Get-ADUser -Identity $managerDN -Properties mail
                $managerEmail = $manager.mail -replace 'CN=.*?,', '' -replace ',.*', ''
                Write-Host $($manager.Name)
                Write-Host $managerEmail
    }
    Write-Host "# MemberOf :"
    $_.MemberOf | Sort-Object | ForEach-Object {
        $value = $_ -replace 'CN=', '' -replace ',.*', ''
        Write-Host "$value"
    }
}

$certificate = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "*.{dnsSuffix}","*.scm.{dnsSuffix}"

$certThumbprint = "cert:\localMachine\my\" + $certificate.Thumbprint
$password = ConvertTo-SecureString -String "{pfxPassword}" -Force -AsPlainText

$fileName = "{pfxLocalFilename}.pfx"
Export-PfxCertificate -cert $certThumbprint -FilePath $fileName -Password $password     

$fileContentBytes = get-content -encoding byte $fileName
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)
$fileContentEncoded | set-content ($fileName + ".b64")
Write-Host "Thumbprint"
$certificate.Thumbprint
Write-Host "b64"
$fileContentEncoded
# version for org wide token
param (
    [string]$folder,
    [string]$pat,
    [string]$org,
    [string]$windowsLogonAccount,
    [string]$windowsLogonPassword,
    [string]$workFolder
)

Set-Location $folder
$headers = @{
    Accept                 = "application/vnd.github+json"
    Authorization          = "Bearer $pat"
    "X-GitHub-Api-Version" = "2022-11-28"
}
$regTokenUrl = "https://api.github.com/orgs/$($org)/actions/runners/registration-token"
$r = Invoke-RestMethod -Method Post -Uri $regTokenUrl -Headers $headers
$token = $r.token
$r.token
$currentDateTime = Get-Date
$runnerName = $currentDateTime.ToString("yyyyMMdd-HHmmss")
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-win-x64-2.321.0.zip -OutFile actions-runner-win-x64-2.321.0.zip -Verbose
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.321.0.zip", "$PWD")
.\config.cmd --url https://github.com/$org --token $token --runasservice --windowslogonaccount $windowsLogonAccount --windowslogonpassword $windowsLogonPassword --name $runnerName --work $workFolder --unattended
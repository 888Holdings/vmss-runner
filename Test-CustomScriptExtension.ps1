param (
    [string]$org,
    [string]$folder,
    [string]$pat    
)

Start-Transcript -Path "$env:SystemRoot\Temp\PowerShell_transcript.$($env:COMPUTERNAME).$(Get-Date ((Get-Date).ToUniversalTime()) -f yyyyMMddHHmmss).txt" -IncludeInvocationHeader
Set-PSDebug -Trace 2
Write-Output "Write-Output output from 888: $($MyInvocation.MyCommand.Name)"
New-Item -Path $folder -Type Directory
Set-Location $folder
Write-Output "$($pat)"
Write-Output "$($folder)"
$headers = @{
    Accept                 = "application/vnd.github+json"
    Authorization          = "Bearer $pat"
    "X-GitHub-Api-Version" = "2022-11-28"
}
$regTokenUrl = "https://api.github.com/orgs/$($org)/actions/runners/registration-token"
$r = Invoke-RestMethod -Method Post -Uri $regTokenUrl -Headers $headers
$token = $r.token
Write-Output "$($r.token)"
exit 2
Stop-Transcript

$UserName  = "UserName"
$PlainTextPassword = "Password"
$SecurePassword  = ConvertTo-SecureString $PlainTextPassword -AsPlainText -Force
$Credentials     = New-Object System.Management.Automation.PSCredential ($UserName, $SecurePassword)
$RESTAPIUser     = $Credentials.UserName
$RESTAPIPassword = $Credentials.GetNetworkCredential().password

$Method = "GET"
$URI = "https://api.businesscentral.dynamics.com/v2.0/yourdomain/Production/ODataV4/Company('CRONUS%20USA%2C%20Inc.')/Chart_of_Accounts"
$Headers = @{"Authorization" = "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($RESTAPIUser+":"+$RESTAPIPassword))}
$Type = "application/json"

$Parameters = @{
    URI     = $URI
    Headers = $Headers
    ContentType =$Type
    Method = $Method
    TimeoutSec = 100

}
$BCList = Invoke-RestMethod @Parameters

# $BCList = Invoke-RestMethod -Method Get -Uri $URL -TimeoutSec 100 -Headers $Headers -ContentType $Type

$BCListValue = $BCList.value
$BCListValue |  Out-GridView
# # $OutputFile = join-path $PSScriptRoot "ChartOutput.csv"
# # $BCList | export-csv -path $OutputFile -NoTypeInformation


$ServerInstance = "Instance"
$DatabaseName   = "Database"
$SchemaName     = "schema"
$TableName      = "BCGLAccounts"

$SQLParameters = @{
    serverinstance = $ServerInstance 
    DatabaseName   = $DatabaseName 
    SchemaName     = $SchemaName 
    TableName      = $TableName 
    ErrorAction    = "Stop"  
    Force          = $true
}

$BCListValue | Write-SqlTableData @SQLParameters



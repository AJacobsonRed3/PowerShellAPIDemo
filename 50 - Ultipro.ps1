$UserName  = "UserName"
$PlainTextPassword = "Password"
$SecurePassword = ConvertTo-SecureString $PlainTextPassword -AsPlainText -Force
$Credentials    = New-Object System.Management.Automation.PSCredential ($UserName, $SecurePassword)
$RESTAPIUser = $Credentials.UserName
$RESTAPIPassword = $Credentials.GetNetworkCredential().password
$URI = "https://client.ultiprotime.com:443/mobility/service/user/get_current"
$Headers = @{"Authorization" = "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($RESTAPIUser+":"+$RESTAPIPassword))}
$Type = "application/json"
$Method = "GET"

$Parameters1 = @{
    URI     = $URI
    Headers = $Headers
    ContentType =$Type
    Method = $Method
    TimeoutSec = 100
    ResponseHeadersVariable = "ResponseHeaders"
}
Invoke-RestMethod @Parameters1

$WFMBAT     = $ResponseHeaders.'HCM-WFM-wbat'
$JSESSIONID = $ResponseHeaders.'HCM-SID-WFM-JSESSIONID'
$WFMBAT
$JSESSIONID

$OutputRecords = @()  
$BaseURI = "https://client.ultiprotime.com:443/mobility/service/timesheet/get_work_summaries?"
$empName = 123456 #($Employees[$i].EmpNo).ToString().padleft(6,'0')
$from  =     "2020-04-06T00:00"
$to    =     "2020-04-15T23:59" 
$URI    = $BaseURI + "empName="+ $empName + "&from=" + $from + "&to=" + $to
$URI    = $URI + "&full=true"
$Headers.add("HCM-WFM-wbat",$ResponseHeaders.'HCM-WFM-wbat'[0])
$Headers.add("HCM-SID-WFM-JSESSIONID",$ResponseHeaders.'HCM-SID-WFM-JSESSIONID'[0])

$Parameters2 = @{
    URI     = $URI
    Headers = $Headers
    ContentType =$Type
    Method = $Method
    TimeoutSec = 100
}
$GetWorkSummary = Invoke-RestMethod @Parameters2
# #$GetWorkSummary | ConvertTo-Json | add-content "test.json" 


foreach($WorkSummary in $GetWorkSummary.workSummaries) {
      foreach($WorkDetail in $WorkSummary.workDetails) {
          $OutputRecord = [PSCustomObject]@{
              NYFEmployeeID = $empName
              WorkSummaryID = $WorkSummary.id
              SQLEmpID      = $WorkSummary.empID
              WorkDate      = $WorkSummary.workDate
              WrkMins       = $WorkSummary.wrkMins
              WorkDetailID  = $WorkDetail.id
              StartTime     = $WorkDetail.startTime
              EndTime       = $WorkDetail.endTime
              Rate          = $WorkDetail.rate
              TimeCode      = $WorkDetail.timecode.name
              JobName       = $WorkDetail.job.name
              JobLocDesc    = $WorkDetail.job.locDesc
              DeptName      = $WorkDetail.department.name
              WorkDetailType = $WorkDetail.workType
              HourType      = $WorkDetail.hourType.name
              PayrollPeriodEndDate = $to
          }  
          $OutputRecords += $OutputRecord
      }  
}

$OutputRecords | Out-GridView
$ServerInstance = "Server"
$DatabaseName = "Database"
$SchemaName = "Schema"

$TableName = "PayrollDetailDemo"

$SQLparams = @{
    serverinstance = $ServerInstance 
    DatabaseName   = $DatabaseName 
    SchemaName     = $SchemaName 
    TableName      = $TableName 
    ErrorAction    = "Stop" 
    Force          = $true
}

,($OutputRecords) | Write-SqlTableData @SQLparams 

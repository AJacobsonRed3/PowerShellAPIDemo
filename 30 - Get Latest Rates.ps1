# PowerShell formats the response based to the data type. For an RSS or ATOM feed, PowerShell returns the Item or Entry XML nodes. 
# For JavaScript Object Notation (JSON) or XML, PowerShell converts, or deserializes, the content into objects.

$URI = "http://data.fixer.io/api/latest?access_key=key&symbols=AUD,CAD,EUR,GBP"
$Method = "GET"
$Type = "application/json"

$Parameters = @{
    URI = $URI
    ContentType =$Type
    Method = $Method
    TimeoutSec = 100
}

$Results = Invoke-RestMethod @Parameters

# $Results | Out-GridView
# $Results | ConvertTo-Json  
 

$Results.success
$Results.date
$Results.timestamp
$Results.rates.AUD
# $Results.rates | Out-gridview
# $Results.rates.psobject.Members | where-object membertype -like 'noteproperty'

$Results | ConvertTo-Json | add-content "test.json"
# foreach ($member in $objMembers) {
#     $member.name
#     $member.value
# }







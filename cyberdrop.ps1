
param (
    [parameter(Mandatory=$true)]
    [String]$url
)

$title = Split-Path $url -leaf
Write-Output "Downloading album $title..."

$links = (Invoke-WebRequest -Uri $url).Links | Where-Object {$_.id -eq "file"} | ForEach-Object {$_.href}

New-Item -Name $title -ItemType Directory -Force | Out-Null

$count = 1;
$total = $links.Length;
foreach ($link in $links) {
    $filename = Split-Path $link -leaf
    $outputFile = Join-Path -Path $title -ChildPath $filename

    Write-Output "($count of $total)`tDownloading file $filename"
    Invoke-WebRequest $link -outfile $outputFile

    $count++;
}

Function Set-RepoLocation {
    $RepoLocation = Read-Host "Set repo location"
    if (Test-Path -Path $RepoLocation)
    {        
        [Environment]::SetEnvironmentVariable('REPO_LOCATION', $RepoLocation, 'User')
        return $true
    } 
    Write-Host "Invalid location"
    return $false
}

$Set = $null -ne [Environment]::GetEnvironmentVariable('REPO_LOCATION', 'User')
while($Set -ne $true)
{    
    $Set = Set-RepoLocation
}

$Location = [Environment]::GetEnvironmentVariable('REPO_LOCATION', 'User')
$Found = $false
while($Found -ne $true){
    $Repo = Read-Host "Where to?"
    
    if($Repo -like 'set*')
    {
        Set-RepoLocation
    }
    elseif($Repo -like 'help') {
        Write-Host "Commands:`n'list' for all folders in repo folder`n'list [subfolder]' for all folders in given subfolders`n'set'to set the location of repo folders`n"
    }
    elseif($Repo -like 'list*')
    {
        if($Repo -eq 'list'){
            $Folder = $Location
        } else {
            $Folder = $Location + "/" + $Repo -replace 'list '
        }

        if (Test-Path -Path $Folder) {            
            $List = Get-ChildItem -Path $Folder | select name
            foreach ($Directory in $List){
                Write-Host $Directory.Name
            }
        }
    } else {
        $Folder = "$Location\$Repo"
        if (Test-Path -Path $Folder) {
            cd $Folder
            start "C:\Program Files\Git\git-bash.exe"
            $Found = $true
        } else {
            "Path doesn't exist."
        }
    }
    
}

# Nuget Pipeline - auto semver, packs, deploys and add vsc tracking with git!
 

param([string]$nupkgfile=".\bin\debug\", [string]$filepath=".\*.csproj") 

#
# Auto SemVer ++
#
$Project = Resolve-Path $filepath
$xml = [Xml] (Get-Content $Project)
$v = [version] $xml.Project.PropertyGroup.Version
$vu = [version]::New($v.Major,$v.Minor,$v.build+1)
switch -wildcard ($v) 
{ 
        {$v.build -eq '9'} {$vu = [version]::New($v.Major,$v.Minor+1,0)}
        {$v.Minor -eq '9' -AND $v.build -eq '9'} {$vu = [version]::New($v.Major+1,0,0)}
        {$v.Major -eq '9' -AND $v.Minor -eq '9' -AND $v.build -eq '9'} {$vu = [version]::New($v.Major+1,0,0)}
        {$v.Major -eq '99' -AND $v.Minor -eq '9' -AND $v.build -eq '9'} {$vu = [version]::New($v.Major+1,0,0)}
    default {$vu = [version]::New($v.Major,$v.Minor,$v.build+1)}
}
  
Write-Host $vu
$xml.Project.PropertyGroup.Version = [string]$vu
$xml.Save($Project);

# pack
dotnet pack

# Deploy
$deploy = "dotnet nuget push $nupkgfile$($xml.Project.PropertyGroup.Name).$vu.nupkg --source https://mynugetserver/nuget -k secretpassword"
Invoke-Expression $deploy

# Git folder and sync with remote
Push-Location ../../

$branch = git branch --show-current

git add .

git commit -m "Meaningful message from the void of memory that is the pipeline"

git push origin $branch

# return to dir
Pop-Location
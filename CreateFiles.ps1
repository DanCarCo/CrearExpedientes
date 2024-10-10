# Paths and files
$basePath = "Specify the path of the file you want to copy en masse"
$files = @(
    "file 1",
    "file 2",
    "file 3"
) # Specify the names of the files you want to copy

# Folder ranges
$ranges = @(
    @{Start = "Specify the name with the first consecutive number"; End = "Specify the name with the last consecutive number"}
)

# Create folders, subfolders, and their subfolders
foreach ($range in $ranges) {
    for ($i = $range.Start; $i -le $range.End; $i++) {
        $folderPath = Join-Path -Path $basePath -ChildPath ($i)
        if (!(Test-Path -Path $folderPath)) {
            # Create the main folder
            New-Item -ItemType Directory -Path $folderPath
            Write-Host "Folder '$folderPath' created."
            
            # Create a subfolder ("Specify the name of the subfolder you want to create inside each folder")
            $subfolderPath = Join-Path -Path $folderPath -ChildPath "subfolder1"
            New-Item -ItemType Directory -Path $subfolderPath
            Write-Host "Subfolder 'subfolder1' created in '$folderPath'."
            
            # Create subfolders "C01" and "C02" inside "subfolder1"
            $pathC01 = Join-Path -Path $subfolderPath -ChildPath "C01"
            $pathC02 = Join-Path -Path $subfolderPath -ChildPath "C02"
            
            New-Item -ItemType Directory -Path $pathC01
            New-Item -ItemType Directory -Path $pathC02
            
            Write-Host "Subfolders 'C01' and 'C02' created in '$subfolderPath'."
        } else {
            Write-Host "The folder '$folderPath' already exists."
        }
    }
}

# Copy files to the "C01" and "C02" folders
$startName = "Specify the name with the first consecutive number" 
$endName = "Specify the name with the last consecutive number"

for ($i = $startName; $i -le $endName; $i++) {
    $folderPath = Join-Path -Path $basePath -ChildPath ($i)
    $pathC01 = Join-Path -Path $folderPath -ChildPath "subfolder1\C01"
    $pathC02 = Join-Path -Path $folderPath -ChildPath "subfolder1\C02"
    
    if (Test-Path -Path $pathC01 -and Test-Path -Path $pathC02) {
        foreach ($file in $files) {
            $filePath = Join-Path -Path $basePath -ChildPath $file
            
            # Copy to C01
            Copy-Item -Path $filePath -Destination $pathC01 -Force
            Write-Host "File '$file' copied to '$pathC01'."

            # If the file is "file3", also copy to C02
            if ($file -eq "file3") {
                Copy-Item -Path $filePath -Destination $pathC02 -Force
                Write-Host "File '$file' copied to '$pathC02'."
            }
        }
    } else {
        Write-Host "The folders '$pathC01' or '$pathC02' do not exist."
    }
}

# Rename folders with a "0" before and after the name
Set-Location -Path $basePath

$digitsToAdd = "0"

# Filter and rename the folders within the specified range
$folders = Get-ChildItem -Directory
foreach ($folder in $folders) {
    if ($folder.Name -ge $startName -and $folder.Name -le $endName) {
        $newName = $digitsToAdd + $folder.Name + $digitsToAdd + $digitsToAdd
        Rename-Item $folder.FullName -NewName $newName
        Write-Host "Folder '$folder.Name' renamed to '$newName'."
    }
}


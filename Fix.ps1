# Get the current directory path
$currentDirectory = Get-Location
$basePath = "Choose location"
$files = @("file1")

# Check that the base path is not empty
if (-not (Test-Path -Path $basePath)) {
    Write-Host "The base path '$basePath' does not exist. Please verify the path."
    exit
}

# Ranges of folders
$ranges = @(
    @{Start = 0000000; End = 0000001}
)

# Part 1: Rename files in the current directory
$files = Get-ChildItem -Path $currentDirectory -Recurse -File
foreach ($file in $files) {
    $newFileName = $file.Name -replace '[^\w.-]', '' -replace ' ', ''
    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($newFileName)
    $fileExtension = [System.IO.Path]::GetExtension($newFileName)

    if ($fileNameWithoutExtension.Length -gt 38) {
        $newFileName = $fileNameWithoutExtension.Substring(0, 38) + $fileExtension
    }

    $newFilePath = Join-Path -Path $file.DirectoryName -ChildPath $newFileName
    if ($newFilePath -ne $file.FullName) {
        if (-not (Test-Path -Path $newFilePath)) {
            try {
                Rename-Item -Path $file.FullName -NewName $newFileName
                Write-Host "Renamed: '$($file.FullName)' to '$newFilePath'"
            } catch {
                Write-Host "Error renaming: '$($file.FullName)'. $_"
            }
        } else {
            Write-Host "The file '$newFilePath' already exists. Not renaming '$($file.FullName)'."
        }
    }
}

# Part 2: Create folders and copy files
foreach ($range in $ranges) {
    for ($i = $range.Start; $i -le $range.End; $i++) {
        $folderPath = Join-Path -Path $basePath -ChildPath $i.ToString()

        if (Test-Path -Path $folderPath) {
            $subFolderPath = Join-Path -Path $folderPath -ChildPath "01file"
            if (!(Test-Path -Path $subFolderPath)) {
                New-Item -ItemType Directory -Path $subFolderPath
                Write-Output "Subfolder '01PrimeraInstancia' created in '$folderPath'."
            }

            $pathC01 = Join-Path -Path $subFolderPath -ChildPath "C01"
            $pathC02 = Join-Path -Path $subFolderPath -ChildPath "C02"
            if (!(Test-Path -Path $pathC01)) {
                New-Item -ItemType Directory -Path $pathC01
                Write-Output "Subfolder 'C01Principal' created in '$subFolderPath'."
            }
            if (!(Test-Path -Path $pathC02)) {
                New-Item -ItemType Directory -Path $pathC02
                Write-Output "Subfolder 'C02MedidasCautelares' created in '$subFolderPath'."
            }

            foreach ($file in $files) {
                $filePath = Join-Path -Path $basePath -ChildPath $file

                if (Test-Path -Path $pathC01) {
                    Copy-Item -Path $filePath -Destination $pathC01 -Force
                    Write-Host "File '$file' copied to '$pathC01'."

                    if ($file -eq "file1") {
                        Copy-Item -Path $filePath -Destination $pathC02 -Force
                        Write-Host "File '$file' copied to '$pathC02'."
                    }
                } else {
                    Write-Host "The folder '$pathC01' does not exist."
                }
            }
        } else {
            Write-Output "The folder '$folderPath' does not exist. No subfolders are created."
        }
    }
}

# Part 3: Rename folders by adding a "0" before and after the name
Set-Location -Path $basePath
$digitsToAdd = "0"
$startName = 0000000
$endName = 0000001

$folders = Get-ChildItem -Directory
foreach ($folder in $folders) {
    if ($folder.Name -ge $startName -and $folder.Name -le $endName) {
        $newName = $digitsToAdd + $folder.Name + $digitsToAdd + $digitsToAdd
        Rename-Item $folder.FullName -NewName $newName
        Write-Host "Folder '$($folder.Name)' renamed to '$newName'."
    }
}

Write-Host "Process completed."

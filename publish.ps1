# This script is for stinky windows users.
# If you want to know the what and the why, look at the bash script
# It does all the same stuff in the same order

$basename = Split-Path -Path $pwd -Leaf

if ($args.Length -eq 2) {
    $banner_path = $args[0]
    $icon_path = $args[1]
    if (Test-Path $banner_path -PathType Leaf) {
        echo "Banner found. Moving to root directory"
        Copy-Item $banner_path -Destination "."
    } else {
        echo "No file found at banner path"
        exit 1
    }

    if (Test-Path $icon_path -PathType Leaf) {
        echo "Icon found. Moving to root directory"
        Copy-Item $banner_path -Destination "."
    } else {
        echo "No file found at icon path"
        exit 1
    }

    Clear-Variable $banner_path
    Clear-Variable $icon_path
} else {
    Write-Host "Searching for images..." -NoNewline
}

$filenames = "banner", "icon"
$filetypes = "png", "jpg", "jpeg"


foreach ($filename in $filenames) {
    foreach($filetype in $filetypes) {
        if (Test-Path "./$filename.$filetype" -PathType Leaf) {
            if ($filename -eq "banner") {
                $banner_path = "$filename.$filetype"
            } else {
                $icon_path = "$filename.$filetype"
            }
            break
        }
    }
}

if ($banner_path -eq $null) {
    echo "Banner not found in current directory"
    if ($args.Length -eq 2) {
        echo "Maybe the banner was not the correct name or filetype?"
    }
    exit 1
}

if ($icon_path -eq $null) {
    echo "Icon not found in current directory"
    if ($args.Length -eq 2) {
        echo "Maybe the icon was not the correct name or filetype?"
    }
    exit 1
}

if ($args.Length -lt 2) {
    echo "Found"
}

if (Test-Path "./$basename.zip" -PathType Any) {
    Remove-Item "./basename.zip"
}

if (Test-Path "./bin" -PathType Any) {
    Remove-Item "./bin" -Recurse
}

# Write-Host -NoNewline "Building..."
dotnet publish -c Release -r linux-x64 --self-contained
# echo "Done"

if (Test-Path "./publish" -PathType Container) {
    Remove-Item "./publish"
}

Move-Item "./bin/Release/net6.0/linux-x64/publish" "./"

Write-Host "Zipping..." -NoNewline
Compress-Archive -Path "./publish", $banner_path, $icon_path -DestinationPath "$basename.zip"
Write-Host "Done"


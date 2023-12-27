# Get the user's temporary folder path
$tempFolderPath = [System.IO.Path]::GetTempPath()

try {
    # Get the list of files in the temporary folder
    $tempFiles = Get-ChildItem -Path $tempFolderPath -File -Force

    # Delete all files from the temporary folder that are not in use
    foreach ($file in $tempFiles) {
        try {
            # Check if the file is in use
            $fileInUse = Test-Path -Path $file.FullName -ErrorAction SilentlyContinue

            if (-not $fileInUse) {
                Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                Write-Host "File $($file.FullName) deleted."
            } else {
                Write-Host "Unable to delete $($file.FullName) as it is in use."
            }
        } catch {
            Write-Host "Error deleting $($file.FullName): $_"
        }
    }

    # Display a success message
    Write-Host "Cleaning temporary files completed."
} catch {
    # In case of an error, display an error message
    Write-Host "An error occurred while cleaning temporary files: $_"
}

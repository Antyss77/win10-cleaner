Add-Type -AssemblyName PresentationFramework

# Creating the window
$Window = New-Object System.Windows.Window
$Window.Title = "win10-cleaner"
$Window.Width = 400
$Window.Height = 200
$Window.WindowStartupLocation = "CenterScreen"

# Creating a button to initiate the cleaning process
$Button = New-Object System.Windows.Controls.Button
$Button.Content = "Clean Temp Folder"
$Button.Add_Click({
    try {
        # Code to clean the Temp folder asynchronously
        $job = Start-Job -ScriptBlock {
            $tempPath = [System.IO.Path]::GetTempPath()
            $files = Get-ChildItem -Path $tempPath

            $deletedFiles = @()  # To store the names of deleted files

            foreach ($file in $files) {
                try {
                    Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                    $deletedFiles += $file.Name  # Add the name of the deleted file
                } catch [System.IO.IOException] {
                    # Handle deletion errors
                } catch {
                    # Handle other errors
                }
            }

            # Return the names of the deleted files
            $deletedFiles
        }
        [System.Windows.MessageBox]::Show("Cleaning the Temp folder is in progress.", "Cleaning in Progress", "OK", "Information")

        # Wait for the job to finish
        Wait-Job $job | Out-Null

        # Retrieve the result of the job
        $result = Receive-Job $job

        # Check if any files were deleted
        if ($result.Count -gt 0) {
            # Display the deleted files in the console
            Write-Host "Files deleted from the Temp folder:"
            $result | ForEach-Object { Write-Host $_ }
            [System.Windows.MessageBox]::Show("The Temp folder has been cleaned!", "Cleaning Completed", "OK", "Information")
        } else {
            [System.Windows.MessageBox]::Show("No files to delete in the Temp folder.", "Cleaning Completed", "OK", "Information")
        }
        Remove-Job $job  # Remove the job once completed
    } catch {
        [System.Windows.MessageBox]::Show("An error occurred while cleaning the Temp folder.", "Error", "OK", "Error")
    }
})
$Button.HorizontalAlignment = "Center"
$Button.VerticalAlignment = "Center"

# Adding the button to the window
$Window.Content = $Button

# Displaying the window
$Window.ShowDialog() | Out-Null

# Load PresentationFramework assembly
Add-Type -AssemblyName PresentationFramework

# Create the window
$Window = New-Object System.Windows.Window
$Window.Title = "win10-cleaner"
$Window.Width = 400
$Window.Height = 200
$Window.WindowStartupLocation = "CenterScreen"

# Set the background color to white
$BackgroundColor = [System.Windows.Media.Brushes]::White
$Window.Background = $BackgroundColor

# Get the list of .ps1 scripts in the "Individual Scripts" folder
$scriptsPath = ".\Individual Scripts"
$scriptFiles = Get-ChildItem -Path $scriptsPath -Filter "*.ps1" -File

# Create a StackPanel to hold the buttons
$ButtonPanel = New-Object System.Windows.Controls.StackPanel
$ButtonPanel.Orientation = "Vertical"
$ButtonPanel.HorizontalAlignment = "Center"
$ButtonPanel.VerticalAlignment = "Center"

# Create a button for each script in the folder and add to the panel
foreach ($scriptFile in $scriptFiles) {
    $Button = New-Object System.Windows.Controls.Button
    $Button.Content = $scriptFile.Name.Replace(".ps1", "")
    $Button.Add_Click({
        try {
            # Execute the selected script
            $scriptPath = Join-Path -Path $scriptsPath -ChildPath $scriptFile.Name
            & $scriptPath

            # Show a success message if necessary
            [System.Windows.MessageBox]::Show("Script executed successfully!", "Script Execution", "OK", "Information")
        } catch {
            # Error while executing the script
            [System.Windows.MessageBox]::Show("An error occurred while executing the script.", "Error", "OK", "Error")
        }
    })

    # Add the button to the StackPanel
    $ButtonPanel.Children.Add($Button)
}

# Add the StackPanel to the window
$Window.Content = $ButtonPanel

# Show the window
$Window.ShowDialog() | Out-Null

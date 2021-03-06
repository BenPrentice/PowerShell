<#  
.SYNOPSIS  
    Start Stop and Restart services on any machine that is connected to the network  
.DESCRIPTION  
    The tool will populate the list of services based on the computer name
    that you put in the text field. You can then select the service you wish
    to stop or start. Pretty straight forward.
        
.NOTES  
    File Name  : Servicer.ps1  
    Author     : Benjiman Prentice - BenPrentice.com
    Requires   : PowerShell V4 or higher 
#>


[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

#Add your own if you want
#$Icon = New-Object system.drawing.icon ("C:\Bens Tools\Service Controller\icon.ico")

function StopThing()
{
    $svc = Get-Service -ComputerName $objTextBox.Text -Name $objListView.SelectedItems[0].Text
        if($objListView.SelectedItems[0].Text -ne $null)
        {
            Stop-Service -Name $svc.Name
            $svc.WaitForStatus('Stopped')
            UpdateStatus
        }

}

function StartThing()
{

    $svc = Get-Service -ComputerName $objTextBox.Text -Name $objListView.SelectedItems[0].Text
        if($objListView.SelectedItems[0].Text -ne $null)
        {
            Start-Service -Name $svc.Name
            $svc.WaitForStatus('Running')
            UpdateStatus
        }
}

function MyButtonClick()
{ 
    #Clearing the items in the ListView
    $objListView.Items.Clear()

    #Retrieving services from Specified PC
    $services = Get-Service -ComputerName $objTextBox.Text

    #Loop through available services on PC to show user in list.
    foreach ($service in $services)
    {
        $lvitem = New-Object System.Windows.Forms.ListViewItem([System.String[]](@($service.Name, $service.Status)), -1)
        $objListView.Items.AddRange(
        [System.Windows.Forms.ListViewItem[]](@($lvitem))
        )

    }
}
function UpdateStatus()
{
    #put something here
    MyButtonClick
}

#GUI Window
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Service Controller"
$objForm.Size = New-Object System.Drawing.Size(325,413) 
$objForm.StartPosition = "CenterScreen"
$objForm.FormBorderStyle = "FixedSingle"
$objForm.MaximizeBox = $false
#Add if you want $objForm.Icon = $Icon

#Input box for Admin to specify PC name which binds to $pc
$objTextBox = New-Object System.Windows.Forms.TextBox
$objTextBox.Location = New-Object System.Drawing.Point(10,10)
$objTextBox.Size = New-Object System.Drawing.Size(150,20)
$objTextBox.Text = "Machine Name..."
$objForm.Controls.Add($objTextBox)


#Enter/Ok button to set Variable $pc
$objOKButton = New-Object System.Windows.Forms.Button
$objOKButton.Location = New-Object System.Drawing.Point(161,10)
$objOKButton.Size = New-Object System.Drawing.Size(30,20)
$objOKButton.Text = "Ok"
$objOKButton.Add_Click({MyButtonClick})
$objForm.AcceptButton = $objOKButton
$objForm.Controls.Add($objOKButton)

#Service:Status Label
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,40)
$objLabel.Size = New-Object System.Drawing.Size(280,20)
$objLabel.Text = "Service:"
$objForm.Controls.Add($objLabel)

#GUI Start button
$StopButton = New-Object System.Windows.Forms.Button
$StopButton.Location = New-Object System.Drawing.Size(162.5,340)
$StopButton.Size = New-Object System.Drawing.Size(75,23)
$StopButton.Text = "Stop"
$StopButton.Add_Click({StopThing})
$objForm.Controls.Add($StopButton)

#GUI Stop button
$Start = New-Object System.Windows.Forms.Button
$Start.Location = New-Object System.Drawing.Size(87.5,340)
$Start.Size = New-Object System.Drawing.Size(75,23)
$Start.Text = "Start"
$Start.Add_Click({$x = $objListView.SelectedItem; StartThing})
$objForm.Controls.Add($Start)

#List of Services
$objListView = New-Object System.Windows.Forms.ListView
$objListView.Location = New-Object System.Drawing.Size(10,60)
$objListView.Size = New-Object System.Drawing.Size(300,20)
$objListView.Height = 280
$objListView.View = ("Details")
$objListView.FullRowSelect = $true
$objListView.HeaderStyle = ("Nonclickable")
$objListView.HideSelection = $true
$objListViewCol1 = New-Object System.Windows.Forms.ColumnHeader
$objListViewCol1.Text = "Service"
$objListViewCol1.Width = 215
$objListViewCol2 = New-Object System.Windows.Forms.ColumnHeader
$objListViewCol2.Text = "Status"
$objListView.Columns.AddRange(
[System.Windows.Forms.ColumnHeader[]](
@($objListViewCol1, $objListViewCol2))
)

$objName = New-Object System.Windows.Forms.Label
#$objName.Location = New-Object System.Drawing.Size(50,391)
#$objName.Size = New-Object System.Drawing.Size(20,391)
#$objName.AutoSize = $false
$objName.TextAlign = "BottomCenter"
$objName.Dock = "Fill"
$objName.Text = "BenPrentice.com - Benjiman Prentice"



#Adding list to Form and Showing the form.
$objForm.Controls.Add($objListView) 
$objForm.Controls.Add($objName)
$objForm.Topmost = $True
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()


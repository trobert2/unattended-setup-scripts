$CloudbaseInitMsi = "$ENV:Temp\CloudbaseInitSetup_Beta.msi"
$CloudbaseInitMsiUrl = "http://www.cloudbase.it/downloads/CloudbaseInitSetup_Beta.msi"
$CloudbaseInitMsiLog = "$ENV:Temp\CloudbaseInitSetup_Beta.log"

(new-object System.Net.WebClient).DownloadFile($CloudbaseInitMsiUrl, $CloudbaseInitMsi)

$p = Start-Process -Wait -PassThru -FilePath msiexec -ArgumentList "/i $CloudbaseInitMsi /qn /l*v $CloudbaseInitMsiLog"
if ($p.ExitCode -ne 0)
{
    throw "Installing $CloudbaseInitMsi failed. Log: $CloudbaseInitMsiLog"
}

winrm set winrm/config/service `@`{EnableCompatibilityHttpListener=`"true`"`}
winrm set winrm/config/service `@`{AllowUnencrypted=`"true`"`}
winrm set winrm/config/service/auth `@`{Basic=`"true`"`}
netsh advfirewall firewall add rule name="WinRM HTTP" dir=in action=allow protocol=TCP localport=5985

$Host.UI.RawUI.WindowTitle = "Running Sysprep..."
$unattendedXmlPath = "$ENV:ProgramFiles (x86)\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"
& "$ENV:SystemRoot\System32\Sysprep\Sysprep.exe" `/generalize `/oobe `/shutdown `/unattend:"$unattendedXmlPath"

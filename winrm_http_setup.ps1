winrm set winrm/config/service `@`{EnableCompatibilityHttpListener=`"true`"`}
winrm set winrm/config/service `@`{AllowUnencrypted=`"true`"`}
winrm set winrm/config/service/auth `@`{Basic=`"true`"`}
netsh advfirewall firewall add rule name="WinRM HTTP" dir=in action=allow protocol=TCP localport=5985

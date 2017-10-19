::reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\InetStp\Configuration" /v "MaxWebConfigFileSizeInKB" /t reg_dword -d "0" /f
::reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp\Configuration" /v "MaxWebConfigFileSizeInKB" /t reg_dword -d "0" /f

echo %HOST% >>/Windows/System32/drivers/etc/hosts
echo %HOST2% >>/Windows/System32/drivers/etc/hosts
echo %HOST3% >>/Windows/System32/drivers/etc/hosts
echo %HOST4% >>/Windows/System32/drivers/etc/hosts
echo %HOST4% >>/Windows/System32/drivers/etc/hosts
echo %HOST5% >>/Windows/System32/drivers/etc/hosts
echo %HOST6% >>/Windows/System32/drivers/etc/hosts

cd /wwwroot/%site_name%/configFile
powershell -executionpolicy bypass -Command "if ($env:memcache) { (Get-Content 'MemcacheConfigModel.config').replace('10.30.42.114', $env:memcache) | Set-Content 'MemcacheConfigModel.config' };
/windows/system32/inetsrv/appcmd.exe delete site "Default Web Site/"
/windows/system32/inetsrv/appcmd.exe add apppool /name:"%site_name%"  /managedRuntimeVersion:"v%site_version%.0"  /managedPipelineMode:Integrated -queueLength:65535
/windows/system32/inetsrv/appcmd.exe add site /name:"%site_name%" /physicalPath:"c:\wwwroot\%site_name%" -serverAutoStart:true /bindings:http://%site_name%:80 
/windows/system32/inetsrv/appcmd.exe set site /site.name:"%site_name%" /[path='/'].applicationPool:"%site_name%"
rem  /windows/system32/inetsrv/appcmd add app  /site.name:"%site_name%" /path:"/configFile" /physicalPath:"c:\wwwroot\baseconfigapi.vxuepin.com\configFile"
rem sc create winlogbeat binpath= "C:\winlog\winlogbeat.exe -c \"C:\winlog\winlogbeat.yml\"  -path.home \"C:\winlog\" -path.data \"C:\ProgramData\winlogbeat\"" displayname= "winlogbeat" start= auto
rem sc start winlogbeat
for /f "tokens=2* delims==:" %%a in ('ipconfig^|find /i "10.0"') do ( 
curl.exe -XPUT http://haproxy:2379/v2/keys/web/%site_name%/%computername% -d value="%%a:80"
)
c:\ServiceMonitor.exe w3svc
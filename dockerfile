FROM microsoft/iis
# install ASP.NET 4.5
RUN dism /online /enable-feature /all /featurename:NetFx4 /featurename:IIS-ApplicationInit /featurename:IIS-ASPNET45 /NoRestart
# enable windows eventlog
RUN powershell.exe -command Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-Application Start 1
ADD wget.exe /wget.exe
ADD unzip.exe /unzip.exe
ADD client.rsp /client.rsp
RUN wget http://www.lushare.com/soft/win64_11gR2_client.zip && /unzip.exe /win64_11gR2_client.zip && del /S /Q win64_11gR2_client.zip && /client/setup.exe -silent -force -noconsole -ignoreSysPrereqs -ignorePrereq -waitforcompletion -responseFile C:\client.rsp && del /S /Q client
ENTRYPOINT ["C:\\SetHostsAndStartMonitoring.cmd"]
RUN for %s in (TermService,SessionEnv,iphlpsvc,RemoteRegistry,WinHttpAutoProxySvc,SENS,WinRM,LanmanWorkstation,Winmgmt) do ( sc config %s start= disabled) && reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\InetStp\Configuration" /v "MaxWebConfigFileSizeInKB" /t reg_dword -d "0" /f && reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp\Configuration" /v "MaxWebConfigFileSizeInKB" /t reg_dword -d "0" /f
VOLUME ["c:/inetpub/logs/LogFiles"]
ADD curl.exe /windows/system32/curl.exe
ADD winlog /winlog
ENV site_version 4
ENV site_name www.lushare.com
ADD SetHostsAndStartMonitoring.cmd \SetHostsAndStartMonitoring.cmd
ADD webroot C:/wwwroot/www.lushare.com

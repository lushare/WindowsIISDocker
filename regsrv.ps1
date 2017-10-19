$cname=[System.Net.DNS]::GetHostByName('').HostName
$ip=[System.Net.DNS]::GetHostByName($null).AddressList.IPAddressToString |findstr 10.0
$domain=$env:site_name
curl.exe -XPUT http://haproxy:2379/v2/keys/web/${domain}/${cname} -d value="${ip}:80"
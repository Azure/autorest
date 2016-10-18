###
### Save this file as "install-software.ps1"
###

# check for elevated powershell
write-host -nonewline -fore cyan "Info: Verifying user is elevated:" 
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    write-host -fore Red "NO"
    return write-error "You must run this script elevated."
}
write-host -fore Yellow "YES" 

write-host -fore cyan "Info: making temp directory."
$null = mkdir -ea 0 c:\tmp

Function Get-AndroidHomeFromRegistry
{
    if ([environment]::GetEnvironmentVariable("ProgramFiles(x86)")) {
        $androidRegistryKey = "HKLM:\SOFTWARE\Wow6432Node\Android SDK Tools"
    }
    else {
        $androidRegistryKey = "HKLM:\SOFTWARE\Android SDK Tools"
    }

    if (Test-Path $androidRegistryKey) {
        $path = (Get-ItemProperty $androidRegistryKey Path).Path

        if (-not (Test-Path -ea 0 $path)) {
            $path = $null
        }
    }
    return $path
}

function DiffPathFromRegistry {
    $u = ([System.Environment]::GetEnvironmentVariable( "path", 'User'))
    $m = ([System.Environment]::GetEnvironmentVariable( "path", 'Machine'))
    $newPath = "$m;$u"
    $np = $newpath.split(";") |% { $_.trim("\").Trim() }
    $op = $env:path.split(";") |% { $_.trim("\").Trim() }
    diff $np $op
}

function ReloadPathFromRegistry {
    write-host -fore darkcyan "      Reloading Path From Registry."
    $u = ([System.Environment]::GetEnvironmentVariable( "path", 'User'))
    $m = ([System.Environment]::GetEnvironmentVariable( "path", 'Machine'))
    $newPath = "$m;$u"
    $env:path = $newPath
}

function GetEnvironmentFromRegistry {
    ([System.Environment]::GetEnvironmentVariables( 'User'))
    ([System.Environment]::GetEnvironmentVariables( 'Machine'))
}


# install chocolatey oneget provider
write-host -fore cyan "Info: Ensuring Chocolatey OneGet provider is installed."
$pp = get-packageprovider -force chocolatey
if( !$pp ) { return write-error "can't get chocolatey package provider "}

# start with a clean slate.
ReloadPathFromRegistry

# install jdk8
if( !(get-command -ea 0 java.exe) ) {
    write-host -fore cyan "Info: Installing JDK 8."
    $null = install-package -provider chocolatey jdk8 -force
    if( !(get-command -ea 0 java.exe) ) { return write-error "No Java in PATH." }
}
write-host -fore darkcyan "      Setting JAVA_HOME environment key."
([System.Environment]::SetEnvironmentVariable('JAVA_HOME',  (resolve-path "$((get-command -ea 0 javac).Source)..\..\..").Path , "Machine" ))

# install Android SDK
if( ! (Get-AndroidHomeFromRegistry) ) {
    write-host -fore cyan "Info: Installing Android SDK."
    $null = install-package -provider chocolatey android-sdk -force
    if( ! (Get-AndroidHomeFromRegistry) ) { return write-error "No Android SDK Installed" }
    # set the environment variable for the user.
}
write-host -fore darkcyan "      setting ANDROID_HOME environment key."
([System.Environment]::SetEnvironmentVariable('ANDROID_HOME', (Get-AndroidHomeFromRegistry) ,'Machine'))

# Install node.js
if( !(get-command -ea 0 node.exe) ) { 
    write-host -fore cyan "Info: Installing NodeJS."
    $null = install-package -provider chocolatey nodejs -force
    ReloadPathFromRegistry
    if( !(get-command -ea 0 node.exe) ) { return write-error "No NodeJS in PATH." }
    
    # use system-wide locations for npm
    npm config --global set cache "$env:ALLUSERSPROFILE\npm-cache"
    npm config --global set prefix "$env:ALLUSERSPROFILE\npm"
    $p = ([System.Environment]::GetEnvironmentVariable( "path", 'Machine'))
    $p = "$env:ALLUSERSPROFILE\npm;$p"
    ([System.Environment]::SetEnvironmentVariable( "path", $p,  'Machine'))    
    ReloadPathFromRegistry
   
}

# install gulp
if( !(get-command -ea 0 gulp) ) {
    write-host -fore cyan "Info: Installing Gulp globally."
    npm install -g gulp
    if( !(get-command -ea 0 gulp) ) { return write-error "No gulp in PATH. (npm bin folder missing?)" }
}

# install Ruby 2.3
if( !(get-command -ea 0 ruby) ) {
    write-host -fore cyan "Info: Downloading Ruby."
    ( New-Object System.Net.WebClient).DownloadFile("http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.1.exe","c:\tmp\rubyinstaller-2.3.1.exe")
    if( !(test-path -ea 0  "c:\tmp\rubyinstaller-2.3.1.exe" ) ) { return write-error "Unable to download ruby installer" }
    write-host -fore darkcyan "      Running Ruby Installer."
    C:\tmp\rubyinstaller-2.3.1.exe /verysilent /dir=c:\ruby2.3.1 /tasks="assocfiles,modpath"
    while( (get-process -ea 0 rubyinstaller*) )  { write-host -NoNewline "." ; sleep 1 }
    ReloadPathFromRegistry
    if( !(get-command -ea 0 ruby.exe) ) { return write-error "No RUBY in PATH." }
    $ruby = (get-command -ea 0 ruby.exe).Source
    $null = netsh firewall add allowedprogram  "$ruby" "$ruby" ENABLE
}

# 7zip
if( ! (test-path -ea 0  "C:\Program Files\7-Zip\7z.exe")) {
    write-host -fore cyan "Info: Downloading 7zip."
    ( New-Object System.Net.WebClient).DownloadFile("http://www.7-zip.org/a/7z1604-x64.msi", "c:\tmp\7z1604-x64.msi" );
    if( !(test-path -ea 0  "c:\tmp\7z1604-x64.msi") ) { return write-error "Unable to download 7zip installer" }
    write-host -fore darkcyan "      Installing 7Zip."
    Start-Process -wait -FilePath msiexec -ArgumentList  "/i", "c:\tmp\7z1604-x64.msi", "/passive"

    if( ! (test-path -ea 0  "C:\Program Files\7-Zip\7z.exe"))  { return write-error "Unable to install 7zip" } 
}

# ruby devkit
if( ! (test-path -ea 0  "C:\ruby2.3.1\devkit")) {
    write-host -fore cyan "Info: Downloading Ruby Devkit."
    ( New-Object System.Net.WebClient).DownloadFile("http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe", "c:\tmp\DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe" )
    if( !(test-path -ea 0  "c:\tmp\DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe") ) { return write-error "Unable to download ruby devkit" }
    write-host -fore darkcyan "      Unpacking ruby devkit."
    &'C:\Program Files\7-Zip\7z' x C:\tmp\DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe -oC:\ruby2.3.1\devkit
    pushd C:\ruby2.3.1\devkit\
    write-host -fore darkcyan "      Installing ruby devkit."
    ruby dk.rb init
    ruby dk.rb install

    write-host -fore darkcyan "      Installing missing ruby certificate roots."
set-content -path "c:\ruby2.3.1\lib\ruby\2.3.0\rubygems\ssl_certs\fastly.pem" -value @"
-----BEGIN CERTIFICATE-----
MIIO5DCCDcygAwIBAgISESFY8xfYRUgn/tM1S/rCQFqRMA0GCSqGSIb3DQEBCwUA
MGYxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTwwOgYD
VQQDEzNHbG9iYWxTaWduIE9yZ2FuaXphdGlvbiBWYWxpZGF0aW9uIENBIC0gU0hB
MjU2IC0gRzIwHhcNMTYwMzEwMTc1NDA5WhcNMTgwMzEzMTQwNDA2WjBsMQswCQYD
VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5j
aXNjbzEVMBMGA1UECgwMRmFzdGx5LCBJbmMuMRkwFwYDVQQDDBBsLnNzbC5mYXN0
bHkubmV0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy8dy9W+1kNgD
fZZaVm9OuB6aAcLysbODKUvHt7IvPEJjLZYMP5SLCB5+eo93Vb1Vl3I/lU+qdBIP
1Yzi9Oh8XB+DBA7YmgzyeuWvT07YBOJOfXrbQK9tx+dmcZQtU3oka0uqOUDeT8fE
qccufwxA0RoVPGEKCZjDr4NALIBL4ckKxWeibvwnX1rN1fqyMMiW36ML3A9gdSA5
0YIy7vh9CDvaSt/hBn/pUt2xkhhwtdi/zr6BrpjsMSgB/0qT03GukZ7fsxLI7Kwa
yspUlhLUbY99pKiXrf6NNuTIHt57IuD3a1TnBnHkOs9uQny31o3ShPOnxo4hB0xj
d+bbz2GsuQIDAQABo4ILhDCCC4AwDgYDVR0PAQH/BAQDAgWgMEkGA1UdIARCMEAw
PgYGZ4EMAQICMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24u
Y29tL3JlcG9zaXRvcnkvMIIJyQYDVR0RBIIJwDCCCbyCEGwuc3NsLmZhc3RseS5u
ZXSCECouMXN0ZGlic2Nkbi5jb22CCiouYW1hbi5jb22CGCouYW5zd2Vyc2luZ2Vu
ZXNpcy5jby51a4IWKi5hbnN3ZXJzaW5nZW5lc2lzLm9yZ4IUKi5hcGkubGl2ZXN0
cmVhbS5jb22CEiouYXJrZW5jb3VudGVyLmNvbYIUKi5hdHRyaWJ1dGlvbi5yZXBv
cnSCDSouYmVzdGVnZy5jb22CEyouYnV5aXRkaXJlY3QuY28udWuCESouY29udGVu
dGJvZHkuY29tghQqLmNyZWF0aW9ubXVzZXVtLm9yZ4IbKi5jdXJhdGlvbnMuYmF6
YWFydm9pY2UuY29tgg4qLmRsc2FkYXB0LmNvbYIVKi5kb2xsYXJzaGF2ZWNsdWIu
Y29tghoqLmV4Y2l0ZW9ubGluZXNlcnZpY2VzLmNvbYIQKi5mYXN0bHlsYWJzLmNv
bYIPKi5maWxlcGlja2VyLmlvghIqLmZpbGVzdGFja2FwaS5jb22CESouZm9kLXNh
bmRib3guY29tghEqLmZvZC1zdGFnaW5nLmNvbYIKKi5mb2Q0LmNvbYIMKi5mdWxs
MzAuY29tgg4qLmZ1bmRwYWFzLmNvbYIPKi5mdW5rZXI1MzAuY29tghAqLmZ1bm55
b3JkaWUuY29tgg8qLmdhbWViYXR0ZS5jb22CCCouaGZhLmlvghEqLmphY2t0aHJl
YWRzLmNvbYIMKi5rbm5sYWIuY29tgg8qLmxlYWRlcnNpbi5jb22CDCoubGV0ZW1w
cy5jaIIPKi5sb290Y3JhdGUuY29tghUqLm1hcmxldHRlZnVuZGluZy5jb22CDyou
bXliZXN0ZWdnLmNvbYIJKi5uZmwuY29tggsqLnBhdGNoLmNvbYIMKi5wZWJibGUu
Y29tghAqLnBvdHRlcm1vcmUuY29tghAqLnByaW1lc3BvcnQuY29tghgqLnByb3Rl
Y3RlZC1jaGVja291dC5uZXSCCyoucmNoZXJ5LnNlgg4qLnJ1YnlnZW1zLm9yZ4IP
Ki5yd2xpdmVjbXMuY29tghcqLnNhZmFyaWJvb2tzb25saW5lLmNvbYISKi5zbWFy
dHNwYXJyb3cuY29tgg0qLnRhYy1jZG4ubmV0gg8qLnRoZXJlZHBpbi5jb22CDyou
dGhyaWxsaXN0LmNvbYIPKi50b3RhbHdpbmUuY29tgg8qLnRyYXZpcy1jaS5jb22C
DyoudHJhdmlzLWNpLm9yZ4ISKi50cmVhc3VyZWRhdGEuY29tggwqLnR1cm5lci5j
b22CDyoudW5pdGVkd2F5Lm9yZ4IOKi51bml2ZXJzZS5jb22CCSoudXJ4LmNvbYIK
Ki52ZXZvLmNvbYIbKi52aWRlb2NyZWF0b3IueWFob28tbmV0LmpwghYqLndob2xl
Zm9vZHNtYXJrZXQuY29tghMqLnliaS5pZGNmY2xvdWQubmV0ghEqLnlvbmRlcm11
c2ljLmNvbYIQYS4xc3RkaWJzY2RuLmNvbYINYWZyb3N0cmVhbS50doIPYXBpLmRv
bWFpbnIuY29tgg1hcGkubnltYWcuY29tghdhcHAuYmV0dGVyaW1wYWN0Y2RuLmNv
bYIaYXNzZXRzLmZsLm1hcmthdmlwLWNkbi5jb22CHGFzc2V0czAxLmN4LnN1cnZl
eW1vbmtleS5jb22CEmF0dHJpYnV0aW9uLnJlcG9ydIIYY2RuLmZpbGVzdGFja2Nv
bnRlbnQuY29tghZjZG4uaGlnaHRhaWxzcGFjZXMuY29tggxjZG4ua2V2eS5jb22C
C2RvbWFpbnIuY29tgh5lbWJlZC1wcmVwcm9kLnRpY2tldG1hc3Rlci5jb22CGGVt
YmVkLm9wdGltaXplcGxheWVyLmNvbYIWZW1iZWQudGlja2V0bWFzdGVyLmNvbYIO
ZmFzdGx5bGFicy5jb22CD2ZsLmVhdDI0Y2RuLmNvbYIKZnVsbDMwLmNvbYIMZnVu
ZHBhYXMuY29tgg1mdW5rZXI1MzAuY29tggtnZXRtb3ZpLmNvbYIZZ2l2aW5ndHVl
c2RheS5naXZlZ2FiLmNvbYIOaS51cHdvcnRoeS5jb22CGmltYWdlcy5mbC5tYXJr
YXZpcC1jZG4uY29tgg9qYWNrdGhyZWFkcy5jb22CFmpzaW4uYWRwbHVnY29tcGFu
eS5jb22CFWpzaW4uYmx1ZXBpeGVsYWRzLmNvbYIKa25ubGFiLmNvbYINbGVhZGVy
c2luLmNvbYINbG9vdGNyYXRlLmNvbYITbWVkaWEuYmFyZm9vdC5jby5ueoIVbWVk
aWEucmlnaHRtb3ZlLmNvLnVrgg1tZXJyeWphbmUuY29tgiBtaWdodHktZmxvd2Vy
cy00MjAubWVycnlqYW5lLmNvbYIgbmV4dGdlbi1hc3NldHMuZWRtdW5kcy1tZWRp
YS5jb22CCW55bWFnLmNvbYILKi5ueW1hZy5jb22CCXBhdGNoLmNvbYIKcGViYmxl
LmNvbYIPcGl4ZWwubnltYWcuY29tgg5wcmltZXNwb3J0LmNvbYIicHJvcXVlc3Qu
dGVjaC5zYWZhcmlib29rc29ubGluZS5kZYIMcnVieWdlbXMub3JnghVzYWZhcmli
b29rc29ubGluZS5jb22CEXNlYXJjaC5tYXB6ZW4uY29tghFzdGF0aWMudmVzZGlh
LmNvbYIOdGhlZ3VhcmRpYW4udHaCECoudGhlZ3VhcmRpYW4udHaCDXRocmlsbGlz
dC5jb22CDXRvdGFsd2luZS5jb22CB3VyeC5jb22CGXZpZGVvY3JlYXRvci55YWhv
by1uZXQuanCCGndlbGNvbWUtZGV2LmJhbmtzaW1wbGUuY29tghB3aWtpLXRlbXAu
Y2EuY29tgg13d3cuYmxpbnEuY29tggx3d3cuYnVscS5jb22CInd3dy5jcmlzdGlh
bm9yb25hbGRvZnJhZ3JhbmNlcy5jb22CGXd3dy5mcmVlZ2l2aW5ndHVlc2RheS5v
cmeCEXd3dy5mcmVlbG90dG8uY29tgg53d3cuaW9kaW5lLmNvbYIXd3d3LmxhcHRv
cHNkaXJlY3QuY28udWuCDnd3dy5sZXRlbXBzLmNoghF3d3cubWVycnlqYW5lLmNv
bYIkd3d3Lm1pZ2h0eS1mbG93ZXJzLTQyMC5tZXJyeWphbmUuY29tghh3d3cubWls
bHN0cmVhbWxvdDQ2LmluZm+CEnd3dy5wb3R0ZXJtb3JlLmNvbYITd3d3LnRyYWlu
b3JlZ29uLm9yZ4IQd3d3LnZzbGl2ZS5jby5uejAJBgNVHRMEAjAAMB0GA1UdJQQW
MBQGCCsGAQUFBwMBBggrBgEFBQcDAjBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8v
Y3JsLmdsb2JhbHNpZ24uY29tL2dzL2dzb3JnYW5pemF0aW9udmFsc2hhMmcyLmNy
bDCBoAYIKwYBBQUHAQEEgZMwgZAwTQYIKwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzb3JnYW5pemF0aW9udmFsc2hhMmcycjEu
Y3J0MD8GCCsGAQUFBzABhjNodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nv
cmdhbml6YXRpb252YWxzaGEyZzIwHQYDVR0OBBYEFExxRkNZ5ZAu1b3yysQe7R0J
p5v0MB8GA1UdIwQYMBaAFJbeYfG9HBYpUxzAzH07gwBA5hp8MA0GCSqGSIb3DQEB
CwUAA4IBAQAK0xY/KR6G9I6JJN1heilrcYEm71lrzxyAOrOq2YZV9l1L+qgSGxjV
vzvCNczZr76DD54+exBymDerBbwSI47JpSg3b5EzyiVvhz5r9rADYPBZBAkcTTUJ
std5fSbTMEKk+sB/DGdLr6v07kY+WRYbXMBuYNfRBVCoRXabzT5AMJEIYOudGFQC
1S/4tx3t1w7l4584Mr7uTAlDcMsNOkU4gs0Onghn6IAfuu1MN/0BYCuwO/qKdt5L
gN8rZB60W6VFOJGd1qJJv5erH/1j2nC8PBZQwl//IwW437uRNI5/ti3Fj/WR/0+T
dwT31o1uEbJZ0Mr5XmLQ/l8kal+xOiS0
-----END CERTIFICATE-----
"@

set-content -path "c:\ruby2.3.1\lib\ruby\2.3.0\rubygems\ssl_certs\GeoTrustGlobalCA.pem" -value @"
-----BEGIN CERTIFICATE-----
MIIDVDCCAjygAwIBAgIDAjRWMA0GCSqGSIb3DQEBBQUAMEIxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1HZW9UcnVzdCBJbmMuMRswGQYDVQQDExJHZW9UcnVzdCBHbG9i
YWwgQ0EwHhcNMDIwNTIxMDQwMDAwWhcNMjIwNTIxMDQwMDAwWjBCMQswCQYDVQQG
EwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEbMBkGA1UEAxMSR2VvVHJ1c3Qg
R2xvYmFsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2swYYzD9
9BcjGlZ+W988bDjkcbd4kdS8odhM+KhDtgPpTSEHCIjaWC9mOSm9BXiLnTjoBbdq
fnGk5sRgprDvgOSJKA+eJdbtg/OtppHHmMlCGDUUna2YRpIuT8rxh0PBFpVXLVDv
iS2Aelet8u5fa9IAjbkU+BQVNdnARqN7csiRv8lVK83Qlz6cJmTM386DGXHKTubU
1XupGc1V3sjs0l44U+VcT4wt/lAjNvxm5suOpDkZALeVAjmRCw7+OC7RHQWa9k0+
bw8HHa8sHo9gOeL6NlMTOdReJivbPagUvTLrGAMoUgRx5aszPeE4uwc2hGKceeoW
MPRfwCvocWvk+QIDAQABo1MwUTAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTA
ephojYn7qwVkDBF9qn1luMrMTjAfBgNVHSMEGDAWgBTAephojYn7qwVkDBF9qn1l
uMrMTjANBgkqhkiG9w0BAQUFAAOCAQEANeMpauUvXVSOKVCUn5kaFOSPeCpilKIn
Z57QzxpeR+nBsqTP3UEaBU6bS+5Kb1VSsyShNwrrZHYqLizz/Tt1kL/6cdjHPTfS
tQWVYrmm3ok9Nns4d0iXrKYgjy6myQzCsplFAMfOEVEiIuCl6rYVSAlk6l5PdPcF
PseKUgzbFbS9bZvlxrFUaKnjaZC2mqUPuLk/IH2uSrW4nOQdtqvmlKXBx4Ot2/Un
hw4EbNX/3aBd7YdStysVAq45pmp06drE57xNNB6pXE0zX5IJL4hmXXeXxx12E6nV
5fEWCRE11azbJHFwLJhWC9kXtNHjUStedejV0NxPNO3CBWaAocvmMw==
-----END CERTIFICATE-----
"@

set-content -path "c:\ruby2.3.1\lib\ruby\2.3.0\rubygems\ssl_certs\GlobalSignRoot.pem" -value @"
-----BEGIN CERTIFICATE-----
MIIDdTCCAl2gAwIBAgILBAAAAAABFUtaw5QwDQYJKoZIhvcNAQEFBQAwVzELMAkGA1UEBhMCQkUx
GTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNVBAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkds
b2JhbFNpZ24gUm9vdCBDQTAeFw05ODA5MDExMjAwMDBaFw0yODAxMjgxMjAwMDBaMFcxCzAJBgNV
BAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMRAwDgYDVQQLEwdSb290IENBMRswGQYD
VQQDExJHbG9iYWxTaWduIFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDa
DuaZjc6j40+Kfvvxi4Mla+pIH/EqsLmVEQS98GPR4mdmzxzdzxtIK+6NiY6arymAZavpxy0Sy6sc
THAHoT0KMM0VjU/43dSMUBUc71DuxC73/OlS8pF94G3VNTCOXkNz8kHp1Wrjsok6Vjk4bwY8iGlb
Kk3Fp1S4bInMm/k8yuX9ifUSPJJ4ltbcdG6TRGHRjcdGsnUOhugZitVtbNV4FpWi6cgKOOvyJBNP
c1STE4U6G7weNLWLBYy5d4ux2x8gkasJU26Qzns3dLlwR5EiUWMWea6xrkEmCMgZK9FGqkjWZCrX
gzT/LCrBbBlDSgeF59N89iFo7+ryUp9/k5DPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBRge2YaRQ2XyolQL30EzTSo//z9SzANBgkqhkiG9w0BAQUF
AAOCAQEA1nPnfE920I2/7LqivjTFKDK1fPxsnCwrvQmeU79rXqoRSLblCKOzyj1hTdNGCbM+w6Dj
Y1Ub8rrvrTnhQ7k4o+YviiY776BQVvnGCv04zcQLcFGUl5gE38NflNUVyRRBnMRddWQVDf9VMOyG
j/8N7yy5Y0b2qvzfvGn9LhJIZJrglfCm7ymPAbEVtQwdpf5pLGkkeB6zpxxxYu7KyJesF12KwvhH
hm4qxFYxldBniYUr+WymXUadDKqC5JlR3XC321Y9YeRq4VzW9v493kHMB65jUr9TU/Qr6cf9tveC
X4XSQRjbgbMEHMUfpIBvFSDJ3gyICh3WZlXi/EjJKSZp4A==
-----END CERTIFICATE-----
"@

    write-host -fore darkcyan "      Testing ruby devkit."
    gem install json --platform=ruby
    $answer =  ruby -rubygems -e "require 'json'; puts JSON.load('[42]').inspect"
    if( $answer -ne "[42]") {
        return write-error "Ruby devkit/gems not working?"
    }

    gem install bundle
}

# install python 2.7 and 3.5
if( !(get-command -ea 0 python.exe) ) { 
    write-host -fore cyan "Info: Downloading Python 2.7 and 3.5"
    ( New-Object System.Net.WebClient).DownloadFile("https://www.python.org/ftp/python/2.7.12/python-2.7.12.amd64.msi","c:\tmp\python-2.7.12.amd64.msi")
    ( New-Object System.Net.WebClient).DownloadFile("https://www.python.org/ftp/python/3.5.2/python-3.5.2-amd64.exe","c:\tmp\python-3.5.2-amd64.exe" )

    if( !(test-path -ea 0  "c:\tmp\python-2.7.12.amd64.msi") ) { return write-error "Unable to download Python 2.7" }
    if( !(test-path -ea 0  "c:\tmp\python-3.5.2-amd64.exe") ) { return write-error "Unable to download Python 3.5" }
    write-host -fore darkcyan "      Installing Python 2.7."
    Start-Process -wait -FilePath msiexec -ArgumentList  "/i", "C:\tmp\python-2.7.12.amd64.msi", "TARGETDIR=c:\python27", "ALLUSERS=1", "ADDLOCAL=All", "/passive"
    write-host -fore darkcyan "      Installing Python 3.5."
    C:\tmp\python-3.5.2-amd64.exe /quiet InstallAllUsers=1 PrependPath=1
    while( (get-process -ea 0 python*) )  { write-host -NoNewline "." ; sleep 1 }
    ReloadPathFromRegistry
    if( !(get-command -ea 0 python.exe) ) { return write-error "No PYTHON in PATH." }
}

#install Tox
if( !(get-command -ea 0 tox.exe) ) { 
    write-host -fore cyan "Info: Installing Tox"
    pip install tox
    if( !(get-command -ea 0 tox.exe) ) { return write-error "No TOX  in PATH." }
}

# install gradle
if( !(get-command -ea 0 gradle.bat) ) { 
    write-host -fore cyan "Info: Downloading Gradle"
    (New-Object System.Net.WebClient).DownloadFile("https://services.gradle.org/distributions/gradle-3.1-all.zip", "c:\tmp\gradle-3.1-all.zip" )
    if( !(test-path -ea 0  "c:\tmp\gradle-3.1-all.zip") ) { return write-error "Unable to download Gradle" }
    write-host -fore darkcyan "      Unpacking Gradle."
    Expand-Archive C:\tmp\gradle-3.1-all.zip -DestinationPath c:\
    write-host -fore darkcyan "      Adding gradle to system PATH."
    $p = ([System.Environment]::GetEnvironmentVariable( "path", 'Machine'))
    $p = "$p;c:\gradle-3.1\bin"
    ([System.Environment]::SetEnvironmentVariable( "path", $p,  'Machine'))
    ReloadPathFromRegistry
    if( !(get-command -ea 0 gradle.bat) ) { return write-error "No Gradle in PATH." }
}

#install go 
if( !(get-command -ea 0 go.exe) ) { 
    write-host -fore cyan "Info: Downloading Go"
    (New-Object System.Net.WebClient).DownloadFile("https://storage.googleapis.com/golang/go1.7.1.windows-amd64.msi", "c:\tmp\go1.7.1.windows-amd64.msi" )
    if( !(test-path -ea 0  "c:\tmp\go1.7.1.windows-amd64.msi" ) ) { return write-error "Unable to download Go" }
    write-host -fore darkcyan "      Installing Go."
    Start-Process -wait -FilePath msiexec -ArgumentList  "/i", "C:\tmp\go1.7.1.windows-amd64.msi", "/passive"
    ReloadPathFromRegistry
    if( !(get-command -ea 0 go.exe) ) { return write-error "No GO in PATH." }
}

# install glide
if( !(get-command -ea 0 glide.exe) ) {
    write-host -fore cyan "Info: Downloading Glide"
    (New-Object System.Net.WebClient).DownloadFile("https://github.com/Masterminds/glide/releases/download/v0.11.1/glide-v0.11.1-windows-amd64.zip", "c:\tmp\glide-v0.11.1-windows-amd64.zip" )
    if( !(test-path -ea 0  "c:\tmp\glide-v0.11.1-windows-amd64.zip" ) ) { return write-error "Unable to download Glide" }
    write-host -fore darkcyan "      Unpacking Glide."
    Expand-Archive C:\tmp\glide-v0.11.1-windows-amd64.zip -DestinationPath c:\glide
    write-host -fore darkcyan "      adding glide to system PATH."
    $p = ([System.Environment]::GetEnvironmentVariable( "path", 'Machine'))
    $p = "$p;C:\glide\windows-amd64"
    ([System.Environment]::SetEnvironmentVariable( "path", $p,  'Machine'))
    ReloadPathFromRegistry
    if( !(get-command -ea 0 glide.exe) ) { return write-error "No glide in PATH." }
}

# install git 
if( !(get-command -ea 0 git) ) { 
    write-host -fore cyan "Info: Installing GIT"
    $null = install-package -provider chocolatey git -force
    if( !(get-command -ea 0 git) ) { return write-error "No git in PATH." }
    # it also needs to be in x86. 
    write-host -fore darkcyan "      Putting git in x86 program files too."
    robocopy /mir "c:\program files\git" "c:\program files (x86)\git"
}

write-host -fore cyan "Info: Fixing firewall rules for languages/tools"
@("java", "javaw", "javaws", "node", "ruby", "go", "glide" ) |% { $app = ((get-command -ea 0 $_).source); $null= netsh firewall add allowedprogram  "$app" "$app" ENABLE }

# visual studio community
if( ! (test-path  -ea 0 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\' ) ) {
    write-host -fore cyan "Info: Downloading VS_Community"
    (New-Object System.Net.WebClient).DownloadFile("https://download.microsoft.com/download/0/B/C/0BC321A4-013F-479C-84E6-4A2F90B11269/vs_community.exe" , "c:\tmp\vs_community.exe")
    if( !(test-path -ea 0 "c:\tmp\vs_community.exe") ) { return write-error "Unable to download VS 2015 community" }
    write-host -fore darkcyan "      Installing VS Community (full install) -- this may take around 90 minutes"
    C:\tmp\vs_community.exe /full /norestart /q
    while( get-process vs_*  ) { write-host -NoNewline "." ; sleep 1 }
}

# disable strong naming on the build server.
write-host -fore cyan "Info: Turning off strong name verification (for testing)"
$null = &"C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\sn.exe" -Vr *
$null = &"C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\x64\sn.exe" -Vr *

# visual studio code
if( !(get-command -ea 0 code) ) {
    write-host -fore cyan "Info: Downloading Visual Studio Code"
    (New-Object System.Net.WebClient).DownloadFile("https://go.microsoft.com/fwlink/?LinkID=623230", "c:\tmp\vs_code.exe" )
    if( !(test-path -ea 0 "c:\tmp\vs_code.exe" ) ) { return write-error "Unable to download VS code" }
    write-host -fore darkcyan "      Installing VS Code"
    C:\tmp\vs_code.exe /silent /norestart
    while( get-process vs_*  ) { write-host -NoNewline "." ; sleep 1 }
    ReloadPathFromRegistry
    if( !(get-command -ea 0 code) ) { return write-error "No VS Code in PATH." }
}

# install wix
if (!(get-command -ea 0 heat.exe) ) {
    write-host -fore cyan "Info: Downloading Wix Toolset."
    (New-Object System.Net.WebClient).DownloadFile("http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=wix&DownloadId=1587179&FileTime=131118854865270000&Build=21031", "c:\tmp\wix310.exe")
    if( !(test-path -ea 0 "c:\tmp\wix310.exe" ) ) { return write-error "Unable to download Wix Toolset" }
    write-host -fore darkcyan "      Installing Wix Toolset"
    C:\tmp\wix310.exe /passive /noreboot
    while( get-process wix*  ) { write-host -NoNewline "." ; sleep 1 }
    write-host -fore darkcyan "      adding Wix Toolset to system PATH."
    $p = ([System.Environment]::GetEnvironmentVariable( "path", 'Machine'))
    $p = "$p;C:\Program Files (x86)\WiX Toolset v3.10\bin"
    ([System.Environment]::SetEnvironmentVariable( "path", $p,  'Machine'))
    ReloadPathFromRegistry
    if (!(get-command -ea 0 heat.exe) ) { return "No Wix Toolset in path." }
}

# dotnet cli
if( !(get-command -ea 0 dotnet) ) {
    write-host -fore cyan "Info: Downloading Visual Studio Code"
    (New-Object System.Net.WebClient).DownloadFile("https://go.microsoft.com/fwlink/?LinkId=817245", "c:\tmp\dotnet-cli.exe" );
    if( !(test-path -ea 0 "c:\tmp\dotnet-cli.exe" ) ) { return write-error "Unable to download dotnet-cli" }
    write-host -fore darkcyan "      Installing Dotnet-cli"
    C:\tmp\dotnet-cli.exe /install /passive /noreboot SKIP_VSU_CHECK=1
    while( get-process dotnet-*  ) { write-host -NoNewline "." ; sleep 1 }
    ReloadPathFromRegistry
    if( !(get-command -ea 0 dotnet) ) { return write-error "No dotnet.exe in PATH." }
}

write-host -fore green  "You should restart this computer now. (ie, type 'RESTART-COMPUTER' )"
return 

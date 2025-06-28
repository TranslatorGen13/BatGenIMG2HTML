::Ver 1.15
@Echo off
SetLocal EnableExtensions DisableDelayedExpansion

::Запоминание кодировки для возращения старой кодировки по завершению скрипта 
for /f "tokens=2 delims=:." %%a in ('chcp') do set "kodstr=%%a"
chcp 65001 > NUL

title Сгенерировать HTML для просмотра 
::Константы
set OutFile=Просмотр.html
set TempFile=temp.html
::Форматы изображений для вставки, можно заменить на маску имени необходимых картинок
set Templates="*.jpg" "*.jpeg" "*.png" "*.gif" "*.bmp" "*.tiff" "*.tif" "*.webp" "*.svg" "*.raw" "*.heic" "*.heif" "*.avif"
::Удаление старого файла просмотра
if exist %OutFile% (del %OutFile%)
::Поиск начала html кода в этом файле
for /f "delims=[]" %%N in ('find /n "HTMLCodeFirstStart" ^<"%~f0"') do set /a sta=%%N
::Вставка всего html кода во временный файл
more +%sta% >%TempFile% <"%~f0"
::Посточное копирование временного файла с втавкой картинок (функция Insert) вместо тега InsertImages
for /f "tokens=*" %%x in (%TempFile%) do (
	if "%%x"=="::-InsertImages-" (call :Insert)else echo %%x>>%OutFile%
)
del %TempFile%

::Запрос на открытие документа в браузере по умолчанию
set "isLaunch=Y"
set /p isLaunch="Открыть сгенерированную страницу?(По умолчанию Y) Y/N "
if %isLaunch%==Y (start %OutFile%)
chcp %kodstr% > NUL
EndLocal
goto :eof

:Insert
REM dir /a-d /B /N /O:N /S %Templates%
set /a counter=0
::Включение режима отложенного расширения для подстановки текущих переменных внутри цикла
setlocal EnableDelayedExpansion
::Вставка картинок в незавершённый html файл вывода
for /f "delims=" %%a In ('dir /a-d /B /N /O:N /S %Templates%') do (
	set /a counter= !counter!+1
	set Out=^<div class="container"^>^<div class="Number"^>^<div class="text"^>!counter!^</div^>^</div^>^<img src="%%~nxa"^>^</div^>
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
.holder img {max-width: 90%;}
.Number {
opacity: 0.4;
background: #343434;
border: 0.1em solid #141414;
color: #fff;
margin: 0 0 -2.2em 75vw;
position: sticky;
top: 92vh;
height: 2em;
width: 2em;
border-radius: 100%;
}
.Number:hover {
opacity: 1;
}
.text {
text-align: center;
margin: 0.5em 0 0.5em 0;
}
</style>
</head>
<body align=center style="background:#343434;">
<div class="main" style="width: 90%;display: block; margin: auto;">
<div class="holder" id="content">
::-InsertImages-
</div></div></body></html>

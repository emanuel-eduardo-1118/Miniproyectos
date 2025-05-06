@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion
echo Escriba la extensión del archivo sin .
set /p filter=""
echo Escriba una palabra que contenga el archivo a buscarse
set /p word_filter=""
echo Pegue la ruta del directorio donde se encuentra el archivo
set /p "origin_rute= "
if exist !origin_rute! (
    echo Si el archivo se encuentra dentro de una sub carpeta, escribala el nombre de esa subcarpeta:
    set /p "sub_folder="
) else (
    echo Ruta no existe, intente denuevo.
)
echo Desde la carpeta N°:
set /p "range_one="
echo Hasta la carpeta N°: 
set /p "range_two="
set check=0
echo Escriba 1 para encontrar coincidencias o 2 para encontrar faltantes
set /p choose=""

for /d %%d in ("!origin_rute!\*") do (
    set /a check+=1
    if !check! geq !range_one! if !check! leq !range_two! (
        set count=0
        set "archive="
        for %%f in ("%%d\%sub_folder%*.!filter!") do (
            echo %%~nxf | findstr /r /i "\<%word_filter%\>" >nul
            if !errorlevel! equ 0 (
                set /a count+=1
                if defined archive (
                    set "archive=!archive! - %%~nxf"
                ) else (
                    set "archive=%%~nxf"
                )
            )
        )
        if !count! GTR 0 (
            if "!choose!"=="1" (
                echo Archivo !archive! encontrado en %%~nxd
            )
        ) else if !count! EQU 0 (
            if "!choose!"=="2" (
                echo No se encontro el archivo en: %%~nxd
            ) 
        )
    )
)
goto fin
    
:fin
echo "Finalizó el programa"
pause

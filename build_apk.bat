@echo off
setlocal enabledelayedexpansion

REM Definir variáveis de ambiente
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
set ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk

REM Limpar build anterior
echo Limpando build anterior...
call flutter clean

REM Obter dependências
echo Obtendo dependências...
call flutter pub get

REM Gerar APK de debug
echo Gerando APK de debug...
call flutter build apk --debug

REM Verificar se foi gerado com sucesso
if exist "build\app\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ========================================
    echo APK gerado com sucesso!
    echo ========================================
    echo Localização: build\app\outputs\apk\debug\app-debug.apk
    echo.
    pause
) else (
    echo.
    echo ========================================
    echo ERRO: APK não foi gerado!
    echo ========================================
    echo.
    pause
)

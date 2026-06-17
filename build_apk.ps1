$ErrorActionPreference = "Stop"

# Definir variáveis de ambiente
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:ANDROID_HOME = "$env:USERPROFILE\AppData\Local\Android\Sdk"

# Adicionar Flutter ao PATH
$flutterPath = "C:\src\flutter\bin"
if (Test-Path $flutterPath) {
    $env:PATH = "$flutterPath;$env:PATH"
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "Gerando APK com rastreamento em tempo real" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Limpar build anterior
Write-Host "Limpando build anterior..." -ForegroundColor Yellow
& flutter clean

# Obter dependências
Write-Host "Obtendo dependências..." -ForegroundColor Yellow
& flutter pub get

# Gerar APK de debug
Write-Host "Gerando APK de debug..." -ForegroundColor Yellow
& flutter build apk --debug

# Verificar se foi gerado com sucesso
$apkPath = "build\app\outputs\apk\debug\app-debug.apk"
if (Test-Path $apkPath) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "APK gerado com sucesso!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Localização: $apkPath" -ForegroundColor Cyan
    Write-Host ""
    
    # Mostrar tamanho do arquivo
    $size = (Get-Item $apkPath).Length / 1MB
    Write-Host "Tamanho: $([Math]::Round($size, 2)) MB" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "ERRO: APK não foi gerado!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    exit 1
}

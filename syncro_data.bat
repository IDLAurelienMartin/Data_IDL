@echo off
REM ===============================================
REM Script de backup automatique vers GitHub
REM ===============================================

REM --- Chemins ---
set SOURCE="C:\Users\aumartin\Google Drive\DossierPartage"
set DEST="C:\Users\aumartin\Desktop\VSCode\Data_app"

REM --- Copier les fichiers depuis le Drive ---
xcopy %SOURCE% %DEST% /s /y /i
echo Fichiers copiés dans le dépôt local.

REM --- Se déplacer dans le dépôt Git ---
cd /d %DEST%

REM --- Ajouter les fichiers au suivi Git ---
git add .

REM --- Commit avec date et heure ---
for /f "tokens=1-4 delims=/: " %%a in ("%date% %time%") do set DATETIME=%%a-%%b-%%c_%%d
git commit -m "Backup automatique %DATETIME%"

REM --- Push vers GitHub ---
git push origin main

echo Sauvegarde et push GitHub terminés !
pause

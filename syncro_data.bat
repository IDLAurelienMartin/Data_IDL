@echo off
REM ===============================================
REM Script de backup automatique vers GitHub
REM ===============================================

REM --- Chemins ---
set "SOURCE=C:\Users\aumartin\OneDrive - ID Logistics\Data_app"
set "DEST=C:\Users\aumartin\Desktop\VSCode\Data_app"

REM --- Copier les fichiers depuis le Drive ---
xcopy "%SOURCE%" "%DEST%" /s /y /i
echo Fichiers copiés dans le dépôt local.

REM --- Se déplacer dans le dépôt Git ---
cd /d "%DEST%"

REM --- Définir la date et l'heure ---
for /f "tokens=1-4 delims=/: " %%a in ("%date% %time%") do set DATETIME=%%a-%%b-%%c_%%d

REM --- Ajouter les fichiers au suivi Git ---
git add .

REM --- Commit si nécessaire ---
git diff --cached --quiet || git commit -m "Backup automatique %DATETIME%"

REM --- Forcer la synchro : la version locale écrase la version distante ---
git fetch origin main
git reset --soft origin/main
git checkout --ours .
git add .
git commit -m "Résolution automatique des conflits - %DATETIME%"
git push origin main --force

echo Sauvegarde et push GitHub terminés !
pause

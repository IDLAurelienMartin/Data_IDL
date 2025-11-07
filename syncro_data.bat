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

REM --- Mettre à jour le dépôt local sans supprimer de fichiers locaux ---
git fetch origin main
git merge origin/main --no-edit

REM --- Ajouter uniquement les fichiers nouveaux ou non suivis ---
for /f "delims=" %%f in ('git ls-files --others --exclude-standard') do git add "%%f"

REM --- Commit seulement s’il y a des fichiers ajoutés ---
git diff --cached --quiet || git commit -m "Ajout fichiers manquants %DATETIME%"

REM --- Push vers GitHub ---
git push origin main

echo Sauvegarde et push GitHub terminés !
pause

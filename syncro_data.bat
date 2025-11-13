@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM === BACKUP AUTOMATIQUE + PUSH FORCE AVEC DATE MODIFICATION ==
REM ============================================================

REM --- Chemins ---
set UNC_DEST="\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\Data_app"
set BACKUP_DIR="Data_app_backup_remote"
set FOLDER1="\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\2 - Mvt Stock\1 - Compilation"
set FOLDER2="\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\5 - Historique des Sorties\1 - Compilation"
set FOLDER3="\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\8 - Ecart MMS\2 - Archives"
set FOLDER4="\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\6 - Historique Reception\1 - Compilation"

REM --- Se placer dans le dossier réseau avec pushd ---
pushd "%UNC_DEST%" || (
    echo Erreur : impossible d'accéder à %UNC_DEST%
    pause
    exit /b
)

REM --- Copier les fichiers locaux ---
xcopy %FOLDER1% "%CD%\Mvt_Stock" /s /y /i >nul
xcopy %FOLDER2% "%CD%\Historique_des_Sorties" /s /y /i >nul
xcopy %FOLDER3% "%CD%\Ecart_Stock" /s /y /i >nul
xcopy %FOLDER4% "%CD%\Historique_Reception" /s /y /i >nul

echo Fichiers copiés dans le dépôt local.

REM --- Vérifier que c’est un dépôt Git ---
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo Erreur : %CD% n’est pas un dépôt Git valide.
    popd
    pause
    exit /b
)

REM --- Backup du dépôt distant ---
echo Création du backup du dépôt distant...
if exist "%CD%\%BACKUP_DIR%" rd /s /q "%CD%\%BACKUP_DIR%"
git clone --mirror https://github.com/IDLAurelienMartin/Data_IDL "%CD%\%BACKUP_DIR%" >nul 2>&1
echo Backup distant créé dans %BACKUP_DIR%

REM --- Commit détaillé par fichier avec date de modification ---
for /f "delims=" %%F in ('git ls-files --others --exclude-standard') do (
    REM Récupérer date et heure du fichier
    for /f "tokens=1-3 delims=/ " %%A in ('forfiles /P "%CD%\%%~dpF" /M "%%~nxF" /C "cmd /c echo @fdate @ftime"') do (
        set FILEDATE=%%C-%%B-%%AT%%D
        set GIT_AUTHOR_DATE=!FILEDATE!
        set GIT_COMMITTER_DATE=!FILEDATE!
        git add "%%F"
        git commit -m "Ajout de %%F avec date de modification originale" --date "!FILEDATE!"
    )
)

REM --- Ajouter et committer tous les fichiers déjà suivis ---
git add -A
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Backup automatique local"
)

REM --- Push forcé vers GitHub ---
echo Push forcé vers GitHub...
git push origin main --force

echo ===========================================
echo Sauvegarde et push forcé terminés !
echo Backup distant sauvegardé dans %BACKUP_DIR%
echo ===========================================

popd
pause


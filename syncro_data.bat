@echo off
chcp 1252 >nul
echo ==============================================
echo   SYNCHRONISATION VERS ONEDRIVE - %date% %time%
echo ==============================================

:: --- 1er dossier ---
robocopy "\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\2 - Mvt Stock\1 - Compilation" ^
"C:\Users\aumartin\OneDrive - ID Logistics\Data_app\Mvt_stock" /E /XO

:: --- 2e dossier ---
robocopy "\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\5 - Historique des Sorties\1 - Compilation" ^
"C:\Users\aumartin\OneDrive - ID Logistics\Data_app\Historique_des_Sorties" /E /XO

:: --- 3e dossier ---
robocopy "\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\6 - Historique Reception\1 - Compilation" ^
"C:\Users\aumartin\OneDrive - ID Logistics\Data_app\Historique_Reception" /E /XO

:: --- 4e dossier ---
robocopy "\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser\8 - Ecart MMS\2 - Archives" ^
"C:\Users\aumartin\OneDrive - ID Logistics\Data_app\Ecart_Stock" /E /XO

:: --- 5e fichier : Article_euros.xlsx ---
robocopy "\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser" ^
"C:\Users\aumartin\OneDrive - ID Logistics\Data_app" "Article_euros.xlsx" /XO

:: --- 6e fichier : Inventory_21_09_2025.xlsx ---
robocopy "\\spwfs-metbre\Partage\07_Gestion_Des_Stocks\02 - Fichiers Synchro\1 - Fichiers a Actualiser" ^
"C:\Users\aumartin\OneDrive - ID Logistics\Data_app" "Inventory_21_09_2025.xlsx" /XO

echo.
echo ==============================================
echo   SYNCHRONISATION TERMINEE - %date% %time%
echo ==============================================
pause

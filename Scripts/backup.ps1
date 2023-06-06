######################################
##############Var Configs#############
######################################
$BackupConfig = "C:\BackupScript\Config\BackupConfig.csv"
$BackupRapport = "C:\BackupScript\Config\BackupRapport.csv"

$DayFile = Get-Date -Format "dd"
$MonthFile = Get-Date -Format "MM"
$YearFile = Get-Date -Format "yyyy"

$ScriptPath = "C:\BackupScript\Scripts\backup.ps1"
$UserAdmin = "AHB\Administrator"
$dest   = "C:\BackupScript\BackupFiles\" + $DayFile + "-" + $MonthFile + "-" + $YearFile + "\"

$Delimiter = ";"

######################################
######################################
######################################

#

######################################
############ SheduledTask ############
######################################
$taskName = "Backup"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName } # Recherche de la task Backup

if($taskExists) { # Si elle existe alors






######################################
###########Etat des machines##########
######################################


# Importation des fichiers csv
$machines = import-csv -Path $BackupConfig -Delimiter $Delimiter
$Services = import-csv -Path $BackupRapport -Delimiter $Delimiter

# Boucle a travers chaque machine
foreach ($machine in $machines) {
    $nomMachine = $machine.PC

    # Verifier l'etat de la machine
    $etatMachine = "Inconnu"
    if (Test-Connection -ComputerName $nomMachine -Count 1 -Quiet) {
        $etatMachine = "Online"
    } else {
        $etatMachine = "Offline"
    }

    # Enregistrer l'etat de la machine dans le fichier CSV
    $machine.Status = $etatMachine
}

# Export les modifications dans le fichier CSV
$machines | Export-Csv -Path $BackupConfig -NoTypeInformation -Delimiter $Delimiter

######################################
######################################
######################################

#

######################################
################Robocopy##############
######################################


# Reimportation du fichier csv pour le mettre a jour
$csvconfigs = import-csv -Path $BackupConfig -Delimiter $Delimiter



    $day = Get-Date -Format "dddd" # Stock le jour actuel
    $hour = Get-Date -Format hh:mm # Stock l'heure actuelle
    $TodayBackup = $csvconfigs -match $day # Verification si le jour actuel est egal au jour dans le fichier csv
    $TodayHour = $TodayBackup | Where-Object {$_.hour -le $hour} # Verification si l'heure actuelle est inferieur ou egal a l'heure dans le fichier csv


    foreach ($list in $TodayHour) { # Boucle a travers chaque machine

    $Computer = $list.PC # Stock les nom des machine
    $Date = Get-Date -Format dd.MM.yyyy # Stock la date actuelle
    $etatMachine = $list.Status # Stock l'etat de la machine


## Si machine en ligne alors

    if ($etatMachine -eq "Online") {
        #
        $source = "\\" + $list.PC + "\c$\" + $list.BackupDirectory
        $desti = $dest + $list.PC
        robocopy "$source" "$desti" /E /SEC /ZB
        #
        #Ajout de la ligne de rapport dans le fichier CSV
        #$newRow = New-Object PsObject -Property @{ Computer = $Computer ; MoyenEnService = 'Oui' ; Date = $Date ; EtatDeLaSauvegarde = "Reussi" }
        #$Services += $newRow
        #$Services | Export-Csv -Path $BackupRapport -NoTypeInformation -Delimiter $Delimiter
        "$Computer;Oui;$Date;Reussi;-" | Out-File -FilePath "$BackupRapport" -Encoding UTF8 -Append
        #
        #Si la sauvegarde a reussi alors
        if (($LASTEXITCODE -eq 0) -or ($LASTEXITCODE -eq 1) -or ($LASTEXITCODE -eq 2) -or ($LASTEXITCODE -eq 3) -or ($LASTEXITCODE -eq 4) -or ($LASTEXITCODE -eq 5) -or ($LASTEXITCODE -eq 6) -or ($LASTEXITCODE -eq 7)) {

            Read-Host "La sauvegarde sur la machine $Computer a reussi."

        }
        #Sinon
        else {
        Read-Host "La sauvegarde sur la machine $Computer a Echoue."
        #$newRow = New-Object PsObject -Property @{ Computer = $Computer ; MoyenEnService = 'Non' ; Date = $Date ; EtatDeLaSauvegarde = "Erreur" ; CodeErreur = $LASTEXITCODE }
        #$Services += $newRow
        #$Services | Export-Csv -Path $BackupRapport -NoTypeInformation -Delimiter $Delimiter
        "$Computer;Non;$Date;Erreur;$LASTEXITCODE" | Out-File -FilePath "$BackupRapport" -Encoding UTF8 -Append
        }




        #### hors ligne


        } elseif ($etatMachine -eq "Offline") {
                Read-Host "La machine $nomMachine est hors ligne. La sauvegarde est impossible."
                #$newRow = New-Object PsObject -Property @{ Computer = $Computer ; MoyenEnService = 'Non' ; Date = $Date ; EtatDeLaSauvegarde = "Ok" }
                #$Services += $newRow
                #$Services | Export-Csv -Path $BackupRapport -NoTypeInformation -Delimiter $Delimiter
                "$Computer;Non;$Date;Erreur;-" | Out-File -FilePath "$BackupRapport" -Encoding UTF8 -Append
        } else {
                Read-Host "L'Etat de la machine $nomMachine est invalide dans le fichier CSV."
                #$newRow = New-Object PsObject -Property @{ Computer = $Computer ; MoyenEnService = 'Non' ; Date = $Date ; EtatDeLaSauvegarde = "Ok" }
                #$Services += $newRow
                #$Services | Export-Csv -Path $BackupRapport -NoTypeInformation -Delimiter $Delimiter
                "$Computer;Non;$Date;Erreur;-" | Out-File -FilePath "$BackupRapport" -Encoding UTF8 -Append
    }
}

################################################################################################


} else {

### Creation de l'execution automatique du script

$action = New-ScheduledTaskAction -Execute 'powershell' -Argument "-File $ScriptPath"

$trigger = @(
    $(New-ScheduledTaskTrigger -Daily -At 11am),
    $(New-ScheduledTaskTrigger -Daily -At 16pm)
)

Register-ScheduledTask -TaskName "Backup" -Description "Backup journaliere" -Trigger $trigger -User $UserAdmin -Action $action
}
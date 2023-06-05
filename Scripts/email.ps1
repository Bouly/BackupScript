$Date = Get-Date -Format dd.MM.yyyy
$smtpServer = "157.26.80.25"
$EmailFrom = "BackupScript@ceff.ch"
$EmailTo = "ahmed.boulahdjar@ceff.ch"
$emailSubject = "Rapport Backup du $Date"
$emailBody = "Veuillez trouver ci-dessous le rapport de la backup du $Date :"

$DayFile = Get-Date -Format "dd"
$MonthFile = Get-Date -Format "MM"
$YearFile = Get-Date -Format "yyyy"

$UserAdmin = "AHB\Administrator"

######################################
############ SheduledTask ############
######################################

$taskName = "EmailBackup"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName } # Recherche de la task Backup

if($taskExists) { # Si elle existe alors


# Chemin du fichier CSV
$MovePath = "C:\backup\Rapports\" + $DayFile + "-" + $MonthFile + "-" + $YearFile + ".csv"
$csvPath = "C:\backup\Config\BackupRapport.csv"
# Fonction pour convertir les données CSV en tableau HTML avec style
function ConvertTo-HtmlTable {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Object[]]$Data
    )
    
######################################
################ HTML ################
######################################

    $htmlTable = @"
<table class="styled-table">
  <thead>
  <style>
  .styled-table {
    border-collapse: collapse;
    margin: 25px 0;
    font-size: 0.9em;
    font-family: sans-serif;
    min-width: 400px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
    border: 1px solid #ffffff;
  }
  .styled-table thead tr {
    background-color: #282D3C;
    color: #ffffff;
    text-align: left;
    border: 1px solid #ffffff;
  }
  .styled-table th,
  .styled-table td {
    padding: 12px 15px;
    border: 1px solid #ffffff;
  }
  .error-row {
    background-color: #9B2335;
    color: #ffffff;
  }
  .ok-row {
    background-color: #EFC050;
    color: #ffffff;
  }
  .success-row {
    background-color: #009B77;
    color: #ffffff;
  }
  .styled-table tbody tr:nth-child(even) {
    background-color: #f3f3f3;
  }
  .styled-table tbody tr:hover {
    background-color: #009879;
    color: #ffffff;
  }
</style>
"@
    
    # En-têtes de colonnes
    $htmlTable += "<tr>"
    foreach ($header in $Data[0].PSObject.Properties.Name) {
        $htmlTable += "<th>$header</th>"
    }
    $htmlTable += "</tr>"
    
    $htmlTable += "</thead><tbody>"
    
    # Lignes de données
    foreach ($row in $Data) {
        $htmlTable += "<tr"
        switch ($row.EtatDeLaSauvegarde) {
            "Erreur" {
                $htmlTable += " class='error-row'"
            }
            "OK" {
                $htmlTable += " class='ok-row'"
            }
            "Reussi" {
                $htmlTable += " class='success-row'"
            }
        }
        $htmlTable += ">"
        foreach ($property in $row.PSObject.Properties) {
            $htmlTable += "<td>$($property.Value)</td>"
        }
        $htmlTable += "</tr>"
    }
    
    $htmlTable += "</tbody></table>"
    
    return $htmlTable
}

# Lecture du fichier CSV
$data = Import-Csv -Path $csvPath -Delimiter ";"

# Conversion des données en tableau HTML avec style
$htmlTable = ConvertTo-HtmlTable -Data $data

# Construction du corps de l'e-mail avec le tableau HTML
$emailBodyWithTable = "<html><body><p>$emailBody</p><br />$htmlTable</body></html>"

# Envoi de l'e-mail
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $emailBodyWithTable -BodyAsHtml -SmtpServer $SmtpServer

Move-Item -Path $csvPath -Destination $MovePath
Copy-Item -Path C:\backup\Config\Default-BackupRapport.csv -Destination C:\backup\Config\BackupRapport.csv

} else {

### Execution automatique du script

$action = New-ScheduledTaskAction -Execute 'powershell' -Argument '-File C:\script\backup.ps1'

$trigger = New-ScheduledTaskTrigger -Daily -At 1pm

Register-ScheduledTask -TaskName "EmailBackup" -Description "Backup Email" -Trigger $trigger -User $UserAdmin -Action $action
}
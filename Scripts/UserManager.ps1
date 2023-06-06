Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$PathUserManager = "C:\Users\cp-20ahb\Desktop\config.csv"

# Create a form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Backup User Management"
$Form.Size = New-Object System.Drawing.Size(585, 365)
# Étire automatiquement la fenêtre
$Form.AutoSize         = $true
# Centre la fênetre lors du lancement du script
$Form.StartPosition= 'CenterScreen'
# Couleur du fond
$Form.BackColor        = '38,36,49'
# Design de la fênetre
$main_form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
# Icon du GUI
#$main_form.Icon             = [System.Drawing.Icon]::ExtractAssociatedIcon("$CurrentPath\logo.ico") 
# Bloque la taille max et min
$Form.minimumSize      = New-Object System.Drawing.Size(385,265)
$Form.maximumSize      = New-Object System.Drawing.Size(385,265)


# Création des contrôles pour le nom, le jour et l'heure
$LabelName = New-Object System.Windows.Forms.Label
$LabelName.Location = New-Object System.Drawing.Point(10,20)
$LabelName.Size = New-Object System.Drawing.Size(100,20)
$LabelName.Text = "Nom"
$LabelName.ForeColor = "white"
$LabelName.Font      = "Bahnschrift, 16"
$Form.Controls.Add($LabelName)

$TextBoxName = New-Object System.Windows.Forms.TextBox
$TextBoxName.Location = New-Object System.Drawing.Point(120,20)
$TextBoxName.Size = New-Object System.Drawing.Size(200,20)
# Design du champ de text
$TextBoxName.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$Form.Controls.Add($TextBoxName)

##

$LabelDirectory = New-Object System.Windows.Forms.Label
$LabelDirectory.Location = New-Object System.Drawing.Point(10,50)
$LabelDirectory.Size = New-Object System.Drawing.Size(100,20)
$LabelDirectory.Text = "Directory"
$LabelDirectory.ForeColor = "white"
$LabelDirectory.Font      = "Bahnschrift, 16"
$Form.Controls.Add($LabelDirectory)

$TextBoxDirectory = New-Object System.Windows.Forms.TextBox
$TextBoxDirectory.Location = New-Object System.Drawing.Point(120,50)
$TextBoxDirectory.Size = New-Object System.Drawing.Size(200,20)
# Design du champ de text
$TextBoxDirectory.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$Form.Controls.Add($TextBoxDirectory)

##


$LabelDay = New-Object System.Windows.Forms.Label
$LabelDay.Location = New-Object System.Drawing.Point(10,80)
$LabelDay.Size = New-Object System.Drawing.Size(100,20)
$LabelDay.Text = "Jour"
$LabelDay.ForeColor = "white"
$LabelDay.Font      = "Bahnschrift, 16"
$Form.Controls.Add($LabelDay)

$TextBoxDay = New-Object System.Windows.Forms.TextBox
$TextBoxDay.Location = New-Object System.Drawing.Point(120,80)
$TextBoxDay.Size = New-Object System.Drawing.Size(200,20)
# Design du champ de text
$TextBoxDay.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$Form.Controls.Add($TextBoxDay)

$LabelTime = New-Object System.Windows.Forms.Label
$LabelTime.Location = New-Object System.Drawing.Point(10,110)
$LabelTime.Size = New-Object System.Drawing.Size(100,20)
$LabelTime.Text = "Heure"
$LabelTime.ForeColor = "white"
$LabelTime.Font      = "Bahnschrift, 16"
$Form.Controls.Add($LabelTime)

$TextBoxTime = New-Object System.Windows.Forms.TextBox
$TextBoxTime.Location = New-Object System.Drawing.Point(120,110)
$TextBoxTime.Size = New-Object System.Drawing.Size(200,20)
# Design du champ de text
$TextBoxTime.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$Form.Controls.Add($TextBoxTime)

# Création des boutons pour ajouter et supprimer un utilisateur
$ButtonAdd = New-Object System.Windows.Forms.Button
$ButtonAdd.Location = New-Object System.Drawing.Point(10,150)
$ButtonAdd.Size = New-Object System.Drawing.Size(100,30)
$ButtonAdd.Text = "Ajouter"
#Police et taille du text
$ButtonAdd.Font      = "Bahnschrift, 13"
#Couleur du text
$ButtonAdd.BackColor = "153, 152, 246"
#Deisgn du button
$ButtonAdd.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
#Couleur du text
$ButtonAdd.ForeColor = "243, 244, 247"
$ButtonAdd.Add_Click({
    $PC = $TextBoxName.Text
    $BackupDirectory = $TextBoxDirectory.Text
    $day = $TextBoxDay.Text
    $time = $TextBoxTime.Text

    # Vérifier si le fichier CSV existe
    if (!(Test-Path "$PathUserManager")) {
        # Créer le fichier CSV avec les en-têtes
        "PC;BackupDirectoryPC;Day;Hour;Status" | Out-File -FilePath "$PathUserManager" -Encoding UTF8
    }

    # Ajouter une nouvelle ligne dans le fichier CSV
    "$PC;$BackupDirectory;$day;$time" | Out-File -FilePath "$PathUserManager" -Encoding UTF8 -Append

    # Effacer les valeurs des champs
    $TextBoxName.Text = ""
    $TextBoxDirectory.Text = ""
    $TextBoxDay.Text = ""
    $TextBoxTime.Text = ""
})
$Form.Controls.Add($ButtonAdd)

$ButtonRemove = New-Object System.Windows.Forms.Button
$ButtonRemove.Location = New-Object System.Drawing.Point(120,150)
$ButtonRemove.Size = New-Object System.Drawing.Size(100,30)
$ButtonRemove.Text = "Supprimer"
#Police et taille du text
$ButtonRemove.Font      = "Bahnschrift, 13"
#Couleur du text
$ButtonRemove.BackColor = "153, 152, 246"

$ButtonRemove.TextAlign = [System.Drawing.ContentAlignment]::TopCenter

#Deisgn du button
$ButtonRemove.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
#Couleur du text
$ButtonRemove.ForeColor = "243, 244, 247"
$ButtonRemove.Add_Click({
    $PC = $TextBoxName.Text

    # Vérifier si le fichier CSV existe
    if (Test-Path "$PathUserManager") {
        # Lire le contenu du fichier CSV
        $users = Import-Csv -Path "$PathUserManager" -Delimiter ";"

        # Rechercher l'utilisateur par nom
        $user = $users | Where-Object { $_.PC -eq $PC }

        if ($user) {
            # Supprimer l'utilisateur du tableau
            $users = $users | Where-Object { $_.PC -ne $PC }

            # Enregistrer les modifications dans le fichier CSV
            $users | Export-Csv -Path "$PathUserManager" -Delimiter ";" -NoTypeInformation -Encoding UTF8

            # Effacer les valeurs des champs
            $TextBoxName.Text = ""
            $TextBoxDirectory.Text = ""
            $TextBoxDay.Text = ""
            $TextBoxTime.Text = ""

            [System.Windows.Forms.MessageBox]::Show("L'utilisateur a été supprimé avec succès.")
        } else {
            [System.Windows.Forms.MessageBox]::Show("L'utilisateur n'a pas été trouvé.")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Aucun fichier utilisateurs.csv trouvé.")
    }
})
$Form.Controls.Add($ButtonRemove)

# Afficher la fenêtre principale
$Form.ShowDialog()
# BackupScript **[not finished]**

<p align="center">
A simple automated script to back up file with some features
</p>

# ![#581845](https://placehold.co/15x15/581845/581845.png) Installation

1️⃣ Place the script on C:\

2️⃣ Rename the folder BackupScript (remove -main)

3️⃣ Add user with UserManager.ps1

*If you launch backup.ps1 and email.ps1 for the first time, it will add a new task scheduler and the backup script will start automatically twice a day. The email script will start every Friday.*

*If your dont have acces to the computer the backup will not work*

Configure the script if needed ⤵️

# ![#48A14D](https://placehold.co/15x15/48A14D/48A14D.png) Configs

<p align="center">
To use the script correctly, you must configure the following files
</p>
  
## ![#48A14D](https://placehold.co/15x15/48A14D/48A14D.png) **Add user on BackupConfig.csv file**

<p align="center">
You can use UserManager.ps1 Script to add user easily
</p>
  
### • PC 
  The name of the computer

### • BackupDirectory       
  The path of the backup directory *(exemple: C:\Bouly\Documentation)*

### • Day                
  The backup day

### • Hour                  
  The backup hour *(if the backup script start and the hour has passed)*

### • Status                
  The script will automatically fill this field

## ![#48A14D](https://placehold.co/15x15/48A14D/48A14D.png) **Config de backup.ps1**

### • $UserAdmin

  Enter your Administrator user

## ![#48A14D](https://placehold.co/15x15/48A14D/48A14D.png) **Config de email.ps1**

### • $smtpServer

  Enter your smtp server

### • $EmailFrom

  Enter the email sender

### • $EmailTo

  Enter the email receiver

### • $emailSubject

  You can change the subject email

### • $emailBody

  You can change the body email

# ![#1589F0](https://placehold.co/15x15/1589F0/1589F0.png) Features

## ![#1589F0](https://placehold.co/15x15/1589F0/1589F0.png) **A small script to add user**

<p align="center">
A script to add and remove user from a CSV
</p>

<p align="center">
  <img src="https://github.com/Bouly/BackupScript/assets/94909482/9b3ace8e-71c0-499c-b83a-c33943fbcdd0"/>
</p>
  
## ![#1589F0](https://placehold.co/15x15/1589F0/1589F0.png) **Check computer state**

<p align="center">
Check if the computer is Online to make the backup or not
</p>
  
## ![#1589F0](https://placehold.co/15x15/1589F0/1589F0.png) **Weekly email report**

<p align="center">
  A script to send email with backup status
</p>

<p align="center">
  <img src="https://github.com/Bouly/BackupScript/assets/94909482/d5af72bf-0f2f-4fe7-b195-7a505dbcce95"/>
</p>

# ![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) How it works

## ![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) Backup

<p align="center">
<img src="https://github.com/Bouly/BackupScript/assets/94909482/a0b0ae47-6614-4162-b155-12564cea45ad"/>
</p>

## ![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) Email

<p align="center">
<img src="https://github.com/Bouly/BackupScript/assets/94909482/78b84b54-5e4f-4afe-bc1a-f902aa3c1a6c"/>
</p>

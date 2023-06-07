# BackupScript

<p align="center">
A simple script to backup file with some features
</p>

# Configs

<p align="center">
To use the script correctly you must configure the following files
</p>
  
## ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) **Add user on BackupConfig.csv file**

<p align="center">
You can use UserManager.ps1 Script to add user easly
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

## ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) **Config de backup.ps1**

### • $UserAdmin

  Enter your Administrator user

## ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) **Config de email.ps1**

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

# Features

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
  
## ![#1589F0](https://placehold.co/15x15/1589F0/1589F0.png) **Weakly email report**

<p align="center">
  A script to send email with backup status
</p>

<p align="center">
  <img src="https://github.com/Bouly/BackupScript/assets/94909482/d5af72bf-0f2f-4fe7-b195-7a505dbcce95"/>
</p>

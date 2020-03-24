# AD Setup

# Before Terraform is used

Make changes to the following files:

* UserAccounts.xlsx

Fill in the columns in the spreadsheet:

**sAMAccountName** - Usernames that your users will log on with.
**FirstName** - First name of the user.
**LastName** - Surname / Last Name of the user.
**DisplayName** - Do not change, should be exactly equal to the sAMAccountName.
**Email** - User's email address.
**Description** - An appropriate description.
**Password** - The first password for the user, this should be changed by the user at the next logon.

Once complete, save the file as UserAccounts.csv

* GroupAccounts.xlsx

Fill in the columns in the spreadsheet:

**sAMAccountName** - The explicit name of the group you are creating, this name must be unique.
**Member** - The **sAMAccountName** of the **user** you wish to add to the group. One user per column. If you wish to add more members than there are Member columns, feel free to create new columns with the heading Member# (with no space between Member and the Number).

* script.ps1

In the next steps, you will need to enter your AD domain in component form.

The domain **hello.world.com**, when split in to its components looks like:

```txt
dc=hello,dc=world,dc=com
```

Open script.ps1 in a text editor, scroll to the bottom of the file where you will see two lines that look like this:

```powershell
Create-ADAccountsFromCSV -CSVPath "C:\Users\admin\Desktop\ADSetup\UserAccounts.csv" -ADName "ad" -TeamName "helloworld377323" -Type "User" -Domain "DC=ad,DC=cedc,DC=cloud"
Create-ADAccountsFromCSV -CSVPath "C:\Users\admin\Desktop\ADSetup\GroupAccounts.csv" -ADName "ad" -TeamName "helloworld377323" -Type "Group" -Domain "DC=ad,DC=cedc,DC=cloud"
```

Change the following to suit your needs:

* ADName
* TeamName
* Domain **(in component form)**

Save the file and ensure it is uploaded to the AD Manager box through terraform.

# After Terraform has uploaded the files to the AD Manager

1. RDP in to your Windows AD Manager server.

2. Open cmd. Navigate to C:\Users\admin\Desktop\ADSetup

```cmd
cd C:\Users\admin\Desktop\ADSetup
```

3. Enter PoweShell by entering in the console.

```cmd
PowerShell
```

4. Run the script

```powershell
.\script.ps1
```

5. Your users and groups are now created, and the users have been assigned to the groups you set earlier.


## Troubleshooting


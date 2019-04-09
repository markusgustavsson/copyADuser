$copyuser = "the user we copy"
$usertocreate = "the new user"

import-module activedirectory

##Once you've got the ActiveDirectory module downloaded and installed, you can then use the Get-AdUser cmdlet to inspect all of the attributes you've defined on your template user.

Get-ADUser $copyuser -Properties *
##Once you've seen all of the attributes defined on the template user, you can then assign that user account to a variable. This gives us a way to pass this user account object when creating the new user.

$usertocreate = Get-ADUser $copyuser -Properties *


##Creating the New User
Once the user account has been captured into a variable, we can then use the New-AdUser cmdlet, passing it the $user variable to the Instance parameter and then defining any attributes that are specific to this individual account. Because you probably have not assigned the name to the template user since everyone's name is different, you can fill in any specific attributes here. Below, I'm setting all of the attributes from my template user but making the name Adam Bertram.

New-ADUser -Name '$NewUser' -Instance $user
##Your new user should be created now! However, not all attributes transfer over. 
##We can compare which attributes were copied over or not by retrieving the template user and the new user 
##along with all of the attributes using the Properties parameter.

$templateUser = Get-ADUser ctemplate -Properties *
$newUser = Get-ADUser 'Adam Bertram' -Properties *
##Once we've got both objects assigned to variables, we can then read each object's properties and 
##compare them to each other. Below is one way to do that. This will show you every property on the new user that doesn't match the template user. From this information, you can then build a list of to-dos if you'd like to add more functionality to this script.

foreach ($property in $newUser.PSObject.Properties) {
    $matchingTemplateUserProperty = $templateUser.PSObject.Properties | Where-Object { $_.Name -eq $property.Name }
    if ($matchingTemplateUserProperty.Value -ne $property.Value) {
        Write-Host "The [$($property.Name) attribute is different]"
    }
}
##Creating Active Directory users is a common task. If you're still creating users manually,
##you're wasting a lot of time. Create them using PowerShell either by copying existing accounts here or even 
##creating them from scratch with the New-Aduser cmdlet. You'll not only save a ton of time, but also ensure human error doesn't 
##come into the mix!

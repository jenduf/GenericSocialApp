peggsite-ios
================

Adding a Developer to Apple
-------------------------

1. Log into https://developer.apple.com as one of the accounts with Admin access to the PeggSite team.
1. Click the *People* tab.
1. Click *Invitations -> Invite Person*
1. Enter the name, and email associated with the developer's Apple ID.
1. Choose member or admin, and then send the invitation.
    1. Make sure this person looks in their spam folder. It does often get marked as spam.

After the user receives the email and creates an account, they should:

 1. Log into https://developer.apple.com
 2. Click *Certificates, Identifiers & Profiles -> Certificates*
 3. Click the plus icon to create a new certificate.
 4. Create a "development certificate for iOS" and follow the steps until they download the certificate.
 5. Double-click the downloaded file to add it to Keychain.
 6. Open XCode.
 7. Under the XCode menu, select *Preferences*
 8. Click the *Accounts* tab.
    10. Click the plus icon and add a the Apple ID that was just added to the team account.
    11. Make sure the details show "PeggSite, Inc." withint the details pane after loggin in.

NOTE: You *can* use your Developer Account on more than one machine. To do so:

  1. Exporting Your Signing Identities and Provisioning Profiles (Instructions: http://goo.gl/1OKfgo)
  2. Importing Your Signing Identities and Provisioning Profiles (Instructions: http://goo.gl/2rQdJy)

**Register their Device as a Test Device**

 9. With XCode open, connect the iPhone to the Mac via the USB cable.
 10. Click *Organizer* under the *Window* menu.
 11. Select the iPhone icon and click *Use For Development*
 12. Copy the UUID of the phone and paste it into a document for later use.
 13. (see next section)

Adding a Device to the Provisioning Profile
-------------------------

 1. Log into https://developer.apple.com
 2. Click *Certificates, Identifiers & Profiles -> Devices*
 3. Click the plus icon to add a new device.
 4. Enter the UUID of the device, and a descriptive name.
 5. Click *All* under *Provisioning Profiles*
 6. Click the "peggsite-ios" row and then click *Edit*
 7. Walk through the steps and to select all the devices (including the new one) to include in the profile.
 8. Click *Generate* and then download the new profile.

**After the provisioning profile has been edited, all developers must:**

 9. Download the new profile from https://developer.apple.com
 10. Open XCode, and plug in development phone.
 11. Click *Organizer* under the *Window* menu.
 11. Select the iPhone icon and select *Provisioning Profiles*
 12. Delete the profile named "peggsite-ios"
 13. Click *Add* and import the profile that was downloaded in step 1.

Adding a Developer or Tester to HockeyApp
-------------------------

We are currently using HockeyApp to distribute over the air builds. This will likely be replaced with [Test Flight][1], when iOS8 is released.

1. Log in http://hockeyapp.net as a current owner of the team.
2. Click *Teams -> PeggSite -> Invite Users*
5. After a user is invited, they can be set as a "developer" or "tester".

Creating and Distributing a New Build
-------------------------

**Generate the Build**

 1. Open XCode.
 2. Make sure that no iPhone is currently plugged in to the Mac.
 3. In the "Navigator", click the "PeggSite" project file.
 4. Under "Targets", click *PeggSite*.
 5. Click the *General* tab and increment the "Version" and Build".
 6. In the header area of XCode (near the play and stop buttons), change the "activity scheme" to "Dev Ad Hoc - iOS Device".
 7. Within the *Product* menu, click *Archive*.
 8. The "Organizer" window should open.
 9. Click *Distribute*.
 10. Select "Save for Enterprise or Ad Hoc Deployment" and click *Next*.
 11. Select the provisioning profile "peggsite-ios" and click *Next*.
 12. Save the IPA file to the desktop (DO NOT click *Save for Enterprise Distribution*).

**Deploy the Build**

 13. Log in http://hockeyapp.net
 14. Click the PeggSite icon.
 15. Click the *Add Version* button.
 16. Upload the IPA file from your desktop.
 17. Write some bullet points to testers about what has changed.
 18. Follow the steps to send out notifications to testers.


  [1]: https://www.testflightapp.com/

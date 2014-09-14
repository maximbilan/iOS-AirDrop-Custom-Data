iOS Airdrop Custom Data Sample
=======================

In iOS 7, Apple introduced AirDrop, a way of sharing files and links between nearby devices using a combination of Bluetooth and Wi-Fi.
If you’re sharing images, or simple web links, you’ll get the simple behavior with UIActivityViewController, but if you want to share custom data into your native application you have to do a little more work. I'd like to tell exactly how to do this.

You need to register the document types that your application can open with iOS. To do this you need to add a document type to your app’s Info.plist for each document type that your app can open. Additionally if any of the document types are not known by iOS, you will need to provide an Uniform Type Identifier (UTI) for that document type.

To add the document type do the following:

1. In your Xcode project, select the target you want to add the document type to.
2. Select the Info tab.
3. Click on the disclosure button for Document Types to open the document types.
4. Click the “+” button.
5. In the newly created document type :
6. - Type the name of the document type.
   - In the “Types” section fill in the UTI for the new type.
   - Provide an icon for the document.
7. Click the disclosure triangle to open Additional document type properties.
8. Click in the table to add a new key and value.
9. - For the key value type: CFBundleTypeRole.
   - For the value type: Editor.
10. Click the + button to add another key/value pair.
11. - For the key value type: LSHandlerRank.
    - For the value type: Owner.

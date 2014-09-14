iOS Airdrop Custom Data Sample
=======================

In iOS 7, Apple introduced AirDrop, a way of sharing files and links between nearby devices using a combination of Bluetooth and Wi-Fi.<br>

If you’re sharing images, or simple web links, you’ll get the simple behavior with UIActivityViewController, but if you want to share custom data into your native application you have to do a little more work. I'd like to tell exactly how to do this.<br>

You need to register the document types that your application can open with iOS. To do this you need to add a document type to your app’s Info.plist for each document type that your app can open. Additionally if any of the document types are not known by iOS, you will need to provide an Uniform Type Identifier (UTI) for that document type.<br>

<b>To add the document type do the following:</b>

1. In your Xcode project, select the target you want to add the document type to.
2. Select the Info tab.
3. Click on the disclosure button for Document Types to open the document types.
4. Click the “+” button.
5. In the newly created document type :
6. Type the name of the document type. In the “Types” section fill in the UTI for the new type. Provide an icon for the document.
7. Click the disclosure triangle to open Additional document type properties.
8. Click in the table to add a new key and value.
9. For the key value type: CFBundleTypeRole. For the value type: Editor.
10. Click the + button to add another key/value pair.
11. For the key value type: LSHandlerRank. For the value type: Owner.

If the document type you are adding is a custom document type, or a document type that iOS does not already know about, you will need to define the UTI for the document type.

<b>To add a new UTI do the following:</b>

1. In your Xcode project select the target you want to add the new UTI to.
2. Select the Info tab.
3. Click on the disclosure button for Exported UTIs.
4. Click the “+” button.
5. Select “Add Exported UTI”.
6. In the Description field, fill in a description of the UTI. In the Identifier field, fill in the identifier for the UTI. In the Conforms To field fill in the list of UTIs that this new UTI conforms to.
7. Toggle the “Additional imported UTI properties” disclosure triangle to open up a table where you can add some additional information.
8. Click in the empty table and a list of items that can be added to the table will be displayed.
9. Type in “UTTypeTagSpecification”.
10. Set the type to Dictionary.
11. Click the disclosure triangle to open it, and click the + button in the table row to add an entry.
12. For the “New item” change the name to “public.filename-extension”.
13. For the type of the item change it to “Array”.
14. Toggle open the item you just added and click the + button in the table row.
15. For item 0 change the “value” to the file extension of your document. For example, txt, pdf, docx, etc.

For example:<br>
![alt tag](https://raw.github.com/maximbilan/ios_airdrop_custom_data/master/img/img1.png)

The source you can found here https://developer.apple.com/library/ios/qa/qa1587/_index.html.

For our custom data format create UIActivityItemSource class:

<pre>
#import &#60;Foundation/Foundation.h&#62;
#import &#60;UIKit/UIKit.h&#62;

@interface AirDropCustomData : NSObject &#60;UIActivityItemSource&#62;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *subject;

- (id)initWithURL:(NSURL *)url subject:(NSString *)subject;

@end
</pre>

And implementation:

<pre>
#import "AirDropCustomData.h"

@implementation AirDropCustomData

- (id)initWithURL:(NSURL *)url subject:(NSString *)subject;
{
    self = [super init];
    if (self != nil) {
        self.url = url;
        self.subject = subject;
    }
    return self;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return self.url;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return self.url;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType
{
    return self.subject;
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController
      thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
{
    if ([activityType isEqualToString:UIActivityTypeAirDrop]) {
        return [UIImage imageNamed:@"AppIcon"];
    }
    return nil;
}

@end
</pre>

For calling the airdrop sharing you can use this code:

<pre>
   NSString *path1 = [[NSBundle mainBundle] pathForResource:@"readme 1" ofType:@"customdata"];
    NSURL *url1 = [NSURL fileURLWithPath:path1];
    AirDropCustomData *item1 = [[AirDropCustomData alloc] initWithURL:url1 subject:@"readme 1"];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"readme 2" ofType:@"customdata"];
    NSURL *url2 = [NSURL fileURLWithPath:path2];
    AirDropCustomData *item2 = [[AirDropCustomData alloc] initWithURL:url2 subject:@"readme 2"];
    
    NSArray *items = [NSArray arrayWithObjects:item1, item2, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter,
                                    UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage,
                                    UIActivityTypeMail,
                                    UIActivityTypePrint,
                                    UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList,
                                    UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo,
                                    UIActivityTypePostToTencentWeibo];
    activityViewController.excludedActivityTypes = excludedActivities;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else {
        if (![self.activityPopover isPopoverVisible]) {
            self.activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            [self.activityPopover presentPopoverFromRect:[self.shareButton frame]
                                                  inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else {
            [self.activityPopover dismissPopoverAnimated:YES];
        }
    }
</pre>

readme 1.customdata and readme 2.customdata - pre created files, which are located in bundle.
Files should not be necessary in the bundle, it's just for sample, they may be created anywhere, depends on your implementation.

And for obtaining and processing your custom data, you should use openURL method in application delegate. For example:

<pre>
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url isFileURL] && [[[url absoluteString] pathExtension] isEqualToString:@"customdata"]) {
        // processing

        return YES;
    }
    
    return NO;
}
</pre>

That's all. Completed sample you can found in this repository. I think it is not very difficult. And you should not have difficulties to understand this. Thanks for attention.

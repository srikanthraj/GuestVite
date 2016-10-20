//
//  SendBulkInviteViewController.m
//  GuestVite
//
//  Created by admin on 2016-10-13.
//  Copyright © 2016 admin. All rights reserved.
//

#import "SendBulkInviteViewController.h"
#import <MessageUI/MessageUI.h>


@import Firebase;

@interface SendBulkInviteViewController () <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *guestList;


@property (weak, nonatomic) IBOutlet UITextField *inviteForDateText;
@property (weak, nonatomic) IBOutlet UITextField *inviteExpireDateText;
@property (weak, nonatomic) IBOutlet UITextView *inviteMessage;


@property (strong, nonatomic) FIRDatabaseReference *ref;


@end

@implementation SendBulkInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    self.ref = [[FIRDatabase database] reference];
    
    self.guestList.layer.cornerRadius = 10.0;
    self.guestList.layer.borderWidth = 1.0;
    
    self.inviteForDateText.layer.cornerRadius = 10.0;
    self.inviteForDateText.layer.borderWidth = 1.0;
    
    self.inviteExpireDateText.layer.cornerRadius = 10.0;
    self.inviteExpireDateText.layer.borderWidth = 1.0;
    
    self.inviteMessage.layer.cornerRadius = 10.0;
    self.inviteMessage.layer.borderWidth = 1.0;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    
    self.guestList.inputAccessoryView = keyboardDoneButtonView;
    self.inviteForDateText.inputAccessoryView = keyboardDoneButtonView;
    self.inviteExpireDateText.inputAccessoryView = keyboardDoneButtonView;
    self.inviteMessage.inputAccessoryView = keyboardDoneButtonView;
    
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}
- (IBAction)sendTapped:(id)sender {
    
    
    // Get the invite Row
    
    __block NSMutableString *rowValue = [[NSMutableString alloc] init];
    
    __block NSMutableString *senderName = [[NSMutableString alloc] init];
    
    __block NSMutableArray *smsList = [[NSMutableArray alloc] init];
    
    __block NSMutableArray *emailList = [[NSMutableArray alloc] init];
    
    __block NSMutableArray *noneList = [[NSMutableArray alloc] init];
    
    
    
    if([self.guestList.text length] ==0) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"GuestVite" message:@"At Least One Guest Info is required"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *aa = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [ac addAction:aa];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    else{
        
        self.ref = [[FIRDatabase database] reference];
        
        
        
        NSString *userID = [FIRAuth auth].currentUser.uid;
        
        NSLog(@"User Id %@",userID);
        
        [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSDictionary *dict = snapshot.value;
            
             NSArray * arr = [self.guestList.text componentsSeparatedByString:@"\n"];
            int i =0;
            for(NSString *address in arr)
            {
            
                if([address containsString:@".com"])
                {
            NSDictionary *post = @{@"Sender First Name": [dict valueForKey:@"First Name"],
                                   @"Sender Last Name": [dict valueForKey:@"Last Name"],
                                   @"Sender EMail": [dict valueForKey:@"EMail"],
                                   @"Sender Address1": [dict valueForKey:@"Address1"],
                                   @"Sender Address2": [dict valueForKey:@"Address2"],
                                   @"Sender City": [dict valueForKey:@"City"],
                                   @"Sender Zip": [dict valueForKey:@"Zip"],
                                   @"Sender Phone": [dict valueForKey:@"Phone"],
                                   @"Mesage From Sender": self.inviteMessage.text,
                                   @"Receiver First Name": @"BULK",
                                   @"Receiver Last Name": @"BULK",
                                   @"Receiver EMail": address,
                                   @"Receiver Phone": @"BULK",
                                   @"Invite For Date": self.inviteForDateText.text,
                                   @"Invite Valid Till Date": self.inviteExpireDateText.text,
                                   @"Invitation Status": @"Pending",
                                   };
            
            
            
            
            
            NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
            NSString *intervalString = [NSString stringWithFormat:@"%f", timeInSeconds];
            NSRange range = [intervalString rangeOfString:@"."];
            NSString *primarykey = [intervalString substringToIndex:range.location];
            
                    NSString *pkey1 = [userID stringByAppendingString:primarykey];
                    
                    NSString *pkey2 = [pkey1 stringByAppendingString:@"_"] ;
                    
                    NSString *pKey = [pkey2 stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)[arr indexOfObject:address]]];
                    
                    
            [rowValue setString:pKey];
            [senderName setString:[dict valueForKey:@"First Name"]];
            [senderName appendString:@" "];
            [senderName appendString:[dict valueForKey:@"Last Name"]];
            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/invites/%@/", pKey]: post};
            [_ref updateChildValues:childUpdates];
                    [emailList addObject:address];
                    NSLog(@"PKEY for E-Mail address %@",pKey);
            }
                
            
                else if([address length] == 10 && !([address containsString:@".com"]))
                {
                    NSDictionary *post = @{@"Sender First Name": [dict valueForKey:@"First Name"],
                                           @"Sender Last Name": [dict valueForKey:@"Last Name"],
                                           @"Sender EMail": [dict valueForKey:@"EMail"],
                                           @"Sender Address1": [dict valueForKey:@"Address1"],
                                           @"Sender Address2": [dict valueForKey:@"Address2"],
                                           @"Sender City": [dict valueForKey:@"City"],
                                           @"Sender Zip": [dict valueForKey:@"Zip"],
                                           @"Sender Phone": [dict valueForKey:@"Phone"],
                                           @"Mesage From Sender": self.inviteMessage.text,
                                           @"Receiver First Name": @"BULK",
                                           @"Receiver Last Name": @"BULK",
                                           @"Receiver EMail": @"BULK",
                                           @"Receiver Phone": address,
                                           @"Invite For Date": self.inviteForDateText.text,
                                           @"Invite Valid Till Date": self.inviteExpireDateText.text,
                                           @"Invitation Status": @"Pending",
                                           };
                    
                    
                    
                    
                    
                    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
                    NSString *intervalString = [NSString stringWithFormat:@"%f", timeInSeconds];
                    NSRange range = [intervalString rangeOfString:@"."];
                    NSString *primarykey = [intervalString substringToIndex:range.location];
                    NSString *pkey1 = [userID stringByAppendingString:primarykey];
                    
                    NSString *pkey2 = [pkey1 stringByAppendingString:@"_"] ;
                
                    NSString *pKey = [pkey2 stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)[arr indexOfObject:address]]];
                    
                    [rowValue setString:pKey];
                    [senderName setString:[dict valueForKey:@"First Name"]];
                    [senderName appendString:@" "];
                    [senderName appendString:[dict valueForKey:@"Last Name"]];
                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/invites/%@/", pKey]: post};
                    [_ref updateChildValues:childUpdates];
                    [smsList addObject:address];
                    NSLog(@"PKEY for PHONE NUMBER %@",pKey);
                }
    
                else {
                    
                    [noneList addObject:address];
                    
                }
                
                
                i++;
                
                
            }
            
            
            
        }];
        
        while([rowValue length]== 0 && [senderName length] ==0 && ([smsList count] == 0 || [emailList count] == 0 || [noneList count] == 0)) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
        
        
        
        // -------------------- SEND EMAIL ------------------------------------
        
        
        if([emailList count] > 0) {
            
            // Email Subject
            NSString *emailTitle = @"Message From GeuestVite";
            // Email Content
            NSString *messageBody = [NSString stringWithFormat:@"Hey!, This is %@  and I want to invite you at my place , please login to this new cool App GuestVite! for all further details, Thanks and looking forward to see you soon!",senderName];
            // To address
            //NSArray *toRecipents = [NSArray arrayWithObject:self.guestEMailText.text];
            
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:emailList];
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
            
            
            
        }
        
        // -------------------- SEND SMS  When Email not defined and Phone Defined OR Both Phone and E Mail Defined------------------------------------
        
        if([smsList count] > 0){
            
            
            
            if(![MFMessageComposeViewController canSendText]) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your Device Does not support SMS" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *aa = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                
                [ac addAction:aa];
                [self presentViewController:ac animated:YES completion:nil];
                return;
            }
            
            
            
            
            
            //NSArray *recipents = [NSArray arrayWithObject:self.guestPhoneText.text];
            
            
            NSString *message = [NSString stringWithFormat:@"Hey!, You are invited by %@ as a guest, Please login/Register to GuestVite App for more Details ,Thanks!",senderName];
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            [messageController setRecipients:smsList];
            [messageController setBody:message];
            
            
            [self presentViewController:messageController animated:YES completion:nil];
            
        }
        
        

        
        
        
        if([noneList count] > 0) {
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Cannot send E-Mail/SMS to %@",noneList] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *aa = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [ac addAction:aa];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
        NSLog(@"SMS List: %@",smsList);
        
        NSLog(@"Email List: %@",emailList);
        
        NSLog(@"None List: %@",noneList);
    }
    
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
       
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
        
        
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent: {
            NSLog(@"Mail SENT!!!");
            
            break;
        }
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}




@end

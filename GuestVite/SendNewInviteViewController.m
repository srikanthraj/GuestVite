//
//  SendNewInviteViewController.m
//  GuestVite
//
//  Created by admin on 2016-10-11.
//  Copyright © 2016 admin. All rights reserved.
//

#import "SendNewInviteViewController.h"

@import Firebase;

@interface SendNewInviteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *guestNameText;
@property (weak, nonatomic) IBOutlet UITextField *guestEMailText;

@property (weak, nonatomic) IBOutlet UITextField *guestPhoneText;
@property (weak, nonatomic) IBOutlet UITextField *inviteForDateText;
@property (weak, nonatomic) IBOutlet UITextField *inviteExpireDateText;
@property (weak, nonatomic) IBOutlet UITextView *messageText;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation SendNewInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
    //self.guestNameText.layer.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.1].CGColor;
    self.guestNameText.layer.cornerRadius = 10.0;
    self.guestNameText.layer.borderWidth = 1.0;
    
    self.guestEMailText.layer.cornerRadius = 10.0;
    self.guestEMailText.layer.borderWidth = 1.0;
    
    self.guestPhoneText.layer.cornerRadius = 10.0;
    self.guestPhoneText.layer.borderWidth = 1.0;
    
    self.inviteForDateText.layer.cornerRadius = 10.0;
    self.inviteForDateText.layer.borderWidth = 1.0;
    
    self.inviteExpireDateText.layer.cornerRadius = 10.0;
    self.inviteExpireDateText.layer.borderWidth = 1.0;
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendInviteTapped:(id)sender {
    
    if([self.guestEMailText.text length] ==0 && [self.guestPhoneText.text length] ==0) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"GuestVite" message:@"At Least One field amonf E-Mail Address or Phone is required"preferredStyle:UIAlertControllerStyleAlert];
        
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
        
            NSArray * arr = [self.guestNameText.text componentsSeparatedByString:@" "];
    
            
            NSDictionary *post = @{@"Sender First Name": [dict valueForKey:@"First Name"],
                                   @"Sender Last Name": [dict valueForKey:@"Last Name"],
                                   @"Sender EMail": [dict valueForKey:@"EMail"],
                                   @"Sender Address1": [dict valueForKey:@"Address1"],
                                   @"Sender Address2": [dict valueForKey:@"Address2"],
                                   @"Sender City": [dict valueForKey:@"City"],
                                   @"Sender Zip": [dict valueForKey:@"Zip"],
                                   @"Sender Phone": [dict valueForKey:@"Phone"],
                                   @"Mesage From Sender": self.messageText.text,
                                   @"Receiver First Name": [arr objectAtIndex:0],
                                   @"Receiver Last Name": [arr objectAtIndex:1],
                                   @"Receiver EMail": self.guestEMailText.text,
                                   @"Receiver Phone": self.guestPhoneText.text,
                                   @"Invite For Date": self.inviteForDateText.text,
                                   @"Invite Valid Till Date": self.inviteExpireDateText.text,
                                   @"Invitation Status": @"Pending",
                                   };
            
            
            
           
            
            NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
            NSString *intervalString = [NSString stringWithFormat:@"%f", timeInSeconds];
            NSRange range = [intervalString rangeOfString:@"."];
             NSString *primarykey = [intervalString substringToIndex:range.location];
            NSString *pKey = [userID stringByAppendingString:primarykey];
            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/invites/%@/", pKey]: post};
            [_ref updateChildValues:childUpdates];
            
            
            
        }];
        
    
    }
    
    // Check if the E_mail and (or) password exists
    
    if([self.guestEMailText.text length] >0  && [self.guestPhoneText.text length] == 0) {
        
        NSLog(@"Only Guest Email Available");
        
        [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

            NSLog(@"%@",snapshot);
            
            NSDictionary *dict = snapshot.value;
            
            
            NSArray * arr = [dict allValues];
            
            BOOL isaMember = FALSE;
            
            for (int i = 0; i < [arr count]; i++) {
            
                if([arr[i][@"EMail"] isEqualToString:self.guestEMailText.text]) {
                    NSLog(@"Guest Is a member");
                    isaMember = TRUE;
                    break;
                }
                
            }
            
            if(!isaMember) {
                NSLog(@"Guest Is NOT a member");
            }
            
            
        }];
        
    }
    
    // Only Phone
    else if([self.guestPhoneText.text length] >0  && [self.guestEMailText.text length] == 0) {
        
        
        NSLog(@"Only Phone Available");
        
        [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSLog(@"%@",snapshot);
            
            NSDictionary *dict = snapshot.value;
            
            
            NSArray * arr = [dict allValues];
            
            BOOL isaMember = FALSE;
            
            for (int i = 0; i < [arr count]; i++) {
                
                if([arr[i][@"Phone"] isEqualToString:self.guestPhoneText.text]) {
                    NSLog(@"Guest Is a member");
                    isaMember = TRUE;
                    break;
                }
                
            }
            
            if(!isaMember) {
                NSLog(@"Guest Is NOT a member");
            }
            
            
        }];

        
        
        
    }
    
    
    
    else if([self.guestPhoneText.text length] >0  && [self.guestEMailText.text length] > 0) {
        
        
        NSLog(@"Both Available");
        
        [[_ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSLog(@"%@",snapshot);
            
            NSDictionary *dict = snapshot.value;
            
            
            NSArray * arr = [dict allValues];
            
            BOOL isaMember = FALSE;
            
            for (int i = 0; i < [arr count]; i++) {
                
                if([arr[i][@"EMail"] isEqualToString:self.guestEMailText.text] && [arr[i][@"Phone"] isEqualToString:self.guestPhoneText.text]) {
                    NSLog(@"Guest Is a member");
                    isaMember = TRUE;
                    break;
                }
                
            }
            
            if(!isaMember) {
                NSLog(@"Guest Is NOT a member");
            }
            
            
        }];
        

        
    }
    
    
}

@end

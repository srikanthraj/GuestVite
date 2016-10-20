//
//  SendAddressBookInviteViewController.m
//  GuestVite
//
//  Created by admin on 2016-10-20.
//  Copyright © 2016 admin. All rights reserved.
//

#import "SendAddressBookInviteViewController.h"
#import <MessageUI/MessageUI.h>
#import "SendBulkInviteViewController.h"
#import "SendNewInviteViewController.h"

@import Firebase;

@interface SendAddressBookInviteViewController () <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *eMailguestList;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UITextField *inviteForDateText;
@property (weak, nonatomic) IBOutlet UITextField *inviteExpireDateText;
@property (weak, nonatomic) IBOutlet UITextView *inviteMessage;

@property (weak, nonatomic) IBOutlet UITextView *smsGuestList;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation SendAddressBookInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.ref = [[FIRDatabase database] reference];
    
    self.eMailguestList.text = @"Enter Email Addressses here";
    self.eMailguestList.textColor = [UIColor lightGrayColor];
    self.eMailguestList.layer.cornerRadius = 10.0;
    self.eMailguestList.layer.borderWidth = 1.0;
    self.eMailguestList.delegate = self;
    
    self.smsGuestList.text = @"Enter Phone Numbers here";
    self.smsGuestList.textColor = [UIColor lightGrayColor];
    self.smsGuestList.layer.cornerRadius = 10.0;
    self.smsGuestList.layer.borderWidth = 1.0;
    self.smsGuestList.delegate = self;
    
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
    
    self.eMailguestList.inputAccessoryView = keyboardDoneButtonView;
    self.smsGuestList.inputAccessoryView = keyboardDoneButtonView;
    self.inviteForDateText.inputAccessoryView = keyboardDoneButtonView;
    self.inviteExpireDateText.inputAccessoryView = keyboardDoneButtonView;
    self.inviteMessage.inputAccessoryView = keyboardDoneButtonView;
    
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
}

- (IBAction)segmentTapped:(id)sender {
    
    if(self.segmentControl.selectedSegmentIndex ==0){
        
        
        SendNewInviteViewController *sendNewVC =
        [[SendNewInviteViewController alloc] initWithNibName:@"SendNewInviteViewController" bundle:nil];
        
        //hPViewController.userName  = eMailEntered;
        [self.navigationController pushViewController:sendNewVC animated:YES];
        
        [self presentViewController:sendNewVC animated:YES completion:nil];
    }
    
    if(self.segmentControl.selectedSegmentIndex ==1){
        
        
        SendBulkInviteViewController *sendBulkVC =
        [[SendBulkInviteViewController alloc] initWithNibName:@"SendBulkInviteViewController" bundle:nil];
        
        //hPViewController.userName  = eMailEntered;
        [self.navigationController pushViewController:sendBulkVC animated:YES];
        
        [self presentViewController:sendBulkVC animated:YES completion:nil];
    }
    
    
    
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if(self.eMailguestList.isFirstResponder)
    {
        if([self.eMailguestList.text isEqualToString:@"Enter Email Addressses here"]) {
            self.eMailguestList.text = @"";
            self.eMailguestList.textColor = [UIColor blackColor];
        }
        
    }
    
    if(self.smsGuestList.isFirstResponder)
    {
        if([self.smsGuestList.text isEqualToString:@"Enter Phone Numbers here"]) {
            self.smsGuestList.text = @"";
            self.smsGuestList.textColor = [UIColor blackColor];
        }
    }
    
}

-(void) textViewDidChangeSelection:(UITextView *)textView
{
    
    
    if(!self.eMailguestList.isFirstResponder)
    {
        if(self.eMailguestList.text.length == 0){
            self.eMailguestList.textColor = [UIColor lightGrayColor];
            self.eMailguestList.text = @"Enter Email Addressses here";
            [self.eMailguestList resignFirstResponder];
        }
    }
    
    
    if(!self.smsGuestList.isFirstResponder)
    {
        if(self.smsGuestList.text.length == 0){
            self.smsGuestList.textColor = [UIColor lightGrayColor];
            self.smsGuestList.text = @"Enter Phone Numbers here";
            [self.smsGuestList resignFirstResponder];
        }
    }
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "KBContactsSelectionViewController.h"

#import <ContactsUI/ContactsUI.h>

@import Firebase;

@interface SendAddressBookInviteViewController () <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate, CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextView *eMailguestList;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UITextField *inviteForDateText;
@property (weak, nonatomic) IBOutlet UITextField *inviteExpireDateText;
@property (weak, nonatomic) IBOutlet UITextView *inviteMessage;

@property (weak, nonatomic) IBOutlet UITextView *smsGuestList;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UIButton *addressBookButton;

@property (nonatomic, strong) NSMutableArray *arrContactsData;

@property (nonatomic, strong) NSMutableArray *emailContactsData;

@property (nonatomic, strong) NSMutableArray *phoneContactsData;

@property (nonatomic, strong) NSDictionary *dictContactDetails;

@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
-(void)showAddressBook;

-(void)populateContactData;

-(void)selectContactData;

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
    
    self.phoneContactsData = [[NSMutableArray alloc]init];
    self.emailContactsData = [[NSMutableArray alloc]init];
    
}


-(void)peoplePickerNavigationControllerDidCancel:(CNContactPickerViewController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}





-(void)peoplePickerNavigationController:(CNContactPickerViewController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    
    
    
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"",@"", @"",@""]
                                            forKeys:@[@"firstName", @"lastName",@"mobileNumber", @"homeNumber",@"EMail"]];
    
    CFTypeRef generalCFObject;
    
    //Get First name
    
    generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    //Get Last Name
    
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    
    //Phone
    
    
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        if(currentPhoneLabel)
        {
        CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue)
        {
            CFRelease(currentPhoneValue);
        }
    }
    if(phonesRef)
    {
    CFRelease(phonesRef);
    }
    
    //E-Mails
    
    ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    NSMutableArray *allEmails = [[NSMutableArray alloc] init];
    
    for (int i=0; i<ABMultiValueGetCount(emailsRef); i++) {
       // CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(emailsRef, i);
       // CFStringRef currentEmailValue = ABMultiValueCopyValueAtIndex(emailsRef, i);
        
        //NSString *email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailsRef, i);
        [contactInfoDict setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(emailsRef, i) forKey:@"EMail"];
        //[email release];
    }
    
   // NSLog(@"ALL EMAILS %@",allEmails);
    if(emailsRef)
    {
    CFRelease(emailsRef);
    }
    
    
    
    
    if (_arrContactsData == nil) {
        _arrContactsData = [[NSMutableArray alloc] init];
    }
    [_arrContactsData addObject:contactInfoDict];
    
    
    //[self.tableView reloadData];
    
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    //NSLog(@"CONTACT INFO DICTIONARY %@",contactInfoDict);
    
    NSString *tempo = [[NSString alloc]init];
    
    NSString *tempoEMail = [[NSString alloc]init];
    
    if([[contactInfoDict objectForKey:@"mobileNumber"] length] != 0)
    {
    tempo = [NSString stringWithFormat:@"%@ %@: %@",[contactInfoDict objectForKey:@"firstName"],[contactInfoDict objectForKey:@"lastName"],[contactInfoDict objectForKey:@"mobileNumber"]];
    
    }
    
    else if([[contactInfoDict objectForKey:@"homeNumber"] length] != 0)
    {
        tempo = [NSString stringWithFormat:@"%@ %@: %@",[contactInfoDict objectForKey:@"firstName"],[contactInfoDict objectForKey:@"lastName"],[contactInfoDict objectForKey:@"homeNumber"]];
    }
    
    
    if([[contactInfoDict objectForKey:@"EMail"] length] != 0)
    {
        tempoEMail = [NSString stringWithFormat:@"%@ %@: %@",[contactInfoDict objectForKey:@"firstName"],[contactInfoDict objectForKey:@"lastName"],[contactInfoDict objectForKey:@"EMail"]];
        
    }
    
   // NSLog(@"TEMPO %@",tempo);
   //NSLog(@"TEMPO EMAIL %@",tempoEMail);
    
    
    [self.phoneContactsData addObject:tempo];
    
    [self.emailContactsData addObject:tempoEMail];
    
    
   //NSLog(@"LENGTH of array %lu",(unsigned long)[self.emailContactsData count]);
    
   // NSLog(@"MOBILE NUMBER = %@", [contactInfoDict objectForKey:@"mobileNumber"]);
    
   // NSLog(@"HOME NUMBER = %@", [contactInfoDict objectForKey:@"homeNumber"]);
    
    //NSLog(@"EMAIL = %@", [contactInfoDict objectForKey:@"EMail"]);
    
    // Check for Mobile Number
    
    if(([[contactInfoDict objectForKey:@"mobileNumber"] length] !=0))
    {
        
        tempo = [NSString stringWithFormat:@"%@ %@: %@",[contactInfoDict objectForKey:@"firstName"],[contactInfoDict objectForKey:@"lastName"],[contactInfoDict objectForKey:@"mobileNumber"]];
    
        NSLog(@"PHONE CONTACTS DATA %@",[contactInfoDict objectForKey:@"mobileNumber"]);
    if([self.smsGuestList.text isEqualToString:@"Enter Phone Numbers here"]){
        self.smsGuestList.text = [tempo stringByAppendingString:@"\n"];
        
    }
    
    else {
        
        NSLog(@"PHONE CONTACTS DATA %@",[contactInfoDict objectForKey:@"mobileNumber"]);
        
        self.smsGuestList.text = [self.smsGuestList.text stringByAppendingString:[tempo stringByAppendingString:@"\n"]];
    }
    
    }
    
    // Take Home Number If Mobile Number is ot there
    
    else if(([[contactInfoDict objectForKey:@"homeNumber"] length] !=0))
    {
        
        tempo = [NSString stringWithFormat:@"%@ %@: %@",[contactInfoDict objectForKey:@"firstName"],[contactInfoDict objectForKey:@"lastName"],[contactInfoDict objectForKey:@"homeNumber"]];
        
        
        NSLog(@"PHONE CONTACTS DATA %@",[contactInfoDict objectForKey:@"homeNumber"]);
        if([self.smsGuestList.text isEqualToString:@"Enter Phone Numbers here"]){
            self.smsGuestList.text = [tempo stringByAppendingString:@"\n"];
            
        }
        
        else {
            
            NSLog(@"PHONE CONTACTS DATA %@",[contactInfoDict objectForKey:@"homeNumber"]);
            
            self.smsGuestList.text = [self.smsGuestList.text stringByAppendingString:[tempo stringByAppendingString:@"\n"]];
        }
        
    }
    
    
    // Check for E-Mail
    
    if([[contactInfoDict objectForKey:@"EMail"] length] !=0)
    {
        NSLog(@"EMAIL CONTACTS DATA %@",[self.emailContactsData objectAtIndex:0]);
    
    if([self.eMailguestList.text isEqualToString:@"Enter Email Addressses here"]){
        self.eMailguestList.text = [[self.emailContactsData objectAtIndex:0] stringByAppendingString:@"\n"];
        
    }
    
    else {
        
        NSLog(@"EMAIL CONTACTS DATA %@",[self.emailContactsData objectAtIndex:[self.emailContactsData count] -1 ]);
        
        self.eMailguestList.text = [self.eMailguestList.text stringByAppendingString:[[self.emailContactsData objectAtIndex:[self.emailContactsData count] -1 ] stringByAppendingString:@"\n"]];
    }

    }

     
    NSLog(@"Inside!!!");
    //return NO;
}



-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


-(void)showAddressBook{
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
}


-(void)populateContactData{
    NSString *contactFullName = [NSString stringWithFormat:@"%@ %@", [_dictContactDetails objectForKey:@"firstName"], [_dictContactDetails objectForKey:@"lastName"]];
    
    //[self.eMailguestList setText:contactFullName];
    
}

-(void)selectContactData {

    CNContactPickerViewController * picker = [[CNContactPickerViewController alloc] init];
    
    picker.delegate = self;
    picker.displayedPropertyKeys = (NSArray *)CNContactGivenNameKey;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *test = contact.givenName;
    NSLog(@"NAME IS  %@",test);
}

- (IBAction)addressButtonTapped:(id)sender {
    
    
    //[self selectContactData];
    [self showAddressBook];
    //[self populateContactData];
    
    
    
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

//
//  RegPageViewController.m
//  GuestVite
//
//  Created by admin on 2016-10-08.
//  Copyright © 2016 admin. All rights reserved.
//

#import "RegPageViewController.h"
#import "HomePageViewController.h"
#include "TextFieldValidator.h"
@import Firebase;

@interface RegPageViewController ()



@property (weak, nonatomic) IBOutlet UITextField *fNameText;
@property (weak, nonatomic) IBOutlet UITextField *lNameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *addr1Text;

@property (weak, nonatomic) IBOutlet UITextField *addr2Text;

@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *zipText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation RegPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerTapped:(id)sender {
    
    NSString *eMailAddress = self.emailText.text;
    NSString *password = self.passwordText.text;
    
    
    [[FIRAuth auth]
     createUserWithEmail:eMailAddress
     password:password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         
         if (error) {
             UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"GuestVite" message:@"There was an error creating your account"preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *aa = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             
             [ac addAction:aa];
             [self presentViewController:ac animated:YES completion:nil];         }
         
            else {
             
                
                 //NSString *key = [[_ref child:@"users"] childByAutoId].key;
                
                [_ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    
                    NSLog(@"%@",[_ref child:@"EMail"]);
                    
                    
                }];
                //Update all the values to the DB
                
                if([self.fNameText.text length] >0 && [self.lNameText.text length] >0 && [self.emailText.text length] > 0 && [self.addr1Text.text length] >0 && [self.addr2Text.text length] > 0 && [self.cityText.text length] > 0 && [self.zipText.text length] > 0 && [self.phoneText.text length] > 0)
                {
                
               
                NSDictionary *post = @{@"uid" : user.uid,
                                       @"First Name": self.fNameText.text,
                                       @"Last Name": self.lNameText.text,
                                       @"EMail": self.emailText.text,
                                       @"Address1": self.addr1Text.text,
                                       @"Address2": self.addr2Text.text,
                                       @"City": self.cityText.text,
                                       @"Zip": self.zipText.text,
                                       @"Phone": self.phoneText.text,
                                       
                                       };
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/users/%@/", user.uid]: post};
                [_ref updateChildValues:childUpdates];
                }
                /*
                [[[_ref child:@"users"] child:user.uid] setValue:@{@"First Name": self.fNameText.text}];
                [[[_ref child:@"users"] child:user.uid] setValue:@{@"Last Name": self.lNameText.text}];
                [[[_ref child:@"users"] child:user.uid] setValue:@{@"EMail": self.emailText.text}];
                [[[_ref child:@"users"] child:user.uid] setValue:@{@"Address1": self.addr1Text.text}];
                [[[_ref child:@"users"] child:user.uid] setValue:@{@"Address2": self.addr2Text.text}];
                [[[_ref child:@"users"] child:user.uid] setValue:@{@"City": self.cityText.text}];
                
                [[[_ref child:@"users"] child:user.uid] setValue:@{@"Zip": self.zipText.text}];
                
                [[[_ref child:@"users"] child:user.uid] setValue:@{@"Phone": self.phoneText.text}];
                */
                
                
                HomePageViewController *hpViewController =
                [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
                
                
                [self.navigationController pushViewController:hpViewController animated:YES];
                
                
                [self presentViewController:hpViewController animated:YES completion:nil];

         }
         
     }];

    
    }


@end

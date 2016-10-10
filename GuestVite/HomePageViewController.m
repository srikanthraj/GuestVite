//
//  HomePageViewController.m
//  GuestVite
//
//  Created by admin on 2016-10-08.
//  Copyright © 2016 admin. All rights reserved.
//

#import "HomePageViewController.h"

@import Firebase;
@interface HomePageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.ref = [[FIRDatabase database] reference];
    
    [self addFirstName];
    
    
}

-(void) addFirstName {
    
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *dict = snapshot.value;
        NSString *firstName = [dict valueForKey:@"First Name"];
        NSLog(@"First Name is %@" , firstName);
        
        self.welcomeLabel.text = [self.welcomeLabel.text stringByAppendingFormat:@" %@",firstName];
              
              } withCancelBlock:^(NSError * _Nonnull error) {
                  NSLog(@"%@", error.localizedDescription);
              }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)signOutTapped:(id)sender {
    
   [[FIRAuth auth] signOut:nil];
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            NSLog(@"User is signed in with uid: %@", user.uid);
        } else {
            NSLog(@"No user is signed in.");
        }
    }];
    
        
}

@end

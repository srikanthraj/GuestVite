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

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

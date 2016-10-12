//
//  HomePageViewController.m
//  GuestVite
//
//  Created by admin on 2016-10-08.
//  Copyright © 2016 admin. All rights reserved.
//

#import "HomePageViewController.h"

#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "ViewController.h"

#import "SendNewInviteViewController.h"

@import Firebase;
@interface HomePageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;


@property (weak, nonatomic) IBOutlet UIButton *sendInviteButton;

@property (weak, nonatomic) IBOutlet UIButton *waitingRespButton;
@property (weak, nonatomic) IBOutlet UIButton *prevReqRecvdButton;

@property (weak, nonatomic) IBOutlet UIButton *prevInvSentButton;
@property (weak, nonatomic) IBOutlet UIButton *trackButton;

@property (weak, nonatomic) IBOutlet UIButton *awaitMyRespButton;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation HomePageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.ref = [[FIRDatabase database] reference];
    
    [self addFirstName];
    
     [self configureButtons];
    
  
}


- (void) configureButtons {
    
    // Stylize the Tweet text View
    
    
     self.sendInviteButton.layer.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.1].CGColor;
    self.sendInviteButton.layer.cornerRadius = 10.0;
    self.sendInviteButton.layer.borderWidth = 2.0;
    
    self.waitingRespButton.layer.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.1].CGColor;
    self.waitingRespButton.layer.cornerRadius = 10.0;
    self.waitingRespButton.layer.borderWidth = 2.0;

    
    self.prevReqRecvdButton.layer.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.1].CGColor;
    self.prevReqRecvdButton.layer.cornerRadius = 10.0;
    self.prevReqRecvdButton.layer.borderWidth = 2.0;

    
    self.prevInvSentButton.layer.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.1].CGColor;
    self.prevInvSentButton.layer.cornerRadius = 10.0;
    self.prevInvSentButton.layer.borderWidth = 2.0;

    
    self.trackButton.layer.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.1].CGColor;
    self.trackButton.layer.cornerRadius = 10.0;
    self.trackButton.layer.borderWidth = 2.0;

    
    self.awaitMyRespButton.layer.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.1].CGColor;
    self.awaitMyRespButton.layer.cornerRadius = 10.0;
    self.awaitMyRespButton.layer.borderWidth = 2.0;

    self.settingsButton.layer.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:0.1].CGColor;
    self.settingsButton.layer.cornerRadius = 10.0;
    self.settingsButton.layer.borderWidth = 2.0;
    
    
}



-(void) addFirstName {
    
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_ref child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *dict = snapshot.value;
        NSString *firstName = [dict valueForKey:@"First Name"];
        NSLog(@"First Name is %@" , firstName);
        
        self.welcomeLabel.text = [self.welcomeLabel.text stringByAppendingFormat:@" %@"  ,firstName];
              
              } withCancelBlock:^(NSError * _Nonnull error) {
                  NSLog(@"%@", error.localizedDescription);
              }];

    
}


- (IBAction)sendNewInviteTapped:(id)sender {
    
  
    
    SendNewInviteViewController *sendNewVC =
    [[SendNewInviteViewController alloc] initWithNibName:@"SendNewInviteViewController" bundle:nil];
    
    //hPViewController.userName  = eMailEntered;
    [self.navigationController pushViewController:sendNewVC animated:YES];
    
    [self presentViewController:sendNewVC animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)signOutTapped:(id)sender {
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            NSLog(@"User is signed in with uid: %@", user.uid);
        } else {
            NSLog(@"No user is signed in.");
        }
    }];
   
   [[FIRAuth auth] signOut:nil];
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"uid"];
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            NSLog(@"User is signed in with uid: %@", user.uid);
        } else {
            NSLog(@"No user is signed in.");
        }
    }];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"myViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
    
    
   }







@end

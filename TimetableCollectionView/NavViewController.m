//
//  NavViewController.m
//  TimetableCollectionView
//
//  Created by Igor Andrade on 6/19/15.
//  Copyright (c) 2015 Tokenlab. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:(114.0f/255.0f) green:(184.0f/255.0f) blue:(175.0f/255.0f) alpha:1.0f];
    [UINavigationBar appearance].titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
    // Do any additional setup after loading the view.
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

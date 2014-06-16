//
//  SearchTagViewController.h
//  AutoCommentInstagram
//
//  Created by Daniele Rognone on 15/05/13.
//  Copyright (c) 2013 Daniele Rognone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTagViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *hashtagToSearch;
@property (weak, nonatomic) IBOutlet UITextField *commentToSpam;

- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender;

@end

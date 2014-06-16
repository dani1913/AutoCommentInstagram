//
//  FeedTableViewController.h
//  AutoCommentInstagram
//
//  Created by Daniele Rognone on 11/05/13.
//  Copyright (c) 2013 Daniele Rognone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewController : UITableViewController

extern NSMutableString *commentToSpam;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;

- (void)downloadFeedByHashtag:(NSString *)hashtag commentWithSpam:(NSString*)comment;
- (IBAction)reloadButtonPushed:(UIBarButtonItem *)sender;

@end

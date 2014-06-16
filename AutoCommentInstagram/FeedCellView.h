//
//  FeedCellView.h
//  AutoCommentInstagram
//
//  Created by Daniele Rognone on 15/05/13.
//  Copyright (c) 2013 Daniele Rognone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedData.h"

@interface FeedCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (strong, nonatomic) FeedData *userFeed;

- (IBAction)likeButtonPressed:(UIButton *)sender;
- (IBAction)commentButtonPressed:(UIButton *)sender;


@end

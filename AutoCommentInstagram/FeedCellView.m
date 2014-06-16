//
//  FeedCellView.m
//  AutoCommentInstagram
//
//  Created by Daniele Rognone on 15/05/13.
//  Copyright (c) 2013 Daniele Rognone. All rights reserved.
//

#import "FeedCellView.h"
#import "ViewController.h"
#import "AFJSONRequestOperation.h"
#import "FeedTableViewController.h"

@implementation FeedCellView

@synthesize image = _image;
@synthesize userFeed = _userFeed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)likeButtonPressed:(UIButton *)sender {
    
    NSString *methodName = @"likeButtonPressed";
    NSLog(@"%@ - %@: %@", @"FeedCellView", methodName, @"started");
    
    NSString *idPicture = self.userFeed.imageId;
    
    NSString *accessTokenInstagram = [[NSUserDefaults standardUserDefaults] objectForKey:INSTAGRAM_ACCESS_TOKEN_KEY];
    NSString *searchPicInstagramUrl = [NSString stringWithFormat: @"https://api.instagram.com/v1/media/%@/likes?access_token=%@", idPicture, accessTokenInstagram];
    
    NSURL *url = [NSURL URLWithString:searchPicInstagramUrl];
    NSLog(@"%@", [url description]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Json description %@", [JSON description]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Json error %@", [JSON description]);
    }];
    
    [operation start];
}

- (IBAction)commentButtonPressed:(UIButton *)sender {

    NSString *accessTokenInstagram = [[NSUserDefaults standardUserDefaults] objectForKey:INSTAGRAM_ACCESS_TOKEN_KEY];

    NSString *idPicture = self.userFeed.imageId;
    NSString *searchPicInstagramUrl = [NSString stringWithFormat: @"https://api.instagram.com/v1/media/%@/comments?access_token=%@", idPicture, accessTokenInstagram];
    
    NSURL *url = [NSURL URLWithString:searchPicInstagramUrl];
    NSLog(@"%@", [url description]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
	NSString *postData = [NSString stringWithFormat:@"text=%@", commentToSpam];
    
	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	[request setValue:length forHTTPHeaderField:@"Content-Length"];
    
	[request setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Json description %@", [JSON description]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Json error %@", [JSON description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Ooops!"
                                   message: @"This feature is not available yet."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
    }];
    
    [operation start];
}
@end

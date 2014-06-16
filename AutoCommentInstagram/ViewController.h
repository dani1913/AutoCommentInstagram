//
//  ViewController.h
//  AutoCommentInstagram
//
//  Created by Daniele Rognone on 11/05/13.
//  Copyright (c) 2013 Daniele Rognone. All rights reserved.
//

#import <UIKit/UIKit.h>
#define INSTAGRAM_ACCESS_TOKEN_KEY @"access_token"

@interface ViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *loginWebView;

@end

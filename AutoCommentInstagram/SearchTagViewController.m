//
//  SearchTagViewController.m
//  AutoCommentInstagram
//
//  Created by Daniele Rognone on 15/05/13.
//  Copyright (c) 2013 Daniele Rognone. All rights reserved.
//

#import "SearchTagViewController.h"
#import "FeedTableViewController.h"
#import "ViewController.h"

@interface SearchTagViewController ()

@end

@implementation SearchTagViewController

@synthesize hashtagToSearch = _hashtagToSearch;
@synthesize commentToSpam = _commentToSpam;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"prepareForSegue - started");
    [segue.destinationViewController downloadFeedByHashtag:self.hashtagToSearch.text commentWithSpam:self.commentToSpam.text];
}

- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://instagram.com/accounts/logout/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        // Inside anotherViewController
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *rootViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Oh oh!"
                                   message: @"Something went wrong, retry."
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
    }
}
@end

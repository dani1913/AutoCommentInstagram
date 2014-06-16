//
//  ViewController.m
//  AutoCommentInstagram
//
//  Created by Daniele Rognone on 11/05/13.
//  Copyright (c) 2013 Daniele Rognone. All rights reserved.
//

#import "ViewController.h"
#import "AFJSONRequestOperation.h"

@interface ViewController () {
    
    NSString *_instagramCode;
}

@end

@implementation ViewController

@synthesize loginWebView = _loginWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginWebView.delegate = self;
	NSURL *url = [NSURL URLWithString:@"http://dani1913.altervista.org"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_loginWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    _instagramCode = [[[[[webView request] URL] query] componentsSeparatedByString:@"="] objectAtIndex:1];
    NSLog(@"webViewDidFinishLoad code from instagram %@", _instagramCode);

    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [@"grant_type=authorization_code&client_id=06e690864f3b4eb6a18d2389bf57aff3&client_secret=2ca91b309e364b039585b3ddd3b29c31&redirect_uri=http://dani1913.altervista.org/instagram_login.php&code=" stringByAppendingString:_instagramCode];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"IP Address: %@", [JSON description]);
        NSDictionary *jsonDictionary = JSON;
        [self performSelector:@selector(didReceiveJSONResponse:) withObject:jsonDictionary];
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON)
                {
                    NSLog(@"Failed: %@",[error localizedDescription]);
                    [self performSelector:@selector(didNotReceiveJSONResponse)];
                }];
    [operation start];
}

- (void)didReceiveJSONResponse:(NSDictionary *)jsonDicitonary {
    
    NSString * methodName = @"didReceiveJSONResponse";
    NSLog(@"%@", [NSString stringWithFormat:@"%@ - %@", methodName, @"started"]);
    
    NSString *accessTokenValue = [jsonDicitonary valueForKey:INSTAGRAM_ACCESS_TOKEN_KEY];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:accessTokenValue forKey:INSTAGRAM_ACCESS_TOKEN_KEY];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@ - %@ : %@", methodName, @"preference value", [preferences valueForKey:INSTAGRAM_ACCESS_TOKEN_KEY]]);
}

- (void)didNotReceiveJSONResponse {
    
}

@end

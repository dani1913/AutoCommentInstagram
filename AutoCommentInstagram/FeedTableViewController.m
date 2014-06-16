//
//  FeedTableViewController.m
//  AutoCommentInstagram
//
//  Created by Daniele Rognone on 11/05/13.
//  Copyright (c) 2013 Daniele Rognone. All rights reserved.
//

#import "FeedTableViewController.h"
#import "AFJSONRequestOperation.h"
#import "ViewController.h"
#import "FeedCellView.h"
#import "AFImageRequestOperation.h"
#import "FeedData.h"

#define IMG_KEY_LOW_RESOLUTION      @"low_resolution"
#define IMG_KEY_STANDARD_RESOLUTION @"standard_resolution"
#define IMG_KEY_THUMBNAIL           @"thumbnail"
#define IMAGES_KEY                  @"images"
#define CAPTION_KEY                 @"caption"
#define USERNAME_KEY                @"username"
#define DATA_KEY                    @"data"

#define THIS_CLASS_NAME @"FeedTableViewController"

#define LABEL_WIDTH 80
#define LABEL_HEIGHT 20

@interface FeedTableViewController () {
    
    NSString *_hashtag;
    NSString *_commentSpam;
    NSString *_nextMaxTagId;
    NSString *_accessTokenInstagram;
    NSMutableArray *_arrayOfFeed;
    UIActivityIndicatorView *_activityIndicatorView;
    UIView *_activityIndicatorViewContainer;
}

-(void)downloadDataByMaxTagId:(NSString *)nextMaxTagId;

@end

@implementation FeedTableViewController

NSMutableString *commentToSpam;

@synthesize reloadButton = _reloadButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _accessTokenInstagram = [[NSUserDefaults standardUserDefaults] objectForKey:INSTAGRAM_ACCESS_TOKEN_KEY];
    
    _activityIndicatorViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    [_activityIndicatorViewContainer addSubview:_activityIndicatorView];
    _activityIndicatorView.center = _activityIndicatorViewContainer.center;
    self.tableView.tableHeaderView = _activityIndicatorViewContainer;

    [self downloadDataByMaxTagId:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOfFeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedCellView";
    FeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (!cell) {
        cell = [[FeedCellView alloc] init];
    }
    
    FeedData *userFeed = [_arrayOfFeed objectAtIndex:indexPath.row];
    
    cell.image.image = userFeed.image;
    cell.nickname.text = [NSString stringWithFormat:@"@%@", userFeed.username];
    cell.nickname.textColor = [UIColor grayColor];
    cell.userFeed = userFeed;

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)downloadDataByMaxTagId:(NSString *)nextMaxTagId {
    
    NSString *methodName = @"downloadDataByMaxTagId";
    NSString *queryStringMaxId;

    NSLog(@"%@ - %@: %@", THIS_CLASS_NAME, methodName, @"started");

    if(nextMaxTagId) {
        _nextMaxTagId = nextMaxTagId;
        queryStringMaxId = [NSString stringWithFormat:@"max_id=%@&", nextMaxTagId];
    }
    else {
        queryStringMaxId = @"";
    }

    NSString *searchPicInstagramUrl = [NSString stringWithFormat: @"https://api.instagram.com/v1/tags/%@/media/recent?%@access_token=%@", _hashtag, queryStringMaxId, _accessTokenInstagram];
    NSURL *url = [NSURL URLWithString:searchPicInstagramUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    self.reloadButton.enabled = NO;
    [_activityIndicatorView startAnimating];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@ - %@ Json is correct", THIS_CLASS_NAME, methodName);
        NSDictionary *jsonData = JSON;
        [self performSelector:@selector(didReveiveJsonWithResponse:) withObject:jsonData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@ - %@ Json error", THIS_CLASS_NAME, methodName);
        [_activityIndicatorView stopAnimating];
        UILabel *noResultsFound = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        noResultsFound.text =@"No results found";
        self.tableView.tableHeaderView = noResultsFound;
    }];

    [operation start];
}

- (void)downloadFeedByHashtag:(NSString *)hashtag commentWithSpam:(NSString*)comment {
    
    NSLog(@"%@ with #hashtag %@", @"setHashtagToSearch invoked", hashtag);
    _hashtag = hashtag;
    //_commentSpam = comment;
    commentToSpam = [[NSMutableString alloc] initWithString:comment];
}

- (void)didReveiveJsonWithResponse:(NSDictionary *)jsonData {

    NSString *methodName = @"didReceiveJsonWithReposnse";
    NSLog(@"%@ - %@ - started and jsonData is null: %d", THIS_CLASS_NAME, methodName, (id)jsonData == [NSNull null]);

    NSLog(@"jDataDescription %@", [jsonData description]);
    
    NSArray *tmp = [jsonData objectForKey:DATA_KEY];
    if([tmp count] == 0) {
        [_activityIndicatorView stopAnimating];
        UILabel *noResultsFound = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        noResultsFound.text =@"No results found";
        self.tableView.tableHeaderView = noResultsFound;
        return;
    }
    
    NSOperationQueue *imageRequestQueue = [[NSOperationQueue alloc] init];
    int tmpLengh = tmp.count;

    _arrayOfFeed = [NSMutableArray array];
    for(int i=0; i<tmpLengh; i++) {

        FeedData *userFeed = [[FeedData alloc] init];
        
        NSDictionary *tmpDictionary = [tmp objectAtIndex:i];

        NSDictionary *tmpCaption = [tmpDictionary objectForKey:CAPTION_KEY];
        //sometimes the caption is null
        if(tmpCaption != (NSDictionary*)[NSNull null]) {
            
            userFeed.username = [[tmpCaption objectForKey:@"from"] objectForKey:USERNAME_KEY];
            userFeed.imageId = [tmpDictionary objectForKey:@"id"];

            NSDictionary *tmpImg = [tmpDictionary objectForKey:IMAGES_KEY];
            NSURL *url = [NSURL URLWithString:[[tmpImg objectForKey:IMG_KEY_THUMBNAIL] objectForKey:@"url"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];

            AFImageRequestOperation *imageRequestOp = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image){
            
                userFeed.image = image;
                [_arrayOfFeed addObject:userFeed];
                if(i == tmpLengh-1) {
                    [_activityIndicatorView stopAnimating];
                    self.tableView.tableHeaderView = nil;
                    self.reloadButton.enabled = YES;
                    [self.tableView reloadData];
                }
            }];
            [imageRequestQueue addOperation:imageRequestOp];
        }
    }
}


- (IBAction)reloadButtonPushed:(UIBarButtonItem *)sender {

    NSString *methodName = @"reloadButtonPushed";
    NSLog(@"%@ - %@ started", THIS_CLASS_NAME, methodName);
    
    self.tableView.tableHeaderView = _activityIndicatorViewContainer;
    [self downloadDataByMaxTagId:_nextMaxTagId];
}

@end

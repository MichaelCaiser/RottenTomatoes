//
//  RestaurantTableVC.m
//  Yelp
//
//  Created by Cheng-Yuan Wu on 6/24/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "RestaurantTableVC.h"
#import "YelpClient.h"
#import "RestaurantDataObject.h"
#import "RestaurantTableCell.h"
#import <UIImageView+AFNetworking.h>
#import "FilterTableVC.h"
//#import "UISearchBarDelegate.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

//NSMutableDictionary *searchOptions;
NSMutableDictionary *searchOptions;
@interface RestaurantTableVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationBarItem;
@property (strong, nonatomic) UIButton *filterButton;
@property (strong, nonatomic) YelpClient *client;
@property (strong, nonatomic) NSMutableArray *restaurants;
@property (strong, nonatomic) FilterTableVC *filterController;
@property (strong, nonatomic) UISearchBar *searchBar;
@end


@implementation RestaurantTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"detail view did load");
    //setup
    self.restaurants = [[NSMutableArray alloc] init];
    //[self setupNavigationBar];
    [self setupFilterButton:@"Filter"];
    [self setupSearchBar];
    [self setupFilterView];

    if (!searchOptions){
        [self setupSearchOptions];
    }
    
    //API request
    [self sendRequest: searchOptions];


    //table view setup
    [self.restaurantTableView registerNib:[UINib nibWithNibName:@"RestaurantTableCell" bundle:nil] forCellReuseIdentifier:@"RestaurantTableCell"];
    self.restaurantTableView.dataSource = self;
    self.restaurantTableView.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    //view pushed from filter view, do the new request with filter
    NSLog(@"didAppear-----------");
    NSLog(@"%@", searchOptions);
    [self sendRequest: searchOptions];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.restaurants count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RestaurantTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantTableCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[RestaurantTableCell alloc] init];
    }
    
    cell.name.text = [(RestaurantDataObject *)self.restaurants[indexPath.row] name];
    cell.address.text = [(RestaurantDataObject *)self.restaurants[indexPath.row] address];

    cell.type.text = [(RestaurantDataObject *)self.restaurants[indexPath.row] type];
    cell.distance.text = [(RestaurantDataObject *)self.restaurants[indexPath.row] distance];

    cell.reviewCount.text = [(RestaurantDataObject *)self.restaurants[indexPath.row] review];

    [cell.restaurantImage setImageWithURL:[NSURL URLWithString:[self.restaurants[indexPath.row] mainImgUrl]]];
    [cell.ratingImage setImageWithURL:[NSURL URLWithString:[self.restaurants[indexPath.row] ratingImgUrl]]];
    /*
    //assign image to the cell
    NSURL *url =[NSURL URLWithString:[self.restaurants[indexPath.row] mainImgUrl]];
    NSLog(@"url===========%@", [self.restaurants[0] mainImgUrl]);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSLog(@"url===========%@", [self.restaurants[indexPath.row] mainImgUrl]);
    [cell.restaurantImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeHolder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [cell.restaurantImage setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //err handling
        NSLog(@"error loagin img");
    }];
    
    url =[NSURL URLWithString:[self.restaurants[indexPath.row] ratingImgUrl]];
    request = [[NSURLRequest alloc] initWithURL:url];
    [cell.ratingImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeHolder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [cell.ratingImage setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //err handling
                NSLog(@"error loagin img");
    }];
     */
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  110.0f;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    NSLog(@"did select");
    FilterTableVC *controller = [[FilterTableVC alloc] initWithNibName:@"FilterTableVC" bundle:nil];
    if (!self.navigationController) {
        NSLog(@"navi is nil");
    }
    [self.navigationController pushViewController:controller animated:YES];
    
    //<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
     
}
*/


- (void)sendRequest {    
   // self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        //default search keyword
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"success");
            [self setupData:response];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
}

- (void)sendRequest:(NSMutableDictionary *)filter {
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        //default search keyword
        [self.client searchWithDict:filter success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"success");
            [self setupData:response];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
}
- (void)sendSearchRequest:(NSString *)keyWord {
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:keyWord success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"success");
            [self setupData:response];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
}

- (void)filterButtonAction {
    if(!self.filterController)
        NSLog(@"filter is nil");
    [self.navigationController pushViewController: self.filterController animated:YES];
}

#pragma mark - UISearchBar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"TextDidEndEditing");
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"TextDidBeginEditing");
    //reset the search bar
    searchBar.text = @"";
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
//    [self.client searchWithTerm:searchBar.text success:^(AFHTTPRequestOperation *operation, id response) {
    [self sendSearchRequest:searchBar.text];

    //do API search
}

- (void)setupData:(id)responseData {
    //clear original data
    [self.restaurants removeAllObjects];
    //add new search result data
    for(NSDictionary *restaurant in responseData[@"businesses"]) {
        RestaurantDataObject *restaurantObj = [[RestaurantDataObject alloc] initWithRawData:restaurant];
        [self.restaurants addObject:restaurantObj];
    }

    // you can request image here!!
    [self.restaurantTableView reloadData];
}

- (void)setupFilterButton:(NSString *)buttonTitle {
    self.filterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [self.filterButton setBackgroundColor:[UIColor redColor]];
    [self.filterButton.layer setBorderWidth:1.5f];
    [self.filterButton.layer setBorderColor:[UIColor brownColor].CGColor];
    [self.filterButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.filterButton addTarget:self action:@selector(filterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(100.0f, 10.0f, 200.0f, 15.0f)];
    [self.searchBar setPlaceholder:@"Restaurants"];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;

    UIBarButtonItem *filterBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.filterButton];
    
    [self.navigationItem setTitleView:self.searchBar];
    [self.navigationItem setLeftBarButtonItem:filterBarItem];

//    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    


//    self.myNavigationBarItem.titleView = searchBar;
//    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
//    self.navigationBarItem.rightBarButtonItem = searchBarItem;
//    self.myNavigationBarItem.leftBarButtonItem = filterBarItem;

//    [self.navigationController setToolbarHidden:YES];
}

- (void)setupNavigationBar {

    [self.myNavigationBar setBackgroundColor:[UIColor redColor]];
    [self.myNavigationBar setBarTintColor:[UIColor redColor]];
    //    self.navigationBar.opaque = YES;
    [self.myNavigationBar setAlpha:1.0f];
    
//    [self.navigationController setToolbarItems:<#(NSArray *)#>
}

- (void)setupFilterView {
    self.filterController = [[FilterTableVC alloc] initWithNibName:@"FilterTableVC" bundle:nil];
//    self.filterController = [[FilterTableVC alloc] init];
}

- (void)setupSearchOptions {
    searchOptions = [[NSMutableDictionary alloc] init];
    NSNumber *match = [[NSNumber alloc] initWithInt:0];
    [searchOptions setObject:match forKey:@"sort"];
    NSNumber *num = [[NSNumber alloc] initWithFloat:0.3f];
    [searchOptions setObject:num forKey:@"distance"];
//    NSMutableArray *category = [[NSMutableArray alloc] initWithObjects:@"thai", nil];
//    [searchOptions setObject:category forKey:@"category"];
    [searchOptions setObject:@"37.774866,-122.394556" forKey: @"ll"];
}

@end

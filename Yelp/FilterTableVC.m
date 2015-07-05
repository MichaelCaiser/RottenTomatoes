//
//  FilterTableVC.m
//  Yelp
//
//  Created by Cheng-Yuan Wu on 6/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterTableVC.h"
#import "DropDownTableCell.h"
#import "SwitchTableCell.h"
#import "RestaurantTableVC.h"
#import "SwitchCellDelegate.h"
#import "YelpClient.h"

@interface FilterTableVC () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *filterTableView;
@property (nonatomic) BOOL isExpandingSortCell;
@property (nonatomic) BOOL isExpandingDistanceCell;
@property (nonatomic) BOOL isExpandingCategoryCell;
@property (nonatomic) NSInteger selectedSortOption;
@property (nonatomic) NSInteger selectedDistanceOption;
@property (nonatomic) NSInteger selectedCategoryOption;
@property (strong, nonatomic) NSArray *sortOptions;
@property (strong, nonatomic) NSArray *distanceOptions;
@property (strong, nonatomic) NSArray *categoryOptions;
@property (strong, nonatomic) NSArray *sectionTitle;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) RestaurantTableVC *restaurantController;

@end

@implementation FilterTableVC
//@synthesize isExpandingCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSectionTitle];

    self.selectedDistanceOption = 0;
    self.selectedSortOption = 0;
    self.isExpandingSortCell = NO;
    self.isExpandingDistanceCell = NO;
    self.isExpandingCategoryCell = NO;
    self.sortOptions = [[NSArray alloc] initWithObjects:@"Best Match", @"Distance", @"Highest Rate", nil];
    self.distanceOptions = [[NSArray alloc] initWithObjects:@"0.3", @"0.5", @"1", @"3",@"5",nil];
    self.categoryOptions = [[NSArray alloc] initWithObjects:@"Thai", @"French", @"Vegetarian", @"Cafes",@"Breakfast & Brunch", nil];
    self.filterTableView.dataSource = self;
    self.filterTableView.delegate = self;
     //   [self.restaurantTableView registerNib:[UINib nibWithNibName:@"RestaurantTableCell" bundle:nil] forCellReuseIdentifier:@"RestaurantTableCell"];
    [self.filterTableView registerNib:[UINib nibWithNibName:@"DropDownTableCell" bundle:nil]  forCellReuseIdentifier:@"DropDownTableCell"];
    [self.filterTableView registerNib:[UINib nibWithNibName:@"SwitchTableCell" bundle:nil]  forCellReuseIdentifier:@"SwitchTableCell"];
    
    
    [self setupSearchButton];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    //view pushed
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //1) sort by 2) category 3) distance 4) deal
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.isExpandingSortCell ? [self.sortOptions count] : 1;
        case 1:
            return self.isExpandingDistanceCell ? [self.distanceOptions count] : 1;
        case 2:
            return self.isExpandingCategoryCell ? [self.categoryOptions count] + 1 : 3;
                                                                            //show less
        case 3:
            return 1;
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    switch (indexPath.section) {
        case 0: //sort cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownTableCell" forIndexPath:indexPath];
            if (!cell) {
                cell = [[DropDownTableCell alloc] init];
            }
            if (self.isExpandingSortCell) {
                ((DropDownTableCell *)cell).cellTitle.text = self.sortOptions[indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else {
                ((DropDownTableCell *)cell).cellTitle.text = self.sortOptions[self.selectedSortOption];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

            break;
        case 1: //distance cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownTableCell" forIndexPath:indexPath];
            
            if (!cell) {
                cell = [[DropDownTableCell alloc] init];
            }
            
            if (self.isExpandingDistanceCell) {
                ((DropDownTableCell *)cell).cellTitle.text = self.distanceOptions[indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else {
                ((DropDownTableCell *)cell).cellTitle.text = self.distanceOptions[self.selectedDistanceOption];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

            break;
        case 2:
            NSLog(@"cell return-------------");
            //沒展開時
            if (!self.isExpandingCategoryCell && indexPath.row == 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownTableCell" forIndexPath:indexPath];
                ((DropDownTableCell *)cell).cellTitle.text = @"More options ...";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            //展開時的最後一個 cell
            else if (indexPath.row == [self.categoryOptions count]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownTableCell" forIndexPath:indexPath];
                ((DropDownTableCell *)cell).cellTitle.text = @"Show Less";
//                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            //展開時其他 cell
            else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTableCell" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[SwitchTableCell alloc] init];
                }
                ((SwitchTableCell *)cell).cellTitle.text = self.categoryOptions[indexPath.row];
                //setup switch each time the cell is reused
                //work around

                
                
                switch (indexPath.row) {
                    case 0:
                        ((SwitchTableCell *)cell).uiSwitch.on =  [self containCategoryOption:@"thai"];
                        break;
                    case 1:
                        ((SwitchTableCell *)cell).uiSwitch.on =  [self containCategoryOption:@"french"];
                        break;
                    case 2:
                        ((SwitchTableCell *)cell).uiSwitch.on =  [self containCategoryOption:@"vegetarian"];
                        break;
                    case 3:
                        ((SwitchTableCell *)cell).uiSwitch.on =  [self containCategoryOption:@"cafes"];
                        break;
                    case 4:
                        ((SwitchTableCell *)cell).uiSwitch.on =  [self containCategoryOption:@"breakfast_brunch"];
                        break;
                    default:
                        break;
                }

//                ((SwitchTableCell *)cell).uiSwitch
                ((SwitchTableCell *)cell).delegate = self;
            }
            
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTableCell" forIndexPath:indexPath];
            ((SwitchTableCell *)cell).cellTitle.text = @"deal";
            ((SwitchTableCell *)cell).delegate = self;
            break;
        default:
            break;
    }

//    cell.accessoryType = UITableViewCellAccessoryCheckmark;

//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    cell setAccessoryView:<#(UIView *)#>
    
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitle[section];
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    switch (indexPath.section) {
        case 0 : {
            if (self.isExpandingSortCell) {
                self.selectedSortOption = indexPath.row;
            }
            self.isExpandingSortCell =  self.isExpandingSortCell ? NO : YES;

            //reload section
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case 1:
            if (self.isExpandingDistanceCell) {
                self.selectedDistanceOption = indexPath.row;
            }
            self.isExpandingDistanceCell =  self.isExpandingDistanceCell ? NO : YES;
            //reload section
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case 2:
            //show more
            if (!self.isExpandingCategoryCell && indexPath.row == 2) {
                self.isExpandingCategoryCell = YES;
                
                //reload section
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            //show less
            else if (self.isExpandingCategoryCell && indexPath.row == [self.categoryOptions count]) {
                self.isExpandingCategoryCell = NO;
                //reload section
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        default:
            break;
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchButtonAction {
    [self addSearchOptions:@"sort" value:[NSString stringWithFormat:@"%ld", self.selectedSortOption]];
    switch (self.selectedDistanceOption) {
        case 0:
            [self addSearchOptions:@"distance" value:@"0.3"];
            break;
        case 1:
            [self addSearchOptions:@"distance" value:@"0.5"];
            break;
        case 2:
                [self addSearchOptions:@"distance" value:@"1"];
            break;
        case 3:
                [self addSearchOptions:@"distance" value:@"3"];
            break;
        case 4:
                [self addSearchOptions:@"distance" value:@"5"];
            break;
    }

    //---------------
    //pop to main page and do the search
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setup
- (void)setupSectionTitle {
    self.sectionTitle = [[NSArray alloc] initWithObjects:@"Sort by", @"distance", @"category", @"deal", nil];
}

- (void)setupNavigationBar {
    [self.navigationController setTitle:@"Filter"];
}

- (void)setupSearchButton {
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [self.searchButton.layer setBorderWidth:1.5f];
    [self.searchButton.layer setBorderColor:[UIColor brownColor].CGColor];
    [self.searchButton setBackgroundColor:[UIColor redColor]];
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

/*
 * "sort" : 0 (Best match)
 *          1 (distance)
 *          2 (highest rate)
 * "category_filter" : "thai"
 *                     "french"
 *                     "vegetarian"
 *                     "cafes"
 *                     "breakfast_brunch"
 * "distance": number
 */


- (BOOL)containCategoryOption:(NSString *)category
{

    NSMutableArray *categoryArr = searchOptions[@"category_filter"];
        if (!categoryArr) {
            return NO;
        }
        else {
            return [categoryArr containsObject:category];
        }
}

- (void)addSearchOptions:(NSString *)key value:(NSString *)value
{
    if ([key isEqualToString:@"sort"] || [key isEqualToString:@"distance"]) {
        [searchOptions setObject:value forKey:key];
    }
    else if ([key isEqualToString:@"category_filter"]) {
        NSMutableArray *category = searchOptions[key];
        if (!category) {
            category = [[NSMutableArray alloc] init];
        }
        [category addObject:value];
        [searchOptions setObject:category forKey:key];
    }
}

- (void)removeSearchOptions:(NSString *)key value:(NSString *)value
{
    if ([key isEqualToString:@"category_filter"]) {
        NSMutableArray *category = searchOptions[key];
        //check exist?
        if (category) {
            if ([category containsObject:value]) {
                [category removeObject:value];
                [searchOptions setObject:category forKey:key];
            }
        }
    }
}

- (void)switchCell:(UITableViewCell *)cell didUpdateValue:(BOOL)value {
    NSLog(@"switch update------------------");
        //add to dict
    //NSString *title = ((SwitchTableCell *)cell).cellTitle.text;
    NSInteger section = [self.tableView indexPathForCell:cell].section;
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    if (section == 2) { // category section
        switch (index) {
            case 0:
                value ? [self addSearchOptions:@"category_filter" value:@"thai"] : [self removeSearchOptions:@"category_filter" value:@"thai"];
                break;
            case 1:
                value ? [self addSearchOptions:@"category_filter" value:@"french"] : [self removeSearchOptions:@"category_filter" value:@"french"];
                break;
            case 2:
                value ? [self addSearchOptions:@"category_filter" value:@"vegetarian"] : [self removeSearchOptions:@"category_filter" value:@"vegetarian"];
                break;
            case 3:
                value ? [self addSearchOptions:@"category_filter" value:@"cafes"] : [self removeSearchOptions:@"category_filter" value:@"cafes"];
                break;
            case 4:
                value ? [self addSearchOptions:@"category_filter" value:@"breakfast_brunch"] : [self removeSearchOptions:@"category_filter" value:@"breakfast_brunch"];
                break;
            default:
                break;
        }
    }
    
    //seach and update
}


@end

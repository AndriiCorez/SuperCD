//
//  HeroListController.m
//  SuperCD
//
//  Created by Corezina on 2/5/16.
//  Copyright © 2016 Corezina. All rights reserved.
//

#import "HeroListController.h"
#import "AppDelegate.h"

@interface HeroListController ()
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@end

@implementation HeroListController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    //selecting Tab bar Btn
    //UITabBarItem *item = [self.heroTabBar.items objectAtIndex:0];
    //[self.heroTabBar setSelectedItem:item];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Select the Tab Bar button
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger selectedTab = [defaults integerForKey:kSelectedTabDefaultKey];
    UITabBarItem *itemBar = [self.heroTabBar.items objectAtIndex:selectedTab];
    [self.heroTabBar setSelectedItem:itemBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITabBarDelegate Methods
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    [defaults setInteger:tabIndex forKey:kSelectedTabDefaultKey];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController*)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Hero" inManagedObjectContext:managedObjectContext];
    //sets for fetch request
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    //user defaults if no tab is selected
    NSUInteger tabIndex = [self.heroTabBar.items indexOfObject:self.heroTabBar.selectedItem];
    if (tabIndex == NSNotFound) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        tabIndex = [defaults integerForKey:kSelectedTabDefaultKey];
    }
    //sorting - telling what entity is used for sorting
    NSString *sectionKey = nil;
    switch (tabIndex) {
        case kByName:{
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            sectionKey = @"name";
            break;
        }
        case kBySecretIdentity:{
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            sectionKey = @"secretIdentity";
            break;
        }
        default:
            break;
    }
    //instantiate fetch results controller
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:sectionKey cacheName:@"Hero"];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.heroTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.heroTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.heroTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.heroTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.heroTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.heroTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        case NSFetchedResultsChangeUpdate:
        case NSFetchedResultsChangeMove:
            break;
    }
}

#pragma mark - UIAlertController handler methods
- (void)dismissButtonOnAlertController:(UIAlertAction*)action{
    exit(-1);
}

- (void)showAlert:(NSString*)title
          message:(NSString*)message
       buttonText:(NSString*)buttonText
          handler:(void(^)(UIAlertAction *alert))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKBtn = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
    [alert addAction:OKBtn];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Edit and Add buttons action
- (IBAction)addHero:(id)sender {
    NSManagedObjectContext *contextMO = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:contextMO];
    
    NSError *error = nil;
    if (![contextMO save:&error]) {
        NSString *message = [NSString stringWithFormat:@"Error addHero %@: quit", error.localizedDescription];
        [self showAlert:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:NSLocalizedString(message, message) buttonText:NSLocalizedString(@"OK", @"OK") handler:^(UIAlertAction *alert) {
            [self dismissButtonOnAlertController:alert];
        }];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    self.addBtn.enabled = !editing;
    [self.heroTableView setEditing:editing animated:animated];
}



@end

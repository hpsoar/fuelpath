//
//  TestViewController.m
//  fuelpath
//
//  Created by Aldrich Huang on 3/1/14.
//  Copyright (c) 2014 beacon. All rights reserved.
//

#import "TestViewController.h"
#import "TestNewActivityViewController.h"
#import "TestMapViewController.h"

@interface TestViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, TestNewActivityViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedActivityController;

@end

@implementation TestViewController

- (NSFetchedResultsController *)fetchedActivityController {
    if (_fetchedActivityController == nil) {
        NSFetchRequest *fetchRequest = [self.dataStore fetchRequestForActivity];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        _fetchedActivityController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataStore.managedObjectContext sectionNameKeyPath:nil cacheName:@"Activities"];
        _fetchedActivityController.delegate = self;
        
        NSError *error;
        if (![_fetchedActivityController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
    return _fetchedActivityController;
}

- (IBAction)newActivity:(id)sender {
    TestNewActivityViewController *newActivityViewController = [[TestNewActivityViewController alloc] initWithNibName:NSStringFromClass([TestNewActivityViewController class]) bundle:nil];

    newActivityViewController.dataStore = self.dataStore;
    newActivityViewController.delegate = self;
    
    [self presentViewController:newActivityViewController animated:YES completion:nil];
}

- (void)testNewActivityViewController:(TestNewActivityViewController *)controller didFinishActivity:(RunningActivity *)activity {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedActivityController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.fetchedActivityController.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ActivityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Activity *activity = [self.fetchedActivityController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", activity.title, activity.beginTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TestMapViewController *testMapViewController = [[TestMapViewController alloc] initWithNibName:NSStringFromClass([TestMapViewController class]) bundle:nil];
    testMapViewController.activity = [self.fetchedActivityController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:testMapViewController animated:YES];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

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
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.title = @"Activities";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonSystemItemAdd target:self action:@selector(newActivity:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

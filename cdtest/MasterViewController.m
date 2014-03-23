//
//  MasterViewController.m
//  cdtest
//
//  Created by Marco Pappalardo (private) on 23/03/14.
//  Copyright (c) 2014 Marco Pappalardo (private). All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#define LOAD_DELAYED    1

@interface MasterViewController ()

@property NSMutableArray *notes;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    /*UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadRecords];
    });
}

- (void)loadRecords
{
    _notes = [NSMutableArray arrayWithArray: @[@{@"id":@1, @"text": @"First note"},
                                                              @{@"id":@2, @"text": @"Secon note with a link to http://www.google.de"},
                                                              @{@"id":@3, @"text": @"Third note"},
                                                              @{@"id":@4, @"text": @"Fourth note"},
                                                              @{@"id":@5, @"text": @"Fifth note with an email adress to jakob@mbraceapp.com"},
                                                              @{@"id":@6, @"text": @"6th note"},
                                                              @{@"id":@6, @"text": @"6th note updated"},
                                                              @{@"id":@7, @"text": @"7th note"},
                                                              @{@"id":@8, @"text": @"8th note"},
                                                              @{@"id":@9, @"text": @"9th note"},
                                                              @{@"id":@10, @"text": @"10th note"},
                                                              @{@"id":@11, @"text": @"11th note"},
                                                              @{@"id":@12, @"text": @"12th note"},
                                                              @{@"id":@13, @"text": @"13th note"},
                                                              @{@"id":@14, @"text": @"14th note"},
                                                              @{@"id":@15, @"text": @"get mbrace at http://www.getmbrace.com"},
                                                              @{@"id":@16, @"text": @"16th note"},
                                                              @{@"id":@17, @"text": @"17th note"},
                                                              @{@"id":@18, @"text": @"18th note"},
                                                              @{@"id":@19, @"text": @"19th note"},
                                                              @{@"id":@20, @"text": @"20th note"},
                                                              @{@"id":@21, @"text": [NSNull null]},
                                                              @{@"id":@22, @"text": @"22th note"},
                                                              @{@"id":@23, @"text": @"23th note"},
                                                              @{@"id":@24, @"text": @"Visit www.mbraceapp.com"},
                                                              @{@"id":@25, @"text": @"25th note"},
                                                              @{@"id":@26, @"text": @"Note that is a little bit longer than all the other notes because of consiting of some strings that are useless and take a lot of space"},
                                                              @{@"id":@27, @"text": @"27th note"},
                                                              @{@"id":@28, @"text": @"28th note"},
                                                              @{@"id":@29, @"text": @"29th note"},
                                                              @{@"id":@30, @"text": @"another email to lukas@mbraceapp.com"},
                                                              @{@"id":@31, @"text": @"31th note"},
                                                              @{@"id":@32, @"text": @"32th note"},
                                                              @{@"id":@33, @"text": @"33th note"},
                                                              @{@"id":@34, @"text": @"almost at the end note"},
                                                              @{@"id":@35, @"text": @"Last note note"},
                                                              @{@"id":@12, @"text": @"Updated 12th note"}]
                             ];
    
    /*for(int i=40; i<540; i++)
    {
        [_notes addObject:@{@"id":[NSNumber numberWithInt:i], @"text": @"buffer note"}];
    }*/
    
#if LOAD_DELAYED
    [self insertNextObject:[NSNumber numberWithInt:0]];
#else
    for(NSDictionary *note in _notes)
    {
        [self insertNewObjectWithId:[[note objectForKey:@"id"] intValue] andText:[note objectForKey:@"text"]];
    }
#endif
}

- (void)insertNextObject:(NSNumber *)index
{
    NSDictionary *note = [_notes objectAtIndex:[index intValue]];
    
    NSArray *object = [NSArray arrayWithObjects:[note objectForKey:@"id"], [note objectForKey:@"text"], nil];
    
    [self insertObject:object];
    
    if([index intValue] + 1 < [_notes count])
    {
        [self performSelector:@selector(insertNextObject:) withObject:[NSNumber numberWithInt:[index intValue] + 1] afterDelay:0.15];
    }
}

- (void)insertObject:(NSArray *)object
{
    [self insertNewObjectWithId:[[object objectAtIndex:0] intValue] andText:[object objectAtIndex:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:0 forKey:@"id"];
    [newManagedObject setValue:@"default" forKey:@"text"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)insertNewObjectWithId:(int)ID andText:(NSString *)text
{
    if(text != (id)[NSNull null] && text != nil)
    {
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *matches = [linkDetector matchesInString:text options:0 range:NSMakeRange(0, [text length])];
        
        for (NSTextCheckingResult *match in matches)
        {
            if ([match resultType] == NSTextCheckingTypeLink)
            {
                NSString *schemeLessUrl = [[[[match URL] absoluteString] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
                
                NSString *urlString = [NSString stringWithFormat:@"<a href=\"%@\"> %@ </a>", [[match URL] absoluteString], schemeLessUrl];
                
                NSString *htmlString = [NSString stringWithFormat:@"\
                                       <html><head>\
                                       <style type=\"text/css\">\
                                       body {\
                                       background-color: white;\
                                       color: black;\
                                       font-family: arial;\
                                       font-size: 15;\
                                       }\
                                       </style>\
                                       </head><body style=\"margin:0\">\
                                       %@\
                                       </body></html>", urlString];
                
                NSString *newString = [text stringByReplacingOccurrencesOfString:[[match URL] absoluteString] withString:htmlString];
                
                if([newString isEqualToString:text])
                    text = [text stringByReplacingOccurrencesOfString:schemeLessUrl withString:htmlString];
                else
                    text = newString;
                
            }
        }
    }
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Note" inManagedObjectContext:context]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %i", ID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    for(NSManagedObject *object in results)
    {
        [context deleteObject:object];
        [context processPendingChanges];
    }
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSNumber numberWithInt:ID] forKey:@"id"];
    [newManagedObject setValue:(text != nil && text != (id)[NSNull null]) ? text : @"" forKey:@"text"];
    
    //NSLog(@"insert object with id %i and text %@", ID, text);
    
    // Save the context.
    error = nil;
    
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if([[object valueForKey:@"text"] isEqualToString:@""])
        cell.textLabel.text = @"[empty note]";
    else
        cell.textLabel.text = [object valueForKey:@"text"];
}

@end

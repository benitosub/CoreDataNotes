//
//  MasterViewController.h
//  cdtest
//
//  Created by Marco Pappalardo (private) on 23/03/14.
//  Copyright (c) 2014 Marco Pappalardo (private). All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

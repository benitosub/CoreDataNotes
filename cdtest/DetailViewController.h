//
//  DetailViewController.h
//  cdtest
//
//  Created by Marco Pappalardo (private) on 23/03/14.
//  Copyright (c) 2014 Marco Pappalardo (private). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *noteTextWebView;

@end

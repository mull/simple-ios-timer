//
//  ViewController.h
//  Timer
//
//  Created by Emil Ahlbäck on 08/08/14.
//  Copyright (c) 2014 Emil Ahlbäck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *stopwatchLabel;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *pauseButton;

@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSMutableArray *loggedTimes;

@property (nonatomic, weak) IBOutlet UITableView *tableView;


- (IBAction)onStartPressed:(id)sender;
- (IBAction)onResetPressed:(id)sender;
- (IBAction)onClearPressed:(id)sender;
@end

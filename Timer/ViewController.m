//
//  ViewController.m
//  Timer
//
//  Created by Emil Ahlbäck on 08/08/14.
//  Copyright (c) 2014 Emil Ahlbäck. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController
{
  BOOL isRunning;
  int numberOfLogs;
  int continuingForLog;
  NSMutableArray *loggedTimes;
  double pauseTime;
  
}

- (NSString *)timeString
{
  NSString *timeString;
  if (self.startDate) {
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    timeInterval += pauseTime;
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    timeString = [dateFormatter stringFromDate:timerDate];
    
  } else {
    timeString = @"00:00:00.000";
  }
  
  return timeString;
}

- (void)logCurrentTime
{
  NSString *currentTime = [self timeString];
  [loggedTimes addObject:currentTime];
  
  [self.tableView reloadData];
}

- (void)logCurrentTimeReplaceLast
{
  if ([loggedTimes count] < 1) {
    [self logCurrentTime];
  } else {
    NSString *currentTime = [self timeString];
    [loggedTimes replaceObjectAtIndex:([loggedTimes count] - 1)
                           withObject:currentTime];
    
    [self.tableView reloadData];
  }
}

- (void)updateTimer
{
  self.stopwatchLabel.text = [self timeString];
}

- (void)updateStartButtonText
{
  if (isRunning) {
    [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
  } else {
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
  }
}

- (void)updatePauseButton
{
  if (isRunning) {
    [self.pauseButton setEnabled:YES];
  } else {
    [self.pauseButton setEnabled:!self.stopWatchTimer];
  }
}

- (void)updateState
{
  [self updateStartButtonText];
  [self updatePauseButton];
}

- (IBAction)onStartPressed:(id)sender
{
  if (isRunning) {
    [self stopTimer];
  } else {
    [self startTimer];
  }
}

- (IBAction)onResetPressed:(id)sender
{
  numberOfLogs++;
  
  [self.stopWatchTimer invalidate];
  self.stopWatchTimer = nil;
  
  if (isRunning) {
    [self logCurrentTime];
    [self startTimer];
    
  } else {
    self.startDate = nil;
  }
  
  [self updateTimer];
  pauseTime = 0;
}

- (void)startTimer
{
  self.startDate = [NSDate date];
  
  if (!numberOfLogs) {
    numberOfLogs = 1;
    continuingForLog = 1;
  }
  
  self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
  isRunning = true;
  [self updateState];
}

- (void)stopTimer
{
  if (continuingForLog == numberOfLogs) {
    [self logCurrentTimeReplaceLast];
  } else {
    [self logCurrentTime];

    continuingForLog = numberOfLogs;
  }
  
  
  NSDate *currentDate = [NSDate date];
  
  NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
  pauseTime += timeInterval;
  
  
  [self.stopWatchTimer invalidate];
  self.stopWatchTimer = nil;
  
  
  
  isRunning = false;
  [self updateState];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [loggedTimes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *simpleTableIdentifier = @"SimpleTabCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
  }
  
  cell.text = [loggedTimes objectAtIndex:indexPath.row];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return YES if you want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [loggedTimes removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  isRunning = NO;
  loggedTimes = [[NSMutableArray alloc] initWithObjects:nil];
  pauseTime = 0;
  
  self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

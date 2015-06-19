//
//  ViewController.m
//  TimetableCollectionView
//
//  Created by Igor Andrade on 6/17/15.
//  Copyright (c) 2015 Tokenlab. All rights reserved.
//

#import "ViewController.h"
#import "WeekDayCollectionViewCell.h"
#import "EventCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *timetableTabButton;
@property (weak, nonatomic) IBOutlet UIButton *courseDetailTabButton;

@end

@implementation ViewController

static NSString *weekDayCellIdentifier = @"WeekDayCellIdentifier";
static NSString *eventCellIdentifier = @"EventCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *weekDayCollectionViewCell = [UINib nibWithNibName:@"WeekDayCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:weekDayCollectionViewCell forCellWithReuseIdentifier:weekDayCellIdentifier];
    UINib *eventCollectionViewCell = [UINib nibWithNibName:@"EventCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:eventCollectionViewCell forCellWithReuseIdentifier:eventCellIdentifier];
}

#pragma mark - UICollectionViewDataSource protocol methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 30;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WeekDayCollectionViewCell *weekDayCell = (WeekDayCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:weekDayCellIdentifier forIndexPath:indexPath];
        weekDayCell.backgroundColor = [UIColor blueColor];
        if (indexPath.row == 0) {
            weekDayCell.weekDayLabel.text = @"";
        } else {
            weekDayCell.weekDayLabel.font = [UIFont systemFontOfSize:16];
            weekDayCell.weekDayLabel.textColor = [UIColor whiteColor];
            weekDayCell.weekDayLabel.text = @"SEG";
        }
        return weekDayCell;
    } else {
        if (indexPath.row == 0) {
            // Sera substituido por TimeCollectionViewCell
            WeekDayCollectionViewCell *weekDayCell = (WeekDayCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:weekDayCellIdentifier forIndexPath:indexPath];
            weekDayCell.backgroundColor = [UIColor whiteColor];
            weekDayCell.weekDayLabel.font = [UIFont systemFontOfSize:13];
            weekDayCell.weekDayLabel.textColor = [UIColor blackColor];
            weekDayCell.weekDayLabel.text = [NSString stringWithFormat:@"%d:%d", 10, 30];
            return weekDayCell;
        } else {
            EventCollectionViewCell *eventCell = (EventCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:eventCellIdentifier forIndexPath:indexPath];
            if (indexPath.row % 2 == 0) {
                eventCell.backgroundColor = [UIColor whiteColor];
                eventCell.eventLabel.text = @"";
            } else {
                eventCell.backgroundColor = [UIColor greenColor];
                eventCell.eventLabel.font = [UIFont systemFontOfSize:13];
                eventCell.eventLabel.textColor = [UIColor whiteColor];
                eventCell.eventLabel.text = @"Evento X";
            }
            return eventCell;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

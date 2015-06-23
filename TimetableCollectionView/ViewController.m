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
#import "TimeCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *timetableTabButton;
@property (weak, nonatomic) IBOutlet UIButton *courseDetailTabButton;
@property (nonatomic) NSArray *flattenData;

@end

@implementation ViewController

static NSString *weekDayCellIdentifier = @"WeekDayCellIdentifier";
static NSString *eventCellIdentifier = @"EventCellIdentifier";
static NSString *timeCellIdentifier = @"TimeCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *weekDayCollectionViewCell = [UINib nibWithNibName:@"WeekDayCollectionViewCell" bundle:nil];
    UINib *timeCollectionViewCell = [UINib nibWithNibName:@"TimeCollectionViewCell" bundle:nil];
    UINib *eventCollectionViewCell = [UINib nibWithNibName:@"EventCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:weekDayCollectionViewCell forCellWithReuseIdentifier:weekDayCellIdentifier];
    [self.collectionView registerNib:timeCollectionViewCell forCellWithReuseIdentifier:timeCellIdentifier];
    [self.collectionView registerNib:eventCollectionViewCell forCellWithReuseIdentifier:eventCellIdentifier];
    
    self.flattenData = @[
        @[@0,       @"SEG", @"TER",                                @"QUA",                                           @"QUI",                                @"SEX"],
        @[@"19:20", @0,     @"SEMINÁRIOS INTEGRADOS EM MARKETING", @0,                                               @"SEMINÁRIOS INTEGRADOS EM MARKETING", @0],
        @[@"20:10", @0,     @1,                                    @0,                                               @1,                                    @0],
        @[@"21:00", @0,     @1,                                    @0,                                               @0,                                    @0],
        @[@"21:30", @0,     @0,                                    @"PREVISAO E MENSURAÇÃO DA DEMANDA EM MARKETING", @0,                                    @0],
        @[@"22:00", @0,     @0,                                    @1,                                               @0,                                    @0]
    ];
}

#pragma mark - UICollectionViewDataSource protocol methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSInteger numberOfItems = 0;
//    for (id element in self.flattenData[section]) {
//        if ([element isEqual:@0] || [element isEqual:@1]) continue;
//        numberOfItems++;
//    }
    return [(NSArray *)self.flattenData[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.flattenData[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        WeekDayCollectionViewCell *weekDayCell = (WeekDayCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:weekDayCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [weekDayCell removeConstraints:[weekDayCell constraints]];
            [weekDayCell.weekDayLabel setEnabled:false];
            weekDayCell.weekDayLabel.text = @"";
        } else {
            weekDayCell.weekDayLabel.text = (NSString *)item;
        }
        return weekDayCell;
    } else {
        if (indexPath.row == 0) {
            TimeCollectionViewCell *timeCell = (TimeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:timeCellIdentifier forIndexPath:indexPath];
            timeCell.timeLabel.text = self.flattenData[indexPath.section][indexPath.row];
            return timeCell;
        } else {
            EventCollectionViewCell *eventCell = (EventCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:eventCellIdentifier forIndexPath:indexPath];
            if ([item isEqual:@0] || [item isEqual:@1]) {
                eventCell.eventLabel.text = @"";
                eventCell.eventLabel.backgroundColor = [UIColor whiteColor];
            } else {
                eventCell.eventLabel.text = (NSString *)item;
                eventCell.eventLabel.backgroundColor = [UIColor colorWithRed:114.f/255.f green:184.f/255.f blue:175.f/255.f alpha:1.0f];
            }
            return eventCell;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger columnSpan = 1;
    id item = self.flattenData[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(75.f, 40.f);
        } else {
            return CGSizeMake(120.f, 40.f);
        }
    } else {
        if (indexPath.row == 0) {
            return CGSizeMake(75.f, 120.f);
        } else {
            if ([item isEqual:@0] || [item isEqual:@1]) {
                return CGSizeMake(120.f, 120.f);
            } else {
                columnSpan = [self columnSpanForItemAtIndexPath:indexPath];
                return CGSizeMake(120.f, columnSpan * 120.f);
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout zIndexForItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.flattenData[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 1024;
        } else {
            return 1023;
        }
    } else {
        if (indexPath.row == 0) {
            return 1023;
        } else {
            if ([item isEqual:@0] || [item isEqual:@1]) {
                return 0;
            } else {
                return 1;
            }
        }
    }
}

- (NSInteger)columnSpanForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger maxNumberOfSections = [self numberOfSectionsInCollectionView:self.collectionView];
    NSInteger colSpan = 1;
    NSInteger section = indexPath.section + 1;
    
    while (section < maxNumberOfSections && [self.flattenData[section][indexPath.row] isEqual:@1]) {
        colSpan++;
        section++;
    }
    
    return colSpan;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

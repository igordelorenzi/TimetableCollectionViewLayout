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
        @[@"20:10", @0,                                            @0,                                                                                      @0],
        @[@"21:00", @0,     @0,                                    @0,                                               @0,                                    @0],
        @[@"21:30", @0,     @0,                                    @"PREVISAO E MENSURAÇÃO DA DEMANDA EM MARKETING", @0,                                    @0],
        @[@"22:00", @0,     @0,                                                                                      @0,                                    @0]
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
    if (indexPath.section == 0) {
        WeekDayCollectionViewCell *weekDayCell = (WeekDayCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:weekDayCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [weekDayCell removeConstraints:[weekDayCell constraints]];
            [weekDayCell.weekDayLabel setEnabled:false];
            weekDayCell.weekDayLabel.text = @"";
        } else {
            weekDayCell.weekDayLabel.text = self.flattenData[indexPath.section][indexPath.row];
        }
//        weekDayCell.weekDayLabel.layer.borderWidth=1.0f;
//        weekDayCell.weekDayLabel.layer.borderColor=[UIColor blueColor].CGColor;
        return weekDayCell;
    } else {
        if (indexPath.row == 0) {
            TimeCollectionViewCell *timeCell = (TimeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:timeCellIdentifier forIndexPath:indexPath];
            timeCell.timeLabel.text = self.flattenData[indexPath.section][indexPath.row];
//            timeCell.timeLabel.layer.borderWidth=1.0f;
//            timeCell.timeLabel.layer.borderColor=[UIColor blueColor].CGColor;
            return timeCell;
        } else {
            EventCollectionViewCell *eventCell = (EventCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:eventCellIdentifier forIndexPath:indexPath];
            if ([self.flattenData[indexPath.section][indexPath.row] isEqual:@0]) {
                eventCell.eventLabel.text = @"";
                eventCell.eventLabel.backgroundColor = [UIColor whiteColor];
            } else {
                eventCell.eventLabel.text = self.flattenData[indexPath.section][indexPath.row];
            }
            eventCell.eventLabel.layer.borderWidth=1.0f;
            eventCell.eventLabel.layer.borderColor=[UIColor blackColor].CGColor;
            return eventCell;
        }
    }
}

// TODO: retirar parametros nao usados
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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
            if ([self.flattenData[indexPath.section][indexPath.row] isEqual:@0]) {
                return CGSizeMake(120.f, 120.f);
            } else {
                return CGSizeMake(120.f, 240.f);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

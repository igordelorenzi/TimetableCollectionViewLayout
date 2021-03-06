//
//  TimetableCollectionView.h
//  TimetableCollectionView
//
//  Created by Igor Andrade on 6/17/15.
//  Copyright (c) 2015 Tokenlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTCollectionViewLayoutDelegate <UICollectionViewDelegate>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout zIndexForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TTCollectionViewLayout : UICollectionViewLayout
@property (nonatomic, weak) IBOutlet NSObject<TTCollectionViewLayoutDelegate> *delegate;
@end

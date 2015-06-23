//
//  TimetableCollectionView.m
//  TimetableCollectionView
//
//  Created by Igor Andrade on 6/17/15.
//  Copyright (c) 2015 Tokenlab. All rights reserved.
//

#import "TTCollectionViewLayout.h"

@implementation TTCollectionViewLayout

// Memoization attributes for fast layout.
NSMutableArray *itemAttributes;
NSMutableArray *itemsSize;
CGSize contentSize;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        contentSize = CGSizeZero;
    }
    return self;
}

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.collectionView.numberOfSections == 0) {
        return;
    }
    
    NSInteger column = 0;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    
    //
    // Redesenha os items da primeira linha e a primeira coluna para coincidirem com o conteúdo da Collection View.
    // Ao carregar a tela pela primeira vez o fluxo abaixo não deve executar.
//    if (itemAttributes != nil && itemAttributes.count > 0) {
//        // Itera sobre todos os items (de linha em linha, partindo da esq. p/ dir.)
//        
//        
//        return;
//    }

    NSInteger numberOfSections = self.collectionView.numberOfSections;
    BOOL firstRun = YES;
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSMutableArray *sectionAttributes = [NSMutableArray array];
        for (NSInteger index = 0; index < [self.collectionView numberOfItemsInSection:section]; index++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *attributes;
            
            if (itemAttributes != nil && itemAttributes.count == numberOfSections) {
                if (section != 0 && index != 0) {
                    continue;
                }
                
                firstRun = NO;
                
                attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
                CGRect frame = attributes.frame;
                
                // Fixa primeira linha
                if (section == 0) {
                    frame.origin.y = self.collectionView.contentOffset.y;
                }
                
                // Fixa primeira coluna
                if (index == 0) {
                    frame.origin.x = self.collectionView.contentOffset.x;
                }
                
                frame.size.height = itemSize.height;
                frame.size.width = itemSize.width;
                attributes.frame = frame;
            } else {
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.zIndex = [self.delegate collectionView:self.collectionView layout:self zIndexForItemAtIndexPath:indexPath];
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
                
                NSLog(@"section: %ld - index: %ld", section, index);
                
                if (section == 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame;
                }
                
                [sectionAttributes addObject:attributes];
                
                xOffset += itemSize.width;
                column++;
                
                if (column == [self.collectionView numberOfItemsInSection:section]) {
                    if (xOffset > contentWidth) {
                        contentWidth = xOffset;
                    }
                    
                    column = 0;
                    xOffset = 0;
                    yOffset += itemSize.height;
                }
            }
        }
        
        if (itemAttributes == nil) {
            itemAttributes = [[NSMutableArray alloc] initWithCapacity:self.collectionView.numberOfSections];
        }
        
        if (sectionAttributes.count > 0) {
            [itemAttributes addObject:sectionAttributes];
        }
    }
    
    if (CGSizeEqualToSize(contentSize, CGSizeZero)) {
        UICollectionViewLayoutAttributes *attributes = (UICollectionViewLayoutAttributes *)[[itemAttributes lastObject] lastObject];
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
        contentSize = CGSizeMake(contentWidth, contentHeight);
    }

//    // Itera sobre todos os items (de linha em linha, partindo da esq. p/ dir.)
//    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
//        NSMutableArray *sectionAttributes = [NSMutableArray array];
//        for (NSInteger index = 0; index < [self.collectionView numberOfItemsInSection:section]; index++) {
////            CGSize itemSize = [(NSValue *)itemsSize[index] CGSizeValue];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
//            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
//            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//            
//            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
//            attributes.zIndex = [self.delegate collectionView:self.collectionView layout:self zIndexForItemAtIndexPath:indexPath];
////            if (section == 0 && index == 0) {
////                attributes.zIndex = 1024;
////            } else if (section == 0 || index == 0) {
////                attributes.zIndex = 1023;
////                NSLog(@"section: %ld - index: %ld", section, index);
////            }
//            
////            NSLog(@"attributes.zIndex: %ld", attributes.zIndex);
//            
//            if (section == 0) {
//                CGRect frame = attributes.frame;
//                frame.origin.y = self.collectionView.contentOffset.y;
//                attributes.frame = frame;
//            }
//            
//            [sectionAttributes addObject:attributes];
//            
//            xOffset += itemSize.width;
//            column++;
//            
//            if (column == [self.collectionView numberOfItemsInSection:section]) {
//                if (xOffset > contentWidth) {
//                    contentWidth = xOffset;
//                }
//                
//                column = 0;
//                xOffset = 0;
//                yOffset += itemSize.height;
//            }
//        }
//        
//        if (itemAttributes == nil) {
//            itemAttributes = [[NSMutableArray alloc] initWithCapacity:self.collectionView.numberOfSections];
//        }
//        
//        [itemAttributes addObject:sectionAttributes];
//    }
}

// Subclasses must override this method and use it to return the width and height of the
// collection view’s content. These values represent the width and height of all the content, not
// just the content that is currently visible. The collection view uses this information to
// configure its own content size to facilitate scrolling.
- (CGSize)collectionViewContentSize {
    return contentSize;
}

// UICollectionView calls these four methods to determine the layout information.
// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary
//      or decoration views, or to perform layout in an as-needed-on-screen fashion.
// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to
//      return layout attributes instances on demand for specific index paths.
// If the layout supports any supplementary or decoration view types, it should also implement the
//      respective atIndexPath: methods for those types.
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSArray *section in itemAttributes) {
        NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect(rect, [(UICollectionViewLayoutAttributes *)evaluatedObject frame]);
        }];
        NSArray *filteredArray = [section filteredArrayUsingPredicate:filter];
        [attributes addObjectsFromArray:filteredArray];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (itemAttributes != nil && [itemAttributes count] > 0) {
        return (UICollectionViewLayoutAttributes *)itemAttributes[indexPath.section][indexPath.row];
//    } else {
//        return [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    }
}

// return YES to cause the collection view to requery the layout for geometry information
// return YES chama o prepareLayout quando o usuario mexe a tela
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Helper methods

// Returning NO in the callback will terminate the iterations early.
- (BOOL)traverseAllItems:(BOOL(^)(CGPoint))block {
    for (NSInteger column = 0; column < self.collectionView.numberOfSections; column++) {
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:column]; row++) {
            
        }
    }
    
    NSAssert(0, @"Could find no good place for a block!");
    return YES;
}

@end

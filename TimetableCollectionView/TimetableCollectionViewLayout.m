//
//  TimetableCollectionView.m
//  TimetableCollectionView
//
//  Created by Igor Andrade on 6/17/15.
//  Copyright (c) 2015 Tokenlab. All rights reserved.
//

#import "TimetableCollectionViewLayout.h"

@implementation TimetableCollectionViewLayout

NSInteger numberOfColumns;
NSMutableArray *itemAttributes;
NSMutableArray *itemsSize;
CGSize contentSize;

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if ((self = [super initWithCoder:aDecoder])) {
//        numberOfColumns = [self.collectionView numberOfItemsInSection:0];
//    }
//    return self;
//}

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout {
    if (self.collectionView.numberOfSections == 0) {
        return;
    }
    
    if (! numberOfColumns) {
        numberOfColumns = [self.collectionView numberOfItemsInSection:0];
    }
    
    // Redesenha os items da primeira linha e a primeira coluna para coincidirem com o conteúdo
    // da Collection View.
    // Ao carregar a tela pela primeira vez o fluxo abaixo não deve executar.
    if (itemAttributes != nil && itemAttributes.count > 0) {
        // Itera sobre todos os items (de linha em linha, partindo da esq. p/ dir.)
        for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
            for (NSInteger index = 0; index < numberOfColumns; index++) {
                if (section != 0 && index != 0) {
                    continue;
                }
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
                
                // Fixa primeira linha
                if (section == 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame;
                }
                
                // Fixa primeira coluna
                if (index == 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.x = self.collectionView.contentOffset.x;
                    attributes.frame = frame;
                }
            }
        }
        
        return;
    }
    
    if (itemsSize == nil || itemsSize.count != numberOfColumns) {
        [self calculateItensSize];
    }
    
    NSInteger column = 0;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    
    // Itera sobre todos os items (de linha em linha, partindo da esq. p/ dir.)
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        NSMutableArray *sectionAttributes = [NSMutableArray array];
        for (NSInteger index = 0; index < numberOfColumns; index++) {
            CGSize itemSize = [(NSValue *)itemsSize[index] CGSizeValue];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            
            if (section == 0 && index == 0) {
                attributes.zIndex = 1024;
            } else if (section == 0 || index == 0) {
                attributes.zIndex = 1023;
            }
            
            if (section == 0) {
                CGRect frame = attributes.frame;
                frame.origin.y = self.collectionView.contentOffset.y;
                attributes.frame = frame;
            }
            
            [sectionAttributes addObject:attributes];
            
            xOffset += itemSize.width;
            column++;
            
            if (column == numberOfColumns) {
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }
                
                column = 0;
                xOffset = 0;
                yOffset += itemSize.height;
            }
        }
        
        if (itemAttributes == nil) {
            itemAttributes = [[NSMutableArray alloc] initWithCapacity:self.collectionView.numberOfSections];
        }
        
        [itemAttributes addObject:sectionAttributes];
    }
    
    UICollectionViewLayoutAttributes *attributes = (UICollectionViewLayoutAttributes *)[[itemAttributes lastObject] lastObject];
    contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
    contentSize = CGSizeMake(contentWidth, contentHeight);
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
    return (UICollectionViewLayoutAttributes *)itemAttributes[indexPath.section][indexPath.row];
}

// return YES to cause the collection view to requery the layout for geometry information
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)sizeForItemWithColumnIndex:(NSInteger)columnIndex {
    NSString *text = @"";
    
    switch (columnIndex) {
        case 0:
            text = @"Col 0";
            break;
        
        case 1:
            text = @"Col 1";
            break;
            
        case 2:
            text = @"Col 2";
            break;
            
        case 3:
            text = @"Col 3";
            break;
            
        case 4:
            text = @"Col 5";
            break;
            
        case 5:
            text = @"Col 5";
            break;
            
        case 6:
            text = @"Col 6";
            break;
            
        default:
            text = @"Col -1";
            break;
    }
    
    CGSize size = [text sizeWithAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:17.0] }];
    CGFloat width = size.width + 50;
    
    return CGSizeMake(width, 30);
}

- (void)calculateItensSize {
    itemsSize = [[NSMutableArray alloc] initWithCapacity:numberOfColumns];
    for (NSInteger index = 0; index < numberOfColumns; index++) {
        CGSize size = [self sizeForItemWithColumnIndex:index];
        [itemsSize addObject:[NSValue valueWithCGSize:size]];
    }
}

@end

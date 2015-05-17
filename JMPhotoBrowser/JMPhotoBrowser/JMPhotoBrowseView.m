//
//  JMPhotoBrowserView.m
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/10.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import "JMPhotoBrowseView.h"

@interface JMPhotoBrowseView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *showCells;
@property (nonatomic, strong) NSMutableArray *reusableCells;

@end


@implementation JMPhotoBrowseView
@synthesize dataSource = _dataSource;
@synthesize delegate;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.showCells = ({
            NSMutableArray *array = [[NSMutableArray alloc] init];
            array;
        });
        
        self.reusableCells = ({
            NSMutableArray *array = [[NSMutableArray alloc] init];
            array;
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadScroll];
        });
    }
    
    return self;
}

- (void)loadScroll
{
    for (NSInteger i = 0; i < [self getNumbersOfCell]; i++) {
        
        [self addCellWithIndex:i isBefore:NO];
        
        if ([self getXWithIndex:i] > CGRectGetWidth(self.bounds)) {
            
            break;
        }
    }
    
    NSInteger contentSize_x = 0;
    for (int i = 0; i < [self getNumbersOfCell]; i++) {
        CGFloat w = [self getWidthWithIndex:i];
        contentSize_x += w;

    }

    if (contentSize_x < CGRectGetWidth(self.bounds)) {
        contentSize_x = CGRectGetWidth(self.bounds);
    }
    
    self.scroll.contentSize = CGSizeMake(contentSize_x, CGRectGetHeight(self.bounds));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(browseViewDidLoad:showCells:)]) {
        [self.delegate browseViewDidLoad:self showCells:self.showCells];
    }
}


#pragma mark -
#pragma mark set

- (void)reloadData
{
    for (int i = 0; i < self.showCells.count; i++) {
        
        JMPhotoBrowseCell *cell = self.showCells[i];
        
        [self removeCellWithIndex:cell.index];

    }
    
    [self loadScroll];
}


#pragma mark -
#pragma mark frame

- (NSInteger)getNumbersOfCell
{
    NSInteger count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCellsInBrowseView:)]) {
        count = [self.dataSource numberOfCellsInBrowseView:self];
    }
    return count;
}

- (CGFloat)getWidthWithIndex:(NSInteger)index
{
    CGFloat w = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(browseView:widthForIndex:)]) {
        w = [self.delegate browseView:self widthForIndex:index];
    }
    
    return w;
}

//- (CGFloat)getHeightWithIndex:(NSInteger)index
//{
//    CGFloat h = 0;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:heightForIndex:)]) {
//        h = [self.delegate photoBrowser:self heightForIndex:index];
//    }
//    
//    return h;
//}

- (CGFloat)getXWithIndex:(NSInteger)index
{
    CGFloat x = 0;
    for (int i = 0; i < index; i++) {
        x += [self getWidthWithIndex:i];
    }
    
    return x;
}

- (NSInteger)indexWithScrollOffset:(CGFloat)offset
{
    CGFloat x = 0;
    NSInteger index = 0;
    
    for (int i = 0; i < [self getNumbersOfCell]; i++) {
        x += [self getWidthWithIndex:i];
        if (x >= offset) {
            index = i - 1;
        }
    }
    
    if (index < 0) {
        index = 0;
    }
    
    return index;
}


#pragma mark -
#pragma mark cell

- (void)addCellWithIndex:(NSInteger)index isBefore:(BOOL)isBefore
{
    if (index >= [self getNumbersOfCell] || index < 0) {
        return;
    }
 
    
    CGFloat x = [self getXWithIndex:index];
    CGFloat w = [self getWidthWithIndex:index];
    CGFloat y = 0;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(browseView:cellAtIndex:)]) {
        JMBrowseCell *cell = [self.dataSource browseView:self cellAtIndex:index];
        
        [self.scroll addSubview:cell];
        cell.backgroundColor = [UIColor whiteColor];
        cell.frame = CGRectMake(x, y, w, CGRectGetHeight(self.bounds));
        cell.index = index;
        
        [cell addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"add cell with index = %d", index);

        if (isBefore) {
            [self.showCells insertObject:cell atIndex:0];
        }
        else {
            [self.showCells addObject:cell];
        }
    }
}

- (void)removeCellWithIndex:(NSInteger)index
{
    NSLog(@"remove cell with index = %d", index);

    __block NSInteger arrayIndex = -1;
    [self.showCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        JMPhotoBrowseCell *cell = obj;
        if (cell.index == index) {
            arrayIndex = idx;
            *stop = YES;
        }
    }];
    
    if (arrayIndex > -1) {
        JMPhotoBrowseCell *cell = self.showCells[arrayIndex];
        
        [self enqueueReusableCell:cell];
        
        [cell removeFromSuperview];
        [self.showCells removeObject:cell];
    }
}


#pragma mark -
#pragma mark queue

- (void)enqueueReusableCell:(JMPhotoBrowseCell *)cell
{
    if (cell) {
        [self.reusableCells addObject:cell];
    }
}

- (JMPhotoBrowseCell *)dequeueReusableCell
{
    JMPhotoBrowseCell *cell = nil;
    if (self.reusableCells.count > 0) {
        cell = [self.reusableCells firstObject];
        [self.reusableCells removeObject:cell];
        cell.transform = CGAffineTransformIdentity;
    }
    
    return cell;
}

- (void)didBrowse
{
    @synchronized (self) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(browseViewWillBrowse:showCells:)]) {
            [self.delegate browseViewWillBrowse:self showCells:self.showCells];
        }
        
        JMPhotoBrowseCell *firstCell = [self.showCells firstObject];
        JMPhotoBrowseCell *lastCell = [self.showCells lastObject];
        
        //remove before
        if (CGRectGetMaxX(firstCell.frame) < self.scroll.contentOffset.x) {
            [self removeCellWithIndex:firstCell.index];
            
        }
        
        //remove after
        if (CGRectGetMinX(lastCell.frame) > self.scroll.contentOffset.x + CGRectGetWidth(self.frame)) {
            [self removeCellWithIndex:lastCell.index];
            
        }
        
        //add before
        if (CGRectGetMinX(firstCell.frame) > self.scroll.contentOffset.x) {
            
            if (firstCell.index > 0) {
                [self addCellWithIndex:firstCell.index - 1 isBefore:YES];
            }
        }
        
        //add after
        if (CGRectGetMaxX(lastCell.frame) < self.scroll.contentOffset.x + CGRectGetWidth(self.frame)) {
            if (lastCell.index < [self getNumbersOfCell]) {
                [self addCellWithIndex:lastCell.index + 1 isBefore:NO];
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(browseViewDidBrowse:showCells:)]) {
            [self.delegate browseViewDidBrowse:self showCells:self.showCells];
        }
    }
}


#pragma mark -
#pragma mark touchEvent

- (void)touchUpInside:(JMBrowseCell *)sender
{
    NSLog(@"sender=%@", sender);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(browseView:didSelectCell:)]) {
        [self.delegate browseView:self didSelectCell:sender];
    }
}



#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self didBrowse];
}


@end

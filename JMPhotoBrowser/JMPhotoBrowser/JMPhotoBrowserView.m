//
//  JMPhotoBrowserView.m
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/10.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import "JMPhotoBrowserView.h"

@interface JMPhotoBrowserView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableArray *showCells;
@property (nonatomic, strong) NSMutableArray *reusableCells;

@end


@implementation JMPhotoBrowserView
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scroll = ({
            UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:frame];
            [self addSubview:scroll];
//            scroll.pagingEnabled = YES;
            scroll.showsHorizontalScrollIndicator = NO;
            scroll.showsVerticalScrollIndicator = NO;
            scroll.delegate = self;
            scroll;
        });
        
        self.showCells = ({
            NSMutableArray *array = [[NSMutableArray alloc] init];
            array;
        });
        
        self.reusableCells = ({
            NSMutableArray *array = [[NSMutableArray alloc] init];
            array;
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self update];
        });
    }
    
    return self;
}

- (void)update
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
        CGFloat h = [self getHeightWithIndex:i];
        
        contentSize_x += w;
        
        self.scroll.contentSize = CGSizeMake(contentSize_x, h);
    }
}


#pragma mark -
#pragma mark frame

- (NSInteger)getNumbersOfCell
{
    NSInteger count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
        count = [self.dataSource numberOfPhotosInPhotoBrowser:self];
    }
    return count;
}

- (CGFloat)getWidthWithIndex:(NSInteger)index
{
    CGFloat w = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:widthForIndex:)]) {
        w = [self.delegate photoBrowser:self widthForIndex:index];
    }
    
    return w;
}

- (CGFloat)getHeightWithIndex:(NSInteger)index
{
    CGFloat h = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowser:heightForIndex:)]) {
        h = [self.delegate photoBrowser:self heightForIndex:index];
    }
    
    return h;
}

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
 
    NSLog(@"add cell with index = %ld", index);
    
    CGFloat x = [self getXWithIndex:index];
    CGFloat w = [self getWidthWithIndex:index];
    CGFloat h = [self getHeightWithIndex:index];
    CGFloat y = CGRectGetMidY(self.frame) - h / 2;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(photoBrowser:cellAtIndex:)]) {
        JMPhotoBrowserCell *cell = [self.dataSource photoBrowser:self cellAtIndex:index];
        [self.scroll addSubview:cell];
        
        cell.backgroundColor = [UIColor redColor];
        cell.frame = CGRectMake(x, y, w, h);
        cell.index = index;
        
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
    NSLog(@"remove cell with index = %ld", index);

    __block NSInteger arrayIndex = -1;
    [self.showCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        JMPhotoBrowserCell *cell = obj;
        if (cell.index == index) {
            arrayIndex = idx;
            *stop = YES;
        }
    }];
    
    if (arrayIndex > -1) {
        JMPhotoBrowserCell *cell = self.showCells[arrayIndex];
        
        [self enqueueReusableCell:cell];
        
        [cell removeFromSuperview];
        [self.showCells removeObject:cell];
    }
}


#pragma mark -
#pragma mark queue

- (void)enqueueReusableCell:(JMPhotoBrowserCell *)cell
{
    if (cell) {
        [self.reusableCells addObject:cell];
    }
}

- (JMPhotoBrowserCell *)dequeueReusableCell
{
    JMPhotoBrowserCell *cell = nil;
    if (self.reusableCells.count > 0) {
        cell = [self.reusableCells firstObject];
        [self.reusableCells removeObject:cell];
    }
    
    return cell;
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    @synchronized (self) {
            
        JMPhotoBrowserCell *firstCell = [self.showCells firstObject];
        JMPhotoBrowserCell *lastCell = [self.showCells lastObject];
        
        //remove before
        if (CGRectGetMaxX(firstCell.frame) < scrollView.contentOffset.x) {
            [self removeCellWithIndex:firstCell.index];
            
        }
        
        //remove after
        if (CGRectGetMinX(lastCell.frame) > scrollView.contentOffset.x + CGRectGetWidth(self.frame)) {
            [self removeCellWithIndex:lastCell.index];
            
        }
        
        //add before
        if (CGRectGetMinX(firstCell.frame) > scrollView.contentOffset.x) {
            
            if (firstCell.index > 0) {
                [self addCellWithIndex:firstCell.index - 1 isBefore:YES];
            }
        }
        
        //add after
        if (CGRectGetMaxX(lastCell.frame) < scrollView.contentOffset.x + CGRectGetWidth(self.frame)) {
            if (lastCell.index < [self getNumbersOfCell]) {
                [self addCellWithIndex:lastCell.index + 1 isBefore:NO];
            }
        }
    }
}

@end

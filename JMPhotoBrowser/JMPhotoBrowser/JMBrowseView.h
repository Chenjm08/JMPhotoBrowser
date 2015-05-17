//
//  JMBrowserView.h
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/16.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMBrowseCell.h"

@class JMBrowseView;

@protocol JMBrowseDataSource <NSObject>

- (NSInteger)numberOfCellsInBrowseView:(JMBrowseView *)browseView;
- (JMBrowseCell *)browseView:(JMBrowseView *)browseView cellAtIndex:(NSInteger)index;

@end

@protocol JMBrowseViewDelegate <NSObject>

- (CGFloat)browseView:(JMBrowseView *)browseView heightForIndex:(NSInteger)index;
- (CGFloat)browseView:(JMBrowseView *)browseView widthForIndex:(NSInteger)index;
- (void)browseView:(JMBrowseView *)browseView didSelectCell:(JMBrowseCell *)cell;

- (void)browseViewDidLoad:(JMBrowseView *)browseView showCells:(NSArray *)cells;
- (void)browseViewWillBrowse:(JMBrowseView *)browseView showCells:(NSArray *)cells;
- (void)browseViewDidBrowse:(JMBrowseView *)browseView showCells:(NSArray *)cells;

@end


@interface JMBrowseView : UIView <UIScrollViewDelegate>
@property (nonatomic, weak) id <JMBrowseDataSource> dataSource;
@property (nonatomic, weak) id <JMBrowseViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) BOOL pagingEnabled;

- (JMBrowseCell *)dequeueReusableCell;

- (void)didBrowse;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)setContentOffset:(CGPoint)contentOffset animatedTime:(CGFloat)animatedTime;


@end

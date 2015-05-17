//
//  JMBrowserView.m
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/16.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import "JMBrowseView.h"

@implementation JMBrowseView
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize scroll = _scroll;
@synthesize contentOffset = _contentOffset;
@synthesize pagingEnabled = _pagingEnabled;


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
    }
    
    return self;
}

- (JMBrowseCell *)dequeueReusableCell
{
    return nil;
}

- (CGPoint)contentOffset
{
    return self.scroll.contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    self.scroll.contentOffset = contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [self.scroll setContentOffset:contentOffset animated:animated];
}

- (void)setContentOffset:(CGPoint)contentOffset animatedTime:(CGFloat)animatedTime
{
    [UIView animateWithDuration:animatedTime animations:^{
        [self.scroll setContentOffset:contentOffset];
    }];
}


- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    self.scroll.pagingEnabled = pagingEnabled;
}

- (void)didBrowse
{

}

- (void)browserViewDidBrowse:(JMBrowseView *)browseView showCells:(NSArray *)cells
{
    
}

- (void)browserViewWillBrowse:(JMBrowseView *)browseView showCells:(NSArray *)cells
{
    
}




@end

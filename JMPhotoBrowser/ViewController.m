//
//  ViewController.m
//  JMPhotoBrowser
//
//  Created by chenjiemin on 15/5/11.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import "ViewController.h"
#import "JMPhotoBrowseView.h"

@interface ViewController () <JMBrowseViewDelegate, JMBrowseDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JMPhotoBrowseView *view = [[JMPhotoBrowseView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    view.delegate = self;
    view.dataSource = self;
}


- (void)browseViewDidLoad:(JMBrowseView *)browseView showCells:(NSArray *)cells
{
    
    [self changeCells:cells withBrowseView:browseView];
}

- (void)browserViewDidBrowse:(JMBrowseView *)browseView showCells:(NSArray *)cells
{
    NSLog(@"scrollView=%@", browseView);
    
    [self changeCells:cells withBrowseView:browseView];
}

- (void)changeCells:(NSArray *)cells withBrowseView:(JMBrowseView *)browseView
{
    for (int i = 0; i < cells.count; i++) {
        JMPhotoBrowseCell *cell = [cells objectAtIndex:i];
        
        CGFloat offsetX = CGRectGetMidX(cell.frame) - (browseView.contentOffset.x + CGRectGetMidX(browseView.bounds));
        if (offsetX < - CGRectGetMidX(browseView.bounds)) {
            offsetX = - CGRectGetMidX(browseView.bounds);
        }
        if (offsetX > CGRectGetMidX(browseView.bounds)) {
            offsetX = CGRectGetMidX(browseView.bounds);
        }
        
        CGFloat rate = fabs(offsetX / CGRectGetMidX(browseView.bounds)) * 0.2;
        CGFloat scale = 1 - rate;
        
        cell.alpha = (1-rate* 2);
        cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    }
}

//JMPhotoBrowserDataSource

- (NSInteger)numberOfCellsInBrowseView:(JMBrowseView *)browseView
{
    return 9;
}

- (JMBrowseCell *)browseView:(JMBrowseView *)browseView cellAtIndex:(NSInteger)index
{
    NSArray *images = @[@"PB0.jpg", @"PB1.jpg", @"PB2.jpg", @"PB3.jpg", @"PB4.jpg", @"PB5.jpg", @"PB6.jpg", @"PB7.jpg", @"PB8.jpg"];
    JMBrowseCell *cell = [browseView dequeueReusableCell];
    if (!cell) {
        cell = [[JMPhotoBrowseCell alloc] init];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [cell addSubview:imageView];
    imageView.image = [UIImage imageNamed:images[index]];
    cell.clipsToBounds = YES;
    
    return cell;
}

//JMPhotoBrowserViewDelegate

//- (CGFloat)photoBrowser:(JMPhotoBrowserView *)browser heightForIndex:(NSInteger)index
//{
//    return CGRectGetHeight(self.view.bounds)/2;
//}

- (CGFloat)browseView:(JMBrowseView *)browseView widthForIndex:(NSInteger)index
{
    return CGRectGetWidth(self.view.bounds)/2;
}

- (void)browseView:(JMBrowseView *)browseView didSelectCell:(JMBrowseCell *)cell
{
    NSLog(@"selectAtIndex===%@", cell);
}



@end

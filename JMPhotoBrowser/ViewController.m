//
//  ViewController.m
//  JMPhotoBrowser
//
//  Created by chenjiemin on 15/5/11.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import "ViewController.h"
#import "JMPhotoBrowserView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JMPhotoBrowserView *view = [[JMPhotoBrowserView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    view.delegate = self;
    view.dataSource = self;
}


//JMPhotoBrowserDataSource

- (NSInteger)numberOfPhotosInPhotoBrowser:(JMPhotoBrowserView *)browser
{
    return 9;
}

- (JMPhotoBrowserCell *)photoBrowser:(JMPhotoBrowserView *)browser cellAtIndex:(NSInteger)index
{
    NSArray *images = @[@"PB0.jpg", @"PB1.jpg", @"PB2.jpg", @"PB3.jpg", @"PB4.jpg", @"PB5.jpg", @"PB6.jpg", @"PB7.jpg", @"PB8.jpg"];
    JMPhotoBrowserCell *cell = [browser dequeueReusableCell];
    if (!cell) {
        cell = [[JMPhotoBrowserCell alloc] init];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [cell addSubview:imageView];
    imageView.image = [UIImage imageNamed:images[index]];
    cell.clipsToBounds = YES;
    
    return cell;
}

//JMPhotoBrowserViewDelegate

- (CGFloat)photoBrowser:(JMPhotoBrowserView *)browser heightForIndex:(NSInteger)index
{
    return CGRectGetHeight(self.view.bounds)/2;
}

- (CGFloat)photoBrowser:(JMPhotoBrowserView *)browser widthForIndex:(NSInteger)index
{
    return CGRectGetWidth(self.view.bounds)/2;
}

- (void)photoBrowser:(JMPhotoBrowserView *)browser didSelectAtIndex:(NSInteger)index
{
    NSLog(@"selectAtIndex===%ld", index);
}


@end

//
//  JMPhotoBrowserCell.h
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/10.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMBrowseCell.h"

@interface JMPhotoBrowseCell : JMBrowseCell

@property (nonatomic, strong) NSMutableArray *userSubviews;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;



@end

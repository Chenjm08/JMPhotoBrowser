//
//  JMPhotoBrowserView.h
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/10.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMBrowseView.h"
#import "JMPhotoBrowseCell.h"


@interface JMPhotoBrowseView : JMBrowseView

- (JMPhotoBrowseCell *)dequeueReusableCell;


@end


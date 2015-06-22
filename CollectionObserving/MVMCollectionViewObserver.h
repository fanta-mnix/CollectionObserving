//
// Created by Rafael Fantini da Costa on 6/21/15.
// Copyright (c) 2015 Movile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MVMCollectionViewObserver : NSObject

@property (weak, nonatomic, readonly) UICollectionView *collectionView;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;
- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

@end
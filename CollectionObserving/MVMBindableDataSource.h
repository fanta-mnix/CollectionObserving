//
// Created by Rafael Fantini da Costa on 6/21/15.
// Copyright (c) 2015 Movile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol MVMBindableDataSource <UICollectionViewDataSource>

- (RACSignal *)insertion;
- (RACSignal *)removal;
- (RACSignal *)replacement;

@end
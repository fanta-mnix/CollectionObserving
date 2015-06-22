//
//  MVMArrayDataSource.h
//  CollectionObserving
//
//  Created by Rafael Fantini da Costa on 6/20/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MVMBindableDataSource.h"

@protocol MVMCollectionViewCellPopulator <NSObject>

- (void)populateCell:(UICollectionViewCell *)cell withObject:(id)object;

@end


@interface MVMArrayDataSource : NSObject <MVMBindableDataSource>

@property (weak, nonatomic) id<MVMCollectionViewCellPopulator> cellPopulator;

- (instancetype)initWithData:(NSMutableArray *)data cellIdentifier:(NSString *)cellIdentifier;
- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

- (NSMutableArray *)dataProxy;

@end

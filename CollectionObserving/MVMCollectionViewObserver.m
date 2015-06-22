//
// Created by Rafael Fantini da Costa on 6/21/15.
// Copyright (c) 2015 Movile. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MVMCollectionViewObserver.h"
#import "MVMBindableDataSource.h"
#import "NSIndexSet+Additions.h"


@implementation MVMCollectionViewObserver

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    NSParameterAssert(collectionView != nil);

    self = [super init];
    if (self) {
        _collectionView = collectionView;
        [self applyBindings];
    }

    return self;
}

- (void)applyBindings {
    RACSignal *dataSourceSignal = RACObserve(self.collectionView, dataSource);
    UICollectionView *collectionView = self.collectionView;

    [[dataSourceSignal
            deliverOnMainThread]
            subscribeNext:^(id x) {
                [collectionView reloadData];
            }];

    RACSignal *arrayDataSourceSignal = [dataSourceSignal
            filter:^BOOL(id<UICollectionViewDataSource> dataSource) {
                return [dataSource conformsToProtocol:@protocol(MVMBindableDataSource)];
            }];

    [[[[arrayDataSourceSignal
            map:^RACSignal *(id<MVMBindableDataSource> dataSource) {
                return dataSource == nil
                        ? [RACSignal never]
                        : dataSource.insertion;
            }]
            switchToLatest]
            deliverOnMainThread]
            subscribeNext:^(NSIndexSet *insertions) {
                [collectionView insertItemsAtIndexPaths:[insertions indexPathsForSection:0]];
            }];

    [[[[arrayDataSourceSignal
            map:^RACSignal *(id<MVMBindableDataSource> dataSource) {
                return dataSource == nil
                        ? [RACSignal never]
                        : dataSource.removal;
            }]
            switchToLatest]
            deliverOnMainThread]
            subscribeNext:^(NSIndexSet *removals) {
                [collectionView deleteItemsAtIndexPaths:[removals indexPathsForSection:0]];
            }];

    [[[[arrayDataSourceSignal
            map:^RACSignal *(id<MVMBindableDataSource> dataSource) {
                return dataSource == nil
                        ? [RACSignal never]
                        : dataSource.replacement;
            }]
            switchToLatest]
            deliverOnMainThread]
            subscribeNext:^(NSIndexSet *replacements) {
                [collectionView reloadItemsAtIndexPaths:[replacements indexPathsForSection:0]];
            }];
}

@end
//
//  MVMArrayDataSource.m
//  CollectionObserving
//
//  Created by Rafael Fantini da Costa on 6/20/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MVMArrayDataSource.h"

@interface MVMArrayDataSource ()

@property (strong, nonatomic, readonly) NSMutableArray *data;
@property (strong, nonatomic, readonly) NSString *cellIdentifier;

@end

@implementation MVMArrayDataSource {
    RACSignal *_insertion;
    RACSignal *_removal;
    RACSignal *_replacement;
}

- (instancetype)initWithData:(NSMutableArray *)data cellIdentifier:(NSString *)cellIdentifier {
    NSParameterAssert(data != nil);
    NSParameterAssert(cellIdentifier != nil);

    self = [super init];
    if (self) {
        _data = [data mutableCopy];
        _cellIdentifier = cellIdentifier;
        [self applyBindings];
    };

    return self;
}

- (void)applyBindings {
    RACSignal *change =
            [self rac_valuesAndChangesForKeyPath:@keypath(self, data)
                                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                        observer:nil];

    NSIndexSet *(^extractChangeIndexes)(RACTuple *) = ^NSIndexSet *(RACTuple *value) {
        NSDictionary *info = value.second;
        return info[NSKeyValueChangeIndexesKey];
    };

    _insertion = [[change
            filter:^BOOL(RACTuple *value) {
                NSDictionary *info = value.second;
                return [info[NSKeyValueChangeKindKey] unsignedIntegerValue] == NSKeyValueChangeInsertion;
            }]
            map:extractChangeIndexes];

    _removal = [[change
            filter:^BOOL(RACTuple *value) {
                NSDictionary *info = value.second;
                return [info[NSKeyValueChangeKindKey] unsignedIntegerValue] == NSKeyValueChangeRemoval;
            }]
            map:extractChangeIndexes];

    _replacement = [[change
            filter:^BOOL(RACTuple * value) {
                NSDictionary *info = value.second;
                return [info[NSKeyValueChangeKindKey] unsignedIntegerValue] == NSKeyValueChangeReplacement;
            }]
            map:extractChangeIndexes];

}

- (NSMutableArray *)dataProxy {
    return [self mutableArrayValueForKey:@"data"];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];

    if (self.cellPopulator != nil) {
        id viewModel = self.data[(NSUInteger)indexPath.item];
        [self.cellPopulator populateCell:cell withObject:viewModel];
    }

    return cell;
}

#pragma mark - RACAdditions

- (RACSignal *)insertion {
    return _insertion;
}

- (RACSignal *)removal {
    return _removal;
}

- (RACSignal *)replacement {
    return _replacement;
}

@end

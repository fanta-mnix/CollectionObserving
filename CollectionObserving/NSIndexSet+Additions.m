//
// Created by Rafael Fantini da Costa on 6/20/15.
// Copyright (c) 2015 Movile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSIndexSet+Additions.h"


@implementation NSIndexSet (Additions)

- (NSArray *)indexPathsForSection:(NSInteger)section {
    NSMutableArray *result = [NSMutableArray new];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [result addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];

    return [result copy];
}

@end
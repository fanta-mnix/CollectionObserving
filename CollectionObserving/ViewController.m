//
//  ViewController.m
//  CollectionObserving
//
//  Created by Rafael Fantini da Costa on 6/20/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

#import "ViewController.h"
#import "MVMArrayDataSource.h"
#import "MVMCollectionViewObserver.h"

@interface ViewController () <MVMCollectionViewCellPopulator>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *actionOption;

@property (strong, nonatomic) MVMArrayDataSource *dataSource;
@property (strong, nonatomic) MVMCollectionViewObserver *observer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [[MVMArrayDataSource alloc] initWithData:[NSMutableArray new] cellIdentifier:@"Cell"];
    self.dataSource.cellPopulator = self;

    self.observer = [[MVMCollectionViewObserver alloc] initWithCollectionView:self.collectionView];

    self.collectionView.dataSource = self.dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateCell:(UICollectionViewCell *)cell withObject:(UIColor *)object {
    cell.backgroundColor = object ?: [UIColor magentaColor];
}

- (IBAction)performAction:(id)sender {
    switch (self.actionOption.selectedSegmentIndex) {
        case 0:
            [self.dataSource.dataProxy addObject:[UIColor yellowColor]];
            break;
        case 1:
            [self.dataSource.dataProxy removeLastObject];
            break;
        case 2:
            self.dataSource.dataProxy[0] = [UIColor redColor];
            break;
        default:
            NSLog(@"Invalid action: %@", @(self.actionOption.selectedSegmentIndex));
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

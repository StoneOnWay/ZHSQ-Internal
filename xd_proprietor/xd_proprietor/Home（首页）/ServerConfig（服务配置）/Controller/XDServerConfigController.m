//
//  Created by cfsc on 2020/7/13.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDServerConfigController.h"
#import "XDServerConfigCell.h"
#import "XDServerConfigCellModel.h"
#import "XDDragCellCollectionView.h"
#import "XDServerDataManager.h"
#import "XDMyServerCollectionReusableFooterView.h"
#import "XDMyServerCollectionReusableHeaderView.h"
#import "XDAllServerCollectionReusableHeaderView.h"

@interface XDServerConfigController ()
<
XDDragCellCollectionViewDataSource,
XDDragCellCollectionViewDelegate
>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet XDDragCellCollectionView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
// 是否进行了编辑操作
@property (nonatomic, assign) BOOL editedData;
// 是否是进入二级界面
@property (nonatomic, assign) BOOL goToSub;

@end

@implementation XDServerConfigController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用管理";
    self.editedData = NO;
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.goToSub = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!self.goToSub) {
        // 如果返回首页，需要重置数据
        [XDServerDataManager shareDataManager].isEditing = NO;
        if (self.editedData) {
            [[XDServerDataManager shareDataManager] recoverData];
        }
    }
}

- (void)initUI {
    self.editBtn.layer.cornerRadius = 8.f;
    self.editBtn.layer.masksToBounds = YES;
    [self setUpEditState];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    float cellWidth = self.view.bounds.size.width/4.0;
    layout.itemSize = CGSizeMake(cellWidth, cellWidth);
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = 0.f;
    layout.sectionInset = UIEdgeInsetsZero;
    self.mainView.collectionViewLayout = layout;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    self.mainView.backgroundColor = RGB(246, 246, 246);
    [self.mainView registerNib:[UINib nibWithNibName:@"XDServerConfigCell" bundle:nil] forCellWithReuseIdentifier:@"XDServerConfigCell"];
    [self.mainView registerNib:[UINib nibWithNibName:@"XDMyServerCollectionReusableHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XDMyServerCollectionReusableHeaderView"];
    [self.mainView registerNib:[UINib nibWithNibName:@"XDAllServerCollectionReusableHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XDAllServerCollectionReusableHeaderView"];
    [self.mainView registerNib:[UINib nibWithNibName:@"XDMyServerCollectionReusableFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XDMyServerCollectionReusableFooterView"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editAction:) name:notification_CellBeganEditing object:nil];
}

#pragma mark - <XDDragCellCollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [XDServerDataManager shareDataManager].dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sec = [XDServerDataManager shareDataManager].dataArray[section];
    return sec.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDServerConfigCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDServerConfigCell" forIndexPath:indexPath];
    [cell resetModel:[XDServerDataManager shareDataManager].dataArray[indexPath.section][indexPath.item] :indexPath];
    return cell;
}

- (NSArray *)dataSourceArrayOfCollectionView:(XDDragCellCollectionView *)collectionView{
    self.editedData = YES;
    return [XDServerDataManager shareDataManager].dataArray;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size;
    if (section == 0) {
        if ([XDServerDataManager shareDataManager].isShowHeaderMessage) {
            size = CGSizeMake(self.view.bounds.size.width, 70);
        } else {
            size = CGSizeMake(self.view.bounds.size.width, 50);
        }
    } else {
        size = CGSizeMake(self.view.bounds.size.width, 40);
    }
    return size;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(self.view.bounds.size.width, 120);;
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            XDMyServerCollectionReusableHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XDMyServerCollectionReusableHeaderView" forIndexPath:indexPath];
            headView.title.text = [XDServerDataManager shareDataManager].titleArray[indexPath.section];
            if (indexPath.section == 0 && [XDServerDataManager shareDataManager].isShowHeaderMessage) {
                headView.tipLabelConstraint.constant = 20.f;
            } else if(indexPath.section == 0&& ![XDServerDataManager shareDataManager].isShowHeaderMessage) {
                headView.tipLabelConstraint.constant = 0.f;
            } else {
                headView.tipLabelConstraint.constant = 0.f;
            }
            reusableView = headView;
        } else {
            XDAllServerCollectionReusableHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XDAllServerCollectionReusableHeaderView" forIndexPath:indexPath];
            headView.titleLabel.text = [XDServerDataManager shareDataManager].titleArray[indexPath.section];
            reusableView = headView;
        }
    } else if (kind == UICollectionElementKindSectionFooter){
        if (indexPath.section == 0) {
            XDMyServerCollectionReusableFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XDMyServerCollectionReusableFooterView" forIndexPath:indexPath];
            if ([XDServerDataManager shareDataManager].isEditing) {
                footerView.tipsTitleLabel.text = @"以上应用展示在首页（最多8个）";
            } else {
                footerView.tipsTitleLabel.text = @"以上应用展示在首页";
            }
            reusableView = footerView;
        }
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(XDServerConfigCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.data.isNewAdd && indexPath.section == 0) {
        cell.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [UIView animateWithDuration:0.2 animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            cell.data.isNewAdd = NO;
        }];
    }
}

#pragma mark - <XDDragCellCollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XDServerConfigCellModel *model = [XDServerDataManager shareDataManager].dataArray[indexPath.section][indexPath.row];
    if ([[XDServerDataManager shareDataManager] isUnusableProgram:model.name]) {
        NSString *str = [NSString stringWithFormat:@"您还未入伙，无法使用%@功能", model.name];
        [XDUtil showToast:str];
        return;
    }
    self.goToSub = YES;
    if ([model.type isEqualToString:@"EXTERNAL"]) {
        XDHybridWebController *detailVC = [[XDHybridWebController alloc] initWithURLString:model.routeAddress];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        NSString *vcStr = [[XDServerDataManager shareDataManager] addressChange:model.routeAddress];
        UIViewController *vc = [[NSClassFromString(vcStr) alloc] init];
        vc.title = model.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dragCellCollectionView:(XDDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray {
    self.editedData = YES;
    [XDServerDataManager shareDataManager].dataArray = newDataArray.mutableCopy;
}

- (void)dragCellCollectionView:(XDDragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath {
    // 拖动时候最后禁用掉编辑按钮的点击
    self.editBtn.enabled = NO;
}

- (void)dragCellCollectionViewCellEndMoving:(XDDragCellCollectionView *)collectionView{
    self.editBtn.enabled = YES;
}

- (IBAction)cancelAction:(id)sender {
    if (!self.editedData) {
        // 没有编辑数据直接退出页面
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // 编辑了数据，取消编辑状态
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否保存本次编辑的内容？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[XDServerDataManager shareDataManager] recoverData];
            self.mainView.beginEditing = !self.mainView.beginEditing;
            [self setUpEditState];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            self.mainView.beginEditing = !self.mainView.beginEditing;
            [self setUpEditState];
            [self commitMyPrograms];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)editAction:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        if ([XDServerDataManager shareDataManager].isEditing && self.editedData) {
            // 如果有数据变化并且点击了完成，提交更新我的应用
            [self commitMyPrograms];
        }
        self.mainView.beginEditing = !self.mainView.beginEditing;
    }
    [self setUpEditState];
}

- (void)setUpEditState {
    if ([XDServerDataManager shareDataManager].isEditing) {
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.topViewHeightConstraint.constant = 124.f;
    } else {
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.topViewHeightConstraint.constant = 64;
    }
}

- (void)commitMyPrograms {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (XDServerConfigCellModel *model in [XDServerDataManager shareDataManager].dataArray[0]) {
        [array addObject:model.programId];
    }
    NSDictionary *dic = @{
        @"programIds":array,
        @"platformType":@"CFL"
    };
    [XDHTTPRequst updateMyProgramsWithDic:dic succeed:^(id res) {
        [MBProgressHUD hideHUD];
        if ([res[@"code"] integerValue] == 200) {
            [[XDServerDataManager shareDataManager] setUpData:res[@"result"]];
            if (self.myProgramsDidUpdate) {
                self.myProgramsDidUpdate();
            }
            self.editedData = NO;
        } else {
            [XDUtil showToast:res[@"message"]];
        }
    } fail:^(NSError *error) {
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end

//
//  HZSingleChoiceListView.m
//  Pods
//
//  Created by mason on 2017/8/5.
//
//

#import "HZSingleChoiceListView.h"

@interface HZSingleChoiceItemTableViewCell : UITableViewCell

/** 内容 */
@property (strong, nonatomic) UILabel *titleLabel;
/** 选中标识 */
@property (strong, nonatomic) UIImageView *selectImageView;
/**  */
@property (strong, nonatomic) HZSingleChoiceModel *singleChoiceModel;

@end

@implementation HZSingleChoiceItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectImageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15.f);
    }];

    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-15.f);
        make.size.mas_equalTo(CGSizeMake(13.f, 9.f));
    }];
}

- (void)setSingleChoiceModel:(HZSingleChoiceModel *)singleChoiceModel {
    _singleChoiceModel = singleChoiceModel;
    self.titleLabel.text = singleChoiceModel.title;
    if (singleChoiceModel.selectedStatus) {
        self.selectImageView.hidden = NO;
        self.titleLabel.textColor = UIColorHex(343434);
    } else {
        self.selectImageView.hidden = YES;
        self.titleLabel.textColor = UIColorHex(343434);
    }
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.textColor = UIColorHex(343434);
    }
    return _titleLabel;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_selected"]];
        _selectImageView.contentMode = UIViewContentModeCenter;
    }
    return _selectImageView;
}

@end


@interface HZSingleChoiceListView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) UITableView *tableView;
/** <##> */
@property (strong, nonatomic) NSMutableArray *multipleChoiceArray;
/** <##> */
@property (strong, nonatomic) UIButton *commitBtn;

@end

@implementation HZSingleChoiceListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
    [self addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40.f;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[HZSingleChoiceItemTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HZSingleChoiceItemTableViewCell class])];
    
    
}

- (void)setMultipleChoiceAbled:(BOOL)multipleChoiceAbled {
    _multipleChoiceAbled = multipleChoiceAbled;
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-40.f);
    
    UIView *headerView = [[UIView alloc] init];
    [self addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.height.equalTo(self).with.offset(40.f);
    }];
//    [headerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
//    [headerView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
//    [headerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
//    [headerView autoSetDimension:ALDimensionHeight toSize:40.f];
//
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:cancelBtn];
//    [cancelBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerView];
//    [cancelBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView];
//    [cancelBtn autoSetDimensionsToSize:CGSizeMake(60.f, 40.f)];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(0);
        make.right.equalTo(headerView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60.f, 40.f));
    }];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorHex(5890c7) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:commitBtn];
//    [commitBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerView];
//    [commitBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headerView];
//    [commitBtn autoSetDimensionsToSize:CGSizeMake(60.f, 40.f)];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).with.offset(0);
        make.right.equalTo(headerView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60.f, 40.f));
    }];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:UIColorHex(5890c7) forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [commitBtn setEnabled:NO];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.commitBtn = commitBtn;
}

- (void)cancelAction:(UIButton *)sender {
    if (self.choiceDismissBlock) {
        self.choiceDismissBlock();
    }
}

- (void)commitAction:(UIButton *)sender {
    if (!self.isMultipleChoiceAbled) {
        HZSingleChoiceModel *singleChoiceModel = self.multipleChoiceArray.firstObject;
        if (self.choiceResultBlock) {
            self.choiceResultBlock(singleChoiceModel);
        }
    } else {
        if (self.choiceResultBlock) {
            self.choiceResultBlock(self.multipleChoiceArray);
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HZSingleChoiceItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZSingleChoiceItemTableViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[HZSingleChoiceItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HZSingleChoiceItemTableViewCell class])];
    }
    cell.singleChoiceModel = self.itemArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.isMultipleChoiceAbled) {
        [self.multipleChoiceArray removeAllObjects];
        for (HZSingleChoiceModel *singleChoiceModel in self.itemArray) {
            singleChoiceModel.selectedStatus = NO;
        }
        HZSingleChoiceModel *singleChoiceModel = self.itemArray[indexPath.row];
        singleChoiceModel.selectedStatus = !singleChoiceModel.isSelectedStatus;
        [self.tableView reloadData];
        if (self.choiceResultBlock) {
            self.choiceResultBlock(singleChoiceModel);
        }
        [self.multipleChoiceArray addObject:singleChoiceModel];
    } else {
        HZSingleChoiceModel *singleChoiceModel = self.itemArray[indexPath.row];
        if (singleChoiceModel.isSelectedStatus) {
            [self.multipleChoiceArray removeObject:singleChoiceModel];
            singleChoiceModel.selectedStatus = NO;
        } else {
            singleChoiceModel.selectedStatus = YES;
            [self.multipleChoiceArray addObject:singleChoiceModel];
        }
        [self.tableView reloadData];
    }
    [self.commitBtn setEnabled:self.multipleChoiceArray.count > 0];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (NSMutableArray *)multipleChoiceArray {
    if (!_multipleChoiceArray) {
        _multipleChoiceArray = [NSMutableArray array];
    }
    return _multipleChoiceArray;
}

- (void)dealloc {
}



@end

















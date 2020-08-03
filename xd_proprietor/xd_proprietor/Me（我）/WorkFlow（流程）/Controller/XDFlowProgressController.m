//
//  Created by cfsc on 2020/4/26.
//  Copyright © 2020 zc. All rights reserved.
//

#import "XDFlowProgressController.h"
#import "XDFlowProgressCell.h"

@interface XDFlowProgressController ()

@end

@implementation XDFlowProgressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进度";
    [self.tableView registerNib:[UINib nibWithNibName:@"XDFlowProgressCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDFlowProgressCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flowDetail.processes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDFlowProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDFlowProgressCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.processModel = self.flowDetail.processes[indexPath.row];
    cell.topLine.hidden = indexPath.row == 0 ? YES : NO;
    cell.bottomLine.hidden = indexPath.row == self.flowDetail.processes.count - 1 ? YES : NO;
    return cell;
}

@end

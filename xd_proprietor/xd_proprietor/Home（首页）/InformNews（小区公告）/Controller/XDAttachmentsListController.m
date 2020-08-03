//
//  XDAttachmentsListController.m
//  XD业主
//
//  Created by zc on 2018/5/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDAttachmentsListController.h"
#import "XDAttachmentCell.h"
#import "XDAttachmentsDetailController.h"
#import "XDAttachmentModel.h"

@interface XDAttachmentsListController ()

@end

@implementation XDAttachmentsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = 0;
    self.tableView.rowHeight = 60;
    self.view.backgroundColor = backColor;
    self.title = @"附件列表";
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAttachmentModel *model = self.resourceArray[indexPath.row];
    XDAttachmentCell *cell = [XDAttachmentCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    cell.nameLabels.text = model.name;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAttachmentModel *model = self.resourceArray[indexPath.row];
    XDAttachmentsDetailController *detail = [[XDAttachmentsDetailController alloc] init];
    detail.urlString = model.url;
    [self.navigationController pushViewController:detail animated:YES];
}

@end

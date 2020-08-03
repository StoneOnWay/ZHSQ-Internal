//
//  XDInfoNewsToolBar.h
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XDInfoNewsToolBarDelegate <NSObject>

@optional
//点击分享
-(void)clickShareBtn:(UIButton *)button;
//点击评论
-(void)clickCommentBtn:(UIButton *)button;
//点击赞
-(void)clickZanBtn:(UIButton *)button;
//附件列表
-(void)clickListBtn:(UIButton *)button;

@end

@interface XDInfoNewsToolBar : UIView

@property (nonatomic, weak) id<XDInfoNewsToolBarDelegate>delegate;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
//赞
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
//评论
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
//浏览量
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

//点赞数
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;

@property (weak, nonatomic) IBOutlet UIButton *listBtn;

@end

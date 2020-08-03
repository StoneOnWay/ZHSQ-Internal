//
//  Created by cfsc on 2020/3/4.
//  Copyright © 2020年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDHeaderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIControl *clickControl;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;

- (void)setContent;

@end

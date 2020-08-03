//
//  HZPopView.h
//  Pods
//
//  Created by mason on 2017/8/1.
//
//

#import <UIKit/UIKit.h>

@interface HZPopView : UIView

/**

 @param contenView 内容view
 @param rect 内容view的大小
 @param container 父View 可为空
 */
- (void)popViewWithContenView:(UIView *)contenView
                       inRect:(CGRect)rect
                  inContainer:(UIView *)container;

- (void) diss;
@end

//
//  MLDynamicModalTitleView.h
//  Pods
//
//  Created by Jonatan Urquiza on 8/19/17.
//
//

#import <UIKit/UIKit.h>

@interface MLDynamicModalTitleView : UIView

@property (nonatomic, strong) UILabel *title;

- (instancetype)initWithTitle:(NSAttributedString *)title;

@end

//
//  ZXAlertVC.h
//  ZXAlertViewController
//
//  Created by xinying on 2017/1/23.
//  Copyright © 2017年 habav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXTableViewCell.h"

typedef NS_ENUM(NSInteger, ZXAlertActionStyle) {
    ZXAlertActionStyleDefault = 0,
    ZXAlertActionStyleCancel,
    ZXAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, ZXAlertControllerStyle) {
    ZXAlertControllerStyleActionSheet = 0,
    ZXAlertControllerStyleActionSheetWithTileAndMessage,
    ZXAlertControllerStyleAlert
};

typedef NS_ENUM(NSInteger, ZXBackgroundViewEffect) {
    ZXBackgroundViewBlurEffect =0,
    ZXBackgroundViewBlurAlpha,
};

@interface ZXAlertAction : NSObject

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) ZXAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

+ (instancetype _Nullable )actionWithTitle:(NSString *_Nullable)title style:(ZXAlertActionStyle)style handler:(void (^ __nullable)(ZXAlertAction * _Nullable action))handler;

@end

@interface ZXAlertController : UIViewController

@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic, readonly) ZXAlertControllerStyle preferredStyle;
@property (nonatomic, strong) UIView * _Nonnull customHeaderView;
@property (nonatomic, assign) ZXBackgroundViewEffect backgroundViewEffect;

+ (instancetype _Nullable)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(ZXAlertControllerStyle)preferredStyle;

-(void)addAction:(ZXAlertAction *_Nonnull)action;
-(void)removeAllAction;

-(void)show;
@end

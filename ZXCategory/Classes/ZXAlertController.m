//
//  ZXAlertVC.m
//  ZXAlertViewController
//
//  Created by xinying on 2017/1/23.
//  Copyright © 2017年 habav. All rights reserved.
//

#import "ZXAlertController.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define Cell @"ZXTableViewCell"
#define blockHandler(block , ...) !block ? 0 : block(__VA_ARGS__)

static const NSInteger cellHeight =44;
static const CGFloat   sectionHeaderHeight =5;
static CGFloat   tableViewHeaderHeight =20;

@interface ZXAlertAction ()

@property (nullable, nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) ZXAlertActionStyle style;

@property (nonatomic, strong) NSMutableArray *blockArray;
@property (nonatomic, strong) void(^handler)(ZXAlertAction *action);
@end

@implementation ZXAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(ZXAlertActionStyle)style handler:(void (^ __nullable)(ZXAlertAction *action))handler{
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(ZXAlertActionStyle)style handler:(void (^ __nullable)(ZXAlertAction *action))handler{
    if (self = [super init]) {
        self.title =title;
        self.style =style;
        self.handler = handler;
        self.enabled =YES;
    }
    return self;
}

- (NSMutableArray *)blockArray{
    if(!_blockArray){
        _blockArray =[[NSMutableArray alloc] init];
    }
    return _blockArray;
}

@end

@interface ZXAlertController ()<UITableViewDelegate ,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray<ZXAlertAction *> *alertAction;
@property(nonatomic,strong) NSMutableArray<ZXAlertAction *> *cancelAction;
@property (nonatomic, readwrite) ZXAlertControllerStyle preferredStyle;

@property(nonatomic,assign) NSInteger section;

@end

@implementation ZXAlertController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(ZXAlertControllerStyle)preferredStyle{
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(ZXAlertControllerStyle)preferredStyle{
    if (self = [super init]) {
        self.title =title;
        self.message =message;
        self.preferredStyle =preferredStyle;

        self.view.backgroundColor =[UIColor clearColor];
        self.view.alpha =1;
        self.section =1;
        tableViewHeaderHeight = preferredStyle == ZXAlertControllerStyleActionSheetWithTileAndMessage ? cellHeight : 0;
        [self removeAllAction];
    }
    return self;
}

- (void)setBackgroundViewEffect:(ZXBackgroundViewEffect)backgroundViewEffect{
    
    _backgroundViewEffect = backgroundViewEffect;
    switch (backgroundViewEffect) {
        case 0:
            self.view.backgroundColor =[UIColor clearColor];
            self.view.alpha =1;
            break;
        case 1:
            self.view.backgroundColor =[UIColor blackColor];
            self.view.alpha =0;
            break;
        default:
            break;
    }
}

- (void)loadView{
    [super loadView];
    switch (self.backgroundViewEffect) {
        case 0:{
            UIBlurEffect *effect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *effectView =[[UIVisualEffectView alloc] initWithEffect:effect];
            effectView.frame =self.view.bounds;
            effectView.alpha = 0.7f;
            [self.view insertSubview:effectView atIndex:0];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.preferredStyle == ZXAlertControllerStyleActionSheet) {
//        [self.tableView registerNib:[UINib nibWithNibName:Cell bundle:nil] forCellReuseIdentifier:Cell];
        [self.tableView registerClass:[NSClassFromString(Cell) class] forCellReuseIdentifier:Cell];
        self.tableView.delegate =self;
        self.tableView.dataSource =self;
    }
}

-(void)addAction:(ZXAlertAction *)action{
    if (action.style == ZXAlertActionStyleCancel) {
        _section =2;
        [self.cancelAction addObject:action];
    }else{
        [self.alertAction addObject:action];
    }
}

#pragma mark - Action
-(void)show{
    
    CGFloat height =(self.alertAction.count +self.cancelAction.count) * cellHeight + (self.section -1) * sectionHeaderHeight + tableViewHeaderHeight;
    self.tableView.frame =CGRectMake(0, kScreenHeight, kScreenWidth, height);
    [self.tableView reloadData];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.view];
    [UIView animateWithDuration:0.2 animations:^{
        
        switch (self.backgroundViewEffect) {
            case 1:
                self.view.alpha = 0.5;
                break;
            default:
                break;
        }
        self.tableView.frame =CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)removeAllAction{
    [self.alertAction removeAllObjects];
    [self.cancelAction removeAllObjects];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissmisView];
}
-(void)dissmisView{
    [UIView animateWithDuration:0.2 animations:^{
    
        self.tableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.tableView.bounds.size.height);
        switch (self.backgroundViewEffect) {
            case 1:
                self.view.alpha = 0;
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeAllAction];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXAlertAction *action;
    if (indexPath.section ==0) {
         action = self.alertAction[indexPath.row];
    }else{
        action = self.cancelAction[indexPath.row];
    }
    if (action.isEnabled) {
        blockHandler(action.handler ,action);
    }
    [self dissmisView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return self.alertAction.count;
    }
    return self.cancelAction.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Cell];
    ZXAlertAction *action;
    if (indexPath.section ==0) {
        action = self.alertAction[indexPath.row];
        cell.title.text =action.title;
    }else{
        action = self.cancelAction[indexPath.row];
        cell.title.text =self.cancelAction[indexPath.row].title;
    }
    
    switch (action.style) {
        case ZXAlertActionStyleDestructive:
            cell.title.textColor =[UIColor blueColor];
            break;
        default:
            cell.title.textColor =[UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:1];
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.section;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        return sectionHeaderHeight;
    }else
        return tableViewHeaderHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        return [[UIView alloc] init];
    }else{

        switch (self.preferredStyle) {
            case ZXAlertControllerStyleActionSheetWithTileAndMessage:
                return self.customHeaderView ? : nil;
                break;
                
            default:
                return nil;
                break;
        }
    }
}

#pragma mark - LazyLoad
-(NSMutableArray<ZXAlertAction *> *)alertAction{
    if (!_alertAction) {
        _alertAction =[NSMutableArray arrayWithCapacity:1];
    }
    return _alertAction;
}

-(NSMutableArray<ZXAlertAction *> *)cancelAction{
    if (!_cancelAction) {
        _cancelAction =[NSMutableArray arrayWithCapacity:1];
    }
    return _cancelAction;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor =[UIColor clearColor];
        _tableView.scrollEnabled =NO;
        [self.view addSubview:_tableView];

    }
    return _tableView;
}
@end

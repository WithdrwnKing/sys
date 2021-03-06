//
//  AttendanceViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/19.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#define ActionViewTag       12345

#import "AttendanceViewController.h"
#import "AttenddanceCollectionViewCell.h"
#import "ChosePersonModel.h"
#import <ZLCustomCamera.h>
#import "WKPicturePreviewVC.h"
#import "WKLocationManager.h"
#import <MAMapKit/MAMapKit.h>
#import "LocationView.h"
#import "DetectionViewController.h"
#import "AttendanceModel.h"

static NSString *cellIdentifier = @"AttendanceCell";
@interface AttendanceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YYTextViewDelegate,UITextFieldDelegate>{
    CGFloat moveHeight;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *remakView;
@property (nonatomic, strong) UIButton *selectPhotoBtn;
@property (nonatomic, strong) UIButton *selectTypeBtn;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <AttendanceModel *>*attendModelArr;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, copy) NSArray *attendanceArray;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, copy) NSString *address;

@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传员工考勤信息";
    self.view.userInteractionEnabled = YES;
    
    [self loadCategoryID];
    [self setUpUI];
    [self updateLocation];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

/* 更新用户地理位置 */
- (void)updateLocation{
    WeaklySelf(weakSelf);
    [[WKLocationManager sharedWKLocationManager].locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (location) {
            weakSelf.location = location.coordinate;
        }
        if (regeocode) {
            weakSelf.address = regeocode.formattedAddress;
        }
    }];
}

/* 加载上岗类型 */
- (void)loadCategoryID{
    
    for (ChosePersonModel *obj in self.selectArray) {
        AttendanceModel *model = [[AttendanceModel alloc] init];
        model.staffID = obj.userId;
        model.contrastImage = @"";
        model.status = @"";
        model.nickName = obj.nickName;
        [self.attendModelArr addObject:model];
    }
    
    [[SMGApiClient sharedClient] getTypeOfWorkAndCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            self.attendanceArray = (NSArray *)aResponse;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    self.scrollView.height = self.view.height;
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    moveHeight = 0;
    if (self.view.height - self.textView.bottom-self.remakView.top<height) {
        moveHeight = height - (self.view.height - self.textView.bottom-self.remakView.top);
    }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
}

- (void)setUpUI{
    [self.view addSubview:self.scrollView];
    UILabel *typeLbl = [UILabel new];
    typeLbl.text = @"上岗类型：";
    typeLbl.font = font(15);
    typeLbl.frame = CGRectMake(20, 20, 85, 20);
    [self.scrollView addSubview:typeLbl];
    
    UIButton *selectTypeBtn = [UIButton new];
    selectTypeBtn.frame = CGRectMake(typeLbl.right, 15, SCREEN_WIDTH-typeLbl.right-30, 30);
    [selectTypeBtn setImage:ImageNamed(@"icon_uparrow") forState:UIControlStateNormal];
    [selectTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, selectTypeBtn.width-30, 0, 0)];
    [selectTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    selectTypeBtn.titleLabel.font = font(15);
    [selectTypeBtn setTitleColor:BlackColor forState:UIControlStateNormal];
    [selectTypeBtn addTarget:self action:@selector(showActionVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:selectTypeBtn];
    self.selectTypeBtn = selectTypeBtn;
    ViewBorderRadius(selectTypeBtn, 5, 1, SEPARATOR_LINE_COLOR);
    
    UILabel *photoLbl = [UILabel new];
    photoLbl.text = @"拍照上传：";
    photoLbl.font = typeLbl.font;
    photoLbl.frame = CGRectMake(typeLbl.left, typeLbl.bottom+28, typeLbl.width, typeLbl.height);
    [self.scrollView addSubview:photoLbl];
    [self.scrollView addSubview:self.collectionView];
    
    _remakView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, SCREEN_WIDTH, 135+28)];
    [self.scrollView addSubview:_remakView];
    
    UILabel *remarkLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 100, 20)];
    remarkLbl.font = font(15);
    remarkLbl.text = @"备注：";
    [_remakView addSubview:remarkLbl];
    
    YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(remarkLbl.left, remarkLbl.bottom+12, _remakView.width-40, 59)];
    textView.delegate = self;
    textView.font = font(15);
    textView.textColor = HEX_RGB(0x8c8c8c);
    [_remakView addSubview:textView];
    ViewBorderRadius(textView, 0, 1, SEPARATOR_LINE_COLOR);
    self.textView = textView;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.backgroundColor = CommonRedColor;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    submitBtn.titleLabel.font = font(13);
    submitBtn.frame = CGRectMake(0, _remakView.bottom+30, 140, 36);
    submitBtn.centerX = SCREEN_WIDTH/2;
    [submitBtn addTarget:self action:@selector(sumitNext) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:submitBtn];
    ViewBorderRadius(submitBtn, 5, 0, WhiteColor);
    self.commitBtn = submitBtn;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.commitBtn.bottom+20);
}

- (void)showActionVC:(UIButton *)sender {
    
    if (VIEWWITHTAG(self.view, ActionViewTag)) {
        [VIEWWITHTAG(self.view, ActionViewTag) removeFromSuperview];
        return;
    }
    
    UIView *actionView = [UIView new];
    actionView.frame = CGRectMake(self.selectTypeBtn.left, self.selectTypeBtn.bottom, self.selectTypeBtn.width, 25*self.attendanceArray.count);
    actionView.backgroundColor = WhiteColor;
    actionView.tag = ActionViewTag;
    [self.scrollView addSubview:actionView];
    ViewBorderRadius(actionView, 5, 1, SEPARATOR_LINE_COLOR);
    WeaklySelf(weakSelf);
    for (int i = 0; i < self.attendanceArray.count; i ++) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 25*i, actionView.width, 24.5);
        NSDictionary *dict = self.attendanceArray[i];
        label.text = [dict objectForKey:@"Name"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = font(15);
        label.userInteractionEnabled = YES;
        label.textColor = [UIColor grayColor];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf.selectTypeBtn setTitle:label.text forState:UIControlStateNormal];
            [actionView removeFromSuperview];
        }]];
        [actionView addSubview:label];
        if (i == self.attendanceArray.count-1) {
            return;
        }
        UILabel *line = [UILabel new];
        line.frame = CGRectMake(5, label.bottom, label.width-10, .5);
        line.backgroundColor = SEPARATOR_LINE_COLOR;
        [actionView addSubview:line];
    }
}

/**
 @brief 判断考勤上传条件
 */
- (BOOL)judgeSumit{
    if (![self.selectTypeBtn.titleLabel.text isNotEmpty]) {
        ShowToastAtTop(@"请选择上岗类型");
        return NO;
    }
    for (AttendanceModel *modelObj in self.attendModelArr) {
        if (![modelObj.contrastImage isNotEmpty]) {
            ShowToastAtTop(@"存在未识别人员");
            return NO;
        }
    }

    if (![self.address isNotEmpty]) {
        @weakify(self);
        LocationView *view = [[LocationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [view.loactionSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self updateLocation];
            [view removeFromSuperview];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        return NO;
    }
    
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([CURRENTUSER.infoModel.Dimension doubleValue],[CURRENTUSER.infoModel.Longitude doubleValue]));
    MAMapPoint point2 = MAMapPointForCoordinate(self.location);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    if (distance>1000) {
        ShowToastAtTop(@"请在您负责的客户地址上传考勤信息");
        return NO;
    }

    return YES;
}

/**
 @brief 上传考勤信息
 */
- (void)uploadAttendanceInfo {
    
    WeaklySelf(weakSelf);
    NSString *typeStr;
    NSMutableArray *staffTemArr = [NSMutableArray array];
    NSMutableArray *statusTemArr = [NSMutableArray array];
    NSMutableArray *contrastImageTemArr = [NSMutableArray array];
    for (NSDictionary *dict in self.attendanceArray) {
        NSString *type = dict[@"Name"];
        if ([type isEqualToString:self.selectTypeBtn.titleLabel.text]) {
            typeStr = dict[@"ID"];
        }
    }
    
    for (AttendanceModel *obj in self.attendModelArr) {
        [staffTemArr addObject:obj.staffID];
        [statusTemArr addObject:obj.status];
        [contrastImageTemArr addObject:obj.contrastImage];
    }
    
    [[SMGApiClient sharedClient] submitCheckingWithOrgID:CURRENTUSER.infoModel.orgId Address:self.address Type:typeStr Remark:self.textView.text StaffID:[staffTemArr componentsJoinedByString:@","] ContrastImage:[contrastImageTemArr componentsJoinedByString:@","] Status:[statusTemArr componentsJoinedByString:@","] andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        [SVProgressHUD dismiss];
        if (aResponse) {
            ShowToastAtTop(@"考勤信息已提交成功");
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        }else{
            ShowToastAtTop(@"%@",anError.userInfo[@"message"]);
        }
    }];
}


/**
 @brief 判断考勤人员
 */
- (void)sumitNext{
   
    if (![self judgeSumit]) {
        return;
    }
    
    NSMutableArray *nameArray = [NSMutableArray array];
    for (AttendanceModel *modelObj in self.attendModelArr) {
        if ([modelObj.status integerValue] == 0) {
            [nameArray addObject:modelObj.nickName];
        }
    }
    if (nameArray.count==0) {
        [self uploadAttendanceInfo];
    }else{
        LocationView *view = [[LocationView alloc] initWithFrame:kKeywindow.bounds];
        view.hintStr = [NSString stringWithFormat:@"%@未识别成功，是否要提交？",[nameArray componentsJoinedByString:@","]];
        view.confirmStr = @"确定";
        @weakify(self);
        [view.cancelSignal subscribeNext:^(id  _Nullable x) {
            [view removeFromSuperview];
        }];
        
        [view.loactionSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [view removeFromSuperview];
            [self uploadAttendanceInfo];
        }];
        [kKeywindow addSubview:view];
    }
    
}
/**
 @brief 人脸识别
 */
- (void)sumitData:(UIImage *)image staffID:(NSString *)staffID cell:(AttenddanceCollectionViewCell *)cell{
    if (!image) {
        return;
    }
    [SVProgressHUD showWithStatus:@"正在识别考勤人员"];
    [[SMGApiClient sharedClient] faceRecognitionWithStaffID:staffID fileData:UIImagePNGRepresentation(image) andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        [SVProgressHUD dismiss];
        if (aResponse) {
            NSString *Status  = [[aResponse objectForKey:@"Status"] asNSString];
            NSString *StaffID = [[aResponse objectForKey:@"StaffID"] asNSString];
            NSString *ContrastImage = [[aResponse objectForKey:@"ContrastImage"] asNSString];
            for (ChosePersonModel *obj in self.selectArray) {
                if ([obj.userId isEqualToString:StaffID]) {
                    obj.isSelected = [Status integerValue];
                }
            }
            
            for (AttendanceModel *model in self.attendModelArr) {
                if ([model.staffID isEqualToString:StaffID]) {
                    model.contrastImage = ContrastImage;
                    model.status = Status;
                }
            }
            
            cell.nameBtn.enabled = [Status integerValue];
            if ([Status integerValue] == 1) {
                ShowToastAtTop(@"人脸识别成功");
                cell.imageView.image = image;
            }else{
                ShowToastAtTop(@"人脸识别失败");
                cell.imageView.image = ImageNamed(@"ca_head");
            }
        }else{
            ShowToastAtTop(@"人脸识别失败");
        }
    }];
    
}

- (void)reloadUI{
    CGFloat width = SCREEN_WIDTH - 20;
    width = width/3 - 10;
    CGFloat collectHeight = width + 5;
    NSInteger count = self.selectImageArr.count - 3;
    if (count > 0) {
        NSInteger row = count/3 + 2;
        if (count%3 == 0) {
            row--;
        }
        self.collectionView.height = collectHeight * row ;
    }else{
        self.collectionView.height = collectHeight;
    }
    self.remakView.top = self.collectionView.bottom;
    self.commitBtn.top = self.remakView.bottom+30;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.commitBtn.bottom+20);

}

- (void)upImageClicked{

    WeaklySelf(weakSelf);
    ZLCustomCamera *vc = [[ZLCustomCamera alloc] init];
    vc.allowRecordVideo = NO;
    vc.sessionPreset = ZLCaptureSessionPreset1920x1080;
    vc.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        if (image) {
            [weakSelf.selectImageArr addObject:[image normalizedImage]];
            [weakSelf reloadUI];
            [weakSelf.collectionView reloadData];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidBeginEditing:(YYTextView *)textView{
    if (moveHeight>0) {
        self.view.centerY = self.view.centerY - moveHeight;
    }
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    
    self.navigationItem.rightBarButtonItem = done;
}
- (void)textViewDidEndEditing:(YYTextView *)textView{
    if (moveHeight>0) {
        self.view.centerY = self.view.height/2+STATUSBAR_HEIGHT+44;
    }
    self.navigationItem.rightBarButtonItem = nil;

}
- (void)leaveEditMode {
    [self.textView resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AttenddanceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    ChosePersonModel *model = self.selectArray[indexPath.row];
    [cell.nameBtn setTitle:model.nickName forState:UIControlStateNormal];
    cell.nameBtn.enabled = model.isSelected;
    [self btnRightImage:cell.nameBtn];
    return cell;
}
#pragma mark - UICollectionViewDelegate
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WeaklySelf(weakSelf);
    ChosePersonModel *model = self.selectArray[indexPath.row];
    AttenddanceCollectionViewCell *cell = (AttenddanceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    DetectionViewController *vc = [DetectionViewController new];
    vc.imageBlock = ^(UIImage *image) {
        [weakSelf sumitData:image staffID:model.userId cell:cell];
    };
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)btnRightImage:(UIButton *)btn{
    btn.titleLabel.backgroundColor = btn.imageView.backgroundColor;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - btn.imageView.image.size.width, 0, btn.imageView.image.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+20, 0, -btn.titleLabel.bounds.size.width)];    
}

#pragma mark - lazyLoading
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _scrollView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = SCREEN_WIDTH - 20;
        width = width/3 - 10;
        
        CGFloat height = (width+35);
        NSInteger count = self.selectArray.count - 3;
        if (count > 0) {
            NSInteger row = count/3 + 2;
            if (count%3 == 0) {
                row--;
            }
            height = (width+35) * row ;
        }
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(width, width+30);
        CGFloat top = 88.f + 5.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, top, SCREEN_WIDTH-20, height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"AttenddanceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _collectionView;
}
- (NSMutableArray *)selectImageArr{
    if (!_attendModelArr) {
        _attendModelArr = [NSMutableArray array];
    }
    return _attendModelArr;
}
- (NSMutableArray<AttendanceModel *> *)attendModelArr{
    if (!_attendModelArr) {
        _attendModelArr = [NSMutableArray array];
    }
    return _attendModelArr;
}
@end

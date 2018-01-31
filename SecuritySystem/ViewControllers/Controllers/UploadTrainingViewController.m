//
//  UploadTrainingViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/18.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "UploadTrainingViewController.h"
#import "TrainingCollectionViewCell.h"
#import <ZLCustomCamera.h>
#import "WKLocationManager.h"
#import "LocationView.h"
#import "WKPicturePreviewVC.h"

@interface UploadTrainingViewController ()<YYTextViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    CGFloat moveHeight;
}
@property (strong, nonatomic)  YYTextView *descTextView;
@property (strong, nonatomic)  UILabel *label;
@property (strong, nonatomic)  UIButton *submitBtn;
@property (strong, nonatomic)  UITextField *themeTextField;

@property (nonatomic, strong) NSMutableArray *selectImgArr;
@property (nonatomic, strong) NSMutableArray *selectVideoArr;

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UICollectionView *imgCollectionView;
@property (nonatomic, strong) UICollectionView *videoCollectionView;

@property (nonatomic, assign) __block BOOL isFinshed;
@property (nonatomic, strong) NSMutableArray *uploadImgArr;
@property (nonatomic, strong) NSMutableArray *uploadSimgArr;
@property (nonatomic, strong) NSMutableArray *uploadVideoArr;
@property (nonatomic, strong) NSMutableArray *classIdArr;
@property (nonatomic, copy) NSString *addressStr;

@end

@implementation UploadTrainingViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传员工训练情况";
    
    [self setUpView];
    
    ViewBorderRadius(_descTextView, 5, .5, BlackColor);
    ViewBorderRadius(_themeTextField, 5, .5, BlackColor);
    ViewBorderRadius(_submitBtn, 5, 0, BlackColor);
    
    [self locationFirst:NO];
    
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

- (void)viewDidDisappear:(BOOL)animated{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (void)setUpView{
    [self.view addSubview:self.bgScrollView];
    UILabel *lbl1 = [UILabel new];
    lbl1.text = @"训练主题：";
    lbl1.font = font(15);
    lbl1.frame = CGRectMake(20, 20, 80, 20);
    [self.bgScrollView addSubview:lbl1];
    
    UILabel *lbl2 = [UILabel new];
    lbl2.text = @"上传视频：";
    lbl2.font = font(15);
    lbl2.frame = CGRectMake(lbl1.left, lbl1.bottom+30, lbl1.width, 20);
    [self.bgScrollView addSubview:lbl2];
    CGFloat width = SCREEN_WIDTH - 20;
    width = width/3 - 10;
    
    [self.bgScrollView addSubview:self.videoCollectionView];

    UILabel *lbl3 = [UILabel new];
    lbl3.text = @"上传图片：";
    lbl3.font = font(15);
    lbl3.frame = CGRectMake(lbl1.left, self.videoCollectionView.bottom+20, lbl1.width, 20);
    [self.bgScrollView addSubview:lbl3];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(lbl1.right, lbl1.top-7.5, self.view.width-lbl1.right-30, 30)];
    field.placeholder = @"请输入训练主题";
    field.font = font(15);
    field.delegate = self;
    [self.bgScrollView addSubview:field];
    self.themeTextField = field;
    
    [self.bgScrollView addSubview:self.imgCollectionView];
    
    UILabel *lbl4 = [UILabel new];
    lbl4.text = @"训练说明：";
    lbl4.font = font(15);
    lbl4.frame = CGRectMake(lbl1.left, self.imgCollectionView.bottom+20, lbl1.width, 20);
    [self.bgScrollView addSubview:lbl4];
    self.label = lbl4;
    
    YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(lbl4.left, lbl4.bottom+20, SCREEN_WIDTH-40, 60)];
    textView.font = font(15);
    textView.delegate = self;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.bgScrollView addSubview:textView];
    self.descTextView = textView;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(0, textView.bottom+30, 140, 36);
    submitBtn.backgroundColor = CommonRedColor;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    submitBtn.centerX = SCREEN_WIDTH/2;
    [submitBtn addTarget:self action:@selector(upLoadFiles) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, submitBtn.bottom+kTopHeight+30);
}

- (void)reloadUI{
    CGFloat width = SCREEN_WIDTH - 20;
    width = width/3 - 10;
    CGFloat collectHeight = width + 10;
    NSInteger count = self.selectImgArr.count - 2;
    if (count > 0) {
        NSInteger row = count/3 + 2;
        if (count%3 == 0) {
            row--;
        }
        self.imgCollectionView.height = collectHeight * row ;
    }else{
        self.imgCollectionView.height = collectHeight;
    }
    self.label.top = self.imgCollectionView.bottom+20;
    self.descTextView.top = self.label.bottom+20;
    self.submitBtn.top = self.descTextView.bottom+30;
    
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.submitBtn.bottom+kTopHeight+30);

}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (self.themeTextField.isFirstResponder) {
        return;
    }
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    moveHeight = 0;
    if (self.view.height - self.descTextView.bottom<height) {
        moveHeight = height - (self.view.height - self.descTextView.bottom);
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
}
- (void)textViewDidBeginEditing:(YYTextView *)textView{
    if (moveHeight>0) {
        self.view.centerY = self.view.centerY - moveHeight;
    }
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    self.navigationItem.rightBarButtonItem = done;
}
- (void)textViewDidEndEditing:(YYTextView *)textView{
    if (moveHeight>0) {
        self.view.centerY = self.view.height/2 + kTopHeight;
    }
    self.navigationItem.rightBarButtonItem = nil;

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    self.navigationItem.rightBarButtonItem = done;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.navigationItem.rightBarButtonItem = nil;

}

- (void)leaveEditMode {
    [self.descTextView resignFirstResponder];
    [self.themeTextField resignFirstResponder];
}

- (void)locationFirst:(BOOL)isNeedSubmit {
    WeaklySelf(weakSelf);
    [[WKLocationManager sharedWKLocationManager].locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (regeocode) {
            weakSelf.addressStr = regeocode.formattedAddress;
            NSLog(@"%@",weakSelf.addressStr);
            if (isNeedSubmit) {
                [weakSelf submitTrainingInfo];
            }
        }
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"定位失败"];
        }
    }];
}
- (void)showLocationView{
    [self.view endEditing:YES];
    @weakify(self);
    LocationView *view = [[LocationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view.loactionSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self locationFirst:YES];
        [view removeFromSuperview];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)hideKeyboard {
    if (self.descTextView.isFirstResponder) {
        [self.descTextView resignFirstResponder];
    }
    if (self.themeTextField.isFirstResponder) {
        [self.themeTextField resignFirstResponder];
    }
}

#pragma mark - Actions
- (void)submitTrainingInfo {
    NSLog(@"=======================");
    WeaklySelf(weakSelf);
    
    [[SMGApiClient sharedClient] uploadTrainInfoWithTheme:_themeTextField.text address:_addressStr remark:_descTextView.text orgId:_orgIdStr classId:[_classIdArr componentsJoinedByString:@","] SimagesUrl:[_uploadSimgArr componentsJoinedByString:@","] ImagesUrl:[_uploadImgArr componentsJoinedByString:@","] VideoUrl:[_uploadVideoArr componentsJoinedByString:@","] andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            NSLog(@"提交。。。。。。%@",aResponse);
            ShowToastAtTop(@"训练信息已提交成功");
            [weakSelf.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        }
    }];
}

- (void)upLoadFiles{
    [self hideKeyboard];
    if (![_themeTextField.text isNotEmpty]) {
        ShowToastAtTop(@"请填写训练主题");
        return;
    }
    
    if (![self.addressStr isNotEmpty]) {
        [self showLocationView];
        return;
    }
    
    if (![_selectImgArr isNotEmpty]&&![_selectVideoArr isNotEmpty]) {
        ShowToastAtTop(@"请拍摄训练视频或上传照片再提交");
        [SVProgressHUD dismiss];
        return;
    }
    if (self.selectImgArr.count+self.selectVideoArr.count == self.uploadImgArr.count) {
        [self submitTrainingInfo];
        return;
    }
    [SVProgressHUD showWithStatus:@"上传文件"];

    self.isFinshed = NO;
    WeaklySelf(weakSelf);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.wk.sys.concurrentqueue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    [self.uploadImgArr removeAllObjects];
    [self.uploadVideoArr removeAllObjects];
    [self.uploadSimgArr removeAllObjects];
    
    for (UIImage *image in self.selectImgArr) {
        dispatch_group_async(group, concurrentQueue, ^{
            [[SMGApiClient sharedClient] postPath:@"UploadBigfile.ashx" withImage:UIImagePNGRepresentation(image) parameters:nil completion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
                if (aResponse) {
                    NSLog(@"%@",aResponse);
                    [weakSelf.uploadSimgArr addObject:aResponse[@"Surl"]];
                    [weakSelf.uploadImgArr addObject:aResponse[@"imageUrl"]];
                    [weakSelf.classIdArr addObject:aResponse[@"ClassId"]];
                    
                    if (weakSelf.selectImgArr.count+weakSelf.selectVideoArr.count == weakSelf.uploadImgArr.count) {
                        weakSelf.isFinshed = YES;
                    }
                }
                if (anError) {
                    MAIN(^{
                        [SVProgressHUD showErrorWithStatus:@"上传图片失败"];
                    });
                }
            }];
        });
    }
    
    for (NSString *videoUrl in self.selectVideoArr) {
        dispatch_group_async(group, concurrentQueue, ^{
            [[SMGApiClient sharedClient] postPath:@"UploadBigfile.ashx" withVideo:[NSData dataWithContentsOfFile:videoUrl] parameters:nil completion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
                if (aResponse) {
                    [weakSelf.uploadImgArr addObject:aResponse[@"imageUrl"]];
                    [weakSelf.uploadSimgArr addObject:aResponse[@"Surl"]];
                    [weakSelf.classIdArr addObject:aResponse[@"ClassId"]];
                    
                    if (weakSelf.selectImgArr.count+weakSelf.selectVideoArr.count == weakSelf.uploadImgArr.count) {
                        weakSelf.isFinshed = YES;
                    }
                }
                if (anError) {
                    MAIN(^{
                        [SVProgressHUD showErrorWithStatus:@"上传视频失败"];
                    });
                }
            }];
        });
    }

    [RACObserve(self, isFinshed) subscribeNext:^(id  _Nullable x) {
        BOOL finshed = [x boolValue];
        if (finshed) {
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                NSLog(@"end");
                [SVProgressHUD dismiss];
                [weakSelf submitTrainingInfo];
            });
        }
    }];
}

- (IBAction)upVideoClicked:(UIButton *)sender {
    
    if (self.selectVideoArr.count>0) {
        ShowToastAtTop(@"最多可上传一段视频，可点击删除已上传的视频");
        return;
    }
    WeaklySelf(weakSelf);
    ZLCustomCamera *vc = [[ZLCustomCamera alloc] init];
    vc.allowRecordVideo = YES;
    vc.maxRecordDuration = 10;
    vc.circleProgressColor = [UIColor greenColor];
    vc.sessionPreset = ZLCaptureSessionPreset325x288;
    vc.videoType = ZLExportVideoTypeMp4;
    vc.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        if (videoUrl) {
            [weakSelf.selectVideoArr addObject:videoUrl];
            [weakSelf.videoCollectionView reloadData];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)upImageClicked:(UIButton *)sender {
    
    WeaklySelf(weakSelf);
    ZLCustomCamera *vc = [[ZLCustomCamera alloc] init];
    vc.allowRecordVideo = NO;
    vc.sessionPreset = ZLCaptureSessionPreset1280x720;
    vc.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        if (image) {
            [weakSelf.selectImgArr addObject:[image normalizedImage]];
            [self reloadUI];
            [weakSelf.imgCollectionView reloadData];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _imgCollectionView) {
        return self.selectImgArr.count+1;
    }else{
        return self.selectVideoArr.count+1;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrainingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        if (collectionView == _videoCollectionView) {
            cell.imageView.image = ImageNamed(@"ca_video");
        }else{
            cell.imageView.image = ImageNamed(@"ca_photo");
        }
            
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.deleteBtn.hidden = YES;
    }else{
        cell.deleteBtn.hidden = NO;
        
        @weakify(self);
        if (collectionView == _videoCollectionView) {
            cell.imageView.image = ImageNamed(@"icon_video");
            cell.imageView.contentMode = UIViewContentModeCenter;
            cell.deleteBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                @strongify(self);
                [self.selectVideoArr removeAllObjects];
                [self.videoCollectionView reloadData];
                return [RACSignal empty];
            }];
        }else{
            cell.imageView.image = self.selectImgArr[indexPath.row-1];
            cell.imageView.contentMode = UIViewContentModeScaleToFill;
            cell.deleteBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                @strongify(self);
                [self.selectImgArr removeObjectAtIndex:indexPath.row-1];
                [self reloadUI];
                [self.imgCollectionView reloadData];
                return [RACSignal empty];
            }];
        }
    }
    ViewBorderRadius(cell.imageView, 3, .5, SEPARATOR_LINE_COLOR);

    return cell;
    
}
#pragma mark - UICollectionViewDelegate
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _videoCollectionView) {
        if (indexPath.row == 0) {
            [self upVideoClicked:nil];
            return;
        }
        WKPicturePreviewVC *vc = [WKPicturePreviewVC new];
        vc.imageList = self.selectVideoArr;
        vc.selectIndex = 0;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        if (indexPath.row == 0) {
            [self upImageClicked:nil];
            return;
        }
        WKPicturePreviewVC *vc = [WKPicturePreviewVC new];
        vc.imageList = self.selectImgArr;
        vc.selectIndex = indexPath.row;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark - lazy loading
- (NSMutableArray *)selectImgArr{
    if (!_selectImgArr) {
        _selectImgArr = [NSMutableArray array];
    }
    return _selectImgArr;
}
- (NSMutableArray *)selectVideoArr{
    if (!_selectVideoArr) {
        _selectVideoArr = [NSMutableArray array];
    }
    return _selectVideoArr;
}
- (NSMutableArray *)uploadImgArr{
    if (!_uploadImgArr) {
        _uploadImgArr = [NSMutableArray array];
    }
    return _uploadImgArr;
}
- (NSMutableArray *)uploadSimgArr{
    if (!_uploadSimgArr) {
        _uploadSimgArr = [NSMutableArray array];
    }
    return _uploadSimgArr;
}
- (NSMutableArray *)uploadVideoArr{
    if (!_uploadVideoArr) {
        _uploadVideoArr = [NSMutableArray array];
    }
    return _uploadVideoArr;
}
- (NSMutableArray *)classIdArr{
    if (!_classIdArr) {
        _classIdArr = [NSMutableArray array];
    }
    return _classIdArr;
}
- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _bgScrollView;
}

- (UICollectionView *)imgCollectionView{
    if (!_imgCollectionView) {
        CGFloat width = SCREEN_WIDTH - 20;
        width = width/3 - 10;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(width, width);
        _imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, self.videoCollectionView.bottom+60, SCREEN_WIDTH-20, width+5) collectionViewLayout:layout];
        [_imgCollectionView registerNib:[UINib nibWithNibName:@"TrainingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _imgCollectionView.delegate = self;
        _imgCollectionView.dataSource = self;
        _imgCollectionView.backgroundColor = WhiteColor;
        _imgCollectionView.scrollEnabled = NO;
    }
    return _imgCollectionView;
}
- (UICollectionView *)videoCollectionView{
    if (!_videoCollectionView) {
        CGFloat width = SCREEN_WIDTH - 20;
        width = width/3 - 10;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(width, width);
        _videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 40+50+20, SCREEN_WIDTH-20, width+5) collectionViewLayout:layout];
        _videoCollectionView.delegate = self;
        _videoCollectionView.dataSource = self;
        _videoCollectionView.backgroundColor = WhiteColor;
        [_videoCollectionView registerNib:[UINib nibWithNibName:@"TrainingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _videoCollectionView;
}
@end

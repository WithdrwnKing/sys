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

@interface UploadTrainingViewController ()<UITextViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    CGFloat moveHeight;
}
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UIButton *upImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *upVideoBtn;
@property (weak, nonatomic) IBOutlet UITextField *themeTextField;

@property (nonatomic, strong) NSMutableArray *selectImgArr;
@property (nonatomic, strong) NSMutableArray *selectVideoArr;

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

    ViewBorderRadius(_descTextView, 0, .5, BlackColor);
    ViewBorderRadius(_upImageBtn, 0, .5, SEPARATOR_LINE_COLOR);
    ViewBorderRadius(_upVideoBtn, 0, .5, SEPARATOR_LINE_COLOR);
    ViewBorderRadius(_themeTextField, 0, .5, BlackColor);
    
    [self.view addSubview:self.imgCollectionView];
    [self.view addSubview:self.videoCollectionView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(upLoadFiles)];
    self.navigationItem.rightBarButtonItem = rightItem;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (moveHeight>0) {
        self.view.centerY = self.view.centerY - moveHeight;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (moveHeight>0) {
        self.view.centerY = self.view.centerY + moveHeight;
    }
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
    
    [[SMGApiClient sharedClient] uploadTrainInfoWithTheme:_themeTextField.text address:@"dsad" remark:_descTextView.text orgId:_orgIdStr classId:[_classIdArr componentsJoinedByString:@","] SimagesUrl:[_uploadSimgArr componentsJoinedByString:@","] ImagesUrl:[_uploadImgArr componentsJoinedByString:@","] VideoUrl:[_uploadVideoArr componentsJoinedByString:@","] andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            NSLog(@"提交。。。。。。%@",aResponse);
            [ToastUtils show:@"提交成功"];
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        }
    }];
}

- (void)upLoadFiles{
    [self hideKeyboard];
    if (![_themeTextField.text isNotEmpty]) {
        [ToastUtils show:@"请填写训练主题"];
        return;
    }
    if (![_descTextView.text isNotEmpty]) {
        [ToastUtils show:@"请填写训练说明"];
        return;
    }
    if (![self.addressStr isNotEmpty]) {
        [self showLocationView];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"上传文件"];
    if (![_selectImgArr isNotEmpty]&&![_selectVideoArr isNotEmpty]) {
        [ToastUtils show:@"请添加训练视频或图片"];
        [SVProgressHUD dismiss];
        return;
    }
    if (self.selectImgArr.count+self.selectVideoArr.count == self.uploadImgArr.count && self.selectVideoArr.count+self.selectImgArr.count == self.uploadVideoArr.count) {
        [self submitTrainingInfo];
        return;
    }
    
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
                    [weakSelf.uploadVideoArr addObject:@"\"\""];
                    [weakSelf.classIdArr addObject:aResponse[@"ClassId"]];
                    
                    if (weakSelf.selectImgArr.count+weakSelf.selectVideoArr.count == weakSelf.uploadImgArr.count && weakSelf.selectVideoArr.count+weakSelf.selectImgArr.count == weakSelf.uploadVideoArr.count) {
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
                    [weakSelf.uploadVideoArr addObject:aResponse[@"videoUrl"]];
                    [weakSelf.uploadSimgArr addObject:aResponse[@"Surl"]];
                    [weakSelf.uploadImgArr addObject:@"\"\""];
                    [weakSelf.classIdArr addObject:aResponse[@"ClassId"]];
                    
                    if (weakSelf.selectImgArr.count+weakSelf.selectVideoArr.count == weakSelf.uploadImgArr.count && weakSelf.selectVideoArr.count+weakSelf.selectImgArr.count == weakSelf.uploadVideoArr.count) {
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
        [ToastUtils showAtTop:@"最多可上传一段视频，可点击删除已上传的视频"];
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
    vc.sessionPreset = ZLCaptureSessionPreset1920x1080;
    vc.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        if (image) {
            [weakSelf.selectImgArr addObject:[image normalizedImage]];
            [weakSelf.imgCollectionView reloadData];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _imgCollectionView) {
        return self.selectImgArr.count;
    }else{
        return self.selectVideoArr.count;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrainingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (collectionView == _imgCollectionView) {
        cell.imageView.image = self.selectImgArr[indexPath.row];
    }
    @weakify(self);
    cell.deleteBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (collectionView == self.imgCollectionView) {
            [self.selectImgArr removeObjectAtIndex:indexPath.row];
            [self.imgCollectionView reloadData];
        }else if (collectionView == self.videoCollectionView){
            [self.selectVideoArr removeObjectAtIndex:indexPath.row];
            [self.videoCollectionView reloadData];
        }
        return [RACSignal empty];
    }];
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
        WKPicturePreviewVC *vc = [WKPicturePreviewVC new];
        vc.imageList = self.selectVideoArr;
        vc.selectIndex = 0;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
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
- (UICollectionView *)imgCollectionView{
    if (!_imgCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(self.upImageBtn.width, self.upImageBtn.width);
        _imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.upImageBtn.right, self.upImageBtn.top, SCREEN_WIDTH-self.upImageBtn.right, self.upImageBtn.height) collectionViewLayout:layout];
        [_imgCollectionView registerNib:[UINib nibWithNibName:@"TrainingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _imgCollectionView.delegate = self;
        _imgCollectionView.dataSource = self;
        _imgCollectionView.backgroundColor = WhiteColor;
    }
    return _imgCollectionView;
}
- (UICollectionView *)videoCollectionView{
    if (!_videoCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(self.upVideoBtn.width, self.upVideoBtn.width);
        _videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.upVideoBtn.right, self.upVideoBtn.top, SCREEN_WIDTH-self.upVideoBtn.right, self.upVideoBtn.height) collectionViewLayout:layout];
        _videoCollectionView.delegate = self;
        _videoCollectionView.dataSource = self;
        _videoCollectionView.backgroundColor = WhiteColor;
        [_videoCollectionView registerNib:[UINib nibWithNibName:@"TrainingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

    }
    return _videoCollectionView;
}
@end

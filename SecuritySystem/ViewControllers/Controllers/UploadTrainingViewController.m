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

@interface UploadTrainingViewController ()<UITextViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
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
    _orgIdStr = @"1,2";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(upLoadFiles)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Actions
- (void)submitTrainingInfo {
    NSLog(@"=======================");
    WeaklySelf(weakSelf);
    if (![_themeTextField.text isNotEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"请填写训练主题"];
        return;
    }
    if (![_descTextView.text isNotEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"请填写训练说明"];
        return;
    }
    [[SMGApiClient sharedClient] uploadTrainInfoWithTheme:_themeTextField.text address:@"dsad" remark:_descTextView.text orgId:_orgIdStr classId:[_classIdArr componentsJoinedByString:@","] SimagesUrl:[_uploadSimgArr componentsJoinedByString:@","] ImagesUrl:[_uploadImgArr componentsJoinedByString:@","] VideoUrl:[_uploadVideoArr componentsJoinedByString:@","] andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            NSLog(@"提交。。。。。。%@",aResponse);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)upLoadFiles{
    
    if (![_selectImgArr isNotEmpty]&&![_selectVideoArr isNotEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"请添加训练视频或图片"];
        return;
    }
    if (self.selectImgArr.count == self.uploadImgArr.count && self.selectVideoArr.count == self.uploadVideoArr.count) {
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
                    [weakSelf.uploadImgArr addObject:aResponse[@"Url"]];
                    if (![weakSelf.classIdArr containsObject:aResponse[@"ClassId"]]) {
                        [weakSelf.classIdArr addObject:aResponse[@"ClassId"]];
                    }
                    if (weakSelf.uploadImgArr.count == weakSelf.selectImgArr.count&&weakSelf.uploadVideoArr.count==weakSelf.selectVideoArr.count) {
                        weakSelf.isFinshed = YES;
                    }
                }
            }];
        });
    }
    for (NSString *videoUrl in self.selectVideoArr) {
        dispatch_group_async(group, concurrentQueue, ^{
            [[SMGApiClient sharedClient] postPath:@"UploadBigfile.ashx" withVideo:[NSData dataWithContentsOfFile:videoUrl] parameters:nil completion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
                if (aResponse) {
                    if (weakSelf.uploadImgArr.count == weakSelf.selectImgArr.count&&weakSelf.uploadVideoArr.count==weakSelf.selectVideoArr.count) {
                        weakSelf.isFinshed = YES;
                    }
                }
            }];
        });
    }
    [RACObserve(self, isFinshed) subscribeNext:^(id  _Nullable x) {
        BOOL finshed = [x boolValue];
        if (finshed) {
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                NSLog(@"end");
                [weakSelf submitTrainingInfo];
            });
        }
    }];
}

- (IBAction)upVideoClicked:(UIButton *)sender {
    WeaklySelf(weakSelf);
    ZLCustomCamera *vc = [[ZLCustomCamera alloc] init];
    vc.allowRecordVideo = YES;
    vc.maxRecordDuration = 10;
    vc.circleProgressColor = [UIColor greenColor];
    vc.sessionPreset = ZLCaptureSessionPreset1920x1080;
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
            [weakSelf.selectImgArr addObject:image];
            [weakSelf.imgCollectionView reloadData];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.view.centerY  = self.view.centerY - 100;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.view.centerY  = self.view.centerY + 100;
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

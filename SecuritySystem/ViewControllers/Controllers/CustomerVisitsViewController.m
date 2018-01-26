//
//  CustomerVisitsViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/26.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "CustomerVisitsViewController.h"
#import "WKPicturePreviewVC.h"
#import <ZLCustomCamera.h>
#import "TrainingCollectionViewCell.h"

@interface CustomerVisitsViewController ()<YYTextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *imgCollectionView;
@property (nonatomic, strong) NSMutableArray *selectImgArr;
@property (nonatomic, strong) YYTextView *descTextView;
@property (nonatomic, strong) UIButton *submitBrn;

@property (nonatomic, assign) __block BOOL isFinshed;
@property (nonatomic, strong) NSMutableArray *uploadImgArr;

@end

@implementation CustomerVisitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回访客户情况";
    [self setUpUI];
    
}

- (void)setUpUI{
    
    [self.view addSubview:self.scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 20)];
    label.text = @"回访说明：";
    label.font = font(16);
    [self.scrollView addSubview:label];
    
    YYTextView *descTextView = [[YYTextView alloc] initWithFrame:CGRectMake(label.left, label.bottom+10, label.width, 65)];
    descTextView.delegate = self;
    descTextView.font = font(15);
    [self.scrollView addSubview:descTextView];
    self.descTextView = descTextView;
    ViewBorderRadius(descTextView, 5, .5, SEPARATOR_LINE_COLOR);
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(descTextView.left, descTextView.bottom+20, descTextView.width, 20)];
    label2.font = label.font;
    label2.text = @"上传图片：";
    [self.scrollView addSubview:label2];
    [self.scrollView addSubview:self.imgCollectionView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(0, self.imgCollectionView.bottom+30, 140, 36);
    submitBtn.backgroundColor = CommonRedColor;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    submitBtn.centerX = SCREEN_WIDTH/2;
    [submitBtn addTarget:self action:@selector(upLoadFiles) forControlEvents:UIControlEventTouchUpInside];
    if (submitBtn.bottom<self.view.height-30-kTopHeight) {
        submitBtn.bottom = self.view.height-30-kTopHeight;
    }
    ViewBorderRadius(submitBtn, 5, 0, BlackColor);
    [self.scrollView addSubview:submitBtn];
    self.submitBrn = submitBtn;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, submitBtn.bottom+kTopHeight+30);
}

- (void)upLoadFiles {
    [self leaveEditMode];
    if (![self.descTextView.text isNotEmpty]) {
        ShowToastAtTop(@"请填写回访说明");
        return;
    }
    if (![self.selectImgArr isNotEmpty]) {
        ShowToastAtTop(@"请上传回访签字图片");
        return;
    }
    if (self.selectImgArr.count==self.uploadImgArr.count) {
        [self submitVisitsInfo];
        return;
    }
    [SVProgressHUD showWithStatus:@"上传文件"];
    self.isFinshed = NO;
    WeaklySelf(weakSelf);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.wk.sys.concurrentqueue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    [self.uploadImgArr removeAllObjects];
    for (UIImage *image in self.selectImgArr) {
        dispatch_group_async(group, concurrentQueue, ^{
            [[SMGApiClient sharedClient] uploadClientImgWithImageData:UIImagePNGRepresentation(image) andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
            
                if (aResponse) {
                    NSString *imageUrl = aResponse[@"imageUrl"];
                    [weakSelf.uploadImgArr addObject:imageUrl];
                    if (weakSelf.selectImgArr.count==weakSelf.uploadImgArr.count) {
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
    [RACObserve(self, isFinshed) subscribeNext:^(id  _Nullable x) {
        BOOL finshed = [x boolValue];
        if (finshed) {
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                NSLog(@"end");
                [SVProgressHUD dismiss];
                [weakSelf submitVisitsInfo];
            });
        }
    }];
}
- (void)submitVisitsInfo {
    WeaklySelf(weakSelf);
    [[SMGApiClient sharedClient] subClientReviewTheme:self.descTextView.text imageUrl:[self.uploadImgArr componentsJoinedByString:@","] andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (!anError) {
            ShowToastAtTop(@"回访记录已提交成功");
            [weakSelf.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
        }else{
            ShowToastAtTop(@"回访记录提交失败");
        }
    }];
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
    self.submitBrn.bottom = self.imgCollectionView.bottom+30;
    if (self.submitBrn.bottom<self.view.height-30-kTopHeight) {
        self.submitBrn.bottom = self.view.height-30-kTopHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.submitBrn.bottom+kTopHeight+30);
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
#pragma mark - YYTextViewDelegate
- (void)textViewDidBeginEditing:(YYTextView *)textView{
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    self.navigationItem.rightBarButtonItem = done;
}
- (void)textViewDidEndEditing:(YYTextView *)textView{
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)leaveEditMode {
    [self.descTextView resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectImgArr.count+1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrainingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    @weakify(self);

    if (indexPath.row == 0) {
        cell.imageView.image = ImageNamed(@"ca_photo");
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.deleteBtn.hidden = YES;
        
    }else{
        cell.deleteBtn.hidden = NO;
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
    if (indexPath.row == 0) {
        [self upImageClicked:nil];
        return;
    }
    WKPicturePreviewVC *vc = [WKPicturePreviewVC new];
    vc.imageList = self.selectImgArr;
    vc.selectIndex = indexPath.row;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - lazyLoading
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _scrollView;
}
- (NSMutableArray *)selectImgArr{
    if (!_selectImgArr) {
        _selectImgArr = [NSMutableArray array];
    }
    return _selectImgArr;
}
- (NSMutableArray *)uploadImgArr{
    if (!_uploadImgArr) {
        _uploadImgArr = [NSMutableArray array];
    }
    return _uploadImgArr;
}
- (UICollectionView *)imgCollectionView{
    if (!_imgCollectionView) {
        CGFloat width = SCREEN_WIDTH - 20;
        width = width/3 - 10;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(width, width);
        _imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, self.descTextView.bottom+50, SCREEN_WIDTH-20, width+5) collectionViewLayout:layout];
        [_imgCollectionView registerNib:[UINib nibWithNibName:@"TrainingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        _imgCollectionView.delegate = self;
        _imgCollectionView.dataSource = self;
        _imgCollectionView.backgroundColor = WhiteColor;
        _imgCollectionView.scrollEnabled = NO;
    }
    return _imgCollectionView;
}
@end

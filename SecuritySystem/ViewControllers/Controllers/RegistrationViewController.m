//
//  RegistrationViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/11.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "RegistrationViewController.h"
#import "WKPicturePreviewVC.h"
#import <ZLCustomCamera.h>
#import "TrainingCollectionViewCell.h"
static NSString *cellIdentifier = @"RegistrationCell";
@interface RegistrationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectImageArr;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *telField;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) TrainingCollectionViewCell *firstCell;
@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"脸项登记";
    [self setUpUI];
    if ([_staffID isNotEmpty]) {
        [self loadUserInfo];
    }
    [self.view bringSubviewToFront:self.submitBtn];
}

- (void)loadUserInfo {
    WeaklySelf(weakSelf);
    [[SMGApiClient sharedClient] getStaffInfoWithStaffID:_staffID andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            NSString *name = aResponse[@"Name"];
            NSString *tel = aResponse[@"Tel"];
            NSString *number = aResponse[@"Number"];
            NSString *imageUrl = aResponse[@"ImageUrl"];
            if ([name isNotEmpty]) {
                weakSelf.nameField.text = name;
                weakSelf.nameField.enabled = NO;
            }
            if ([tel isNotEmpty]) {
                weakSelf.telField.text = tel;
                weakSelf.telField.enabled = NO;
            }
            if ([number isNotEmpty]) {
                weakSelf.numberField.text = number;
                weakSelf.numberField.enabled = NO;
            }
            if ([imageUrl isNotEmpty]) {
                weakSelf.collectionView.userInteractionEnabled = NO;
                weakSelf.firstCell.imageView.contentMode = UIViewContentModeScaleToFill;
                [weakSelf.firstCell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:ImageNamed(@"ca_head")];
            }
            if ([name isNotEmpty]&&[tel isNotEmpty]&&[number isNotEmpty]&&[imageUrl isNotEmpty]) {
                weakSelf.submitBtn.hidden = YES;
            }
        }
    }];
}

- (IBAction)submitRegistration:(UIButton *)sender {
    if (![self.nameField.text isNotEmpty]) {
        ShowToast(@"姓名不能为空");
        return;
    }
    if (![self.numberField.text isNotEmpty]) {
        ShowToast(@"身份证号不能为空");
        return;
    }
    if (![self.telField.text isNotEmpty]) {
        ShowToast(@"电话不能为空");
        return;
    }
    if (self.selectImageArr.count!=2) {
        [ToastUtils show:@"请拍摄2张照片"];
        return;
    }
    [SVProgressHUD show];
    WeaklySelf(weakSelf);
    [[SMGApiClient sharedClient] staffFaceCollectWithStaffID:_staffID Filedata:[self.selectImageArr firstObject] FiledataContrast:[self.selectImageArr lastObject] andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            NSString *ContrastImage = [aResponse objectForKey:@"ContrastImage"];
            NSString *StaffID = [aResponse objectForKey:@"StaffID"];
            [SVProgressHUD dismiss];
            DLog(@"%@",aResponse);
            [[SMGApiClient sharedClient] submitStaffInfo:StaffID orgID:CURRENTUSER.infoModel.orgId Name:self.nameField.text Tel:self.telField.text Number:self.numberField.text ContrastImage:ContrastImage userID:CURRENTUSER.userId andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
                if (aResponse) {
                    DLog(@"%@",aResponse);
                    ShowToast(@"登记成功");
                    [weakSelf.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:1.f];
                }
            }];
        }else{
            [SVProgressHUD dismiss];
            [ToastUtils show:@"脸部识别失败"];
        }
    }];
}

- (void)setUpUI{
    ViewBorderRadius(_submitBtn, 10, 0, WhiteColor);
    [self.view addSubview:self.scrollView];
    UILabel *label1 = [UILabel new];
    label1.frame = CGRectMake(20, 20, 77, 35);
    label1.font = font(15);
    label1.text = @"姓       名：";
    [self.scrollView addSubview:label1];
    
    UILabel *label2 = [UILabel new];
    label2.frame = CGRectMake(label1.left, label1.bottom+20, label1.width, label1.height);
    label2.font = font(15);
    label2.text = @"身份证号：";
    [self.scrollView addSubview:label2];
    
    UILabel *label3 = [UILabel new];
    label3.frame = CGRectMake(label1.left, label2.bottom+20, label1.width, label1.height);
    label3.font = font(15);
    label3.text = @"电       话：";
    [self.scrollView addSubview:label3];
    
    UITextField *field1 = [UITextField new];
    field1.frame = CGRectMake(label1.right + 5, label1.top, SCREEN_WIDTH-label1.right-25, label1.height);
    field1.font = font(15);
    field1.delegate = self;
    field1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:field1];
    ViewBorderRadius(field1, 5, 1, SEPARATOR_LINE_COLOR);
    
    UITextField *field2 = [UITextField new];
    field2.frame = CGRectMake(label2.right + 5, label2.top, SCREEN_WIDTH-label2.right-25, label2.height);
    field2.font = font(15);
    field2.delegate = self;
    field2.keyboardType = UIKeyboardTypePhonePad;
    field2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:field2];
    ViewBorderRadius(field2, 5, 1, SEPARATOR_LINE_COLOR);
    
    UITextField *field3 = [UITextField new];
    field3.frame = CGRectMake(label3.right + 5, label3.top, SCREEN_WIDTH-label3.right-25, label3.height);
    field3.font = font(15);
    field3.keyboardType = UIKeyboardTypeNumberPad;
    field3.clearButtonMode = UITextFieldViewModeWhileEditing;
    field3.delegate = self;
    [self.scrollView addSubview:field3];
    ViewBorderRadius(field3, 5, 1, SEPARATOR_LINE_COLOR);
    
    UILabel *label4 = [UILabel new];
    label4.text = @"上传照片";
    label4.frame = CGRectMake(label1.left, label3.bottom+20, label1.width, label1.height);
    [self.scrollView addSubview:label4];
    
    [self.scrollView addSubview:self.collectionView];
    self.collectionView.top = label4.bottom;
    
    self.nameField = field1;
    self.telField = field3;
    self.numberField = field2;
}

- (void)reloadUI{
    CGFloat width = SCREEN_WIDTH - 20;
    width = width/3 - 10;
    CGFloat collectHeight = width + 5;
    NSInteger count = self.selectImageArr.count - 2;
    if (count > 0) {
        NSInteger row = count/3 + 2;
        if (count%3 == 0) {
            row--;
        }
        self.collectionView.height = collectHeight * row ;
    }else{
        self.collectionView.height = collectHeight;
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.collectionView.bottom);
    
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    self.navigationItem.rightBarButtonItem = done;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)leaveEditMode {
    [self.view endEditing:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectImageArr.count+1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrainingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageView.image = ImageNamed(@"ca_photo");
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.deleteBtn.hidden = YES;
        ViewBorderRadius(cell.imageView, 0, .5, SEPARATOR_LINE_COLOR);
        self.firstCell = cell;
    }else{
        cell.deleteBtn.hidden = NO;
        cell.imageView.image = self.selectImageArr[indexPath.row-1];
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        @weakify(self);
        cell.deleteBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            [self.selectImageArr removeObjectAtIndex:indexPath.row-1];
            [self reloadUI];
            [self.collectionView reloadData];
            return [RACSignal empty];
        }];
    }
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
        [self upImageClicked];
    }else{
        WKPicturePreviewVC *vc = [WKPicturePreviewVC new];
        vc.imageList = self.selectImageArr.copy;
        vc.selectIndex = indexPath.row-1;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)upImageClicked{
    if (self.selectImageArr.count >= 2) {
        [ToastUtils show:@"照片个数不得超过2张"];
        return;
    }
    WeaklySelf(weakSelf);
    ZLCustomCamera *vc = [[ZLCustomCamera alloc] init];
    vc.allowRecordVideo = NO;
    vc.sessionPreset = ZLCaptureSessionPreset640x480;
    vc.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        if (image) {
            [weakSelf.selectImageArr addObject:[image normalizedImage]];
            [weakSelf reloadUI];
            [weakSelf.collectionView reloadData];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - lazy loading
- (NSMutableArray *)selectImageArr{
    if (!_selectImageArr) {
        _selectImageArr = [NSMutableArray array];
    }
    return _selectImageArr;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _scrollView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = SCREEN_WIDTH - 20;
        width = width/3 - 10;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(width, width);
        CGFloat top = 88.f + 5.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, top, SCREEN_WIDTH-20, width+5) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"TrainingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _collectionView;
}
@end

//
//  AttendanceViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2017/12/19.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "AttendanceViewController.h"
#import "TrainingCollectionViewCell.h"
#import "ChosePersonModel.h"
#import <ZLCustomCamera.h>
#import "WKPicturePreviewVC.h"

static NSString *cellIdentifier = @"AttendanceCell";
@interface AttendanceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YYTextViewDelegate,UITextFieldDelegate>{
    CGFloat moveHeight;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UIView *remakView;
@property (nonatomic, strong) UIButton *selectPhotoBtn;
@property (nonatomic, strong) UIButton *selectTypeBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectImageArr;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, copy) NSArray *attendanceArray;
@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传员工考勤信息";
    [self loadCategoryID];
    [self setUpUI];
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

- (void)loadCategoryID{
    [[SMGApiClient sharedClient] dictWithCategoryID:@"11" andCompletion:^(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError *anError) {
        if (aResponse) {
            self.attendanceArray = aResponse;
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
    [selectTypeBtn setImage:ImageNamed(@"") forState:UIControlStateNormal];
    [selectTypeBtn setTitle:@"选择上岗类型" forState:UIControlStateNormal];
    selectTypeBtn.titleLabel.font = font(15);
    selectTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [selectTypeBtn setTitleColor:BlackColor forState:UIControlStateNormal];
    [selectTypeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [selectTypeBtn addTarget:self action:@selector(showActionVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:selectTypeBtn];
    ViewBorderRadius(selectTypeBtn, 0, 1, SEPARATOR_LINE_COLOR);
    
    UILabel *photoLbl = [UILabel new];
    photoLbl.text = @"拍照上传：";
    photoLbl.font = typeLbl.font;
    photoLbl.frame = CGRectMake(typeLbl.left, typeLbl.bottom+28, typeLbl.width, typeLbl.height);
    [self.scrollView addSubview:photoLbl];
    [self.scrollView addSubview:self.collectionView];
    
    _nameView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, SCREEN_WIDTH, 10)];
    [self.scrollView addSubview:_nameView];
    
    CGFloat width = (SCREEN_WIDTH-20)/3;
    for (int i = 0; i < self.selectArray.count; i++) {
        ChosePersonModel *model = self.selectArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+width*(i%3), 20+40*(i/3), width, 20);
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ca_right"] forState:UIControlStateNormal];
         [btn setImage:[UIImage imageNamed:@"ca_error"] forState:UIControlStateSelected];
        [btn setTitle:model.nickName forState:UIControlStateNormal];
        btn.titleLabel.backgroundColor = btn.imageView.backgroundColor;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - btn.imageView.image.size.width, 0, btn.imageView.image.size.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+20, 0, -btn.titleLabel.bounds.size.width)];
        btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            btn.selected = !btn.selected;
            return [RACSignal empty];
        }];
        [self.nameView addSubview:btn];
        
        if (i == self.selectArray.count-1) {
            self.nameView.height = btn.bottom;
        }
    }
    
    _remakView = [[UIView alloc] initWithFrame:CGRectMake(0, self.nameView.bottom, SCREEN_WIDTH, 135+28)];
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
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = HEX_RGB(0xc40000);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = font(13);
    submitBtn.frame = CGRectMake(0, textView.bottom+10, 135, 30);
    submitBtn.centerX = textView.centerX;
    [submitBtn addTarget:self action:@selector(sumitData) forControlEvents:UIControlEventTouchUpInside];
    [_remakView addSubview:submitBtn];
    ViewBorderRadius(submitBtn, 5, 0, WhiteColor);
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.remakView.bottom);
}

- (void)showActionVC:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择上岗类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    for (NSDictionary *dict in self.attendanceArray) {
        NSString *name = [dict objectForKey:@"Name"];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sender setTitle:name forState:UIControlStateNormal];
        }];
        [alert addAction:action];
    }
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sumitData {
    
    if (![self.textView.text isNotEmpty]) {
        [ToastUtils show:@"请填写备注"];
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
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
    self.nameView.top = self.collectionView.bottom;
    self.remakView.top = self.nameView.bottom;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.remakView.bottom);

}

- (void)upImageClicked{
    if (self.selectImageArr.count >= self.selectArray.count) {
        [ToastUtils show:@"照片个数不得大于考勤人数"];
        return;
    }
    WeaklySelf(weakSelf);
    ZLCustomCamera *vc = [[ZLCustomCamera alloc] init];
    vc.allowRecordVideo = NO;
    vc.sessionPreset = ZLCaptureSessionPreset1920x1080;
    vc.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        if (image) {
            [weakSelf.selectImageArr addObject:image];
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
    return self.selectImageArr.count+1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TrainingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageView.image = ImageNamed(@"ca_photo");
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.deleteBtn.hidden = YES;
        ViewBorderRadius(cell.imageView, 0, .5, SEPARATOR_LINE_COLOR);
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
- (NSMutableArray *)selectImageArr{
    if (!_selectImageArr) {
        _selectImageArr = [NSMutableArray array];
    }
    return _selectImageArr;
}
@end

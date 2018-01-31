//
//  WKWebViewController.m
//  SecuritySystem
//
//  Created by 王琨 on 2018/1/31.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#define WebView_timeout 10


#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <WKWebViewJavascriptBridge.h>
#import "OffLineErrorView.h"

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
{
    WKWebView *myWebView;
    WKUserContentController* userContentController;
    UIView *loadingView;
    
    NSURLRequest *beforeRequest;
    UIAlertController *networkAlert;
}
@property (nonatomic, copy) NSString *webUrlStr;
@property (nonatomic, strong) WKWebViewJavascriptBridge *webViewBridge;
@property (nonatomic, strong) OffLineErrorView *errorView;
@property (nonatomic, assign) BOOL isInLine;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIActivityIndicatorView *testActivityIndicator;
@end

@implementation WKWebViewController

- (instancetype)initWithUrl:(NSString *)webUrlStr{
    if (self = [super init]) {
        _webUrlStr = webUrlStr;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(execute:) name:@"REFRESHWEBVIEW" object:nil];
    
    if ([myWebView.URL isNotEmpty]&&!_isFirst) {
        
        [myWebView loadRequest:beforeRequest];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HEX_RGB(0xc40004);
    [self setupWKWebView];
    beforeRequest = [[NSURLRequest alloc] init];
    [self setUpLoadingView];
    
    [self.view addSubview:self.errorView];
    [self.view addSubview:self.testActivityIndicator];
    _isInLine = YES;
    _isFirst = YES;
}
#pragma mark - UI
- (void)setUpLoadingView{
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tabBarController.tabBar.top)];
    loadingView.backgroundColor = WhiteColor;
    [self.view addSubview:loadingView];
    
    UIImageView *imv = [[UIImageView alloc] initWithImage:ImageNamed(@"")];
    imv.center = loadingView.center;
    [loadingView addSubview:imv];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, imv.bottom + 10, SCREEN_WIDTH, 20)];
    text.text = @"正在加载...";
    text.font = font(15);
    text.textAlignment = NSTextAlignmentCenter;
    text.textColor = CommonGrayColor;
    [loadingView addSubview:text];
}
- (void)setupWKWebView{
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    webConfig.preferences = [[WKPreferences alloc] init];
    webConfig.preferences.minimumFontSize = 10;
    webConfig.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // web内容处理池
    webConfig.processPool = [[WKProcessPool alloc] init];
    // 将所有cookie以document.cookie = 'key=value';形式进行拼接
    NSString *cookieValue = @"document.cookie = 'fromapp=ios';document.cookie = 'channel=appstore';";
    
    // 加cookie给h5识别，表明在ios端打开该地址
    userContentController = WKUserContentController.new;
    [userContentController addScriptMessageHandler:self name:@"returnApp"];

    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    webConfig.userContentController = userContentController;
    
    myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, self.view.height-20) configuration:webConfig];
    myWebView.UIDelegate = self;
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.scrollView.bounces = NO;
    myWebView.scrollView.showsVerticalScrollIndicator = NO;
    myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlStr]]];
    [self.view addSubview:myWebView];
    
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:myWebView];
    // 如果控制器里需要监听WKWebView 的`navigationDelegate`方法，就需要添加下面这行。
    [_webViewBridge setWebViewDelegate:self];
}
#pragma  mark - 通知
- (void)execute:(NSNotification *)notification{
    if (notification.object&&[notification.object isKindOfClass:[OffLineErrorView class]]) {
        if ([myWebView.URL isNotEmpty]) {
            [myWebView reload];
        }else{
            [myWebView loadRequest:beforeRequest];
        }
        loadingView.hidden = NO;
        
        [self performSelector:@selector(cancelWeb) withObject:nil afterDelay:WebView_timeout];
    }
}
#pragma  mark  -  WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"%s",__FUNCTION__);
    [self performSelector:@selector(cancelWeb) withObject:nil afterDelay:WebView_timeout];
    if (!_isFirst) {
        loadingView.hidden = YES;
        [self.testActivityIndicator startAnimating];
        
    }else
        loadingView.hidden = NO;
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__FUNCTION__);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelWeb) object:nil];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"%s",__FUNCTION__);
    self.errorView.hidden = NO;
    [self.testActivityIndicator stopAnimating];
    
    
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"%s",__FUNCTION__);
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    NSLog(@"%s",__FUNCTION__);
    
    self.errorView.hidden = YES;
    loadingView.hidden = YES;
    _isFirst = NO;
    
    [self.testActivityIndicator stopAnimating];
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    self.errorView.hidden = YES;
    
    _isInLine = [[NSUserDefaults standardUserDefaults] boolForKey:@"_isInLine"];
    
    NSString *requestString = [navigationAction.request.URL absoluteString];
    NSLog(@"requestString%@",requestString);
    if (_isInLine == NO) {
        _isInLine = YES;
        beforeRequest = navigationAction.request;
        self.errorView.hidden = NO;
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)hideAlert{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.errorView.hidden = NO;
    
}

- (void)setErrorViewNoHidden{
    loadingView.hidden = NO;
    
    self.errorView.hidden = NO;
}

//网页加载超时
- (void)cancelWeb
{
    
    loadingView.hidden = YES;
    
    if (!self.errorView.hidden) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您当前的网络不给力" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *reload = [UIAlertAction actionWithTitle:@"重新加载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [myWebView loadRequest:beforeRequest];
        [self performSelector:@selector(cancelWeb) withObject:nil afterDelay:WebView_timeout];
        loadingView.hidden = NO;
        
        
    }];
    UIAlertAction *wait = [UIAlertAction actionWithTitle:@"继续等待" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        loadingView.hidden = NO;
        
        [self performSelector:@selector(setErrorViewNoHidden) withObject:nil afterDelay:WebView_timeout/2];
        
    }];
    [alert addAction:reload];
    [alert addAction:wait];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
        
    });
    
    
    networkAlert = alert;
    //10s
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAlert) object:nil];
    [self performSelector:@selector(hideAlert) withObject:nil afterDelay:WebView_timeout/2];
    
    NSLog(@"加载超时");
    
}
#pragma mark -WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    if ([message.name isEqualToString:@"returnApp"]) {
        [self back];
    }
}
#pragma mark -WKUIDelegate

//监听网页警告框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    NSLog(@"监听js警告框");
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [customAlert show];
    
    completionHandler();
    
}
#pragma mark - 懒加载
- (OffLineErrorView *)errorView{
    if (_errorView == nil) {
        _errorView = [[OffLineErrorView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _errorView.hidden = YES;
    }
    return _errorView;
}

- (UIActivityIndicatorView *)testActivityIndicator{
    if (_testActivityIndicator == nil) {
        _testActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _testActivityIndicator.color = [UIColor lightGrayColor];
        _testActivityIndicator.center = self.view.center;
    }
    return _testActivityIndicator;
}
@end

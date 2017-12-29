//
//  MacroDefinitions.h
//  MyTreasure
//
//  Created by Bryan on 15/11/11.
//  Copyright © 2015年 makervt. All rights reserved.
//

#ifndef MacroDefinitions_h
#define MacroDefinitions_h

#pragma mark -通知

//-------------------获取设备大小-------------------------
/*
 *状态条高度
 */
#define STATUSBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

/**
 *  tabbar 高度
 */
#define TABBAR_HEIGHT (49)

//按宽度适配 (6)
#define FitScreenWidth(W) ((SCREEN_WIDTH/375.f) * W)

//按高度适配 (6)
#define FitScreenHeight(H) ((SCREEN_HEIGHT/667.f) * H)

#define APP_SCREEN_HEIGHT_NO_TABBAR (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)
#define APP_SCREEN_HEIGHT_WITH_TABBAR (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TABBAR_HEIGHT)
//设置随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//获取keyWindow
#define kKeywindow [UIApplication sharedApplication].keyWindow

//-------------------获取设备大小-------------------------


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//---------------------打印日志--------------------------


//----------------------系统----------------------------

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isLANDSCAPE         ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)
//是否ipad
#define isIPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//是否iPhone
#define isIPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

//是否iphone4
#define isIPHONE4           (isIPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)

//是否iphone5
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//是否iphone6
#define isIPHONE6           (isIPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
//是否iphone6+
#define isIPHONE6PLUS       (isIPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations

// 是否iphone5以上屏幕
#define isBigScreen         (isIPHONE && [[UIScreen mainScreen] bounds].size.height > 568.0)

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

#define IOS_7_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? (YES):(NO))
#define IOS_8_OR_LATER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//----------------------系统----------------------------
//—————————————— 应用信息 ————————————————————————
#pragma mark - 应用信息

#define APPDISPLAYNAME [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleDisplayName"] //APP displayname
#define APPVERSION [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"] //APP 版本信息
#define APPVERSIONBUILD [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"] //APP 版本Build信息

//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil



//----------------------内存----------------------------


//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------



//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define HEX_RGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define HEX_RGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(1)]

#undef	RGB
#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef	RGBA
#define RGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

//带有RGBA的颜色设置
#define RGBZ(r) RGBA(r,r,r,1.0f)

#define RGBAZ(r,a) RGBA(r,r,r,a)

//背景色
#define BACKGROUND_COLOR HEX_RGB(0xf0f0f0)

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#define BARGREYCOLOR RGB(45, 57, 78)

/**
 *  默认灰色
 */
#define CommonGrayColor HEX_RGB(0xa0d2f5)

/**
 *  默认黑色
 */
#define CommonBlackColor HEX_RGB(0x323c46)

/**
 *  默认背景色
 */
#define CommonSeparatorColor HEX_RGB(0xf0f0f0)

/**
 *  默认蓝色
 */
#define CommonBlueColor HEX_RGB(0x00a8ff)

/**
 * 白色
 */
#define WhiteColor [UIColor whiteColor]
/**
 * 黑色
 */
#define BlackColor [UIColor blackColor]

/**
 * 分割线颜色
 */
#define SEPARATOR_LINE_COLOR RGB(0xdf, 0xdf, 0xdf)

/**
 * 浅黑色
 */
#define FONT_COLOR_33   RGB(0x33,0x33,0x33)

#define FONT_COLOR_33_A   RGBA(0x33,0x33,0x33,0.8)

/**
 * 深灰色
 */
#define FONT_COLOR_66   RGB(0x66,0x66,0x66)
#define FONT_COLOR_66_A   RGBA(0x66,0x66,0x66,0.8)

/**
 * 中灰色
 */
#define FONT_COLOR_99   RGB(0x99,0x99,0x99)
#define FONT_COLOR_99_A   RGBA(0x99,0x99,0x99,0.8)
//----------------------颜色类--------------------------



//----------------------其他----------------------------

//weakSelf
#define WeaklySelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

//默认cacahe时间为一天
#define DEFAULT_CACHE_INTERVAL (86400)

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//设置 view 圆角和边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//RAC


/**
 * 定义Rect
 */
#define rect(x,y,w,h) CGRectMake(x,y,w,h)
/**
 * 定义point
 */
#define point(x,y) CGPointMake(x,y)
/**
 * 定义size
 */
#define size(w,h) CGSizeMake(w,h)
/**
 *  获取最大X,Y
 */
#define maxX(rect) CGRectGetMaxX(rect)
#define maxY(rect) CGRectGetMaxY(rect)
/**
 *  获取最小X,Y
 */
#define minX(rect) CGRectGetMinX(rect)
#define minY(rect) CGRectGetMinY(rect)
/**
 *  获取矩形宽,高
 */
#define rectW(rect) CGRectGetWidth(rect)
#define rectH(rect) CGRectGetHeight(rect)
//定义字体大小
#define font(s) [UIFont systemFontOfSize:s]

// 分页
#define pSize 10

//---------------------------单例-------------------------//
// .h文件的实现
#define SingletonH(methodName) + (instancetype)shared##methodName;

// .m文件的实现
#define SingletonM(methodName) \
static id _instace = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
if (_instace == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
} \
return _instace; \
} \
\
- (id)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super init]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##methodName \
{ \
return [[self alloc] init]; \
} \
+ (id)copyWithZone:(struct _NSZone *)zone \
{ \
return _instace; \
} \
\
+ (id)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
return _instace; \
}

//________  __________//
//#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);

#endif /* MacroDefinitions_h */

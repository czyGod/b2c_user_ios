//
//  AppMacro.h
//  LetWeCode
//
//  Created by 崔露凯 on 15/10/28.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#import "JenkinsConfig.h"


#pragma mark - ToolsMacros

// 如果数据为NULL，设为nil
#define PASS_NULL_TO_NIL(instance) (([instance isKindOfClass:[NSNull class]]) ? nil : instance)

// 处理nil，为空字符串@""
#define STRING_NIL_NULL(x) if(x == nil || [x isKindOfClass:[NSNull class]]){x = @"";}

//
#define ARRAY_NIL_NULL(x) \
if(x == nil || [x isKindOfClass:[NSNull class] ]) \
{x = @[];}


#define B2CWeakSelf  __weak typeof(self) weakSelf = self;

// 统一处理打印日志
#ifdef DEBUG
#define DLog(format, ...)  NSLog(format, __VA_ARGS__)
#else
#define DLog(...)
#endif

#define ArtDEPRECATED(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#pragma mark - UIMacros
// 界面背景颜色
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//151, 215, 76 RGB(195, 207, 72)
#define kAppCustomMainColor     [UIColor appCustomMainColor]
#define kBackgroundColor        RGB(241, 244, 247)
#define kNavBarBackgroundColor  RGB(241, 241, 241)
#define kButtonBackgroundColor  [UIColor appButtonBackgroundColor]
#define kRedColoerBackgroundColor RGB(255, 83, 27)
#define bgViewColor [UIColor colorWithHexString:@"#f1f4f7"]
//浅灰色
//#define kDarkGreyColor [UIColor colorWithHexString:@"#E9EAEB"]

#define kDarkGreyColor [UIColor colorWithHexString:@"#AEAFB0"]

//暗灰色
#define kTDarkGreyColor [UIColor colorWithHexString:@"#AEAFB0"]


//亮灰色 #999999
#define kLightGreyColor RGB(153, 153, 153)
//橘红色 #ff531b
#define kOrangeRedColor RGB(255, 83, 27)
//淡灰色 #f1f4f7
#define kPaleGreyColor RGB(241, 244, 247)
//深绿色 #417505
#define kDeepGreenColor RGB(65, 117, 5)
//浅绿色 #c8dc51
#define kLightGreenColor RGB(200, 220, 81)
//暗绿色 #335322  RGBa(51, 83, 34)
#define kDarkGreenColor kButtonBackgroundColor
//砖红色 #fo2900
#define kBrickRedColor RGB(240, 41, 0)
//白色   #ffffff
#define kWhiteColor RGB(255, 255, 255)
//黑色   #000000
#define kBlackColor RGB(0, 0, 0)
//淡蓝色 #5aa3e8
#define kPaleBlueColor RGB(90, 163, 232)
//银灰色 #ececec
#define kSilverGreyColor RGB(236, 236, 236)
//浅灰色 #cecece
#define kShallowGreyColor RGB(206, 206, 206)]

#pragma mark - 界面尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWidth(x) (x)*(kScreenWidth)/375.0
#define kHeight(y) (y)*(kScreenHeight)/667.0

#define KViewWidth self.frame.size.width
#define KViewHeight self.frame.size.height

#define Font(F)        [UIFont systemFontOfSize:(F)]
#define boldFont(F)    [UIFont boldSystemFontOfSize:(F)]

#pragma mark - 开发中

//YES  开发中， NO 开发完成
#define kInDevelopment NO




#pragma mark - HttpMacros

//#define SEAVER_APP_ID @"J4*A9N7&B^A9Y7j6sWv8m6%q_p+z-h="

#define SEAVER_APP_ID @"1"

#define  kHttpSignKey  @"&H2S@b&S(1D%a2l(K8^j9@s7&k&a2*_="


// 正式环境
#define kHttpServiceDomainProduct  @"http://b2c.beyondin.com/?m=api&a=api"

#define kHttpImageServiceProduct   @"http://b2c.beyondin.com/api/uploadImage/appid/1/submit/submit"

#define kHttpImageServiceSubmitProduct @"http://b2c.beyondin.com"

#define kWebServiceDomainProduct @"http://b2c.beyondin.com"



// 测试环境
// zrmall-api.beyondin.com
#define kDomainSandbox JenkinsConfigValue(JenkinsDomainKey, @"http://zrmall-api.beyondin.com")
// @"http://zrmall-api.beyondin.com"


#define kHttpServiceDomainSandbox       [NSString stringWithFormat:@"%@/?m=api&a=api", kDomainSandbox]

#define kHttpImageServiceSandbox        kDomainSandbox

#define kHttpImageServiceSubmitSandbox  [NSString stringWithFormat:@"%@/api/uploadImage/appid/1/submit/submit", kDomainSandbox]

#define kWebServiceDomainSandbox        kDomainSandbox



// web路径












#endif /* AppMacro_h */

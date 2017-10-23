//
//  MZErrorCode.h
//  meizhuang
//
//  Created by shinn on 16/9/21.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const MZLocalErrorDomain;
FOUNDATION_EXTERN NSString *const MZLocalSystemErrorMessage;
FOUNDATION_EXTERN NSString *const MZLocalNetworkErrorMessage;
FOUNDATION_EXPORT NSString *const MZRequestErrorDomain;

typedef NS_ENUM(NSInteger, MZErrorCode) {
    MZErrorCodeNone                         = 200,
    MZErrorForbiddenInvalidMethod           = 301,
    MZErrorForbiddenClientVersion           = 314,
    MZErrorForbiddenMandatoryUpgrade        = 315,
    
    MZErrorForbiddenAccessDenied            = 322,
    MZErrorForbiddenUnknow                  = 330,
    MZErrorForbiddenNotLogin                = 351,
    MZErrorForbideenInvalidToken            = 352,
    
    // 资源访问出错
    MZErrorResourceInvalidParam             = 400,
    MZErrorResourceInexistent               = 401, // 资源不存在
    MZErrorResourceError                    = 402,
    MZErrorResourceException                = 403,
    MZErrorResourceUnknown                  = 499,
    
    // 鉴权
    MZErrorAuthForceQuit                    = 500,
    MZErrorAuthAccountForbidden             = 501,
    MZErrorAuthIPForbidden                  = 502,
    
    MZErrorYiDunForbidden                   = 560,  // 易盾反垃圾禁止用户注册、登录
    MZErrorYiDunNeedCaptcha                 = 561,  // 易盾反垃圾需要验证码
    
    // login(登录部分)
    MZErrorLoginUnknown                     = 600,
    MZErrorLoginAccountInexistent           = 601,
    MZErrorLoginInvalidPassword             = 602,
    MZErrorLoginAccountForbbiden            = 603,
    MZErrorLoginExceedFailLimit             = 604,
    MZErrorLoginInvalidInitId               = 605,
    MZErrorLoginFail                        = 606, //登录失败
    MZErrorLoginInvalidMobile               = 607, //手机号码格式错误
    MZErrorLoginOpenAccountAuthFail         = 611,
    MZErrorLoginOpenAccountNotReg           = 612, // 三方用户合法，但是未注册成本系统用户
    MZErrorLoginAccountDuplicate            = 630,
    MZErrorLoginNicknameInvalidFormat       = 631, // 昵称格式错误
    MZErrorLoginNicknameDuplicate           = 632,// 昵称重复
    MZErrorLoginPwdInvalidFormat            = 633, // 密码格式错误
    MZErrorLoginCAPTCHAError                = 634,   //验证码错误
    MZErrorLoginRegisterFail                = 635,   //注册失败,请重试
    
    MZErrorBindingAccountHasUsed            = 670,          // 已被绑定到其他账号
    MZErrorBindingPlatformHasBindAccount    = 671, // 该平台已经绑定账号
    MZErrorBindingAlreadyBindMobile         = 672, // 手机号码已被绑定
    
    // 合辑部分
    MZErrorRepoRecordAlreadyExist           = 701,//心得已存在
    MZErrorRepoMaxCount                     = 702,//最多创建1000个合辑
    MZErrorRepoLoadFail                     = 703,//加载失败
    MZErrorRepoDeleteFail                   = 704,//删除失败
    MZErrorRepoCreateFail                   = 705,//创建失败
    MZErrorRepoAddFail                      = 706,//添加失败
    MZErrorRepoDeleteResourceFail                      = 707,//删除合辑内容失败
    
    //产品
    MZErrorProductSaveFail                  = 801,//保存自定义产品失败
    MZErrorBrandNameFail                    = 802,//品牌名错误
    
    //心得
    MZErrorRecordSaveFail                   = 901,//心得保存失败
    MZErrorRecordDeleteFail                 = 902,//心得删除失败
    
    
    //用户
    MZErrorUserSaveInfoFail                 = 1001,
    MZErrorUserSaveFail                     = 1002,
    MZErrorUserChangePasswordFail           = 1003,
    MZErrorUserChangeSettingFail            = 1004,
    MZErrorUserCommentFail                  = 1005,
    MZErrorUserFavFail                      = 1006,
    MZErrorUserUnFavFail                    = 1007,
    MZErrorUserUploadFail                   = 1008,
    MZErrorUserShareFail                    = 1009,
    MZErrorUserPraiseFail                   = 1010,
    MZErrorUserUnPraiseFail                 = 1011,
    MZErrorShareLongImageWaiting            = 1012,
    
    /**
     LocalErrorCode
     */
    MZErrorLocalCommonError                 = -1,       //通用错误
    MZErrorLocalRequestParamInvalid         = -9001,    //请求参数错误
    MZErrorLocalNotLogin                    = -9011,    //本地未登录
    MZErrorLocalResponseEmpty               = -9012,    //服务器返回结果为空
    MZErrorLocalResponseJsonInvalid         = -9013,    //服务器返回 json 格式不对
    MZErrorLocalEmptyCacheKey               = -9014,    //无缓存key
    MZErrorLocalNoCache                     = -9015,    //无缓存
    MZErrorLocalNeedHttps                   = -9016,    //接口需要 https 鉴权
};


// NSPOSIXErrorDomain
enum {
    NSURLErrorConnectionResetByPeer         = 54
};

@interface NSError (MZErrorDomain)
//本地错误，统一显示系统错误
+ (NSError *)mz_commonLocalSystemErrorWithCode:(MZErrorCode)code;
+ (NSError *)mz_commonLocalNetworkErrorWithCode:(MZErrorCode)code;
+ (NSError *)mz_localErrorWithCode:(NSInteger)code message:(NSString *)msg;
//本地错误，统一错误码为MZErrorLocalCommonError
+ (NSError *)mz_commonLocalErrorWithMessage:(NSString *)msg;
+ (NSError *)mz_requestErrorWithCode:(NSInteger)code message:(NSString *)msg;
//是否在白名单中,在白名单中的不拼接错误码
- (BOOL)isInWhiteList;
//是否在过滤名单中，过滤名单中的错误不在页面上显示
- (BOOL)isInFilterList;
FOUNDATION_EXTERN NSString *MZLocalMessageForError(NSError *error);

@end



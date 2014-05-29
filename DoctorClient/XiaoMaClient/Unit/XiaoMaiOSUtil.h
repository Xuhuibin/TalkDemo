//Create By Jim

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <UIKit/UIKit.h>

//Functions for Encoding Data.
//扩展方法
@interface NSData (TOPEncode)
- (NSString *)MD5EncodedString;
- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
- (NSString *)base64EncodedString;
@end

//Functions for Encoding String.
//扩展方法
@interface NSString (TOPEncode)
- (NSString *)MD5EncodedString;
- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
- (NSString *)base64EncodedString;
@end

/**
 *  http请求方法
 */
typedef enum
{
    GET,
    POST
} HTTPMethod;

@interface XiaoMaiOSUtil : NSObject

//序列化URL，非GET方式将直接返回baseURL
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

//字典变量转换成url参数字符串，如：key=value&key2=value2
+ (NSString *)stringFromDictionary:(NSDictionary *)dict;

//通过appSecret加密成sign
+(void) sign:(NSMutableDictionary *)params appSecret:(NSString *)appSecret;

//多文件提交
+(void)setMultipartPostBody:(NSMutableURLRequest *)req reqParams:(NSMutableDictionary *)reqParams attachs:(NSMutableDictionary *)attachs;

//提示对话框
+(void)showMessageBox:(NSString *)message;

//提示对话框-ForHUD
+(void)showTextHUD:(NSString *)message addView:(UIView*)view;

//提示对话框-ForHUD
+(void)showLoadingHUD:(NSString *)message addView:(UIView*)view;

//处理返回的Response，返回业务执行结果代码
+(Boolean)handleMessage:(id)data addView:(UIView *)view;

//根据枚举获取中文名
+(NSString *)GetHTTPMethodFromEnum:(HTTPMethod)httpMethod;

@end

//Create By Jim

//  IOS客户端，全局一个appkey使用一个，只需要注册就可以创建全局单例。

#import <UIKit/UIKit.h>
#import "XiaoMaiOSSdk.h"
#import "XiaoMaAttachment.h"

@interface XiaoMaClient : NSObject <XiaoMaiOSSdk,UIWebViewDelegate>

@property(copy,atomic) NSString *appKey;
@property(copy,atomic) NSString *appSecret;
@property(copy,atomic) NSString *apiUrl;

//注册不同的appkey的ios客户端,需要提供appkey，appsecretcode
+(id)registeriOSClient:(NSString *)appKey appSecret:(NSString *)appSecret apiUrl:(NSString *)apiUrl;

//根据appkey获得客户端，如果没有注册将得到nil
+(XiaoMaClient *)getiOSClientByAppKey:(NSString *)appKey;

//获得默认第一客户端，如果一个都没有将得到nil
+(XiaoMaClient *)getDefaultiOSClient;

@end

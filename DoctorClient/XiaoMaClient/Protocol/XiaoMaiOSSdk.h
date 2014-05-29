//Create By Jim


#import <UIKit/UIKit.h>
#import "XiaoMaEntityProtocol.h"
#import "XiaoMaiOSUtil.h"


@protocol XiaoMaiOSSdk <NSObject>

//调用api入口:  method请求的方法(GET,POST);requestMethod请求的API方法名;params具体的业务和系统参数(可以不传，内部会有默认设置);target和cb用于请求后传递结果回调（NSString或者NSError两种返回）
//needMainThreadCallBack表明是否回调的时候采用主线程的方式回调（如果为true就采用主线程，主线程回调的作用是当回调函数需要操作ui界面的时候，必须是主线程，如果只是后台保存数据，这个值可以是false）
//Object表明要序列化的对象
//needShowErrorAlertView针对返回的对象为NSError对象时的显示，这里的错误全部被包装成请求超时，原始信息只要跟踪日志输出即可
//timeoutInterval表示请求超时时间
-(void)api:(HTTPMethod)method requestMethod:(NSString *)requestMethod params:(NSDictionary *)params target:(id)target cb:(SEL)cb Object:(id)Object needMainThreadCallBack:(Boolean) needMainThreadCallBack needShowErrorAlertView:(Boolean) needShowErrorAlertView timeoutInterval:(NSTimeInterval)timeoutInterval;

//同步方法，参数与异步方法的一致
-(id)api:(HTTPMethod)method requestMethod:(NSString *)requestMethod params:(NSDictionary *)params Object:(id)Object needShowErrorAlertView:(Boolean) needShowErrorAlertView timeoutInterval:(NSTimeInterval)timeoutInterval;

@end

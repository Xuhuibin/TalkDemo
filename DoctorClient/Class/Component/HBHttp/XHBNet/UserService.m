//
//  UserService.m
//  wq
//
//  Created by berwin on 13-6-18.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "UserService.h"
#import "ResultEx.h"
#import "NetworkUtil.h"
#import "GTMBase64.h"
#import "ASIDataCompressor.h"
#import "ASINetworkQueue.h"
#import "MBProgressHUD.h"
#import "XiaoMaClient.h"
#import "ChatAttachmentsResponse.h"
#import "XiaoMaAttachment.h"
#import "HBFileCache.h"
@implementation UserService

+ (UserService *) sharedInstance
{
    static UserService *sharedInstance = nil ;
    static dispatch_once_t onceToken;  // 锁
    dispatch_once (&onceToken, ^ {     // 最多调用一次
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(ASIHTTPRequest*)uploadFileToServer:(ServiceParam *)param completeBlock:(void(^)(id  result))completeBlock failedBlock:(void(^)(id result))failedBlock view:(UIView*)view
{
    if (![NetworkUtil getNetworkStatue]) {
        if (failedBlock) {
            failedBlock(nil);
        }
        return nil;
    }
    _complete=completeBlock;
    _failed=failedBlock;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString * type=[param.strParam objectForKey:@"type"];
    [params setObject:[param.strParam objectForKey:@"from"]  forKey:@"formuser"];
    [params setObject:[param.strParam objectForKey:@"to"] forKey:@"touser"];
    XiaoMaAttachment * attach=[[XiaoMaAttachment alloc]init];
    if (param.fileParam != nil && param.fileParam.count > 0) {
        for (NSString *fileKey in param.fileParam) {
            id filePath = [param.fileParam objectForKey: fileKey];
            if (filePath != nil&&[filePath isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic=(NSDictionary*)filePath;
                id value=[dic objectForKey:@"value"];
                NSString * name=[dic objectForKey:@"name"];
                if( [value isKindOfClass: [NSString class]] ){
                    NSData * data=[NSData dataWithContentsOfFile:value];
                    [attach setData:data];
                    [attach setName:name];
                } else if( [value isKindOfClass:[NSData class]] ){
                    // 传入的是一个NSData
                    //[request addData:filePath forKey: fileKey];
                    [attach setData:value];
                    [attach setName:name];
                }
            }
        }
    }
    NSString * method;
    if ([type isEqualToString:@"image"]) {
        [params setObject:attach forKey:@"image"];
        method=@"ChatAttachmentsApi.UpdateImageFile";
        
    }else{
        [params setObject:attach forKey:@"sound"];
        method=@"ChatAttachmentsApi.UpdateSoundFile";
        NSString * recodTime =[param.strParam objectForKey:@"recodTime"];
        [params setObject:recodTime forKey:@"recodTime"];
    }
    
    //创建请求客户端
    XiaoMaClient *iosClient =[XiaoMaClient getDefaultiOSClient];
    
    //正式请求
    [iosClient api:POST//请求方式
     requestMethod:method//请求方法//对应url的method参数
            params:params//请求参数
            target:self//设置代理
                cb:@selector(uploadSuccess:)//回调函数
            Object:[ChatAttachmentsResponse class]//需要序列化的对象
needMainThreadCallBack:TRUE//是否需要主线程处理
needShowErrorAlertView:TRUE//是否需要错误提示框
   timeoutInterval:20.0f];//请求超时时间
    return nil;
}
-(void)uploadSuccess:(ChatAttachmentsResponse*)data
{
    if (data.Obj.C_Filename) {
        if (_complete) {
            _complete(data.Obj.C_Filename);
        }
    }else{
        if (_failed) {
            _failed(nil);
        }
    }
}


- (NSString*)getFileUploadUrl {
    return @"http://ejt.s2.c2d.me/api.ashx?method=ChatAttachmentsApi.Test&";
}


//遍历数组
- (void) addParam: (ServiceParam *) param toRequest:(ASIFormDataRequest *) request {
    //添加文件参数
    if (param.fileParam != nil && param.fileParam.count > 0) {
        for (NSString *fileKey in param.fileParam) {
            id filePath = [param.fileParam objectForKey: fileKey];
            if (filePath != nil&&[filePath isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic=(NSDictionary*)filePath;
                id value=[dic objectForKey:@"value"];
                NSString * name=[dic objectForKey:@"name"];
                NSString * mimeType=[dic objectForKey:@"mimeType"];
                
                if( [value isKindOfClass: [NSString class]] ){
                    // 传入的是一个文件路径
                    //[request setFile: filePath forKey: fileKey];
                    [request addFile:value withFileName:name andContentType:mimeType forKey:fileKey];
                } else if( [value isKindOfClass:[NSData class]] ){
                    // 传入的是一个NSData
                    //[request addData:filePath forKey: fileKey];
                    [request addData:value withFileName:name andContentType:mimeType forKey:fileKey];
                }
            }
        }
    }
    for (NSString * key in param.strParam.allKeys) {
        NSString *value=[param.strParam objectForKey:key];
        [request addPostValue:value forKey:key];
    }
}

//对数据编码
+ (NSString*)encodeBase64:(NSData*)data
{
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString *)decodeBase64:(NSData *)data {
    NSData *decodeData = [GTMBase64 decodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:decodeData
                                                    encoding:NSUTF8StringEncoding];
    return base64String;
}

-(void)cancel
{
    [[NSOperationQueue downLoadQueue] cancelAllOperations];
}


@end

//Create By Jim


#import <Foundation/Foundation.h>
#import "XiaoMaEntityProtocol.h"

@interface Error : NSObject<NSCoding,XiaoMaEntityProtocol>

@property (nonatomic,strong) NSNumber *ErrCode;
@property (nonatomic,strong) NSNumber *SubCode;
@property (nonatomic,strong) NSString *RequestArgs;
@property (nonatomic,strong) NSString *ErrMsg;

@end

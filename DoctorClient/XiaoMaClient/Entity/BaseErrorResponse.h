//Create By Jim


#import <Foundation/Foundation.h>
#import "Error.h"
#import "XiaoMaEntityProtocol.h"

@interface BaseErrorResponse : NSObject<NSCoding,XiaoMaEntityProtocol>

@property (nonatomic,strong) Error *Error;

@end

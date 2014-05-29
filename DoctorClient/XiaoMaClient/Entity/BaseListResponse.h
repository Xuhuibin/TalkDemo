//Create By Jim


#import <Foundation/Foundation.h>
#import "ListProperty.h"
#import "XiaoMaEntityProtocol.h"
#import "BaseErrorResponse.h"

@interface BaseListResponse : BaseErrorResponse<NSCoding,XiaoMaEntityProtocol>

@property (nonatomic,strong) ListProperty *Property;

@end

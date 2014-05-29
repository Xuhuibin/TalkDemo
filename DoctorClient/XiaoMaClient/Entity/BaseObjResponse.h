//Create By Jim


#import <Foundation/Foundation.h>
#import "ObjProperty.h"
#import "XiaoMaEntityProtocol.h"
#import "BaseErrorResponse.h"

@interface BaseObjResponse : BaseErrorResponse<NSCoding,XiaoMaEntityProtocol>

@property (nonatomic,strong) ObjProperty *Property;

@end

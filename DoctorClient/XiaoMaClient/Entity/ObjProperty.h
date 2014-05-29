//Create By Jim


#import <Foundation/Foundation.h>
#import "XiaoMaEntityProtocol.h"

@interface ObjProperty : NSObject<NSCoding,XiaoMaEntityProtocol>

@property (nonatomic,strong) NSString *ObjName;
@property (nonatomic,assign) BOOL IsList;

@end

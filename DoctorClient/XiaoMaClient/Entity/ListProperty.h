//Create By Jim


#import <Foundation/Foundation.h>
#import "XiaoMaEntityProtocol.h"

@interface ListProperty : NSObject<NSCoding,XiaoMaEntityProtocol>

@property (nonatomic,strong) NSNumber *PageSize;
@property (nonatomic,assign) BOOL IsList;
@property (nonatomic,assign) BOOL IsNext;
@property (nonatomic,strong) NSNumber *TotalSize;
@property (nonatomic,strong) NSString *ObjName;
@property (nonatomic,strong) NSNumber *PageIndex;

@end

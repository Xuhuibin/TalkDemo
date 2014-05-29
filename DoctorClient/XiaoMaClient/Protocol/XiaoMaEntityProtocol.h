//Create By Jim


#import <Foundation/Foundation.h>

@protocol XiaoMaEntityProtocol <NSCoding>

+ (id)alloc;

//序列化JSON为实体对象的方法
-(id)initWithJson:(NSDictionary *)json;

@end

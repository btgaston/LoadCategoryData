
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface QuestionType : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSSet* Categories;

@end

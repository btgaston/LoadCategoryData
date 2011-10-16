//
//  Category.h
//  CoreDataTest
//
//  Created by Jianwei Sun on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, QuestionType;

@interface Category : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) QuestionType * QuestionType;
@property (nonatomic, retain) NSSet* Items;

@end

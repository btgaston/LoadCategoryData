//
//  Category.h
//  CoreDataTest
//
//  Created by Jianwei Sun on 9/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuestionType;

@interface Category : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) QuestionType * questionType;
@property (nonatomic, retain) NSString * imagePath;

@end

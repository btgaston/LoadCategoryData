//
//  QuestionType.m
//  CoreDataTest
//
//  Created by Jianwei Sun on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QuestionType.h"
#import "Category.h"


@implementation QuestionType
@dynamic name;
@dynamic imagePath;
@dynamic Categories;

- (void)addCategoriesObject:(Category *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Categories"] addObject:value];
    [self didChangeValueForKey:@"Categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeCategoriesObject:(Category *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Categories"] removeObject:value];
    [self didChangeValueForKey:@"Categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addCategories:(NSSet *)value {    
    [self willChangeValueForKey:@"Categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Categories"] unionSet:value];
    [self didChangeValueForKey:@"Categories" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeCategories:(NSSet *)value {
    [self willChangeValueForKey:@"Categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Categories"] minusSet:value];
    [self didChangeValueForKey:@"Categories" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end

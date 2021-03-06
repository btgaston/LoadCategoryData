#import "QuestionType.h"
#import "Category.h"
#import "CHCSV.h"
#import "CoreDataTestAppDelegate.h"
#import "RootViewController.h"

@implementation CoreDataTestAppDelegate

@synthesize window=_window;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;
@synthesize navigationController=_navigationController;


#pragma mark - load initial data


- (void) clearStore: (NSString*) entityTypeName
{
 
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityTypeName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        
    }
    if (![context save:&error]) {
        NSLog(@"Error saving: %@", error);
    }
}

- (void)loadInitialDataCsv
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    NSStringEncoding encoding = NSUTF8StringEncoding;    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"type" ofType:@"csv"];
    NSArray *questionTypes = [NSArray arrayWithContentsOfCSVFile:path encoding:encoding error:nil];
    int count=[questionTypes count];
    NSLog(@"Array count %d", count);
    for (NSObject* questionType in questionTypes) {
        NSString *questionTypeString = [questionType description];
        NSUInteger stringLength= [questionTypeString  length];
        NSLog(@"%@", questionTypeString);    
        NSArray *questionParts = [[questionTypeString substringWithRange:NSMakeRange(1,stringLength-2)] componentsSeparatedByString: @","];
        QuestionType *questionType = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"QuestionType" 
                                   inManagedObjectContext:context];
        //NSLog(@"Question Type :%@", questionType);        
        NSString* questionTypeName=[questionParts objectAtIndex:0];
        NSString* imagePath=[questionParts objectAtIndex:1];
        [questionType setValue:[questionTypeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"name"];
        [questionType setValue:[imagePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"imagePath"];
        [self QuestionType:questionType  loadCategoriesInContext:context];   
    }
    
    NSError *error; 
    if (![context save:&error])
        NSLog(@"Error saving: %@", error);
    [context release];
    [pool drain];
}



-(void) QuestionType:(QuestionType* ) questionType loadCategoriesInContext: (NSManagedObjectContext*) context
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[questionType name] ofType:@"csv"];
    NSLog(@"Category File Path :%@", filePath);
    NSStringEncoding encoding = NSUTF8StringEncoding; 
    NSArray *categories = [NSArray arrayWithContentsOfCSVFile:filePath encoding:encoding error:nil];
    for (NSObject* category in categories){
        NSString *categoryLine = [category description];
        NSUInteger stringLength= [categoryLine length];
        NSArray *categoryParts = [[categoryLine substringWithRange:NSMakeRange(1,stringLength-2)] componentsSeparatedByString: @","]; 
        Category* categoryObject=[NSEntityDescription
                            insertNewObjectForEntityForName:@"Category" 
                            inManagedObjectContext:context];
       
        NSString* categoryName=[categoryParts objectAtIndex:0];
        NSString* imagePath=[categoryParts objectAtIndex:1];
        [categoryObject  setValue:[categoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"name"];
        [categoryObject  setValue:[imagePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"imagePath"];
        
        [self Category:categoryObject  loadItemsInContext:context]; 
        [questionType addCategoriesObject: categoryObject];

    }
}


-(void) Category:(Category* ) category loadItemsInContext: (NSManagedObjectContext*) context
{
    //NSLog(@"Category Name :%@", [category name]);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[category name] ofType:@"csv"];
    int fileLength=[filePath length];
    if(fileLength>0)
    {
        NSLog(@"Item File Path :%@", filePath);
        NSStringEncoding encoding = NSUTF8StringEncoding;
        NSArray *items = [NSArray arrayWithContentsOfCSVFile:filePath encoding:encoding error:nil];
        for (NSObject* item in items){
            NSString *itemLine= [item description];
            NSLog(@"Item Line :%@", itemLine);
            
            NSUInteger stringLength= [itemLine length];
            NSArray *itemParts = [[itemLine substringWithRange:NSMakeRange(1,stringLength-2)] componentsSeparatedByString: @","]; 
            Item* itemObject=[NSEntityDescription
                                      insertNewObjectForEntityForName:@"Item" 
                                      inManagedObjectContext:context];
            
            NSString* itemName=[itemParts objectAtIndex:0];
            NSString* imagePath=[itemParts objectAtIndex:1];
            [itemObject  setValue:[itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"name"];
            [itemObject  setValue:[imagePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"imagePath"]; 
            [category addItemsObject: itemObject]; 
        }
    }
   }



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self clearStore: @"QuestionType"];
    [self clearStore: @"Category"];
    [self clearStore: @"Item"];
    [self loadInitialDataCsv];
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_navigationController release];
    [super dealloc];
}

- (void)awakeFromNib
{
    RootViewController *rootViewController = (RootViewController *)[self.navigationController topViewController];
    rootViewController.managedObjectContext = self.managedObjectContext;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataTest" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataTest.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end

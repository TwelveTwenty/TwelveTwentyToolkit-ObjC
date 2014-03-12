#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (TTTEasySections)

/* Number of objects in section
*/
@property (nonatomic, readonly) NSUInteger ttt_numberOfObjectsInFirstSection;

/* Returns the array of objects in the section.
*/
@property (nonatomic, readonly) NSArray *ttt_objects;

- (id <NSFetchedResultsSectionInfo>)ttt_sectionAtIndex:(NSUInteger)sectionIndex;

- (id <NSFetchedResultsSectionInfo>)ttt_firstSection;

- (id)ttt_firstObjectInFirstSection;

@end
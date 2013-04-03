#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (TTTEasySections)

/* Number of objects in section
*/
@property (nonatomic, readonly) NSUInteger tttNumberOfObjectsInFirstSection;

/* Returns the array of objects in the section.
*/
@property (nonatomic, readonly) NSArray *tttObjects;

- (id <NSFetchedResultsSectionInfo>)tttSectionAtIndex:(NSUInteger)sectionIndex;

- (id <NSFetchedResultsSectionInfo>)tttFirstSection;

- (id)tttFirstObjectInFirstSection;

@end
//
//  TXRootViewController.m
//  UnifiedAddressBook
//
//  Created by Eric-Paul Lecluse on 23-10-12.
//  Copyright (c) 2012 Twelve Twenty. All rights reserved.
//

#import "TXRootViewController.h"
#import "TTCGUtils.h"
#import "TTUnifiedAddressBook.h"
#import "TTUnifiedCard.h"

@interface TXRootViewController ()

@property (nonatomic, strong) TTUnifiedAddressBook *unified;

@end

@implementation TXRootViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        self.title = NSLocalizedString(@"TTUnifiedAddressBook example", nil);
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectAlignToRect(CGRectWithSize(self.view.bounds.size.width, 44), self.view.bounds, CGAlignCenterHorizontally | CGAlignCenterVertically)];
    label.numberOfLines = 2;
    label.textAlignment = UITextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    label.text = NSLocalizedString(@"Nothing to see here.\nLook at your console output.", nil);
    
    [self.view addSubview:label];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUnifiedAddressBookUpdateRequest:) name:TT_UNIFIED_ADDRESS_BOOK_REQUEST_UPDATE_NOTIFICATION object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self requestAddressBookAccess];
}

- (void)requestAddressBookAccess
{
    NSLog(@"Requesting access to the the address book.");
    [TTUnifiedAddressBook accessAddressBookWithGranted:^(ABAddressBookRef addressBook)
     {
         // At this point, we have a valid address book reference for use on the main thread.
         [self unifyCardsOfAddressBook:addressBook];
     }
                                                denied:^(BOOL restricted)
     {
         NSLog(@"Access to the address book is denied%@", restricted ? @" (and restricted)." : @".");
     }];
}

- (void)unifyCardsOfAddressBook:(ABAddressBookRef)addressBook
{
    NSLog(@"Access granted. %li cards in address book", ABAddressBookGetPersonCount(addressBook));
    self.unified = [[TTUnifiedAddressBook alloc] initWithAddressBook:addressBook];
    [self.unified updateAddressBookWithCompletion:^
     {
         // It takes a short while to index the address book, it's done on a background thread.
#warning You  may want to change this query string to something that exists in your own address book.
#warning Set the async param to your liking.
         [self performASearchQuery:@"Twelve Twenty" asynchronously:YES];
     }];
}

/**
 You can perform a synchrounous (blocking) or asynchronous (non-blocking) search on the contents of the address book.
 */
- (void)performASearchQuery:(NSString *)query asynchronously:(BOOL)async
{
    NSLog(@"Completed indexing the address book. Now searching...");
    
    void (^showResults)(NSArray *) = ^(NSArray *resultCards){
        TTUnifiedCard *card = [resultCards lastObject];
        
        // A `TTUnifiedCard` object can be passed around between threads, but the `ABAddressBookRef` is not thread safe.
        // That's why you have to set a valid address book reference before you access it's properties.
        [card setAddressBook:self.unified.addressBook];
        
        // Have a look at the `print` method to see how you can get to the individual properties of a card.
        NSLog(@"Found %i cards, last of which:", [resultCards count]);
        [card print];
    };
    
    if (async)
    {
        [self.unified cardsMatchingQuery:query withAsyncResults:showResults];
    }
    else
    {
        NSArray *results = [self.unified cardsMatchingQuery:query];
        showResults(results);
    }
}

@end

//
//  ContactsViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 5/28/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "ContactsViewController.h"
#import "ShareFriendCell.h"

@interface ContactsViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, weak) IBOutlet UITableView *contactsTableView;

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldHideLoader = YES;
    
    self.contacts = [[NSMutableArray alloc] init];
    
    [self getContacts];
}

- (void)getContacts
{
    [self.contacts removeAllObjects];
    
    [[ShareManager sharedInstance] getContactsWithCompletionBlock:^(ABAddressBookRef addressBook, CFErrorRef error)
     {
         NSArray *allPeople = (NSArray *)CFBridgingRelease( ABAddressBookCopyArrayOfAllPeople(addressBook));
         
         for(id person in allPeople)
         {
             ABRecordRef ref = (ABRecordRef)CFBridgingRetain(person);
             NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
             NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(ref, kABPersonLastNameProperty));
             NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
             [self.contacts addObject:fullName];
             
             CFRelease(ref);
         }
         
         [self.contactsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
         
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ADD_FRIEND_CELL_IDENTIFIER];
    
    NSString *contactName = self.contacts[indexPath.row];
    cell.friendLabel.text = contactName;
    cell.twitterImageView.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  Friend *friend = self.user.friends[indexPath.row];
}

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return YES;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    return YES;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeP;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return TEXT_CONTACTS;
}

@end

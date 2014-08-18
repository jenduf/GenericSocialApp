//
//  NSDate+PSFoundation.m
//
//  Created by Peter Steinberger on 23.05.09.
//

#import "NSDate+PSFoundation.h"

@implementation NSDate (PSFoundation)

static NSDateFormatter *dateFormatter = nil;

- (NSString *)prettyDateWithReference:(NSDate *)reference relativeMonth:(BOOL)relativeMonth
{
  float diff = [reference timeIntervalSinceDate:self];
  float distance = floor(diff);

  if (distance < 60) {
	  //self.timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "second ago" : "seconds ago"];
	  return NSLocalizedString(@"just now", @"");
  }
  else if (distance < 60 * 60) {
    distance = distance / 60;
    return [NSString stringWithFormat:@"%d %@", (int)distance, ((int)distance == 1) ? NSLocalizedString(@"minute ago", @"") : NSLocalizedString(@"mins ago", @"")];
  }
  else if (distance < 60 * 60 * 24) {
    distance = distance / 60 / 60;
    return [NSString stringWithFormat:@"%d %@", (int)distance, ((int)distance == 1) ? NSLocalizedString(@"hour ago", @"") : NSLocalizedString(@"hours ago", @"")];
  }
  else if (distance < 60 * 60 * 24 * 7) {
    distance = distance / 60 / 60 / 24;
    return [NSString stringWithFormat:@"%d %@", (int)distance, ((int)distance == 1) ? NSLocalizedString(@"day ago", @"") : NSLocalizedString(@"days ago", @"")];
  }
  else if (distance < 60 * 60 * 24 * 7 * 4) {
    distance = distance / 60 / 60 / 24 / 7;
    return [NSString stringWithFormat:@"%d %@", (int)distance, ((int)distance == 1) ? NSLocalizedString(@"week", @"") : NSLocalizedString(@"weeks ago", @"")];
  }
  else if (relativeMonth && distance < 60 * 60 * 24 * 7 * 4 * 12) {
    distance = distance / 60 / 60 / 24 / 7 / 4;
    return [NSString stringWithFormat:@"%d %@", (int)distance, ((int)distance == 1) ? NSLocalizedString(@"month ago", @"") : NSLocalizedString(@"months ago", @"")];
  }
  else {
    if (dateFormatter == nil) {
      dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateStyle:NSDateFormatterShortStyle];
      [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return [dateFormatter stringFromDate:self];
  }
}

- (NSString *)prettyDateWithReference:(NSDate *)reference {
  return [self prettyDateWithReference:[NSDate date] relativeMonth:NO];
}

- (NSString *)prettyDate {
  return [self prettyDateWithReference:[NSDate date] relativeMonth:NO];
}


- (NSString *)dateStringWithStyle:(NSDateFormatterStyle)style {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:style];
  return [dateFormatter stringFromDate:self];
}

- (NSString *)dateStringWithStyle:(NSDateFormatterStyle)style time:(NSDateFormatterStyle)timeStyle {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:style];
  [dateFormatter setTimeStyle:timeStyle];
  return [dateFormatter stringFromDate:self];
}

+ (NSDate *)ps_todayMidnight {
  NSDate *today = [NSDate date];

  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

  NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
  NSDateComponents *components = [gregorian components:unitFlags fromDate:today];
  components.hour = 0;
  components.minute = 0;

  NSDate *todayMidnight = [gregorian dateFromComponents:components];

  return todayMidnight;
}

// http://stackoverflow.com/questions/181459/is-there-a-better-way-to-find-midnight-tomorrow
+ (NSDate *)ps_tomorrowMidnight {
  NSDate *today = [NSDate date];

  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day = 1;
  NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:today options:0];

  NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
  components = [gregorian components:unitFlags fromDate:tomorrow];
  components.hour = 0;
  components.minute = 0;

  NSDate *tomorrowMidnight = [gregorian dateFromComponents:components];

  return tomorrowMidnight;
}

// All intervals taken from Google
+ (NSDate *)ps_yesterday {
  return [[NSDate date] dateByAddingTimeInterval: -86400.0];
}

+ (NSDate *)ps_tomorrow {
  return [[NSDate date] dateByAddingTimeInterval: 86400.0];
}

+ (NSDate *)ps_thisWeek {
  return [[NSDate date] dateByAddingTimeInterval: -604800.0];
}

+ (NSDate *)ps_lastWeek {
  return [[NSDate date] dateByAddingTimeInterval: -1209600.0];
}

+ (NSDate *)ps_thisMonth {
  return [[NSDate date] dateByAddingTimeInterval: -2629743.83]; // Use NSCalendar for exact # of days
}

+ (NSDate *)ps_lastMonth {
  return [[NSDate date] dateByAddingTimeInterval: -5259487.66];  // Use NSCalendar for exact # of days
}

+ (NSDate *)ps_oneMinuteFuture {
  return [[NSDate date] dateByAddingTimeInterval: 60];
}

- (BOOL) isBefore:(NSDate*)otherDate {
	return [self timeIntervalSinceDate:otherDate] < 0;
}

- (BOOL) isAfter:(NSDate*)otherDate {
	return [self timeIntervalSinceDate:otherDate] > 0;
}

+ (NSString *)formattedDateFromSeconds:(NSTimeInterval)seconds
{
	NSTimeInterval interval = seconds;
	long min = (long)interval / 60;    // divide two longs, truncates
	long sec = (long)interval % 60;    // remainder of long divide
	NSString* str = [[NSString alloc] initWithFormat:@"%02ld:%02ld", min, sec];
	
	return str;
}

@end

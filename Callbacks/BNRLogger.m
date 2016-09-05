#import "BNRLogger.h"

@implementation BNRLogger

-(NSString *)lastTimeString
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSLog(@"created dateFormatter");
    }
    return [dateFormatter stringFromDate:self.lastTime];
}

-(void)updateLastTime:(NSTimer *)t
{
    NSDate *now = [NSDate date];
    [self setLastTime:now];
    NSLog(@"Just set time to %@",self.lastTimeString);
}

-(void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    NSLog(@"recieved %lu bytes of data",[data length]);
    
    if (!_incomingData) {
        _incomingData = [[NSMutableData alloc]init];
    }
    [_incomingData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Got it all");
    NSString *string = [[NSString alloc]initWithData:_incomingData
                                            encoding:NSUTF8StringEncoding];
    _incomingData = nil;
    NSLog(@"string has %lu characters",[string length]);
}

-(void)connection:(NSURLConnection *)connection
    didFailWithError:(NSError *)error
{
    NSLog(@"connection failed with error: %@",[error localizedDescription]);
    _incomingData = nil;
}

-(void)zoneChange:(NSNotification *)note
{
    NSLog(@"The system time zone has changed!!!");
}
@end
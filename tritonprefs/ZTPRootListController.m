#include "ZTPRootListController.h"

@implementation ZTPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)contactMethod{

NSURL *url;

	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
	url = [NSURL URLWithString:@"tweetbot:///user_profile/mrgamefuzzy"];
} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
	url = [NSURL URLWithString:@"twitterrific:///profile?screen_name=mrgamefuzzy"];
} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
	url = [NSURL URLWithString:@"tweetings:///user?screen_name=mrgamefuzzy"];
} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
	url = [NSURL URLWithString:@"twitter://user?screen_name=mrgamefuzzy"];
} else {
	url = [NSURL URLWithString:@"https://twitter.com/mrgamefuzzy"];
}
  [[UIApplication sharedApplication]openURL:url];
}

-(void)contactMethod1{

NSURL *url1;

	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
	url1 = [NSURL URLWithString:@"tweetbot:///user_profile/designer_simply"];
} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
	url1 = [NSURL URLWithString:@"twitterrific:///profile?screen_name=designer_simply"];
} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
	url1 = [NSURL URLWithString:@"tweetings:///user?screen_name=designer_simply"];
} else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
	url1 = [NSURL URLWithString:@"twitter://user?screen_name=designer_simply"];
} else {
	url1 = [NSURL URLWithString:@"https://twitter.com/designer_simply"];
}
  [[UIApplication sharedApplication]openURL:url1];
}

-(void)emailContactMethod{
NSString *subject = @"Triton Support";
NSString *body = @"";
NSString *urlString = [NSString stringWithFormat:@"mailto:gamefuzzy12345@gmail.com?subject=%@&body=%@", subject, body];
NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
[[UIApplication sharedApplication] openURL:url];
}

@end

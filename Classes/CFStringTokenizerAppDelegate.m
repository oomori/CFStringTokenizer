//
//  CFStringTokenizerAppDelegate.m
//  CFStringTokenizer
//
//  Created by 大森 智史 on 10/11/19.
//  Copyright 2010 Satoshi Oomori. All rights reserved.
//

#import "CFStringTokenizerAppDelegate.h"
#import "CFStringTokenizerViewController.h"

@implementation CFStringTokenizerAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle
-(NSString *)whatLanguageWithString:(CFStringRef)string2
{

    //
	CFRange stringRange2 = CFRangeMake(0, [(NSString *)string2 length]) ;
    
    //解析を行うトークナイザーを作成
	CFStringTokenizerRef tokenizerRef2 = CFStringTokenizerCreate(NULL, //アロケーター
                                                                 string2,                              //解析する文字列
                                                                 stringRange2,                         //解析する範囲
                                                                 
                                                                 //kCFStringTokenizerUnitSentence,//センテンスか
                                                                 kCFStringTokenizerUnitParagraph,//パラグラフ
                                                                 CFLocaleCopyCurrent()
                                                                 //ロケール
                                                                 );
	//次のトークンへ（最初）
    CFStringTokenizerAdvanceToNextToken(tokenizerRef2);
    
    //言語？
    CFTypeRef languageAttr2= CFStringTokenizerCopyCurrentTokenAttribute(tokenizerRef2, 
                                                                        kCFStringTokenizerAttributeLanguage );

    return (NSString *)languageAttr2;
    
}
-(void)resolveString:(CFStringRef)string
{
    //CFStringRef string = (CFStringRef)@"toukyou";
    //
	CFRange stringRange = CFRangeMake(0, [(NSString *)string length]) ;
    
    //解析を行うトークナイザーを作成
	CFStringTokenizerRef tokenizerRef = CFStringTokenizerCreate(NULL, //アロケーター
                                                                string,                              //解析する文字列
                                                                stringRange,                         //解析する範囲
                                                                //kCFStringTokenizerUnitWord, //どういう分け方をするか語で分ける
                                                                kCFStringTokenizerUnitWordBoundary,
                                                                //kCFStringTokenizerUnitWord,//
                                                                //kCFStringTokenizerUnitSentence,//
                                                                //kCFStringTokenizerAttributeLanguage,
                                                                //kCFStringTokenizerUnitWord,
                                                                //kCFStringTokenizerUnitParagraph
                                                                CFLocaleCopyCurrent()
                                                                //ロケール
                                                                );
	//次のトークンへ（最初）
	CFStringTokenizerTokenType type = CFStringTokenizerAdvanceToNextToken(tokenizerRef);
    
    /*
     switch (type << 1) {
     case kCFStringTokenizerTokenIsCJWordMask:
     NSLog(@"1 kCFStringTokenizerTokenIsCJWordMask");
     break;
     case kCFStringTokenizerTokenHasSubTokensMask:
     NSLog(@"1 kCFStringTokenizerTokenHasSubTokensMask");
     break;
     
     
     
     default:
     NSLog(@"default");
     break;
     }
     */
    //終わりまで繰り返す
    while (1) {
        CFRange r = CFStringTokenizerGetCurrentTokenRange(tokenizerRef);
        if (r.location == kCFNotFound && r.length == 0){break;}
		
		NSString *token = [NSString stringWithString:
                           [(NSString *)string substringWithRange: NSMakeRange(r.location, r.length)]];
        
		//読み仮名
		CFTypeRef yomiKana= CFStringTokenizerCopyCurrentTokenAttribute(tokenizerRef, 
                                                                       kCFStringTokenizerAttributeLatinTranscription);
        //                            kCFStringTokenizerAttributeLatinTranscription);
		//言語？
		CFTypeRef languageAttr= CFStringTokenizerCopyCurrentTokenAttribute(tokenizerRef, 
                                                                           kCFStringTokenizerAttributeLanguage );
        
        
        
		//if (attr != NULL) {
        //self.latinTranscription = (NSString *)attr;
        //CFRelease(attr);
		//}
        
		NSLog(@"(%@) よみ = %@",token,(NSString *)yomiKana);
        //NSLog(@"(%@) 言語 = %@",token,(NSString *)languageAttr);
		
		CFStringTokenizerTokenType aType =CFStringTokenizerAdvanceToNextToken(tokenizerRef);
        if(type & kCFStringTokenizerTokenHasSubTokensMask){
            NSLog(@"*kCFStringTokenizerTokenHasSubTokensMask"); 
            
            CFRange subTokenRanges[100];
            CFIndex rangeCount = CFStringTokenizerGetCurrentSubTokens (
                                                                       tokenizerRef,
                                                                       subTokenRanges,
                                                                       sizeof(subTokenRanges) / sizeof(subTokenRanges[0]), 
                                                                       NULL
                                                                       );
            //NSLog(@"rangeCount (%ld)",rangeCount);
            
            CFRange *ranges = NULL;
            CFIndex maxRangeLength = 0;
            NSMutableArray *strings = nil;
            CFIndex numRanges = CFStringTokenizerGetCurrentSubTokens(tokenizerRef, ranges, maxRangeLength, (CFMutableArrayRef)strings);
            
            NSLog(@"rangeCount (%ld)",numRanges);
            
            
        }
        if(type & kCFStringTokenizerTokenIsCJWordMask  ){
            NSLog(@"*kCFStringTokenizerTokenIsCJWordMask");
        }
        
        if(type & kCFStringTokenizerTokenHasHasNumbersMask  ){
            NSLog(@"*kCFStringTokenizerTokenHasHasNumbersMask");
            CFRange subTokenRanges[100];
            CFIndex rangeCount = CFStringTokenizerGetCurrentSubTokens (
                                                                       tokenizerRef,
                                                                       subTokenRanges,
                                                                       sizeof(subTokenRanges) / sizeof(subTokenRanges[0]), 
                                                                       NULL
                                                                       );
 
            
            CFRange *ranges = NULL;
            CFIndex maxRangeLength = 0;
            NSMutableArray *strings = nil;
            CFIndex numRanges = CFStringTokenizerGetCurrentSubTokens(tokenizerRef, ranges, maxRangeLength, (CFMutableArrayRef)strings);
            
            NSLog(@"rangeCount (%ld)",numRanges);
        }
        
        
        
        
        
        NSLog(@"aType(%lu)  %@",aType,token);
        
        NSLog(@"***************************************************");
    }
    CFStringRef language = CFStringTokenizerCopyCurrentTokenAttribute(tokenizerRef, kCFStringTokenizerAttributeLanguage);
    NSLog(@"language  %@",language);
    
    CFRelease(tokenizerRef);
    
    
    
    return;
}
-(void)resolveString2:(CFStringRef)string
{
 
	CFRange stringRange = CFRangeMake(0, [(NSString *)string length]) ;
    
    //解析を行うトークナイザーを作成
	CFStringTokenizerRef tokenizerRef = CFStringTokenizerCreate(NULL, //アロケーター
                                                                string,                              //解析する文字列
                                                                stringRange,                         //解析する範囲
                                                                //kCFStringTokenizerUnitWord, //どういう分け方をするか語で分ける
                                                                kCFStringTokenizerUnitWordBoundary,
                                                                //kCFStringTokenizerUnitWord,//
                                                                //kCFStringTokenizerUnitSentence,//
                                                                //kCFStringTokenizerAttributeLanguage,
                                                                //kCFStringTokenizerUnitWord,
                                                                //kCFStringTokenizerUnitParagraph
                                                                CFLocaleCopyCurrent()
                                                                //ロケール
                                                                );
	//次のトークンへ（最初）
	CFStringTokenizerTokenType type = CFStringTokenizerAdvanceToNextToken(tokenizerRef);
    
    
    //終わりまで繰り返す
    while (1) {
        CFRange r = CFStringTokenizerGetCurrentTokenRange(tokenizerRef);
        if (r.location == kCFNotFound && r.length == 0){break;}
		
		NSString *token = [NSString stringWithString:
                           [(NSString *)string substringWithRange: NSMakeRange(r.location, r.length)]];
        
		//読み仮名
		CFTypeRef yomiKana= CFStringTokenizerCopyCurrentTokenAttribute(tokenizerRef, 
                                                                       kCFStringTokenizerAttributeLatinTranscription);
        //                            kCFStringTokenizerAttributeLatinTranscription);
		//言語？
		CFTypeRef languageAttr= CFStringTokenizerCopyCurrentTokenAttribute(tokenizerRef, 
                                                                           kCFStringTokenizerUnitWord );
        
        
        
        
		NSLog(@"(%@) よみ = %@",token,(NSString *)yomiKana);
        NSLog(@"(%@) 言語 = %@",token,(NSString *)languageAttr);
		
		CFStringTokenizerTokenType aType =CFStringTokenizerAdvanceToNextToken(tokenizerRef);
        //if(type & kCFStringTokenizerTokenHasSubTokensMask){
        NSLog(@"*kCFStringTokenizerTokenHasSubTokensMask"); 
        
        CFRange subTokenRanges[100];
        CFIndex rangeCount = CFStringTokenizerGetCurrentSubTokens (
                                                                   tokenizerRef,
                                                                   subTokenRanges,
                                                                   sizeof(subTokenRanges) / sizeof(subTokenRanges[0]), 
                                                                   NULL
                                                                   );
        
        
        CFRange *ranges = NULL;
        CFIndex maxRangeLength = 0;
        NSMutableArray *strings = nil;
        CFIndex numRanges = CFStringTokenizerGetCurrentSubTokens(tokenizerRef, ranges, maxRangeLength, (CFMutableArrayRef)strings);
        
        NSLog(@"rangeCount (%ld)",numRanges);
        
        
        NSLog(@"***************************************************");
    }
    
    CFRelease(tokenizerRef);
    return;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];


    //解析する文字を
	CFStringRef string = (CFStringRef)@"東京近辺の今日は、よいお天気ですね。";
	//CFStringRef string = (CFStringRef)@"隣の客はよく柿喰う客だ";
    
    
    [self resolveString2:string];  
    
    
    
    NSLog(@"********************** Language *****************************");
    

    //解析可能
	//CFStringRef string2 = (CFStringRef)@"this is a pen.";
    //CFStringRef string2 = (CFStringRef)@"toukyou";
    //CFStringRef string2 = (CFStringRef)@"Ik wens u allen een goede morgen.";//nl オランダ語
    //CFStringRef string2 = (CFStringRef)@"Volo vos omnes bene mane.";//es ラテン語
    CFStringRef string2 = (CFStringRef)@"여러분, 안녕하세요.";//ko 韓国語
    //CFStringRef string2 = (CFStringRef)@"我祝大家早上好。";//zh-Hant 中国ー繁体語
    //CFStringRef string2 = (CFStringRef)@"ฉันขอให้คุณทุกเช้าที่ดี";//th タイ語
    //CFStringRef string2 = (CFStringRef)@"Je vous souhaite à tous une bonne matinée.";//fr フランス語
    
    //解析不可
    //CFStringRef string2 = (CFStringRef)@"გისურვებთ ყველა კარგი დილით.";//?? グルジア語
    
    NSLog(@"(%@) 言語 = %@",string2,[self whatLanguageWithString:string2]);
      
    
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

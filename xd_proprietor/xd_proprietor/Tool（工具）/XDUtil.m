//
//  XDUtil.m
//  xd_proprietor
//
//  Created by mason on 2018/9/10.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDUtil.h"
#import <CommonCrypto/CommonHMAC.h>
#import "WHToast.h"

@implementation XDUtil

#pragma mark -
#pragma mark String
+ (BOOL)stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)stringIsEmpty:(NSString *) aString shouldCleanWhiteSpace:(BOOL)cleanWhileSpace {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    }
    
    if (cleanWhileSpace) {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)isLegalCharacter:(NSString *)content {
    NSString *str = @"[a-zA-Z0-9\u4e00-\u9fa5\u3000-\u301e\ufe10-\ufe19\ufe30-\ufe44\ufe50-\ufe6b\uff01-\uffee]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return [predicate evaluateWithObject:content];
}

+ (NSString *)createSignStrFor:(NSString *)key content:(NSString *)content {
    const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [content cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSLog(@"%@", hash);
    return [self base64forData:hash];
}

+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

// 普通的获取UUID的方法
+ (NSString *)getUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    return result;
}

#pragma mark - 时间处理
+ (NSDateFormatter *)theFormatterWithStr:(NSString *)formatterStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterStr]; // 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    // 设置时区,这个对于时间的处理有时很重要
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return formatter;
}

+ (NSDate *)dateFromDateStr:(NSString*)dateStr WithFormatterStr:(NSString *)formatterStr {
    NSDateFormatter *formatter = [self theFormatterWithStr:formatterStr];
    return [formatter dateFromString:dateStr];
}

+ (NSString *)dateStrFromDate:(NSDate *)date WithFormatterStr:(NSString *)formatterStr {
    NSDateFormatter *formatter = [self theFormatterWithStr:formatterStr];
    return [formatter stringFromDate:date];
}

+ (NSString *)getNowTimeTimestamp {
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

// 获取当前时间戳（以毫秒为单位）
+ (NSString *)getNowTimeMillTimestamp {
    NSDate *datenow = [NSDate date];
    double interval = [datenow timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)(interval*1000)];
    return timeSp;
}

+ (NSString *)getNowTimeStrWithFormatter:(NSString *)formatterStr {
    return [self dateStrFromDate:[NSDate date] WithFormatterStr:formatterStr];
}

+ (NSString*)getDateStrWithFormatter:(NSString *)formatterStr sinceNow:(NSTimeInterval)timeInterval {
    return [self dateStrFromDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval] WithFormatterStr:formatterStr];;
}

+ (NSString *)getTimeStrSinceNowWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day formatterStr:(NSString *)str {
    return [self getTimeStrSinceDate:[NSDate date] WithYear:year month:month day:day formatterStr:str];
}

+ (NSString *)getTimeStrSinceDate:(NSDate *)myDate WithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day formatterStr:(NSString *)str {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:myDate options:0];
    
    NSDateFormatter *formatter = [self theFormatterWithStr:str];
    NSString *timeSp = [formatter stringFromDate:newdate];
    return timeSp;
}


+ (NSInteger)getDistanceWithFirstDate:(NSString *)firstDateStr secondDate:(NSString *)secondDateStr dateFormatter:(NSString *)dateFormatterStr {
    //创建两个日期
    NSDateFormatter *dateFormatter = [self theFormatterWithStr:dateFormatterStr];
    NSDate *startDate = [dateFormatter dateFromString:firstDateStr];
    NSDate *endDate = [dateFormatter dateFromString:secondDateStr];
    
    // 利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay; // 只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    return delta.day;
}

/**
 *  生成二维码
 */
+ (UIImage *)createCodeImageView:(NSString *)url {
    
    //1.生成coreImage框架中的滤镜来生产二维码
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    [filter setValue:[url dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //4.获取生成的图片
    CIImage *ciImg=filter.outputImage;
    //放大ciImg,默认生产的图片很小
    //5.3获取生存的图片
    CGAffineTransform scale=CGAffineTransformMakeScale(10, 10);
    ciImg=[ciImg imageByApplyingTransform:scale];
    
    
    //6.在中心增加一张图片
    UIImage *img=[UIImage imageWithCIImage:ciImg];
    //7.生存图片
    //7.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    //7.2将二维码的图片画入
    [img drawInRect:CGRectMake(10, 10, img.size.width-20, img.size.height-20)];
    
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    return finalImg;
}

// 截取当前屏幕
+ (NSData *)dataWithScreenshotInPNGFormat {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

+ (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
}

+ (void)showToast:(NSString *)message {
    [WHToast showMessage:message originY:kScreenHeight - 80 duration:2 finishHandler:nil];
}

+ (float)folderSizeAtPath:(NSString*)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

+ (long long)fileSizeAtPath:(NSString* )filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (void)clearCache:(NSString *)path {
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
    for (NSString *p in files) {
        NSError *error;
        NSString *Path = [path stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            //清理缓存，保留Preference，里面含有NSUserDefaults保存的信息
            if (![Path containsString:@"Preferences"]) {
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
            }
        } else {
            
        }
    }
}

+ (NSMutableArray *)convertToArrayByStr:(NSString *)str {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    // 遍历字符串，按字符来遍历。每个字符将通过block参数中的substring传出
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        //
        [arr addObject:substring];
    }];
    return arr;
}

// 判断设备是不是iPad
+ (BOOL)isIPad {
    NSString *deviceType = [UIDevice currentDevice].model;
    NSRange range = [deviceType rangeOfString:@"iPad"];
    return range.location != NSNotFound;
}

// 修改约束的multiplier属性
+ (void)changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier {
    [NSLayoutConstraint deactivateConstraints:@[constraint]];
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    newConstraint.priority = constraint.priority;
    newConstraint.shouldBeArchived = constraint.shouldBeArchived;
    newConstraint.identifier = constraint.identifier;
    [NSLayoutConstraint activateConstraints:@[newConstraint]];
}

// 判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile {
    NSString *regex= @"^0?(13[0-9]|14[56789]|15[012356789]|16[6]|17[0-9]|18[0-9]|19[89])[0-9]{8}$";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobile];
    return isMatch;
}

+ (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

// 判断字符串是否为浮点数
+ (BOOL)isPureFloat:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

// 判断是否为整形
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end

//
//  HBK_ RecordManager.m
//  HBK_ Record
//
//  Created by 黄冰珂 on 2018/7/10.
//  Copyright © 2018年 KK. All rights reserved.
//

#import "HBK_ RecordManager.h"

#define COUNTDOWN 60

@interface HBK__RecordManager () {
    NSString    *_filePath;
    NSTimer     *_timer;
    NSInteger   countDown;
}

/* 会话 */
@property (nonatomic, strong) AVAudioSession    *session;
/* 录音器 */
@property (nonatomic, strong) AVAudioRecorder   *recorder;
/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer     *player;
/* 文件地址 */
@property (nonatomic, strong) NSURL             *recordFileUrl;


@end

@implementation HBK__RecordManager


+ (instancetype)shareManager {
    static HBK__RecordManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HBK__RecordManager new];
    });
    return manager;
}

- (void)startRecord {
    countDown = 60;
    [self addTimer];
    self.session = [AVAudioSession sharedInstance];
    NSError *error;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (self.session == nil) {
        NSLog(@"session有错误: %@", error.description);
    } else {
        [self.session setActive:YES error:&error];
    }
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    _filePath = [path stringByAppendingString:@"/Record.wav"];
    NSLog(@"--%@", _filePath);
    self.recordFileUrl = [NSURL fileURLWithPath:_filePath];
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:AVAudioQualityHigh], AVEncoderAudioQualityKey,
                                   nil];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:&error];
    if (self.recorder == nil) {
        NSLog(@"recorder错误: %@", error.description);
    } else {
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
        [self.recorder record];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopRecord];
        });
    }
    
}

- (void)stopRecord {
    [self removeTimer];
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_filePath]) {
        NSString *text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",COUNTDOWN - (long)countDown,[[fileManager attributesOfItemAtPath:_filePath error:nil] fileSize]/1024.0];
        NSLog(@"%@", text);
    } else {
        NSLog(@"最多只能录60秒");
    }
}

- (void)playRecord {
    [self.recorder stop];
    if ([self.player isPlaying]) return;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}



- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}


- (void)timerAction {
    countDown--;
}

@end

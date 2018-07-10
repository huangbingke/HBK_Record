//
//  HBK_ RecordManager.h
//  HBK_ Record
//
//  Created by 黄冰珂 on 2018/7/10.
//  Copyright © 2018年 KK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// 音频录制状态
typedef NS_ENUM(NSInteger, AudioRecordState) {
    AudioRecordStateNormal = 0,     // 初始状态
    AudioRecordStateRecording,      // 正在录音
    AudioRecordStateEnd,            // 录音完成
    AudioRecordStateRecordToShort,  // 录音时间太短（录音结束了）
};

@interface HBK__RecordManager : NSObject


+ (instancetype)shareManager;

/**
 开始录音
 */
- (void)startRecord;

/**
 停止录音
 */
- (void)stopRecord;

/**
 播放录音
 */
- (void)playRecord;


@end

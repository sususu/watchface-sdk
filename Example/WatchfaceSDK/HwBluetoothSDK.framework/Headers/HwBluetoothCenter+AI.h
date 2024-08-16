//
//  HwBluetoothCenter+Expand.h
//  HwBluetooth
//
//  Created by Su on 2018/4/5.
//  Copyright © 2021年 huawo. All rights reserved.
//

#import "HwBluetoothCenter.h"
#import "HwBluetoothDeviceRequestManager.h"

@interface HwBluetoothCenter (AI)

- (HwBluetoothTask *_Nullable)setAppStatus:(HwAppState)appStatus;

- (HwBluetoothTask *_Nullable) setStartRecordingResultWithCode:(int)code 
                                                        andMsg:(NSString *_Nullable)msg;

- (HwBluetoothTask *_Nullable) setEndRecordingResultWithCode:(int)code 
                                                      andMsg:(NSString *_Nullable)msg;

- (void) setRecordToTextResultWithResult:(NSString *_Nullable)result
                                    code:(int)code
                                  andMsg:(NSString *_Nullable)msg;

- (void) setAiAnswerResultWithResult:(NSString *_Nullable)result
                                code:(int)code
                              andMsg:(NSString *_Nullable)msg;

- (HwBluetoothTask *_Nullable) setAiWatchfaceResultWithWatchfaceName:(NSString *_Nullable)watchfaceName
                                                                code:(int)code
                                                              andMsg:(NSString *_Nullable)msg;

- (void) addAiWatchfaceEnterOrExitListener:(HwAiWatchfaceEnterOrExitCallback _Nonnull)callback;
- (void) removeAiWatchfaceEnterOrExitListener:(HwAiWatchfaceEnterOrExitCallback _Nonnull)callback;
- (void) removeAllAiWatchfaceEnterOrExitListeners;

- (void) addAiAnswerEnterOrExitListener:(HwAiAnswerEnterOrExitCallback _Nonnull)callback;
- (void) removeAiAnswerEnterOrExitListener:(HwAiAnswerEnterOrExitCallback _Nonnull)callback;
- (void) removeAllAiAnswerEnterOrExitListeners;

- (void) addAppStatusRequestListener:(HwAppStatusRequestCallback _Nonnull)callback;
- (void) removeAppStatusRequestListener:(HwAppStatusRequestCallback _Nonnull)callback;
- (void) removeAllAppStatusRequestListeners;

- (void) addStartRecordingRequestListener:(HwStartRecordingCallback _Nonnull)callback;
- (void) removeStartRecordingRequestListener:(HwStartRecordingCallback _Nonnull)callback;
- (void) removeAllStartRecordingRequestListeners;

- (void) addEndRecordingRequestListener:(HwEndRecordingCallback _Nonnull)callback;
- (void) removeEndRecordingRequestListener:(HwEndRecordingCallback _Nonnull)callback;
- (void) removeAllEndRecordingRequestListeners;

- (void) addGenerateAiWatchfaceRequestListener:(HwGenerateAiWatchfaceRequestCallback _Nonnull)callback;
- (void) removeGenerateAiWatchfaceRequestListener:(HwGenerateAiWatchfaceRequestCallback _Nonnull)callback;
- (void) removeAllGenerateAiWatchfaceRequestListeners;

- (void) addGenerateAiAnswerRequestListener:(HwGenerateAiAnswerRequestCallback _Nonnull)callback;
- (void) removeGenerateAiAnswerRequestListener:(HwGenerateAiAnswerRequestCallback _Nonnull)callback;
- (void) removeAllGenerateAiAnswerRequestListeners;


@end

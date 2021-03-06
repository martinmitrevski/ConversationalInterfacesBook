#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "util.h"
#import "Wit.h"
#import "WITCircleLayer.h"
#import "WITCircleView.h"
#import "WITContextSetter.h"
#import "WITCvad.h"
#import "WITMicButton.h"
#import "WitPrivate.h"
#import "WITRecorder.h"
#import "WITRecordingSession.h"
#import "WITRecordingSessionDelegate.h"
#import "WitSession.h"
#import "WITSFSpeechRecordingSession.h"
#import "WITState.h"
#import "WITUploader.h"
#import "WITVad.h"
#import "WITVadConfig.h"
#import "WITVadSimple.h"
#import "WITVadTracker.h"

FOUNDATION_EXPORT double WitVersionNumber;
FOUNDATION_EXPORT const unsigned char WitVersionString[];


//
//  iSpeechSDK+PaidFeatures.h
//  iSpeechSDK
//
//  Copyright (c) 2012 iSpeech, Inc. All rights reserved.
//

#import "iSpeechSDK.h"
#import "ISSpeechRecognition.h"
#import "ISSpeechSynthesis.h"

@interface iSpeechSDK (PaidFeatures)

/** @name Paid SDK Methods */

/**
 * Whether the SDK should display dialogs when doing speech recognition or speech synthesis. By default, dialogs are displayed (`YES`).
 */
@property (nonatomic, assign) BOOL displaysDialogs;

/**
 * Whether the SDK should play audio prompts when speech recognition starts and stops recording audio. By default, prompts will play (`YES`).
 */
@property (nonatomic, assign) BOOL playsPrompts;

@end

/** Protocol for receiving recorded audio data. */
@protocol ISSpeechRecognitionDataDelegate <ISSpeechRecognitionDelegate>

@optional

/**
 * Speech recognition has finished recording and is moving on to recognizing the text.
 *
 * This method is called when the timeout is hit for a timed listen, or when the user taps the "Done" button on the dialog. Implement this method instead of `-recognitionDidFinishRecording:` for when you want the audio from the speech recognizer.
 *
 * @param speechRecognition The speech recognition instance that finished recording.
 * @param data The audio recoded from the speech recognizer, as WAV data.
 */
- (void)recognition:(ISSpeechRecognition *)speechRecognition didFinishRecordingWithAudioData:(NSData *)data;

@end

@interface ISSpeechRecognition (PaidFeatures)

/** @name Paid SDK Methods */

/**
 * Returns the level as pulled from the microphone, on a scale of 0.0 to 1.0, or -1.0 if the SDK isn't recording.
 *
 * The meterLevel is the level at that specific point in time. To get it over a period of time, to provide your own level indicator, poll this value. A timeout of 0.02 works well.
 */
@property (nonatomic, assign, readonly) float meterLevel;

@property (nonatomic, unsafe_unretained) id <ISSpeechRecognitionDataDelegate> delegate;

@end

/** Protocol for receiving visemes and downloading synthesis audio data. */
@protocol ISSpeechSynthesisVisemeDataDelegate <ISSpeechSynthesisDelegate>

@optional

/**
 * Visemes have been loaded for a speech synthesis object. 
 *
 * @param synthesis The speech synthesis object that visemes were fetched for.
 * @param visemes An array of `ISViseme` instances for the speech synthesis object.
 */
- (void)synthesis:(ISSpeechSynthesis *)synthesis didFetchVisemes:(NSArray *)visemes;

/**
 * Something went wrong, and visemes weren't fetched.
 * 
 * @param synthesis The speech synthesis object that failed to fetch visemes.
 * @param error The error. Errors from the SDK internals will have the error domain of `iSpeechErrorDomain`. You may get some URL connection errors if something happens with the network.
 */
- (void)synthesis:(ISSpeechSynthesis *)synthesis didFailToFetchVisemesWithError:(NSError *)error;

@end

#ifdef NS_BLOCKS_AVAILABLE

/*^*
 * The callback handler for a viseme fetch request.
 *
 * @param error An error, if one occurred, or `nil`. Errors from the SDK internals will have the error domain of `iSpeechErrorDomain`. You may get some URL connection errors if something happens with the network.
 * @param visemes An array of `ISViseme` instances for the speech synthesis object.
 */
typedef void(^ISSpeechSynthesisVisemeHandler)(NSError *error, NSArray *visemes);

#endif

@interface ISSpeechSynthesis (PaidFeatures)

/** @name Paid SDK Methods */

/**
 * Enable or disable adaptive bitrate.
 *
 * Depending on the network connection (WiFi vs. Cell network), the bitrate for audio files will change to optimize loading performance. Defaulted to enabled (`YES`).
 *
 * @note Adaptive bitrate switches between 24 and 64. Make sure both are enabled in the Developer Control Panel.
 */
@property (nonatomic, assign) BOOL adaptiveBitrateEnabled CONFIGURATION_METHOD;

@property (nonatomic, assign) id <ISSpeechSynthesisVisemeDataDelegate> delegate;

/**
 * Fetches the visemes for this speech synthesis instance.
 *
 * Once fetched, the visemes are passed back to the developer by way of a delegate callback. Implement `-synthesis:didFetchVisemes:` to be notified when visemes have been loaded. Also implement `-synthesis:didFailToFetchVisemesWithError:` to handle errors when fetching the visemes.
 */
- (void)fetchVisemes;

#ifdef NS_BLOCKS_AVAILABLE

/**
 * Fetches the visemes for this speech synthesis instance.
 *
 * @param handler The `ISSpeechSynthesisVisemeHandler` block that will be executed on the main thread when visemes are fetched, or when an error occurs.
 */
- (void)fetchVisemesWithHandler:(ISSpeechSynthesisVisemeHandler)handler;

#endif

@end
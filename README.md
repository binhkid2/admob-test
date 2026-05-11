# AdMob SwiftUI Demo

Small SwiftUI app showing three Google AdMob ad types:

- Banner ads with a `UIViewRepresentable` wrapper around `BannerView`
- Interstitial ads with async preload, present, dismiss, and reload flow
- Native advanced ads with `AdLoader` and a custom `NativeAdView`

## Setup

1. Open `admob-test.xcodeproj` in Xcode.
2. Let Swift Package Manager resolve `GoogleMobileAds`.
3. Build and run on a simulator or device.

The project uses Google's official test IDs in `AdMobDemoIDs.swift`, so it is safe for development. Replace those IDs with your own AdMob app ID and ad unit IDs before shipping.

## How It Works

- `admob_testApp.swift` starts the Mobile Ads SDK.
- `Info.plist` includes `GADApplicationIdentifier` and SKAdNetwork entries.
- `ContentView.swift` shows a tab for each ad type.

## Reusable Files

- `AdMobBannerView.swift`: `AdMobBannerView(adUnitID: "your-banner-id")`
- `AdMobInterstitialController.swift`: create with `AdMobInterstitialController(adUnitID: "your-interstitial-id")`
- `AdMobNativeAdController.swift`: loads native ads with your native ad unit ID
- `AdMobNativeAdvancedAdView.swift`: renders a loaded native ad

The `*DemoView.swift` files are only examples of how to use those reusable pieces.

## Verify

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project admob-test.xcodeproj -scheme admob-test -destination 'generic/platform=iOS Simulator' build
```

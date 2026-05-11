import Combine
import GoogleMobileAds
import UIKit

@MainActor
final class AdMobNativeAdController: NSObject, ObservableObject {
    @Published private(set) var nativeAd: NativeAd?
    @Published private(set) var status: String

    private let adUnitID: String
    private let loadingStatus: String
    private var adLoader: AdLoader?

    init(adUnitID: String, loadingStatus: String = "Loading native ad...") {
        self.adUnitID = adUnitID
        self.loadingStatus = loadingStatus
        self.status = loadingStatus
        super.init()
    }

    func refreshAd(rootViewController: UIViewController? = nil) {
        nativeAd = nil
        status = loadingStatus

        let adLoader = AdLoader(
            adUnitID: adUnitID,
            rootViewController: rootViewController,
            adTypes: [.native],
            options: nil
        )
        adLoader.delegate = self
        self.adLoader = adLoader
        adLoader.load(Request())
    }
}

extension AdMobNativeAdController: NativeAdLoaderDelegate, NativeAdDelegate {
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        nativeAd.delegate = self
        self.nativeAd = nativeAd
        status = "Native ad loaded."
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        nativeAd = nil
        status = "Native ad failed to load: \(error.localizedDescription)"
    }

    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("Native ad recorded a click.")
    }

    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("Native ad recorded an impression.")
    }
}

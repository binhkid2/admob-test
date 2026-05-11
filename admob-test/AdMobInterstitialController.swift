import Combine
import GoogleMobileAds
import UIKit

@MainActor
final class AdMobInterstitialController: NSObject, ObservableObject {
    @Published private(set) var isReady = false
    @Published private(set) var status: String

    private let adUnitID: String
    private let loadingStatus: String
    private var interstitialAd: InterstitialAd?

    init(adUnitID: String, loadingStatus: String = "Loading interstitial...") {
        self.adUnitID = adUnitID
        self.loadingStatus = loadingStatus
        self.status = loadingStatus
        super.init()
    }

    func loadAd() async {
        isReady = false
        status = loadingStatus

        do {
            let ad = try await InterstitialAd.load(
                with: adUnitID,
                request: Request()
            )
            interstitialAd = ad
            interstitialAd?.fullScreenContentDelegate = self
            isReady = true
            status = "Interstitial loaded and ready."
        } catch {
            interstitialAd = nil
            status = "Interstitial failed to load: \(error.localizedDescription)"
        }
    }

    func showAd(from rootViewController: UIViewController? = nil) {
        guard let interstitialAd else {
            status = "Interstitial is not ready yet."
            return
        }

        interstitialAd.present(from: rootViewController)
    }

    private func clearAndReload(status: String) {
        interstitialAd = nil
        isReady = false
        self.status = status

        Task {
            await loadAd()
        }
    }
}

extension AdMobInterstitialController: FullScreenContentDelegate {
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("Interstitial recorded an impression.")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("Interstitial recorded a click.")
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        status = "Interstitial is presenting."
    }

    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        clearAndReload(status: "Interstitial failed to present: \(error.localizedDescription)")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        clearAndReload(status: "Interstitial dismissed. Loading another...")
    }
}

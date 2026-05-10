import Combine
import GoogleMobileAds
import SwiftUI

struct InterstitialAdDemoView: View {
    @StateObject private var interstitial = InterstitialAdController()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Interstitial")
                        .font(.title2.weight(.semibold))

                    Text("Load full-screen ads before a natural pause, then present only after the user finishes an action.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 14) {
                    Image(systemName: interstitial.isReady ? "checkmark.circle.fill" : "clock.badge")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(interstitial.isReady ? .green : .orange)

                    Text(interstitial.status)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                Button {
                    interstitial.showAd()
                } label: {
                    Label("Show Interstitial", systemImage: "play.rectangle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!interstitial.isReady)

                Button {
                    Task {
                        await interstitial.loadAd()
                    }
                } label: {
                    Label("Reload Ad", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Interstitial Ads")
            .task {
                await interstitial.loadAd()
            }
        }
    }
}

final class InterstitialAdController: NSObject, ObservableObject {
    @Published private(set) var isReady = false
    @Published private(set) var status = "Loading test interstitial..."

    private var interstitialAd: InterstitialAd?

    func loadAd() async {
        isReady = false
        status = "Loading test interstitial..."

        do {
            let ad = try await InterstitialAd.load(
                with: AdMobDemoIDs.interstitial,
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

    func showAd() {
        guard let interstitialAd else {
            status = "Interstitial is not ready yet."
            return
        }

        interstitialAd.present(from: nil)
    }
}

extension InterstitialAdController: FullScreenContentDelegate {
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
        interstitialAd = nil
        isReady = false
        status = "Interstitial failed to present: \(error.localizedDescription)"
        Task {
            await loadAd()
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        interstitialAd = nil
        isReady = false
        status = "Interstitial dismissed. Loading another..."
        Task {
            await loadAd()
        }
    }
}

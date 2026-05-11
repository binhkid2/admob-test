import SwiftUI

struct InterstitialAdDemoView: View {
    @StateObject private var interstitial = AdMobInterstitialController(
        adUnitID: AdMobDemoIDs.interstitial
    )

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

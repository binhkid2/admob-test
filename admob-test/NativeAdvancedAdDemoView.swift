import SwiftUI

struct NativeAdvancedAdDemoView: View {
    @StateObject private var nativeAd = AdMobNativeAdController(
        adUnitID: AdMobDemoIDs.nativeAdvanced
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Native Advanced")
                            .font(.title2.weight(.semibold))

                        Text("Native ads are loaded as ad assets and rendered in a custom view registered with Google Mobile Ads.")
                            .foregroundStyle(.secondary)
                    }

                    AdMobNativeAdvancedAdView(nativeAd: nativeAd.nativeAd)
                        .frame(minHeight: 360)
                        .overlay {
                            if nativeAd.nativeAd == nil {
                                ProgressView(nativeAd.status)
                                    .padding()
                            }
                        }

                    Button {
                        nativeAd.refreshAd()
                    } label: {
                        Label("Refresh Native Ad", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Native Advanced Ads")
            .task {
                nativeAd.refreshAd()
            }
        }
    }
}

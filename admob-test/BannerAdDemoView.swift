import SwiftUI

struct BannerAdDemoView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Anchored Adaptive Banner")
                        .font(.title2.weight(.semibold))

                    Text("This demo uses Google's iOS banner test ad unit and sizes itself from the available SwiftUI width.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                Spacer()

                AdMobBannerView(adUnitID: AdMobDemoIDs.banner)
                    .padding(.bottom, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Banner Ads")
        }
    }
}

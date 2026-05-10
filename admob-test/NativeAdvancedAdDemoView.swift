import Combine
import GoogleMobileAds
import SwiftUI
import UIKit

struct NativeAdvancedAdDemoView: View {
    @StateObject private var nativeAd = NativeAdController()

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

                    NativeAdvancedAdView(nativeAd: nativeAd.nativeAd)
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

final class NativeAdController: NSObject, ObservableObject {
    @Published private(set) var nativeAd: NativeAd?
    @Published private(set) var status = "Loading test native ad..."

    private var adLoader: AdLoader?

    func refreshAd() {
        nativeAd = nil
        status = "Loading test native ad..."

        let adLoader = AdLoader(
            adUnitID: AdMobDemoIDs.nativeAdvanced,
            rootViewController: nil,
            adTypes: [.native],
            options: nil
        )
        adLoader.delegate = self
        self.adLoader = adLoader
        adLoader.load(Request())
    }
}

extension NativeAdController: NativeAdLoaderDelegate, NativeAdDelegate {
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

private struct NativeAdvancedAdView: UIViewRepresentable {
    let nativeAd: NativeAd?

    func makeUIView(context: Context) -> NativeAdCardView {
        NativeAdCardView()
    }

    func updateUIView(_ nativeAdView: NativeAdCardView, context: Context) {
        nativeAdView.populate(with: nativeAd)
    }
}

private final class NativeAdCardView: NativeAdView {
    private let adBadgeLabel = UILabel()
    private let headlineLabel = UILabel()
    private let bodyLabel = UILabel()
    private let advertiserLabel = UILabel()
    private let iconImageView = UIImageView()
    private let mediaAdView = MediaView()
    private let callToActionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        registerAssetViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(with nativeAd: NativeAd?) {
        guard let nativeAd else {
            self.nativeAd = nil
            return
        }

        headlineLabel.text = nativeAd.headline
        mediaAdView.mediaContent = nativeAd.mediaContent

        bodyLabel.text = nativeAd.body
        bodyLabel.isHidden = nativeAd.body == nil

        iconImageView.image = nativeAd.icon?.image
        iconImageView.isHidden = nativeAd.icon == nil

        advertiserLabel.text = nativeAd.advertiser
        advertiserLabel.isHidden = nativeAd.advertiser == nil

        callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
        callToActionButton.isHidden = nativeAd.callToAction == nil
        callToActionButton.isUserInteractionEnabled = false

        self.nativeAd = nativeAd
    }

    private func configureView() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true

        adBadgeLabel.text = "Ad"
        adBadgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        adBadgeLabel.textColor = .white
        adBadgeLabel.textAlignment = .center
        adBadgeLabel.backgroundColor = .systemOrange
        adBadgeLabel.layer.cornerRadius = 4
        adBadgeLabel.layer.masksToBounds = true

        headlineLabel.font = .preferredFont(forTextStyle: .headline)
        headlineLabel.numberOfLines = 2

        bodyLabel.font = .preferredFont(forTextStyle: .subheadline)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 3

        advertiserLabel.font = .preferredFont(forTextStyle: .caption1)
        advertiserLabel.textColor = .secondaryLabel

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 8
        iconImageView.layer.masksToBounds = true

        mediaAdView.contentMode = .scaleAspectFill
        mediaAdView.backgroundColor = .tertiarySystemGroupedBackground
        mediaAdView.layer.cornerRadius = 8
        mediaAdView.layer.masksToBounds = true

        callToActionButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        callToActionButton.backgroundColor = .systemBlue
        callToActionButton.tintColor = .white
        callToActionButton.layer.cornerRadius = 8

        let textStack = UIStackView(arrangedSubviews: [adBadgeLabel, headlineLabel, advertiserLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 4

        let headerStack = UIStackView(arrangedSubviews: [iconImageView, textStack])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 12

        let contentStack = UIStackView(arrangedSubviews: [
            headerStack,
            mediaAdView,
            bodyLabel,
            callToActionButton
        ])
        contentStack.axis = .vertical
        contentStack.spacing = 14
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            adBadgeLabel.widthAnchor.constraint(equalToConstant: 32),
            adBadgeLabel.heightAnchor.constraint(equalToConstant: 18),

            iconImageView.widthAnchor.constraint(equalToConstant: 52),
            iconImageView.heightAnchor.constraint(equalToConstant: 52),

            mediaAdView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
            callToActionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func registerAssetViews() {
        headlineView = headlineLabel
        bodyView = bodyLabel
        advertiserView = advertiserLabel
        iconView = iconImageView
        mediaView = mediaAdView
        callToActionView = callToActionButton
    }
}

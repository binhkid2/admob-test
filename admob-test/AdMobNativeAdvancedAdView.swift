import GoogleMobileAds
import SwiftUI
import UIKit

struct AdMobNativeAdvancedAdView: UIViewRepresentable {
    let nativeAd: NativeAd?

    func makeUIView(context: Context) -> AdMobNativeAdCardView {
        AdMobNativeAdCardView()
    }

    func updateUIView(_ nativeAdView: AdMobNativeAdCardView, context: Context) {
        nativeAdView.populate(with: nativeAd)
    }
}

final class AdMobNativeAdCardView: NativeAdView {
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

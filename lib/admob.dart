import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobHelper {
  static String get bannerID => 'ca-app-pub-3851063543965812/3020686211';
  RewardedAd rewardedAd;
  static initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

   BannerAd getBannerAd() {
    BannerAd bAd = new BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerID,
        listener: BannerAdListener(onAdClosed: (Ad ad) {
          print("Ad Closed");
        }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        }, onAdLoaded: (Ad ad) {
          print('Ad Loaded');
        }, onAdOpened: (Ad ad) {
          print('Ad opened');
        }),
        request: AdRequest());

    return bAd;
  }

  void createRewardAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3851063543965812/3650762671',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            this.rewardedAd = ad;
            showRewardAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }

   showRewardAd() {
    rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
      print("Adds Reward is ${rewardItem.amount}");
    });
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );
  }
}

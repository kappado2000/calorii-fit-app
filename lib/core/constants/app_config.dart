/// Phase 1: calling the deployed Cloud Function directly over HTTPS using
/// the plain callable-function wire protocol, without pulling in the full
/// Firebase SDK yet (no Auth/Firestore until Phase 2 — see project plan).
class AppConfig {
  AppConfig._();

  static const String analyzePhotoUrl =
      'https://europe-west1-calorii-fit-app.cloudfunctions.net/analyzePhoto';

  static const String searchFoodsUrl =
      'https://europe-west1-calorii-fit-app.cloudfunctions.net/searchFoods';

  static const String lookupBarcodeUrl =
      'https://europe-west1-calorii-fit-app.cloudfunctions.net/lookupBarcode';

  static const String aiFoodLookupUrl =
      'https://europe-west1-calorii-fit-app.cloudfunctions.net/aiFoodLookup';

  static const String activateAdminUrl =
      'https://europe-west1-calorii-fit-app.cloudfunctions.net/activateAdmin';

  static const String generatePremiumCodeUrl =
      'https://europe-west1-calorii-fit-app.cloudfunctions.net/generatePremiumCode';

  static const String redeemPremiumCodeUrl =
      'https://europe-west1-calorii-fit-app.cloudfunctions.net/redeemPremiumCode';
}

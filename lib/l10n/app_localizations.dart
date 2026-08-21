import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hu'),
    Locale('it'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('sv'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ro, this message translates to:
  /// **'Calorii Fit'**
  String get appTitle;

  /// No description provided for @dailyReminderTitle.
  ///
  /// In ro, this message translates to:
  /// **'Nu uita să-ți loghezi mesele'**
  String get dailyReminderTitle;

  /// No description provided for @dailyReminderBody.
  ///
  /// In ro, this message translates to:
  /// **'Câteva secunde acum îți țin jurnalul la zi și streak-ul viu.'**
  String get dailyReminderBody;

  /// No description provided for @dailyReminderChannelName.
  ///
  /// In ro, this message translates to:
  /// **'Memento zilnic'**
  String get dailyReminderChannelName;

  /// No description provided for @dailyReminderChannelDescription.
  ///
  /// In ro, this message translates to:
  /// **'Memento să-ți loghezi mesele din ziua curentă'**
  String get dailyReminderChannelDescription;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In ro, this message translates to:
  /// **'E nevoie de o actualizare'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In ro, this message translates to:
  /// **'Versiunea aplicației de pe acest telefon nu mai este suportată. Instalează cea mai nouă versiune pentru a continua.'**
  String get updateRequiredMessage;

  /// No description provided for @updateAvailableMessage.
  ///
  /// In ro, this message translates to:
  /// **'O versiune nouă a aplicației este disponibilă.'**
  String get updateAvailableMessage;

  /// No description provided for @hydrationTitle.
  ///
  /// In ro, this message translates to:
  /// **'Hidratare'**
  String get hydrationTitle;

  /// No description provided for @hydrationUndoLastGlass.
  ///
  /// In ro, this message translates to:
  /// **'Anulează ultimul pahar'**
  String get hydrationUndoLastGlass;

  /// No description provided for @hydrationAddGlass.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă un pahar ({ml} ml)'**
  String hydrationAddGlass(int ml);

  /// No description provided for @adaptiveTdeeTitle.
  ///
  /// In ro, this message translates to:
  /// **'TDEE adaptiv'**
  String get adaptiveTdeeTitle;

  /// No description provided for @adaptiveTdeeNotEnoughData.
  ///
  /// In ro, this message translates to:
  /// **'Încă nu ai suficiente date: îți trebuie cel puțin 14 zile logate și 2 cântăriri la minim 10 zile distanță, în ultimele 3 săptămâni. Până atunci se folosește formula standard (Mifflin-St Jeor).'**
  String get adaptiveTdeeNotEnoughData;

  /// No description provided for @adaptiveTdeeExplanation.
  ///
  /// In ro, this message translates to:
  /// **'Calculat din propriul tău echilibru caloric ({loggedDays}/{windowDays} zile logate în ultimele 3 săptămâni), nu doar din formula standard.'**
  String adaptiveTdeeExplanation(int loggedDays, int windowDays);

  /// No description provided for @adaptiveTdeeEstimatedLabel.
  ///
  /// In ro, this message translates to:
  /// **'TDEE estimat'**
  String get adaptiveTdeeEstimatedLabel;

  /// No description provided for @adaptiveTdeeWeightTrendLabel.
  ///
  /// In ro, this message translates to:
  /// **'Trend greutate'**
  String get adaptiveTdeeWeightTrendLabel;

  /// No description provided for @weightTrendValue.
  ///
  /// In ro, this message translates to:
  /// **'{sign}{value} kg/săpt.'**
  String weightTrendValue(String sign, String value);

  /// No description provided for @adaptiveTdeeRejected.
  ///
  /// In ro, this message translates to:
  /// **'Estimarea diferă prea mult de formula standard ca să fie de încredere încă — se folosește în continuare formula standard, până se adună mai multe date consistente.'**
  String get adaptiveTdeeRejected;

  /// No description provided for @weeklySummaryTitle.
  ///
  /// In ro, this message translates to:
  /// **'Rezumatul săptămânii'**
  String get weeklySummaryTitle;

  /// No description provided for @weeklySummaryDaysLogged.
  ///
  /// In ro, this message translates to:
  /// **'Zile logate'**
  String get weeklySummaryDaysLogged;

  /// No description provided for @weeklySummaryAvgCalories.
  ///
  /// In ro, this message translates to:
  /// **'Medie kcal/zi'**
  String get weeklySummaryAvgCalories;

  /// No description provided for @weeklySummaryWorkouts.
  ///
  /// In ro, this message translates to:
  /// **'Antrenamente'**
  String get weeklySummaryWorkouts;

  /// No description provided for @weightEvolutionTitle.
  ///
  /// In ro, this message translates to:
  /// **'Evoluția greutății'**
  String get weightEvolutionTitle;

  /// No description provided for @weightEvolutionSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'De la {date} ({startKg} kg) până azi ({latestKg} kg)'**
  String weightEvolutionSubtitle(String date, String startKg, String latestKg);

  /// No description provided for @deviceCapabilityTitle.
  ///
  /// In ro, this message translates to:
  /// **'Capabilitate captură adâncime'**
  String get deviceCapabilityTitle;

  /// No description provided for @deviceCapabilityError.
  ///
  /// In ro, this message translates to:
  /// **'Eroare la verificarea capabilităților:\n{error}'**
  String deviceCapabilityError(String error);

  /// No description provided for @depthSourceLidarLabel.
  ///
  /// In ro, this message translates to:
  /// **'LiDAR disponibil'**
  String get depthSourceLidarLabel;

  /// No description provided for @depthSourceArcoreLabel.
  ///
  /// In ro, this message translates to:
  /// **'ARCore Depth disponibil'**
  String get depthSourceArcoreLabel;

  /// No description provided for @depthSourcePortraitLabel.
  ///
  /// In ro, this message translates to:
  /// **'Cameră duală (portrait depth)'**
  String get depthSourcePortraitLabel;

  /// No description provided for @depthSourceReferenceLabel.
  ///
  /// In ro, this message translates to:
  /// **'Fără senzor de adâncime'**
  String get depthSourceReferenceLabel;

  /// No description provided for @depthSourceUnknownLabel.
  ///
  /// In ro, this message translates to:
  /// **'Necunoscut'**
  String get depthSourceUnknownLabel;

  /// No description provided for @depthSourceLidarDescription.
  ///
  /// In ro, this message translates to:
  /// **'Estimare volumetrică de înaltă precizie (~10-15% eroare).'**
  String get depthSourceLidarDescription;

  /// No description provided for @depthSourceArcoreDescription.
  ///
  /// In ro, this message translates to:
  /// **'Estimare volumetrică prin ARCore Depth API.'**
  String get depthSourceArcoreDescription;

  /// No description provided for @depthSourcePortraitDescription.
  ///
  /// In ro, this message translates to:
  /// **'Adâncime aproximativă din camera duală, precizie redusă.'**
  String get depthSourcePortraitDescription;

  /// No description provided for @depthSourceReferenceDescription.
  ///
  /// In ro, this message translates to:
  /// **'Se va folosi diametrul farfuriei ca referință de scară (estimare mai puțin precisă).'**
  String get depthSourceReferenceDescription;

  /// No description provided for @depthSourceUnknownDescription.
  ///
  /// In ro, this message translates to:
  /// **'Nu s-a putut determina capabilitatea device-ului.'**
  String get depthSourceUnknownDescription;

  /// No description provided for @depthSourceLidarShort.
  ///
  /// In ro, this message translates to:
  /// **'LiDAR'**
  String get depthSourceLidarShort;

  /// No description provided for @depthSourceArcoreShort.
  ///
  /// In ro, this message translates to:
  /// **'ARCore Depth'**
  String get depthSourceArcoreShort;

  /// No description provided for @depthSourcePortraitShort.
  ///
  /// In ro, this message translates to:
  /// **'cameră duală'**
  String get depthSourcePortraitShort;

  /// No description provided for @depthSourceReferenceShort.
  ///
  /// In ro, this message translates to:
  /// **'referință vizuală'**
  String get depthSourceReferenceShort;

  /// No description provided for @depthSourceUnknownShort.
  ///
  /// In ro, this message translates to:
  /// **'necunoscut'**
  String get depthSourceUnknownShort;

  /// No description provided for @howItWorksTitle.
  ///
  /// In ro, this message translates to:
  /// **'Cum calculăm caloriile'**
  String get howItWorksTitle;

  /// No description provided for @howItWorksTooltip.
  ///
  /// In ro, this message translates to:
  /// **'Cum calculăm caloriile?'**
  String get howItWorksTooltip;

  /// No description provided for @howItWorksIntro.
  ///
  /// In ro, this message translates to:
  /// **'Majoritatea aplicațiilor de nutriție ghicesc porția dintr-o singură fotografie 2D. Calorii Fit măsoară efectiv volumul mâncării de pe farfurie, folosind harta de adâncime a telefonului tău — de asta estimarea e mai precisă.'**
  String get howItWorksIntro;

  /// No description provided for @howItWorksStep1Title.
  ///
  /// In ro, this message translates to:
  /// **'Fotografiezi farfuria'**
  String get howItWorksStep1Title;

  /// No description provided for @howItWorksStep1Description.
  ///
  /// In ro, this message translates to:
  /// **'O singură poză, fără poziționare specială.'**
  String get howItWorksStep1Description;

  /// No description provided for @howItWorksStep2Title.
  ///
  /// In ro, this message translates to:
  /// **'Telefonul captează adâncimea'**
  String get howItWorksStep2Title;

  /// No description provided for @howItWorksStep2GenericDescription.
  ///
  /// In ro, this message translates to:
  /// **'Telefonul tău folosește LiDAR, ARCore Depth sau camera duală, în funcție de model, ca să știe cât de înaltă e mâncarea, nu doar cum arată de sus.'**
  String get howItWorksStep2GenericDescription;

  /// No description provided for @howItWorksStep3Title.
  ///
  /// In ro, this message translates to:
  /// **'Claude identifică alimentele'**
  String get howItWorksStep3Title;

  /// No description provided for @howItWorksStep3Description.
  ///
  /// In ro, this message translates to:
  /// **'Modelul recunoaște ce e pe farfurie și marchează conturul aproximativ al fiecărui aliment — nu calculează el caloriile, doar identifică.'**
  String get howItWorksStep3Description;

  /// No description provided for @howItWorksStep4Title.
  ///
  /// In ro, this message translates to:
  /// **'Volumul devine grame, apoi calorii'**
  String get howItWorksStep4Title;

  /// No description provided for @howItWorksStep4Description.
  ///
  /// In ro, this message translates to:
  /// **'Harta de adâncime × conturul fiecărui aliment dă un volum în cm³. Un tabel de densități (specific fiecărui tip de aliment) transformă volumul în grame, iar baza de date nutrițională transformă gramele în calorii și macro-nutrienți.'**
  String get howItWorksStep4Description;

  /// No description provided for @howItWorksStep5Title.
  ///
  /// In ro, this message translates to:
  /// **'Tu confirmi sau corectezi'**
  String get howItWorksStep5Title;

  /// No description provided for @howItWorksStep5Description.
  ///
  /// In ro, this message translates to:
  /// **'Estimarea automată nu se salvează niciodată direct — vezi mereu un ecran de confirmare unde poți ajusta porția sau schimba alimentul identificat.'**
  String get howItWorksStep5Description;

  /// No description provided for @howItWorksSeeDeviceMethod.
  ///
  /// In ro, this message translates to:
  /// **'Vezi ce metodă folosește telefonul tău'**
  String get howItWorksSeeDeviceMethod;

  /// No description provided for @howItWorksDepthLidar.
  ///
  /// In ro, this message translates to:
  /// **'Telefonul tău are LiDAR — cea mai precisă metodă disponibilă azi pe un telefon, cu o eroare tipică de doar 10-15%.'**
  String get howItWorksDepthLidar;

  /// No description provided for @howItWorksDepthArcore.
  ///
  /// In ro, this message translates to:
  /// **'Telefonul tău folosește ARCore Depth API pentru a estima adâncimea scenei.'**
  String get howItWorksDepthArcore;

  /// No description provided for @howItWorksDepthPortrait.
  ///
  /// In ro, this message translates to:
  /// **'Telefonul tău estimează adâncimea din camera duală (mod portret) — mai puțin precis decât LiDAR, dar tot mai bun decât o poză simplă.'**
  String get howItWorksDepthPortrait;

  /// No description provided for @howItWorksDepthReference.
  ///
  /// In ro, this message translates to:
  /// **'Telefonul tău nu are senzor de adâncime, așa că folosim diametrul standard al unei farfurii ca referință de scară — cea mai puțin precisă metodă, dar tot mai bună decât o ghicire pur vizuală.'**
  String get howItWorksDepthReference;

  /// No description provided for @howItWorksDepthUnknown.
  ///
  /// In ro, this message translates to:
  /// **'Nu am putut determina metoda folosită de telefonul tău.'**
  String get howItWorksDepthUnknown;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In ro, this message translates to:
  /// **'Permite notificările pentru aplicație din setările telefonului.'**
  String get reminderPermissionDenied;

  /// No description provided for @reminderTimePickerHelp.
  ///
  /// In ro, this message translates to:
  /// **'Ora mementoului'**
  String get reminderTimePickerHelp;

  /// No description provided for @reminderDialogTitle.
  ///
  /// In ro, this message translates to:
  /// **'Memento zilnic'**
  String get reminderDialogTitle;

  /// No description provided for @reminderDailyNotification.
  ///
  /// In ro, this message translates to:
  /// **'Notificare zilnică'**
  String get reminderDailyNotification;

  /// No description provided for @reminderDailyNotificationSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'O rememorare să-ți loghezi mesele'**
  String get reminderDailyNotificationSubtitle;

  /// No description provided for @reminderTimeLabel.
  ///
  /// In ro, this message translates to:
  /// **'Ora'**
  String get reminderTimeLabel;

  /// No description provided for @close.
  ///
  /// In ro, this message translates to:
  /// **'Închide'**
  String get close;

  /// No description provided for @deleteAccountWrongPassword.
  ///
  /// In ro, this message translates to:
  /// **'Parolă greșită.'**
  String get deleteAccountWrongPassword;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In ro, this message translates to:
  /// **'Nu am putut șterge contul ({code}). Încearcă din nou.'**
  String deleteAccountFailed(String code);

  /// No description provided for @deleteAccountFailedGeneric.
  ///
  /// In ro, this message translates to:
  /// **'Nu am putut șterge contul. Încearcă din nou.'**
  String get deleteAccountFailedGeneric;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ro, this message translates to:
  /// **'Ștergere cont'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountExplanation.
  ///
  /// In ro, this message translates to:
  /// **'Se șterg definitiv contul și toate datele tale (profil, jurnal de mese, antrenamente, greutăți, alimente memorate). Acțiunea nu poate fi anulată.'**
  String get deleteAccountExplanation;

  /// No description provided for @password.
  ///
  /// In ro, this message translates to:
  /// **'Parolă'**
  String get password;

  /// No description provided for @cancel.
  ///
  /// In ro, this message translates to:
  /// **'Anulează'**
  String get cancel;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In ro, this message translates to:
  /// **'Șterge definitiv'**
  String get deleteAccountConfirm;

  /// No description provided for @barcodeScanTitle.
  ///
  /// In ro, this message translates to:
  /// **'Scanează codul de bare'**
  String get barcodeScanTitle;

  /// No description provided for @barcodeNotFound.
  ///
  /// In ro, this message translates to:
  /// **'Produsul cu codul {barcode} nu a fost găsit.'**
  String barcodeNotFound(String barcode);

  /// No description provided for @addManually.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă manual'**
  String get addManually;

  /// No description provided for @scanAgain.
  ///
  /// In ro, this message translates to:
  /// **'Scanează din nou'**
  String get scanAgain;

  /// No description provided for @bluetoothScaleTitle.
  ///
  /// In ro, this message translates to:
  /// **'Cântar Bluetooth'**
  String get bluetoothScaleTitle;

  /// No description provided for @bluetoothScaleSearch.
  ///
  /// In ro, this message translates to:
  /// **'Caută cântare'**
  String get bluetoothScaleSearch;

  /// No description provided for @bluetoothScaleIdleHint.
  ///
  /// In ro, this message translates to:
  /// **'Apasă \"Caută cântare\" și pornește-ți cântarul lângă telefon.'**
  String get bluetoothScaleIdleHint;

  /// No description provided for @bluetoothScaleSearching.
  ///
  /// In ro, this message translates to:
  /// **'Se caută...'**
  String get bluetoothScaleSearching;

  /// No description provided for @bluetoothScaleNoneFound.
  ///
  /// In ro, this message translates to:
  /// **'Niciun cântar găsit încă.'**
  String get bluetoothScaleNoneFound;

  /// No description provided for @bluetoothScaleConnecting.
  ///
  /// In ro, this message translates to:
  /// **'Se conectează...'**
  String get bluetoothScaleConnecting;

  /// No description provided for @bluetoothScaleWeightSaved.
  ///
  /// In ro, this message translates to:
  /// **'Greutate salvată.'**
  String get bluetoothScaleWeightSaved;

  /// No description provided for @errorPrefixed.
  ///
  /// In ro, this message translates to:
  /// **'Eroare: {message}'**
  String errorPrefixed(String message);

  /// No description provided for @cameraNoneAvailable.
  ///
  /// In ro, this message translates to:
  /// **'Nicio cameră disponibilă pe acest dispozitiv.'**
  String get cameraNoneAvailable;

  /// No description provided for @cameraCaptureTitle.
  ///
  /// In ro, this message translates to:
  /// **'Fotografiază farfuria'**
  String get cameraCaptureTitle;

  /// No description provided for @cameraCapturingStatus.
  ///
  /// In ro, this message translates to:
  /// **'Se capturează fotografia și adâncimea…'**
  String get cameraCapturingStatus;

  /// No description provided for @cameraAnalyzingStatus.
  ///
  /// In ro, this message translates to:
  /// **'Se identifică alimentele…'**
  String get cameraAnalyzingStatus;

  /// No description provided for @cameraConfirmationOpeningStatus.
  ///
  /// In ro, this message translates to:
  /// **'Gata — se deschide confirmarea…'**
  String get cameraConfirmationOpeningStatus;

  /// No description provided for @cameraStartingStatus.
  ///
  /// In ro, this message translates to:
  /// **'Se pornește camera…'**
  String get cameraStartingStatus;

  /// No description provided for @cameraFrameHint.
  ///
  /// In ro, this message translates to:
  /// **'Încadrează farfuria și apasă declanșatorul'**
  String get cameraFrameHint;

  /// No description provided for @cameraErrorPrefixed.
  ///
  /// In ro, this message translates to:
  /// **'Nu am putut porni/analiza fotografia:\n{message}'**
  String cameraErrorPrefixed(String message);

  /// No description provided for @cameraQuotaExceededMessage.
  ///
  /// In ro, this message translates to:
  /// **'Ai atins limita de 20 de analize foto pe zi. Încearcă din nou mâine.'**
  String get cameraQuotaExceededMessage;

  /// No description provided for @cameraUnauthenticatedMessage.
  ///
  /// In ro, this message translates to:
  /// **'Trebuie să fii autentificat pentru a analiza o fotografie.'**
  String get cameraUnauthenticatedMessage;

  /// No description provided for @cameraNetworkErrorMessage.
  ///
  /// In ro, this message translates to:
  /// **'Nu s-a putut realiza conexiunea. Verifică internetul și încearcă din nou.'**
  String get cameraNetworkErrorMessage;

  /// No description provided for @retry.
  ///
  /// In ro, this message translates to:
  /// **'Încearcă din nou'**
  String get retry;

  /// No description provided for @authEnterEmailFirst.
  ///
  /// In ro, this message translates to:
  /// **'Introdu emailul mai întâi, ca să-ți trimitem linkul de resetare.'**
  String get authEnterEmailFirst;

  /// No description provided for @authPasswordResetSent.
  ///
  /// In ro, this message translates to:
  /// **'Ți-am trimis un email de resetare a parolei.'**
  String get authPasswordResetSent;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In ro, this message translates to:
  /// **'Adresă de email invalidă.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In ro, this message translates to:
  /// **'Nu există niciun cont cu acest email.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongCredentials.
  ///
  /// In ro, this message translates to:
  /// **'Email sau parolă greșită.'**
  String get authErrorWrongCredentials;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In ro, this message translates to:
  /// **'Există deja un cont cu acest email.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In ro, this message translates to:
  /// **'Parola e prea slabă (minim 6 caractere).'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorGeneric.
  ///
  /// In ro, this message translates to:
  /// **'A apărut o eroare. Încearcă din nou.'**
  String get authErrorGeneric;

  /// No description provided for @authWelcomeBack.
  ///
  /// In ro, this message translates to:
  /// **'Bine ai revenit'**
  String get authWelcomeBack;

  /// No description provided for @authLetsStart.
  ///
  /// In ro, this message translates to:
  /// **'Hai să începem'**
  String get authLetsStart;

  /// No description provided for @email.
  ///
  /// In ro, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @authEnterValidEmail.
  ///
  /// In ro, this message translates to:
  /// **'Introdu un email valid'**
  String get authEnterValidEmail;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In ro, this message translates to:
  /// **'Minim 6 caractere'**
  String get authPasswordMinLength;

  /// No description provided for @authSignIn.
  ///
  /// In ro, this message translates to:
  /// **'Autentificare'**
  String get authSignIn;

  /// No description provided for @authCreateAccount.
  ///
  /// In ro, this message translates to:
  /// **'Creează cont'**
  String get authCreateAccount;

  /// No description provided for @authNoAccountYet.
  ///
  /// In ro, this message translates to:
  /// **'Nu ai cont? Creează unul'**
  String get authNoAccountYet;

  /// No description provided for @authHaveAccountAlready.
  ///
  /// In ro, this message translates to:
  /// **'Ai deja cont? Autentifică-te'**
  String get authHaveAccountAlready;

  /// No description provided for @authForgotPassword.
  ///
  /// In ro, this message translates to:
  /// **'Ai uitat parola?'**
  String get authForgotPassword;

  /// No description provided for @activityWalkingCasual.
  ///
  /// In ro, this message translates to:
  /// **'Mers pe jos (lejer)'**
  String get activityWalkingCasual;

  /// No description provided for @activityWalkingBrisk.
  ///
  /// In ro, this message translates to:
  /// **'Mers pe jos (alert)'**
  String get activityWalkingBrisk;

  /// No description provided for @activityRunning.
  ///
  /// In ro, this message translates to:
  /// **'Alergare'**
  String get activityRunning;

  /// No description provided for @activityRunningFast.
  ///
  /// In ro, this message translates to:
  /// **'Alergare rapidă'**
  String get activityRunningFast;

  /// No description provided for @activityCycling.
  ///
  /// In ro, this message translates to:
  /// **'Ciclism (moderat)'**
  String get activityCycling;

  /// No description provided for @activityCyclingIntense.
  ///
  /// In ro, this message translates to:
  /// **'Ciclism (intens)'**
  String get activityCyclingIntense;

  /// No description provided for @activitySwimming.
  ///
  /// In ro, this message translates to:
  /// **'Înot'**
  String get activitySwimming;

  /// No description provided for @activityStrengthTraining.
  ///
  /// In ro, this message translates to:
  /// **'Antrenament de forță'**
  String get activityStrengthTraining;

  /// No description provided for @activityYoga.
  ///
  /// In ro, this message translates to:
  /// **'Yoga'**
  String get activityYoga;

  /// No description provided for @activityDancing.
  ///
  /// In ro, this message translates to:
  /// **'Dans'**
  String get activityDancing;

  /// No description provided for @activityHiking.
  ///
  /// In ro, this message translates to:
  /// **'Drumeție'**
  String get activityHiking;

  /// No description provided for @activityJumpRope.
  ///
  /// In ro, this message translates to:
  /// **'Sărit coarda'**
  String get activityJumpRope;

  /// No description provided for @activityFootball.
  ///
  /// In ro, this message translates to:
  /// **'Fotbal'**
  String get activityFootball;

  /// No description provided for @activityBasketball.
  ///
  /// In ro, this message translates to:
  /// **'Baschet'**
  String get activityBasketball;

  /// No description provided for @activityTennis.
  ///
  /// In ro, this message translates to:
  /// **'Tenis'**
  String get activityTennis;

  /// No description provided for @activityOther.
  ///
  /// In ro, this message translates to:
  /// **'Altă activitate'**
  String get activityOther;

  /// No description provided for @mealBreakfast.
  ///
  /// In ro, this message translates to:
  /// **'Dimineață'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In ro, this message translates to:
  /// **'Prânz'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In ro, this message translates to:
  /// **'Seară'**
  String get mealDinner;

  /// No description provided for @mealSnack.
  ///
  /// In ro, this message translates to:
  /// **'Gustare'**
  String get mealSnack;

  /// No description provided for @addWorkoutTitle.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă activitate sportivă'**
  String get addWorkoutTitle;

  /// No description provided for @addWorkoutFromActivity.
  ///
  /// In ro, this message translates to:
  /// **'Din activitate'**
  String get addWorkoutFromActivity;

  /// No description provided for @addWorkoutDirectCalories.
  ///
  /// In ro, this message translates to:
  /// **'Calorii directe'**
  String get addWorkoutDirectCalories;

  /// No description provided for @addWorkoutActivityTypeOptional.
  ///
  /// In ro, this message translates to:
  /// **'Tip activitate (opțional)'**
  String get addWorkoutActivityTypeOptional;

  /// No description provided for @addWorkoutCaloriesBurned.
  ///
  /// In ro, this message translates to:
  /// **'Calorii arse'**
  String get addWorkoutCaloriesBurned;

  /// No description provided for @addWorkoutCaloriesHint.
  ///
  /// In ro, this message translates to:
  /// **'ex. 250'**
  String get addWorkoutCaloriesHint;

  /// No description provided for @save.
  ///
  /// In ro, this message translates to:
  /// **'Salvează'**
  String get save;

  /// No description provided for @addWorkoutActivityType.
  ///
  /// In ro, this message translates to:
  /// **'Tip activitate'**
  String get addWorkoutActivityType;

  /// No description provided for @addWorkoutDuration.
  ///
  /// In ro, this message translates to:
  /// **'Durată'**
  String get addWorkoutDuration;

  /// No description provided for @minutes.
  ///
  /// In ro, this message translates to:
  /// **'minute'**
  String get minutes;

  /// No description provided for @addWorkoutEstimate.
  ///
  /// In ro, this message translates to:
  /// **'Estimare: {kcal} kcal arse'**
  String addWorkoutEstimate(int kcal);

  /// No description provided for @confirmFoodsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Confirmă alimentele'**
  String get confirmFoodsTitle;

  /// No description provided for @mealLabel.
  ///
  /// In ro, this message translates to:
  /// **'Masă:'**
  String get mealLabel;

  /// No description provided for @mixedPlateWarning.
  ///
  /// In ro, this message translates to:
  /// **'Farfurie cu alimente amestecate — verifică fiecare element, identificarea poate fi mai puțin precisă.'**
  String get mixedPlateWarning;

  /// No description provided for @noItemsLeft.
  ///
  /// In ro, this message translates to:
  /// **'Ai eliminat toate elementele identificate. Fotografiază din nou dacă vrei să reîncerci.'**
  String get noItemsLeft;

  /// No description provided for @portionSmall.
  ///
  /// In ro, this message translates to:
  /// **'Mic'**
  String get portionSmall;

  /// No description provided for @portionMedium.
  ///
  /// In ro, this message translates to:
  /// **'Mediu'**
  String get portionMedium;

  /// No description provided for @portionLarge.
  ///
  /// In ro, this message translates to:
  /// **'Mare'**
  String get portionLarge;

  /// No description provided for @notOnPlateRemove.
  ///
  /// In ro, this message translates to:
  /// **'Nu e pe farfurie — elimină'**
  String get notOnPlateRemove;

  /// No description provided for @roughEstimateNote.
  ///
  /// In ro, this message translates to:
  /// **'Estimare aproximativă ({source}, fără senzor de adâncime)'**
  String roughEstimateNote(String source);

  /// No description provided for @realNutritionDataBadge.
  ///
  /// In ro, this message translates to:
  /// **'date reale'**
  String get realNutritionDataBadge;

  /// No description provided for @totalCalories.
  ///
  /// In ro, this message translates to:
  /// **'Total: {kcal} kcal'**
  String totalCalories(int kcal);

  /// No description provided for @activityLevelSedentary.
  ///
  /// In ro, this message translates to:
  /// **'Sedentar (muncă de birou, fără sport)'**
  String get activityLevelSedentary;

  /// No description provided for @activityLevelLight.
  ///
  /// In ro, this message translates to:
  /// **'Activitate ușoară (sport 1-3 zile/săpt.)'**
  String get activityLevelLight;

  /// No description provided for @activityLevelModerate.
  ///
  /// In ro, this message translates to:
  /// **'Activitate moderată (sport 3-5 zile/săpt.)'**
  String get activityLevelModerate;

  /// No description provided for @activityLevelActive.
  ///
  /// In ro, this message translates to:
  /// **'Activ (sport 6-7 zile/săpt.)'**
  String get activityLevelActive;

  /// No description provided for @activityLevelVeryActive.
  ///
  /// In ro, this message translates to:
  /// **'Foarte activ (sport intens zilnic / muncă fizică)'**
  String get activityLevelVeryActive;

  /// No description provided for @goalLose.
  ///
  /// In ro, this message translates to:
  /// **'Slăbit'**
  String get goalLose;

  /// No description provided for @goalMaintain.
  ///
  /// In ro, this message translates to:
  /// **'Menținere'**
  String get goalMaintain;

  /// No description provided for @goalGain.
  ///
  /// In ro, this message translates to:
  /// **'Masă musculară'**
  String get goalGain;

  /// No description provided for @progressPeriod7Days.
  ///
  /// In ro, this message translates to:
  /// **'7 zile'**
  String get progressPeriod7Days;

  /// No description provided for @progressPeriod30Days.
  ///
  /// In ro, this message translates to:
  /// **'30 zile'**
  String get progressPeriod30Days;

  /// No description provided for @progressPeriodWholeProgram.
  ///
  /// In ro, this message translates to:
  /// **'Tot programul'**
  String get progressPeriodWholeProgram;

  /// No description provided for @nutrientVitaminC.
  ///
  /// In ro, this message translates to:
  /// **'Vitamina C'**
  String get nutrientVitaminC;

  /// No description provided for @nutrientVitaminD.
  ///
  /// In ro, this message translates to:
  /// **'Vitamina D'**
  String get nutrientVitaminD;

  /// No description provided for @nutrientCalcium.
  ///
  /// In ro, this message translates to:
  /// **'Calciu'**
  String get nutrientCalcium;

  /// No description provided for @nutrientIron.
  ///
  /// In ro, this message translates to:
  /// **'Fier'**
  String get nutrientIron;

  /// No description provided for @nutrientMagnesium.
  ///
  /// In ro, this message translates to:
  /// **'Magneziu'**
  String get nutrientMagnesium;

  /// No description provided for @nutrientPotassium.
  ///
  /// In ro, this message translates to:
  /// **'Potasiu'**
  String get nutrientPotassium;

  /// No description provided for @macroProtein.
  ///
  /// In ro, this message translates to:
  /// **'Proteine'**
  String get macroProtein;

  /// No description provided for @macroCarbs.
  ///
  /// In ro, this message translates to:
  /// **'Carbohidrați'**
  String get macroCarbs;

  /// No description provided for @macroFat.
  ///
  /// In ro, this message translates to:
  /// **'Grăsimi'**
  String get macroFat;

  /// No description provided for @onboardingAgeTooLow.
  ///
  /// In ro, this message translates to:
  /// **'Aplicația e destinată persoanelor de la {age} ani în sus.'**
  String onboardingAgeTooLow(int age);

  /// No description provided for @onboardingAgeInvalid.
  ///
  /// In ro, this message translates to:
  /// **'Valoare invalidă.'**
  String get onboardingAgeInvalid;

  /// No description provided for @onboardingAgeSexTitle.
  ///
  /// In ro, this message translates to:
  /// **'Câțiva ani și sexul biologic'**
  String get onboardingAgeSexTitle;

  /// No description provided for @age.
  ///
  /// In ro, this message translates to:
  /// **'Vârstă'**
  String get age;

  /// No description provided for @years.
  ///
  /// In ro, this message translates to:
  /// **'ani'**
  String get years;

  /// No description provided for @sexFemale.
  ///
  /// In ro, this message translates to:
  /// **'Femeie'**
  String get sexFemale;

  /// No description provided for @sexMale.
  ///
  /// In ro, this message translates to:
  /// **'Bărbat'**
  String get sexMale;

  /// No description provided for @onboardingSexHint.
  ///
  /// In ro, this message translates to:
  /// **'Folosit doar pentru calculul metabolismului bazal (formula Mifflin-St Jeor).'**
  String get onboardingSexHint;

  /// No description provided for @onboardingHeightWeightTitle.
  ///
  /// In ro, this message translates to:
  /// **'Înălțime și greutate actuală'**
  String get onboardingHeightWeightTitle;

  /// No description provided for @height.
  ///
  /// In ro, this message translates to:
  /// **'Înălțime'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In ro, this message translates to:
  /// **'Greutate'**
  String get weight;

  /// No description provided for @onboardingActivityTitle.
  ///
  /// In ro, this message translates to:
  /// **'Nivel de activitate fizică'**
  String get onboardingActivityTitle;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In ro, this message translates to:
  /// **'Care e obiectivul tău?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingLossRate.
  ///
  /// In ro, this message translates to:
  /// **'Ritm de slăbit dorit'**
  String get onboardingLossRate;

  /// No description provided for @onboardingGainRate.
  ///
  /// In ro, this message translates to:
  /// **'Ritm de creștere dorit'**
  String get onboardingGainRate;

  /// No description provided for @kgPerWeek.
  ///
  /// In ro, this message translates to:
  /// **'kg/săptămână'**
  String get kgPerWeek;

  /// No description provided for @onboardingRateRecommendation.
  ///
  /// In ro, this message translates to:
  /// **'Recomandat: 0.25-0.75 kg/săptămână pentru un ritm sustenabil.'**
  String get onboardingRateRecommendation;

  /// No description provided for @programStartDateLabel.
  ///
  /// In ro, this message translates to:
  /// **'Data de start a dietei'**
  String get programStartDateLabel;

  /// No description provided for @programStartDateHint.
  ///
  /// In ro, this message translates to:
  /// **'Diferă de data creării contului — e momentul de la care vrei să măsurăm progresul.'**
  String get programStartDateHint;

  /// No description provided for @disclaimerTitle.
  ///
  /// In ro, this message translates to:
  /// **'Înainte să începi'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerIntro.
  ///
  /// In ro, this message translates to:
  /// **'Calorii Fit estimează necesarul caloric și ritmul de slăbit pe baza unor formule general acceptate (Mifflin-St Jeor), nu pe baza unei evaluări medicale individuale.'**
  String get disclaimerIntro;

  /// No description provided for @disclaimerMedical.
  ///
  /// In ro, this message translates to:
  /// **'Nu înlocuiește sfatul unui medic sau nutriționist — mai ales dacă ai o afecțiune medicală, ești însărcinată sau alăptezi.'**
  String get disclaimerMedical;

  /// No description provided for @disclaimerAllergens.
  ///
  /// In ro, this message translates to:
  /// **'Identificarea alimentelor din fotografie nu detectează alergeni. Dacă ai o alergie sau intoleranță severă, verifică mereu ingredientele chiar tu, nu te baza pe aplicație pentru asta.'**
  String get disclaimerAllergens;

  /// No description provided for @disclaimerEatingDisorders.
  ///
  /// In ro, this message translates to:
  /// **'Dacă ai avut sau ai o relație dificilă cu alimentația (tulburări de alimentație), discută cu un medic înainte de a urmări calorii — aplicația nu e gândită să înlocuiască acel sprijin.'**
  String get disclaimerEatingDisorders;

  /// No description provided for @disclaimerAcceptLabel.
  ///
  /// In ro, this message translates to:
  /// **'Am înțeles și sunt de acord să folosesc aplicația în cunoștință de cauză.'**
  String get disclaimerAcceptLabel;

  /// No description provided for @finish.
  ///
  /// In ro, this message translates to:
  /// **'Finalizează'**
  String get finish;

  /// No description provided for @continueLabel.
  ///
  /// In ro, this message translates to:
  /// **'Continuă'**
  String get continueLabel;

  /// No description provided for @progress.
  ///
  /// In ro, this message translates to:
  /// **'Progres'**
  String get progress;

  /// No description provided for @activityAndSync.
  ///
  /// In ro, this message translates to:
  /// **'Activitate & sincronizare'**
  String get activityAndSync;

  /// No description provided for @editProfileGoal.
  ///
  /// In ro, this message translates to:
  /// **'Editează profil/obiectiv'**
  String get editProfileGoal;

  /// No description provided for @checkDeviceCapability.
  ///
  /// In ro, this message translates to:
  /// **'Verifică capabilitate device'**
  String get checkDeviceCapability;

  /// No description provided for @myRecipes.
  ///
  /// In ro, this message translates to:
  /// **'Rețetele mele'**
  String get myRecipes;

  /// No description provided for @signOut.
  ///
  /// In ro, this message translates to:
  /// **'Deconectare'**
  String get signOut;

  /// No description provided for @takePhoto.
  ///
  /// In ro, this message translates to:
  /// **'Fotografiază'**
  String get takePhoto;

  /// No description provided for @previousDay.
  ///
  /// In ro, this message translates to:
  /// **'Ziua anterioară'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In ro, this message translates to:
  /// **'Ziua următoare'**
  String get nextDay;

  /// No description provided for @pickDayHelp.
  ///
  /// In ro, this message translates to:
  /// **'Alege ziua'**
  String get pickDayHelp;

  /// No description provided for @dateToday.
  ///
  /// In ro, this message translates to:
  /// **'Azi, {date}'**
  String dateToday(String date);

  /// No description provided for @dateYesterday.
  ///
  /// In ro, this message translates to:
  /// **'Ieri, {date}'**
  String dateYesterday(String date);

  /// No description provided for @dateTomorrow.
  ///
  /// In ro, this message translates to:
  /// **'Mâine, {date}'**
  String dateTomorrow(String date);

  /// No description provided for @setUpYourGoal.
  ///
  /// In ro, this message translates to:
  /// **'Configurează-ți obiectivul'**
  String get setUpYourGoal;

  /// No description provided for @kcalToday.
  ///
  /// In ro, this message translates to:
  /// **'{kcal} kcal azi'**
  String kcalToday(String kcal);

  /// No description provided for @setUp.
  ///
  /// In ro, this message translates to:
  /// **'Setează'**
  String get setUp;

  /// No description provided for @dailyTargetLabel.
  ///
  /// In ro, this message translates to:
  /// **'Ținta: {kcal} kcal'**
  String dailyTargetLabel(String kcal);

  /// No description provided for @calorieDeficit.
  ///
  /// In ro, this message translates to:
  /// **'Deficit caloric'**
  String get calorieDeficit;

  /// No description provided for @totalBurnedLabel.
  ///
  /// In ro, this message translates to:
  /// **'Total arse'**
  String get totalBurnedLabel;

  /// No description provided for @totalConsumedLabel.
  ///
  /// In ro, this message translates to:
  /// **'Total consumate'**
  String get totalConsumedLabel;

  /// No description provided for @overLimitCaption.
  ///
  /// In ro, this message translates to:
  /// **'Ai depășit limita cu {overBy} kcal (peste {limit} kcal).'**
  String overLimitCaption(String overBy, String limit);

  /// No description provided for @limitCaptionLose.
  ///
  /// In ro, this message translates to:
  /// **'Nu depăși {kcal} kcal, ca să atingi ritmul de slăbit propus.'**
  String limitCaptionLose(String kcal);

  /// No description provided for @limitCaptionGain.
  ///
  /// In ro, this message translates to:
  /// **'Ai nevoie de cel puțin {kcal} kcal pentru ritmul de creștere propus.'**
  String limitCaptionGain(String kcal);

  /// No description provided for @limitCaptionMaintain.
  ///
  /// In ro, this message translates to:
  /// **'Rămâi în jurul a {kcal} kcal pentru menținere.'**
  String limitCaptionMaintain(String kcal);

  /// No description provided for @recommendedRange.
  ///
  /// In ro, this message translates to:
  /// **'Valoare recomandată: {low}–{high} kcal'**
  String recommendedRange(String low, String high);

  /// No description provided for @addFood.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă aliment'**
  String get addFood;

  /// No description provided for @sportActivity.
  ///
  /// In ro, this message translates to:
  /// **'Activitate sportivă'**
  String get sportActivity;

  /// No description provided for @manualCaloriesEntered.
  ///
  /// In ro, this message translates to:
  /// **'Calorii introduse manual'**
  String get manualCaloriesEntered;

  /// No description provided for @addActivity.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă activitate'**
  String get addActivity;

  /// No description provided for @caloricIntake.
  ///
  /// In ro, this message translates to:
  /// **'Aport caloric'**
  String get caloricIntake;

  /// No description provided for @dailyCaloricDeficit.
  ///
  /// In ro, this message translates to:
  /// **'Deficit caloric zilnic'**
  String get dailyCaloricDeficit;

  /// No description provided for @setUpProfileFirst.
  ///
  /// In ro, this message translates to:
  /// **'Setează-ți mai întâi profilul și obiectivul din meniu.'**
  String get setUpProfileFirst;

  /// No description provided for @totalCaloriesLabel.
  ///
  /// In ro, this message translates to:
  /// **'Total calorii'**
  String get totalCaloriesLabel;

  /// No description provided for @avgPerDay.
  ///
  /// In ro, this message translates to:
  /// **'Medie/zi'**
  String get avgPerDay;

  /// No description provided for @estimatedLoss.
  ///
  /// In ro, this message translates to:
  /// **'Scădere estimată'**
  String get estimatedLoss;

  /// No description provided for @macroBalanceTitle.
  ///
  /// In ro, this message translates to:
  /// **'Echilibru macronutrienți'**
  String get macroBalanceTitle;

  /// No description provided for @macroBalanceNoData.
  ///
  /// In ro, this message translates to:
  /// **'Niciun aliment cu proteine/carbohidrați/grăsimi cunoscute în această perioadă.'**
  String get macroBalanceNoData;

  /// No description provided for @macroSharePercent.
  ///
  /// In ro, this message translates to:
  /// **'{share}% (recomandat {min}-{max}%)'**
  String macroSharePercent(int share, int min, int max);

  /// No description provided for @micronutrientsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Micronutrienți (medie/zi)'**
  String get micronutrientsTitle;

  /// No description provided for @micronutrientsNoData.
  ///
  /// In ro, this message translates to:
  /// **'Niciun aliment cu date despre vitamine/minerale în această perioadă — vezi nota de mai jos.'**
  String get micronutrientsNoData;

  /// No description provided for @micronutrientsNoEntries.
  ///
  /// In ro, this message translates to:
  /// **'Fără alimente înregistrate în această perioadă.'**
  String get micronutrientsNoEntries;

  /// No description provided for @micronutrientsCoverage.
  ///
  /// In ro, this message translates to:
  /// **'Date de vitamine/minerale disponibile pentru {pct}% din alimentele înregistrate ({withData}/{total}) — restul (mâncare de casă, produse fără etichetă) nu au date cunoscute și nu sunt incluse în medie.'**
  String micronutrientsCoverage(int pct, int withData, int total);

  /// No description provided for @micronutrientShare.
  ///
  /// In ro, this message translates to:
  /// **'{amount} {unit} · {percent}% din doza zilnică'**
  String micronutrientShare(String amount, String unit, int percent);

  /// No description provided for @chartTargetLabel.
  ///
  /// In ro, this message translates to:
  /// **'Țintă'**
  String get chartTargetLabel;

  /// No description provided for @healthConnectTitle.
  ///
  /// In ro, this message translates to:
  /// **'Health Connect / Apple Health'**
  String get healthConnectTitle;

  /// No description provided for @healthConnectDescription.
  ///
  /// In ro, this message translates to:
  /// **'Preia greutatea și activitatea fizică înregistrată de ceasul tău, prin platforma de sănătate a telefonului.'**
  String get healthConnectDescription;

  /// No description provided for @bluetoothScaleSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'Conectează direct un cântar inteligent'**
  String get bluetoothScaleSubtitle;

  /// No description provided for @weightHistoryTitle.
  ///
  /// In ro, this message translates to:
  /// **'Istoric greutate'**
  String get weightHistoryTitle;

  /// No description provided for @addLabel.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă'**
  String get addLabel;

  /// No description provided for @noEntriesYet.
  ///
  /// In ro, this message translates to:
  /// **'Nicio înregistrare încă.'**
  String get noEntriesYet;

  /// No description provided for @syncButton.
  ///
  /// In ro, this message translates to:
  /// **'Sincronizează'**
  String get syncButton;

  /// No description provided for @syncAgain.
  ///
  /// In ro, this message translates to:
  /// **'Sincronizează din nou'**
  String get syncAgain;

  /// No description provided for @stepsToday.
  ///
  /// In ro, this message translates to:
  /// **'pași azi'**
  String get stepsToday;

  /// No description provided for @activeKcal.
  ///
  /// In ro, this message translates to:
  /// **'kcal active'**
  String get activeKcal;

  /// No description provided for @newWeightFetched.
  ///
  /// In ro, this message translates to:
  /// **'Greutate nouă preluată: {kg} kg'**
  String newWeightFetched(String kg);

  /// No description provided for @newWorkoutsImported.
  ///
  /// In ro, this message translates to:
  /// **'{count} antrenamente noi, importate din ceas.'**
  String newWorkoutsImported(int count);

  /// No description provided for @weightSourceManual.
  ///
  /// In ro, this message translates to:
  /// **'manual'**
  String get weightSourceManual;

  /// No description provided for @weightSourceHealthConnect.
  ///
  /// In ro, this message translates to:
  /// **'Health Connect'**
  String get weightSourceHealthConnect;

  /// No description provided for @weightSourceAppleHealth.
  ///
  /// In ro, this message translates to:
  /// **'Apple Health'**
  String get weightSourceAppleHealth;

  /// No description provided for @weightSourceBluetoothScale.
  ///
  /// In ro, this message translates to:
  /// **'cântar BT'**
  String get weightSourceBluetoothScale;

  /// No description provided for @addWeightTitle.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă greutate'**
  String get addWeightTitle;

  /// No description provided for @editWeightTitle.
  ///
  /// In ro, this message translates to:
  /// **'Editează greutatea'**
  String get editWeightTitle;

  /// No description provided for @weighInDateHelp.
  ///
  /// In ro, this message translates to:
  /// **'Data cântăririi'**
  String get weighInDateHelp;

  /// No description provided for @weighInTimeHelp.
  ///
  /// In ro, this message translates to:
  /// **'Ora cântăririi'**
  String get weighInTimeHelp;

  /// No description provided for @edit.
  ///
  /// In ro, this message translates to:
  /// **'Editează'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In ro, this message translates to:
  /// **'Șterge'**
  String get delete;

  /// No description provided for @chooseARecipe.
  ///
  /// In ro, this message translates to:
  /// **'Alege o rețetă'**
  String get chooseARecipe;

  /// No description provided for @newRecipe.
  ///
  /// In ro, this message translates to:
  /// **'Rețetă nouă'**
  String get newRecipe;

  /// No description provided for @editRecipe.
  ///
  /// In ro, this message translates to:
  /// **'Editează rețeta'**
  String get editRecipe;

  /// No description provided for @noRecipesYet.
  ///
  /// In ro, this message translates to:
  /// **'Nu ai nicio rețetă salvată încă. Adaugă una din butonul de mai jos.'**
  String get noRecipesYet;

  /// No description provided for @recipeServingsSummary.
  ///
  /// In ro, this message translates to:
  /// **'{servings} porții · {kcal} kcal/porție'**
  String recipeServingsSummary(int servings, int kcal);

  /// No description provided for @recipeAddedToday.
  ///
  /// In ro, this message translates to:
  /// **'{name} a fost adăugată azi.'**
  String recipeAddedToday(String name);

  /// No description provided for @addRecipeTo.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă „{name}\" la:'**
  String addRecipeTo(String name);

  /// No description provided for @recipeNameLabel.
  ///
  /// In ro, this message translates to:
  /// **'Denumire rețetă'**
  String get recipeNameLabel;

  /// No description provided for @recipeNameHint.
  ///
  /// In ro, this message translates to:
  /// **'ex. Salata mea de pui'**
  String get recipeNameHint;

  /// No description provided for @numberOfServings.
  ///
  /// In ro, this message translates to:
  /// **'Număr de porții'**
  String get numberOfServings;

  /// No description provided for @ingredients.
  ///
  /// In ro, this message translates to:
  /// **'Ingrediente'**
  String get ingredients;

  /// No description provided for @addAtLeastOneIngredient.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă cel puțin un ingredient.'**
  String get addAtLeastOneIngredient;

  /// No description provided for @saveRecipe.
  ///
  /// In ro, this message translates to:
  /// **'Salvează rețeta'**
  String get saveRecipe;

  /// No description provided for @perServing.
  ///
  /// In ro, this message translates to:
  /// **'Per porție ({grams} g): {kcal} kcal'**
  String perServing(int grams, int kcal);

  /// No description provided for @macroSummaryLine.
  ///
  /// In ro, this message translates to:
  /// **'Proteine {protein} · Carbohidrați {carbs} · Grăsimi {fat}'**
  String macroSummaryLine(String protein, String carbs, String fat);

  /// No description provided for @addIngredientTitle.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă ingredient'**
  String get addIngredientTitle;

  /// No description provided for @productNameLabel.
  ///
  /// In ro, this message translates to:
  /// **'Denumire produs'**
  String get productNameLabel;

  /// No description provided for @noProductFound.
  ///
  /// In ro, this message translates to:
  /// **'Niciun produs găsit.'**
  String get noProductFound;

  /// No description provided for @searchWithAiButton.
  ///
  /// In ro, this message translates to:
  /// **'Caută cu AI'**
  String get searchWithAiButton;

  /// No description provided for @aiSearchNoResult.
  ///
  /// In ro, this message translates to:
  /// **'AI nu a găsit un produs sigur pentru această căutare.'**
  String get aiSearchNoResult;

  /// No description provided for @aiEstimateBadge.
  ///
  /// In ro, this message translates to:
  /// **'estimare AI'**
  String get aiEstimateBadge;

  /// No description provided for @quantityLabel.
  ///
  /// In ro, this message translates to:
  /// **'Cantitate'**
  String get quantityLabel;

  /// No description provided for @addIngredientButton.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă ingredientul'**
  String get addIngredientButton;

  /// No description provided for @editIngredientQuantityTitle.
  ///
  /// In ro, this message translates to:
  /// **'Editează cantitatea'**
  String get editIngredientQuantityTitle;

  /// No description provided for @chooseRecipeIconTitle.
  ///
  /// In ro, this message translates to:
  /// **'Alege o iconiță'**
  String get chooseRecipeIconTitle;

  /// No description provided for @recipeIconSuggested.
  ///
  /// In ro, this message translates to:
  /// **'Sugestie'**
  String get recipeIconSuggested;

  /// No description provided for @saveAsRecipeTooltip.
  ///
  /// In ro, this message translates to:
  /// **'Salvează ca rețetă'**
  String get saveAsRecipeTooltip;

  /// No description provided for @saveAsRecipeDialogTitle.
  ///
  /// In ro, this message translates to:
  /// **'Salvează ca rețetă nouă'**
  String get saveAsRecipeDialogTitle;

  /// No description provided for @recipeSavedConfirmation.
  ///
  /// In ro, this message translates to:
  /// **'„{name}” a fost salvată în rețetele tale.'**
  String recipeSavedConfirmation(String name);

  /// No description provided for @addFoodTitle.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă aliment — {meal}'**
  String addFoodTitle(String meal);

  /// No description provided for @productNameHint.
  ///
  /// In ro, this message translates to:
  /// **'ex. Iaurt grecesc'**
  String get productNameHint;

  /// No description provided for @enterProductName.
  ///
  /// In ro, this message translates to:
  /// **'Introdu denumirea produsului'**
  String get enterProductName;

  /// No description provided for @frequentlyLogged.
  ///
  /// In ro, this message translates to:
  /// **'Înregistrate frecvent'**
  String get frequentlyLogged;

  /// No description provided for @addCount.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă ({count})'**
  String addCount(int count);

  /// No description provided for @calorieIndexLabel.
  ///
  /// In ro, this message translates to:
  /// **'Indice caloric (kcal / 100g)'**
  String get calorieIndexLabel;

  /// No description provided for @quantityEatenLabel.
  ///
  /// In ro, this message translates to:
  /// **'Cantitate consumată'**
  String get quantityEatenLabel;

  /// No description provided for @editGramsDialogTitle.
  ///
  /// In ro, this message translates to:
  /// **'Modifică gramajul'**
  String get editGramsDialogTitle;

  /// No description provided for @requiredField.
  ///
  /// In ro, this message translates to:
  /// **'Câmp obligatoriu'**
  String get requiredField;

  /// No description provided for @invalidValue.
  ///
  /// In ro, this message translates to:
  /// **'Valoare invalidă'**
  String get invalidValue;

  /// No description provided for @searchFailedCheckConnection.
  ///
  /// In ro, this message translates to:
  /// **'Căutarea nu a putut fi realizată (verifică conexiunea).'**
  String get searchFailedCheckConnection;

  /// No description provided for @addProductManually.
  ///
  /// In ro, this message translates to:
  /// **'Adaugă produs manual'**
  String get addProductManually;

  /// No description provided for @macroProteinShort.
  ///
  /// In ro, this message translates to:
  /// **'P'**
  String get macroProteinShort;

  /// No description provided for @macroCarbsShort.
  ///
  /// In ro, this message translates to:
  /// **'C'**
  String get macroCarbsShort;

  /// No description provided for @macroFatShort.
  ///
  /// In ro, this message translates to:
  /// **'G'**
  String get macroFatShort;

  /// No description provided for @macrosUnavailable.
  ///
  /// In ro, this message translates to:
  /// **'Macro-nutrienți indisponibili'**
  String get macrosUnavailable;

  /// No description provided for @gramsPreviewLine.
  ///
  /// In ro, this message translates to:
  /// **'{kcal} kcal · Proteine {protein} · Carbohidrați {carbs} · Grăsimi {fat}'**
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat);

  /// No description provided for @languageDialogTitle.
  ///
  /// In ro, this message translates to:
  /// **'Limbă'**
  String get languageDialogTitle;

  /// No description provided for @languageSystemDefault.
  ///
  /// In ro, this message translates to:
  /// **'Limba telefonului (implicit)'**
  String get languageSystemDefault;

  /// No description provided for @languageMenuEntry.
  ///
  /// In ro, this message translates to:
  /// **'Limbă'**
  String get languageMenuEntry;

  /// No description provided for @guideMenuEntry.
  ///
  /// In ro, this message translates to:
  /// **'Ghid de utilizare'**
  String get guideMenuEntry;

  /// No description provided for @guideScreenTitle.
  ///
  /// In ro, this message translates to:
  /// **'Ghid de utilizare'**
  String get guideScreenTitle;

  /// No description provided for @guideIntroTitle.
  ///
  /// In ro, this message translates to:
  /// **'Ce este Calorii Fit'**
  String get guideIntroTitle;

  /// No description provided for @guideIntroBody.
  ///
  /// In ro, this message translates to:
  /// **'O aplicație de nutriție care estimează caloriile direct dintr-o fotografie a farfuriei, folosind senzorul de adâncime al telefonului, nu doar o poză obișnuită. Pe lângă asta, ține jurnalul complet: mese, sport, hidratare, greutate și progresul spre obiectivul tău.'**
  String get guideIntroBody;

  /// No description provided for @guidePhotoTitle.
  ///
  /// In ro, this message translates to:
  /// **'Estimarea din fotografie'**
  String get guidePhotoTitle;

  /// No description provided for @guidePhotoBody.
  ///
  /// In ro, this message translates to:
  /// **'Fotografiezi farfuria, telefonul îi măsoară volumul folosind LiDAR, ARCore Depth sau camera duală, iar aplicația identifică alimentele și calculează porția. Tu confirmi sau ajustezi rezultatul cu un slider sau presetări — nimic nu se salvează automat. Fără senzor de adâncime, se folosește diametrul farfuriei ca reper, marcat clar drept estimare aproximativă.'**
  String get guidePhotoBody;

  /// No description provided for @guideLogTitle.
  ///
  /// In ro, this message translates to:
  /// **'Jurnalul zilnic'**
  String get guideLogTitle;

  /// No description provided for @guideLogBody.
  ///
  /// In ro, this message translates to:
  /// **'Patru mese pe zi — Dimineață, Prânz, Seară, Gustare. Adaugi alimente din fotografie, din căutare, prin scanarea codului de bare, manual, din rețetele tale sau rapid dintr-o listă de bifat cu alimentele obișnuite.'**
  String get guideLogBody;

  /// No description provided for @guideRecipesTitle.
  ///
  /// In ro, this message translates to:
  /// **'Rețetele mele'**
  String get guideRecipesTitle;

  /// No description provided for @guideRecipesBody.
  ///
  /// In ro, this message translates to:
  /// **'Salvezi o combinație de ingrediente pe care o mănânci des și o loghezi dintr-o singură atingere. Poți alege o iconiță pentru fiecare rețetă (sau accepți sugestia automată) și poți edita oricând cantitatea fiecărui ingredient. Când adaugi mai multe alimente deodată, le poți salva pe loc ca rețetă nouă.'**
  String get guideRecipesBody;

  /// No description provided for @guideWorkoutsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Activitate fizică'**
  String get guideWorkoutsTitle;

  /// No description provided for @guideWorkoutsBody.
  ///
  /// In ro, this message translates to:
  /// **'Alegi tipul de sport și durata, iar caloriile arse se calculează automat — sau le introduci direct, dacă le știi deja de la un ceas smart. Caloriile arse se scad din bugetul zilei.'**
  String get guideWorkoutsBody;

  /// No description provided for @guideProgressTitle.
  ///
  /// In ro, this message translates to:
  /// **'Progres'**
  String get guideProgressTitle;

  /// No description provided for @guideProgressBody.
  ///
  /// In ro, this message translates to:
  /// **'Grafice pe 7 zile, 30 de zile sau tot programul: evoluția greutății (netezită), TDEE adaptiv calculat din propriul tău echilibru energetic, balanța macro-urilor și acoperirea micronutrienților. Se sincronizează cu Apple Health / Health Connect și cu un cântar Bluetooth.'**
  String get guideProgressBody;

  /// No description provided for @guideHydrationTitle.
  ///
  /// In ro, this message translates to:
  /// **'Hidratare'**
  String get guideHydrationTitle;

  /// No description provided for @guideHydrationBody.
  ///
  /// In ro, this message translates to:
  /// **'Un contor simplu de pahare de apă pe zi — o atingere ca să adaugi, o atingere ca să anulezi ultimul.'**
  String get guideHydrationBody;

  /// No description provided for @guideStreaksTitle.
  ///
  /// In ro, this message translates to:
  /// **'Motivație'**
  String get guideStreaksTitle;

  /// No description provided for @guideStreaksBody.
  ///
  /// In ro, this message translates to:
  /// **'O insignă cu flacără arată câte zile la rând ai logat cel puțin o masă.'**
  String get guideStreaksBody;

  /// No description provided for @guideRemindersTitle.
  ///
  /// In ro, this message translates to:
  /// **'Memento zilnic'**
  String get guideRemindersTitle;

  /// No description provided for @guideRemindersBody.
  ///
  /// In ro, this message translates to:
  /// **'O notificare, la ora aleasă de tine, care îți amintește să-ți loghezi mesele — dezactivabilă oricând din meniu.'**
  String get guideRemindersBody;

  /// No description provided for @guideProfileTitle.
  ///
  /// In ro, this message translates to:
  /// **'Profil și obiectiv'**
  String get guideProfileTitle;

  /// No description provided for @guideProfileBody.
  ///
  /// In ro, this message translates to:
  /// **'Vârstă, sex biologic, înălțime, greutate, nivel de activitate și obiectiv — editabile oricând. Aplicația recalculează automat ținta calorică la orice schimbare.'**
  String get guideProfileBody;

  /// No description provided for @guidePrivacyTitle.
  ///
  /// In ro, this message translates to:
  /// **'Confidențialitate'**
  String get guidePrivacyTitle;

  /// No description provided for @guidePrivacyBody.
  ///
  /// In ro, this message translates to:
  /// **'Datele tale sunt legate exclusiv de contul tău și nu sunt vizibile altor utilizatori. Poți șterge contul și toate datele asociate oricând, din meniu — ștergerea e permanentă și imediată.'**
  String get guidePrivacyBody;

  /// No description provided for @guideLanguagesTitle.
  ///
  /// In ro, this message translates to:
  /// **'Limbi disponibile'**
  String get guideLanguagesTitle;

  /// No description provided for @guideLanguagesBody.
  ///
  /// In ro, this message translates to:
  /// **'Aplicația e disponibilă în 13 limbi, alese din meniu — nu doar detectate automat din limba telefonului.'**
  String get guideLanguagesBody;

  /// No description provided for @guidePremiumTitle.
  ///
  /// In ro, this message translates to:
  /// **'Premium și abonamente'**
  String get guidePremiumTitle;

  /// No description provided for @guidePremiumDraftNote.
  ///
  /// In ro, this message translates to:
  /// **'Ciornă, nefinalizată — planul de mai jos nu e încă activ în aplicație. Nu există plată în-app sau blocare de funcții momentan.'**
  String get guidePremiumDraftNote;

  /// No description provided for @guidePremiumFreeBody.
  ///
  /// In ro, this message translates to:
  /// **'Gratuit, permanent: jurnal alimentar complet, 20 de analize foto pe zi, rețete proprii nelimitate, grafice de progres de bază și sincronizare cu Apple Health / Health Connect.'**
  String get guidePremiumFreeBody;

  /// No description provided for @guidePremiumPaidBody.
  ///
  /// In ro, this message translates to:
  /// **'Premium (preț orientativ, neconfirmat): analize foto nelimitate, TDEE adaptiv și micronutrienți detaliați, plus suport prioritar.'**
  String get guidePremiumPaidBody;

  /// No description provided for @themeDialogTitle.
  ///
  /// In ro, this message translates to:
  /// **'Temă'**
  String get themeDialogTitle;

  /// No description provided for @themeSystemDefault.
  ///
  /// In ro, this message translates to:
  /// **'Tema telefonului (implicit)'**
  String get themeSystemDefault;

  /// No description provided for @themeLight.
  ///
  /// In ro, this message translates to:
  /// **'Luminoasă'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ro, this message translates to:
  /// **'Întunecată'**
  String get themeDark;

  /// No description provided for @themeMenuEntry.
  ///
  /// In ro, this message translates to:
  /// **'Temă'**
  String get themeMenuEntry;

  /// No description provided for @barcodeToggleTorch.
  ///
  /// In ro, this message translates to:
  /// **'Comută blițul'**
  String get barcodeToggleTorch;

  /// No description provided for @clearSelection.
  ///
  /// In ro, this message translates to:
  /// **'Șterge selecția'**
  String get clearSelection;

  /// No description provided for @accessCodeMenuEntry.
  ///
  /// In ro, this message translates to:
  /// **'Cod de acces'**
  String get accessCodeMenuEntry;

  /// No description provided for @adminDashboardMenuEntry.
  ///
  /// In ro, this message translates to:
  /// **'Panou admin'**
  String get adminDashboardMenuEntry;

  /// No description provided for @accessCodeScreenTitle.
  ///
  /// In ro, this message translates to:
  /// **'Cod de acces'**
  String get accessCodeScreenTitle;

  /// No description provided for @premiumCodeFieldLabel.
  ///
  /// In ro, this message translates to:
  /// **'Cod premium'**
  String get premiumCodeFieldLabel;

  /// No description provided for @activatePremiumButton.
  ///
  /// In ro, this message translates to:
  /// **'Activează premium'**
  String get activatePremiumButton;

  /// No description provided for @premiumActivatedMessage.
  ///
  /// In ro, this message translates to:
  /// **'Acces premium activat până la {date}.'**
  String premiumActivatedMessage(String date);

  /// No description provided for @iAmAdminLink.
  ///
  /// In ro, this message translates to:
  /// **'Sunt admin'**
  String get iAmAdminLink;

  /// No description provided for @adminPasswordFieldLabel.
  ///
  /// In ro, this message translates to:
  /// **'Parolă admin'**
  String get adminPasswordFieldLabel;

  /// No description provided for @activateAdminButton.
  ///
  /// In ro, this message translates to:
  /// **'Activează admin'**
  String get activateAdminButton;

  /// No description provided for @adminActivatedMessage.
  ///
  /// In ro, this message translates to:
  /// **'Cont admin activat.'**
  String get adminActivatedMessage;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In ro, this message translates to:
  /// **'Panou admin'**
  String get adminDashboardTitle;

  /// No description provided for @totalUsersLabel.
  ///
  /// In ro, this message translates to:
  /// **'Utilizatori totali'**
  String get totalUsersLabel;

  /// No description provided for @activePremiumLabel.
  ///
  /// In ro, this message translates to:
  /// **'Premium activ'**
  String get activePremiumLabel;

  /// No description provided for @generateCodeSectionTitle.
  ///
  /// In ro, this message translates to:
  /// **'Generează cod premium'**
  String get generateCodeSectionTitle;

  /// No description provided for @targetEmailLabel.
  ///
  /// In ro, this message translates to:
  /// **'Email cont'**
  String get targetEmailLabel;

  /// No description provided for @durationDaysLabel.
  ///
  /// In ro, this message translates to:
  /// **'Durată (zile)'**
  String get durationDaysLabel;

  /// No description provided for @generateCodeButton.
  ///
  /// In ro, this message translates to:
  /// **'Generează cod'**
  String get generateCodeButton;

  /// No description provided for @codeGeneratedTitle.
  ///
  /// In ro, this message translates to:
  /// **'Cod generat'**
  String get codeGeneratedTitle;

  /// No description provided for @generatedCodesSectionTitle.
  ///
  /// In ro, this message translates to:
  /// **'Coduri generate'**
  String get generatedCodesSectionTitle;

  /// No description provided for @noCodesGeneratedYet.
  ///
  /// In ro, this message translates to:
  /// **'Niciun cod generat încă.'**
  String get noCodesGeneratedYet;

  /// No description provided for @codeStatusPending.
  ///
  /// In ro, this message translates to:
  /// **'neutilizat'**
  String get codeStatusPending;

  /// No description provided for @codeStatusRedeemed.
  ///
  /// In ro, this message translates to:
  /// **'folosit'**
  String get codeStatusRedeemed;

  /// No description provided for @codeStatusRevoked.
  ///
  /// In ro, this message translates to:
  /// **'revocat'**
  String get codeStatusRevoked;

  /// No description provided for @durationDaysValue.
  ///
  /// In ro, this message translates to:
  /// **'{days} zile'**
  String durationDaysValue(int days);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'da',
    'de',
    'en',
    'es',
    'fr',
    'hu',
    'it',
    'nb',
    'nl',
    'pl',
    'pt',
    'ro',
    'sv',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

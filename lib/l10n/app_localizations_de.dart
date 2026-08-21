// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle =>
      'Vergiss nicht, deine Mahlzeiten einzutragen';

  @override
  String get dailyReminderBody =>
      'Ein paar Sekunden reichen, um dein Tagebuch aktuell und deine Serie am Leben zu halten.';

  @override
  String get dailyReminderChannelName => 'Tägliche Erinnerung';

  @override
  String get dailyReminderChannelDescription =>
      'Erinnerung, die heutigen Mahlzeiten einzutragen';

  @override
  String get updateRequiredTitle => 'Ein Update ist erforderlich';

  @override
  String get updateRequiredMessage =>
      'Die Version der App auf diesem Telefon wird nicht mehr unterstützt. Installiere die neueste Version, um fortzufahren.';

  @override
  String get updateAvailableMessage =>
      'Eine neue Version der App ist verfügbar.';

  @override
  String get hydrationTitle => 'Flüssigkeitszufuhr';

  @override
  String get hydrationUndoLastGlass => 'Letztes Glas rückgängig machen';

  @override
  String hydrationAddGlass(int ml) {
    return 'Glas hinzufügen ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'Adaptiver Gesamtenergieumsatz';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Noch nicht genug Daten: Du brauchst mindestens 14 protokollierte Tage und 2 Wiegungen im Abstand von mindestens 10 Tagen innerhalb der letzten 3 Wochen. Bis dahin wird die Standardformel (Mifflin-St Jeor) verwendet.';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Berechnet aus deiner eigenen Kalorienbilanz ($loggedDays/$windowDays Tage protokolliert in den letzten 3 Wochen), nicht nur aus der Standardformel.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'Geschätzter Gesamtenergieumsatz';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Gewichtstrend';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/Woche';
  }

  @override
  String get adaptiveTdeeRejected =>
      'Die Schätzung weicht noch zu stark von der Standardformel ab, um vertrauenswürdig zu sein — die Standardformel wird weiter verwendet, bis konsistentere Daten vorliegen.';

  @override
  String get weeklySummaryTitle => 'Zusammenfassung der Woche';

  @override
  String get weeklySummaryDaysLogged => 'Protokollierte Tage';

  @override
  String get weeklySummaryAvgCalories => 'Ø kcal/Tag';

  @override
  String get weeklySummaryWorkouts => 'Workouts';

  @override
  String get weightEvolutionTitle => 'Gewichtsverlauf';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Vom $date ($startKg kg) bis heute ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Tiefenerfassungs-Fähigkeit';

  @override
  String deviceCapabilityError(String error) {
    return 'Fehler bei der Prüfung der Fähigkeiten:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR verfügbar';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth verfügbar';

  @override
  String get depthSourcePortraitLabel => 'Dual-Kamera (Porträttiefe)';

  @override
  String get depthSourceReferenceLabel => 'Kein Tiefensensor';

  @override
  String get depthSourceUnknownLabel => 'Unbekannt';

  @override
  String get depthSourceLidarDescription =>
      'Hochpräzise Volumenschätzung (~10-15 % Fehler).';

  @override
  String get depthSourceArcoreDescription =>
      'Volumenschätzung über die ARCore Depth API.';

  @override
  String get depthSourcePortraitDescription =>
      'Ungefähre Tiefe über die Dual-Kamera, geringere Präzision.';

  @override
  String get depthSourceReferenceDescription =>
      'Der Tellerdurchmesser wird als Maßstabsreferenz verwendet (weniger präzise Schätzung).';

  @override
  String get depthSourceUnknownDescription =>
      'Die Fähigkeit des Geräts konnte nicht bestimmt werden.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'Dual-Kamera';

  @override
  String get depthSourceReferenceShort => 'visuelle Referenz';

  @override
  String get depthSourceUnknownShort => 'unbekannt';

  @override
  String get howItWorksTitle => 'Wie wir Kalorien berechnen';

  @override
  String get howItWorksTooltip => 'Wie berechnen wir Kalorien?';

  @override
  String get howItWorksIntro =>
      'Die meisten Ernährungs-Apps schätzen die Portion anhand eines einzigen 2D-Fotos. Calorii Fit misst tatsächlich das Volumen des Essens auf dem Teller mithilfe der Tiefenkarte deines Telefons — deshalb ist die Schätzung genauer.';

  @override
  String get howItWorksStep1Title => 'Fotografiere deinen Teller';

  @override
  String get howItWorksStep1Description =>
      'Ein einziges Foto, keine besondere Positionierung nötig.';

  @override
  String get howItWorksStep2Title => 'Dein Telefon erfasst die Tiefe';

  @override
  String get howItWorksStep2GenericDescription =>
      'Dein Telefon nutzt je nach Modell LiDAR, ARCore Depth oder eine Dual-Kamera, um zu wissen, wie hoch das Essen ist, nicht nur, wie es von oben aussieht.';

  @override
  String get howItWorksStep3Title => 'Claude erkennt die Lebensmittel';

  @override
  String get howItWorksStep3Description =>
      'Das Modell erkennt, was auf dem Teller ist, und markiert den ungefähren Umriss jedes Lebensmittels — es berechnet selbst keine Kalorien, sondern identifiziert nur.';

  @override
  String get howItWorksStep4Title => 'Volumen wird zu Gramm, dann zu Kalorien';

  @override
  String get howItWorksStep4Description =>
      'Die Tiefenkarte × der Umriss jedes Lebensmittels ergibt ein Volumen in cm³. Eine Dichtetabelle (spezifisch für jede Lebensmittelart) wandelt das Volumen in Gramm um, und die Nährwertdatenbank wandelt die Gramm in Kalorien und Makronährstoffe um.';

  @override
  String get howItWorksStep5Title => 'Du bestätigst oder korrigierst';

  @override
  String get howItWorksStep5Description =>
      'Die automatische Schätzung wird nie direkt gespeichert — du siehst immer einen Bestätigungsbildschirm, auf dem du die Portion anpassen oder das erkannte Lebensmittel ändern kannst.';

  @override
  String get howItWorksSeeDeviceMethod => 'Zeige die Methode deines Telefons';

  @override
  String get howItWorksDepthLidar =>
      'Dein Telefon hat LiDAR — die präziseste heute auf einem Telefon verfügbare Methode, mit einem typischen Fehler von nur 10-15 %.';

  @override
  String get howItWorksDepthArcore =>
      'Dein Telefon nutzt die ARCore Depth API, um die Szenentiefe zu schätzen.';

  @override
  String get howItWorksDepthPortrait =>
      'Dein Telefon schätzt die Tiefe über die Dual-Kamera (Porträtmodus) — weniger präzise als LiDAR, aber besser als ein einfaches Foto.';

  @override
  String get howItWorksDepthReference =>
      'Dein Telefon hat keinen Tiefensensor, daher verwenden wir den Standarddurchmesser eines Tellers als Maßstabsreferenz — die am wenigsten präzise Methode, aber immer noch besser als eine rein visuelle Schätzung.';

  @override
  String get howItWorksDepthUnknown =>
      'Wir konnten die von deinem Telefon verwendete Methode nicht bestimmen.';

  @override
  String get reminderPermissionDenied =>
      'Erlaube Benachrichtigungen für die App in den Einstellungen deines Telefons.';

  @override
  String get reminderTimePickerHelp => 'Erinnerungszeit';

  @override
  String get reminderDialogTitle => 'Tägliche Erinnerung';

  @override
  String get reminderDailyNotification => 'Tägliche Benachrichtigung';

  @override
  String get reminderDailyNotificationSubtitle =>
      'Eine Erinnerung, deine Mahlzeiten einzutragen';

  @override
  String get reminderTimeLabel => 'Uhrzeit';

  @override
  String get close => 'Schließen';

  @override
  String get deleteAccountWrongPassword => 'Falsches Passwort.';

  @override
  String deleteAccountFailed(String code) {
    return 'Konto konnte nicht gelöscht werden ($code). Versuche es erneut.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Konto konnte nicht gelöscht werden. Versuche es erneut.';

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountExplanation =>
      'Dies löscht dein Konto und alle deine Daten dauerhaft (Profil, Ernährungstagebuch, Workouts, Gewichte, gemerkte Lebensmittel). Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get password => 'Passwort';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get deleteAccountConfirm => 'Dauerhaft löschen';

  @override
  String get barcodeScanTitle => 'Barcode scannen';

  @override
  String barcodeNotFound(String barcode) {
    return 'Das Produkt mit dem Code $barcode wurde nicht gefunden.';
  }

  @override
  String get addManually => 'Manuell hinzufügen';

  @override
  String get scanAgain => 'Erneut scannen';

  @override
  String get bluetoothScaleTitle => 'Bluetooth-Waage';

  @override
  String get bluetoothScaleSearch => 'Waagen suchen';

  @override
  String get bluetoothScaleIdleHint =>
      'Tippe auf „Waagen suchen“ und schalte deine Waage in der Nähe des Telefons ein.';

  @override
  String get bluetoothScaleSearching => 'Suche läuft...';

  @override
  String get bluetoothScaleNoneFound => 'Noch keine Waage gefunden.';

  @override
  String get bluetoothScaleConnecting => 'Verbindung wird hergestellt...';

  @override
  String get bluetoothScaleWeightSaved => 'Gewicht gespeichert.';

  @override
  String errorPrefixed(String message) {
    return 'Fehler: $message';
  }

  @override
  String get cameraNoneAvailable => 'Keine Kamera auf diesem Gerät verfügbar.';

  @override
  String get cameraCaptureTitle => 'Fotografiere deinen Teller';

  @override
  String get cameraCapturingStatus => 'Foto und Tiefe werden erfasst…';

  @override
  String get cameraAnalyzingStatus => 'Lebensmittel werden identifiziert…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Fertig — Bestätigung wird geöffnet…';

  @override
  String get cameraStartingStatus => 'Kamera wird gestartet…';

  @override
  String get cameraFrameHint =>
      'Rahme den Teller ein und tippe auf den Auslöser';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Foto konnte nicht gestartet/analysiert werden:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Du hast das Tageslimit für Foto-Analysen erreicht. Aktiviere Premium für mehr Analysen pro Tag.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Du musst angemeldet sein, um ein Foto zu analysieren.';

  @override
  String get cameraNetworkErrorMessage =>
      'Verbindung fehlgeschlagen. Überprüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get authEnterEmailFirst =>
      'Gib zuerst deine E-Mail ein, damit wir dir den Link zum Zurücksetzen senden können.';

  @override
  String get authPasswordResetSent =>
      'Wir haben dir eine E-Mail zum Zurücksetzen des Passworts gesendet.';

  @override
  String get authErrorInvalidEmail => 'Ungültige E-Mail-Adresse.';

  @override
  String get authErrorUserNotFound =>
      'Es existiert kein Konto mit dieser E-Mail.';

  @override
  String get authErrorWrongCredentials =>
      'Falsche E-Mail oder falsches Passwort.';

  @override
  String get authErrorEmailInUse =>
      'Ein Konto mit dieser E-Mail existiert bereits.';

  @override
  String get authErrorWeakPassword =>
      'Das Passwort ist zu schwach (mindestens 6 Zeichen).';

  @override
  String get authErrorGeneric =>
      'Etwas ist schiefgelaufen. Versuche es erneut.';

  @override
  String get authWelcomeBack => 'Willkommen zurück';

  @override
  String get authLetsStart => 'Los geht\'s';

  @override
  String get email => 'E-Mail';

  @override
  String get authEnterValidEmail => 'Gib eine gültige E-Mail ein';

  @override
  String get authPasswordMinLength => 'Mindestens 6 Zeichen';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authCreateAccount => 'Konto erstellen';

  @override
  String get authNoAccountYet => 'Noch kein Konto? Erstelle eins';

  @override
  String get authHaveAccountAlready => 'Schon ein Konto? Anmelden';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get activityWalkingCasual => 'Gehen (locker)';

  @override
  String get activityWalkingBrisk => 'Gehen (zügig)';

  @override
  String get activityRunning => 'Laufen';

  @override
  String get activityRunningFast => 'Laufen (schnell)';

  @override
  String get activityCycling => 'Radfahren (moderat)';

  @override
  String get activityCyclingIntense => 'Radfahren (intensiv)';

  @override
  String get activitySwimming => 'Schwimmen';

  @override
  String get activityStrengthTraining => 'Krafttraining';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Tanzen';

  @override
  String get activityHiking => 'Wandern';

  @override
  String get activityJumpRope => 'Seilspringen';

  @override
  String get activityFootball => 'Fußball';

  @override
  String get activityBasketball => 'Basketball';

  @override
  String get activityTennis => 'Tennis';

  @override
  String get activityOther => 'Andere Aktivität';

  @override
  String get mealBreakfast => 'Frühstück';

  @override
  String get mealLunch => 'Mittagessen';

  @override
  String get mealDinner => 'Abendessen';

  @override
  String get mealSnack => 'Snack';

  @override
  String get addWorkoutTitle => 'Workout hinzufügen';

  @override
  String get addWorkoutFromActivity => 'Von Aktivität';

  @override
  String get addWorkoutDirectCalories => 'Direkte Kalorien';

  @override
  String get addWorkoutActivityTypeOptional => 'Aktivitätstyp (optional)';

  @override
  String get addWorkoutCaloriesBurned => 'Verbrannte Kalorien';

  @override
  String get addWorkoutCaloriesHint => 'z. B. 250';

  @override
  String get save => 'Speichern';

  @override
  String get addWorkoutActivityType => 'Aktivitätstyp';

  @override
  String get addWorkoutDuration => 'Dauer';

  @override
  String get minutes => 'Minuten';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Schätzung: $kcal kcal verbrannt';
  }

  @override
  String get confirmFoodsTitle => 'Lebensmittel bestätigen';

  @override
  String get mealLabel => 'Mahlzeit:';

  @override
  String get mixedPlateWarning =>
      'Teller mit gemischten Lebensmitteln — prüfe jeden Punkt, die Erkennung kann weniger genau sein.';

  @override
  String get noItemsLeft =>
      'Du hast alle erkannten Elemente entfernt. Mache ein neues Foto, wenn du es erneut versuchen möchtest.';

  @override
  String get portionSmall => 'Klein';

  @override
  String get portionMedium => 'Mittel';

  @override
  String get portionLarge => 'Groß';

  @override
  String get notOnPlateRemove => 'Nicht auf dem Teller — entfernen';

  @override
  String roughEstimateNote(String source) {
    return 'Grobe Schätzung ($source, kein Tiefensensor)';
  }

  @override
  String get realNutritionDataBadge => 'echte Daten';

  @override
  String totalCalories(int kcal) {
    return 'Gesamt: $kcal kcal';
  }

  @override
  String get activityLevelSedentary => 'Sitzend (Schreibtischjob, kein Sport)';

  @override
  String get activityLevelLight => 'Leichte Aktivität (Sport 1-3 Tage/Woche)';

  @override
  String get activityLevelModerate => 'Mäßige Aktivität (Sport 3-5 Tage/Woche)';

  @override
  String get activityLevelActive => 'Aktiv (Sport 6-7 Tage/Woche)';

  @override
  String get activityLevelVeryActive =>
      'Sehr aktiv (intensiver täglicher Sport / körperliche Arbeit)';

  @override
  String get goalLose => 'Gewicht verlieren';

  @override
  String get goalMaintain => 'Halten';

  @override
  String get goalGain => 'Muskeln aufbauen';

  @override
  String get progressPeriod7Days => '7 Tage';

  @override
  String get progressPeriod30Days => '30 Tage';

  @override
  String get progressPeriodWholeProgram => 'Gesamtes Programm';

  @override
  String get nutrientVitaminC => 'Vitamin C';

  @override
  String get nutrientVitaminD => 'Vitamin D';

  @override
  String get nutrientCalcium => 'Kalzium';

  @override
  String get nutrientIron => 'Eisen';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientPotassium => 'Kalium';

  @override
  String get macroProtein => 'Eiweiß';

  @override
  String get macroCarbs => 'Kohlenhydrate';

  @override
  String get macroFat => 'Fett';

  @override
  String onboardingAgeTooLow(int age) {
    return 'Die App ist für Personen ab $age Jahren gedacht.';
  }

  @override
  String get onboardingAgeInvalid => 'Ungültiger Wert.';

  @override
  String get onboardingAgeSexTitle => 'Alter und biologisches Geschlecht';

  @override
  String get age => 'Alter';

  @override
  String get years => 'Jahre';

  @override
  String get sexFemale => 'Weiblich';

  @override
  String get sexMale => 'Männlich';

  @override
  String get onboardingSexHint =>
      'Wird nur zur Berechnung des Grundumsatzes verwendet (Mifflin-St-Jeor-Formel).';

  @override
  String get onboardingHeightWeightTitle => 'Größe und aktuelles Gewicht';

  @override
  String get height => 'Größe';

  @override
  String get weight => 'Gewicht';

  @override
  String get onboardingActivityTitle => 'Körperliches Aktivitätsniveau';

  @override
  String get onboardingGoalTitle => 'Was ist dein Ziel?';

  @override
  String get onboardingLossRate => 'Gewünschte Verlustrate';

  @override
  String get onboardingGainRate => 'Gewünschte Zunahmerate';

  @override
  String get kgPerWeek => 'kg/Woche';

  @override
  String get onboardingRateRecommendation =>
      'Empfohlen: 0,25-0,75 kg/Woche für ein nachhaltiges Tempo.';

  @override
  String get programStartDateLabel => 'Startdatum der Diät';

  @override
  String get programStartDateHint =>
      'Unterscheidet sich vom Erstellungsdatum des Kontos — ab hier soll der Fortschritt gemessen werden.';

  @override
  String get disclaimerTitle => 'Bevor du beginnst';

  @override
  String get disclaimerIntro =>
      'Calorii Fit schätzt deinen Kalorienbedarf und dein Gewichtsverlusttempo anhand allgemein anerkannter Formeln (Mifflin-St Jeor), nicht anhand einer individuellen medizinischen Beurteilung.';

  @override
  String get disclaimerMedical =>
      'Dies ersetzt nicht den Rat eines Arztes oder Ernährungsberaters — besonders wenn du eine medizinische Erkrankung hast, schwanger bist oder stillst.';

  @override
  String get disclaimerAllergens =>
      'Die Erkennung von Lebensmitteln anhand eines Fotos erkennt keine Allergene. Wenn du eine schwere Allergie oder Unverträglichkeit hast, überprüfe die Zutaten immer selbst — verlasse dich dafür nicht auf die App.';

  @override
  String get disclaimerEatingDisorders =>
      'Wenn du eine schwierige Beziehung zum Essen hattest oder hast (Essstörungen), sprich mit einem Arzt, bevor du Kalorien zählst — die App soll diese Unterstützung nicht ersetzen.';

  @override
  String get disclaimerAcceptLabel =>
      'Ich verstehe und stimme zu, die App unter Berücksichtigung dessen zu nutzen.';

  @override
  String get finish => 'Fertig';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get progress => 'Fortschritt';

  @override
  String get activityAndSync => 'Aktivität & Synchronisierung';

  @override
  String get editProfileGoal => 'Profil/Ziel bearbeiten';

  @override
  String get checkDeviceCapability => 'Gerätefähigkeit prüfen';

  @override
  String get myRecipes => 'Meine Rezepte';

  @override
  String get signOut => 'Abmelden';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get previousDay => 'Vorheriger Tag';

  @override
  String get nextDay => 'Nächster Tag';

  @override
  String get pickDayHelp => 'Tag auswählen';

  @override
  String dateToday(String date) {
    return 'Heute, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Gestern, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Morgen, $date';
  }

  @override
  String get setUpYourGoal => 'Richte dein Ziel ein';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal heute';
  }

  @override
  String get setUp => 'Einrichten';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Ziel: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Kaloriendefizit';

  @override
  String get totalBurnedLabel => 'Insgesamt verbrannt';

  @override
  String get totalConsumedLabel => 'Insgesamt verzehrt';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Du hast das Limit um $overBy kcal überschritten (über $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Überschreite nicht $kcal kcal, um dein Ziel-Verlusttempo zu erreichen.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Du brauchst mindestens $kcal kcal für dein Ziel-Zunahmetempo.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Bleibe bei etwa $kcal kcal, um dein Gewicht zu halten.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Empfohlen: $low–$high kcal';
  }

  @override
  String get addFood => 'Lebensmittel hinzufügen';

  @override
  String get sportActivity => 'Körperliche Aktivität';

  @override
  String get manualCaloriesEntered => 'Manuell eingegebene Kalorien';

  @override
  String get addActivity => 'Aktivität hinzufügen';

  @override
  String get caloricIntake => 'Kalorienaufnahme';

  @override
  String get dailyCaloricDeficit => 'Tägliches Kaloriendefizit';

  @override
  String get setUpProfileFirst =>
      'Richte zuerst dein Profil und Ziel über das Menü ein.';

  @override
  String get totalCaloriesLabel => 'Kalorien gesamt';

  @override
  String get avgPerDay => 'Ø/Tag';

  @override
  String get estimatedLoss => 'Geschätzter Verlust';

  @override
  String get macroBalanceTitle => 'Makronährstoffbalance';

  @override
  String get macroBalanceNoData =>
      'Kein Lebensmittel mit bekannten Eiweiß-/Kohlenhydrat-/Fettwerten in diesem Zeitraum.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share % (empfohlen $min-$max %)';
  }

  @override
  String get micronutrientsTitle => 'Mikronährstoffe (Ø/Tag)';

  @override
  String get micronutrientsNoData =>
      'Kein Lebensmittel mit Vitamin-/Mineralstoffdaten in diesem Zeitraum — siehe Hinweis unten.';

  @override
  String get micronutrientsNoEntries =>
      'Keine Lebensmittel in diesem Zeitraum eingetragen.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Vitamin-/Mineralstoffdaten verfügbar für $pct % der eingetragenen Lebensmittel ($withData/$total) — der Rest (Hausmannskost, unetikettierte Produkte) hat keine bekannten Daten und ist im Durchschnitt nicht enthalten.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent % des Tageswerts';
  }

  @override
  String get chartTargetLabel => 'Ziel';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Health';

  @override
  String get healthConnectDescription =>
      'Ruft das von deiner Uhr erfasste Gewicht und die körperliche Aktivität über die Gesundheitsplattform deines Telefons ab.';

  @override
  String get bluetoothScaleSubtitle => 'Verbinde direkt eine smarte Waage';

  @override
  String get weightHistoryTitle => 'Gewichtsverlauf';

  @override
  String get addLabel => 'Hinzufügen';

  @override
  String get noEntriesYet => 'Noch keine Einträge.';

  @override
  String get syncButton => 'Synchronisieren';

  @override
  String get syncAgain => 'Erneut synchronisieren';

  @override
  String get stepsToday => 'Schritte heute';

  @override
  String get activeKcal => 'aktive kcal';

  @override
  String newWeightFetched(String kg) {
    return 'Neues Gewicht abgerufen: $kg kg';
  }

  @override
  String newWorkoutsImported(int count) {
    return '$count neue Trainingseinheiten von deiner Uhr importiert.';
  }

  @override
  String get weightSourceManual => 'manuell';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Health';

  @override
  String get weightSourceBluetoothScale => 'BT-Waage';

  @override
  String get addWeightTitle => 'Gewicht hinzufügen';

  @override
  String get editWeightTitle => 'Gewicht bearbeiten';

  @override
  String get weighInDateHelp => 'Datum der Wiegung';

  @override
  String get weighInTimeHelp => 'Uhrzeit der Wiegung';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get chooseARecipe => 'Rezept auswählen';

  @override
  String get newRecipe => 'Neues Rezept';

  @override
  String get editRecipe => 'Rezept bearbeiten';

  @override
  String get noRecipesYet =>
      'Du hast noch keine Rezepte gespeichert. Füge eines über die Schaltfläche unten hinzu.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings Portionen · $kcal kcal/Portion';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name wurde heute hinzugefügt.';
  }

  @override
  String addRecipeTo(String name) {
    return '„$name“ hinzufügen zu:';
  }

  @override
  String get recipeNameLabel => 'Rezeptname';

  @override
  String get recipeNameHint => 'z. B. Mein Hähnchensalat';

  @override
  String get numberOfServings => 'Anzahl der Portionen';

  @override
  String get ingredients => 'Zutaten';

  @override
  String get addAtLeastOneIngredient => 'Füge mindestens eine Zutat hinzu.';

  @override
  String get saveRecipe => 'Rezept speichern';

  @override
  String perServing(int grams, int kcal) {
    return 'Pro Portion ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Eiweiß $protein · Kohlenhydrate $carbs · Fett $fat';
  }

  @override
  String get addIngredientTitle => 'Zutat hinzufügen';

  @override
  String get productNameLabel => 'Produktname';

  @override
  String get noProductFound => 'Kein Produkt gefunden.';

  @override
  String get searchWithAiButton => 'Mit KI suchen';

  @override
  String get notFindingWhatYouWant => 'Nicht gefunden, wonach du suchst?';

  @override
  String get aiSearchNoResult =>
      'Die KI konnte für diese Suche kein verlässliches Produkt finden.';

  @override
  String get aiEstimateBadge => 'KI-Schätzung';

  @override
  String get quantityLabel => 'Menge';

  @override
  String get addIngredientButton => 'Zutat hinzufügen';

  @override
  String get editIngredientQuantityTitle => 'Menge bearbeiten';

  @override
  String get chooseRecipeIconTitle => 'Symbol wählen';

  @override
  String get recipeIconSuggested => 'Vorschlag';

  @override
  String get saveAsRecipeTooltip => 'Als Rezept speichern';

  @override
  String get saveAsRecipeDialogTitle => 'Als neues Rezept speichern';

  @override
  String recipeSavedConfirmation(String name) {
    return '„$name“ wurde in deinen Rezepten gespeichert.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Lebensmittel hinzufügen — $meal';
  }

  @override
  String get productNameHint => 'z. B. Griechischer Joghurt';

  @override
  String get enterProductName => 'Gib den Produktnamen ein';

  @override
  String get frequentlyLogged => 'Häufig eingetragen';

  @override
  String addCount(int count) {
    return 'Hinzufügen ($count)';
  }

  @override
  String get calorieIndexLabel => 'Kalorienindex (kcal / 100 g)';

  @override
  String get quantityEatenLabel => 'Verzehrte Menge';

  @override
  String get editGramsDialogTitle => 'Menge bearbeiten';

  @override
  String get requiredField => 'Pflichtfeld';

  @override
  String get invalidValue => 'Ungültiger Wert';

  @override
  String get searchFailedCheckConnection =>
      'Die Suche konnte nicht abgeschlossen werden (überprüfe deine Verbindung).';

  @override
  String get addProductManually => 'Produkt manuell hinzufügen';

  @override
  String get macroProteinShort => 'E';

  @override
  String get macroCarbsShort => 'K';

  @override
  String get macroFatShort => 'F';

  @override
  String get macrosUnavailable => 'Makronährstoffe nicht verfügbar';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Eiweiß $protein · Kohlenhydrate $carbs · Fett $fat';
  }

  @override
  String get languageDialogTitle => 'Sprache';

  @override
  String get languageSystemDefault => 'Telefonsprache (Standard)';

  @override
  String get languageMenuEntry => 'Sprache';

  @override
  String get guideMenuEntry => 'Bedienungsanleitung';

  @override
  String get guideScreenTitle => 'Bedienungsanleitung';

  @override
  String get guideIntroTitle => 'Was ist Calorii Fit';

  @override
  String get guideIntroBody =>
      'Eine Ernährungs-App, die Kalorien direkt aus einem Foto deines Tellers schätzt, mithilfe des Tiefensensors deines Telefons — nicht nur eines gewöhnlichen Fotos. Außerdem führt sie ein vollständiges Tagebuch: Mahlzeiten, Sport, Flüssigkeitszufuhr, Gewicht und deinen Fortschritt zu deinem Ziel.';

  @override
  String get guidePhotoTitle => 'Foto-Schätzung';

  @override
  String get guidePhotoBody =>
      'Du fotografierst deinen Teller, dein Telefon misst dessen Volumen mit LiDAR, ARCore Depth oder einer Dual-Kamera, und die App identifiziert die Lebensmittel und berechnet die Portion. Du bestätigst oder passt das Ergebnis mit einem Regler oder Voreinstellungen an — nichts wird automatisch gespeichert. Ohne Tiefensensor wird der Tellerdurchmesser als Referenz verwendet, deutlich als grobe Schätzung gekennzeichnet.';

  @override
  String get guideLogTitle => 'Tagesprotokoll';

  @override
  String get guideLogBody =>
      'Vier Mahlzeiten pro Tag — Frühstück, Mittagessen, Abendessen, Snack. Füge Lebensmittel per Foto, Suche, Barcode-Scan, manuell, aus deinen Rezepten oder schnell über eine Checkliste deiner üblichen Lebensmittel hinzu. Tippe auf einen erfassten Eintrag, um seine Menge zu bearbeiten. Wenn eine Suche nicht genau das findet, was du suchst, tippe auf „Mit KI suchen“, und bei einem Eintrag mit fehlenden Nährstoffen auf „Mit KI ergänzen“. Du kannst mehrere bereits erfasste Lebensmittel auswählen und sie als neues Rezept speichern.';

  @override
  String get guideRecipesTitle => 'Meine Rezepte';

  @override
  String get guideRecipesBody =>
      'Speichere eine Kombination von Zutaten, die du oft isst, und trage sie mit einem Tipp ein. Du kannst für jedes Rezept ein Symbol wählen (oder den automatischen Vorschlag übernehmen) und die Menge jeder Zutat jederzeit bearbeiten. Wenn du mehrere Lebensmittel gleichzeitig hinzufügst, kannst du sie direkt als neues Rezept speichern.';

  @override
  String get guideWorkoutsTitle => 'Körperliche Aktivität';

  @override
  String get guideWorkoutsBody =>
      'Wähle die Aktivitätsart und Dauer, die verbrannten Kalorien werden automatisch berechnet — oder gib sie direkt ein, wenn du sie bereits von einer Smartwatch kennst. Verbrannte Kalorien werden vom Tagesbudget abgezogen.';

  @override
  String get guideProgressTitle => 'Fortschritt';

  @override
  String get guideProgressBody =>
      'Diagramme über 7 Tage, 30 Tage oder das gesamte Programm: Gewichtsverlauf (geglättet), adaptiver Gesamtenergieumsatz aus deiner eigenen Energiebilanz, Makronährstoffbalance und Mikronährstoffabdeckung. Synchronisation mit Apple Health / Health Connect und einer Bluetooth-Waage. Fehlen mehreren Einträgen Nährstoffe, füllt „Mit KI ergänzen“ sie alle auf einmal auf (Premium oder Testphase). Das Symbol in der Kopfzeile öffnet „Nährstoffquellen“: welche Lebensmittel am meisten beitragen, getrennt nach Makro- und Mikronährstoffen.';

  @override
  String get guideHydrationTitle => 'Flüssigkeitszufuhr';

  @override
  String get guideHydrationBody =>
      'Ein einfacher täglicher Wasserglaszähler — ein Tipp zum Hinzufügen, ein Tipp, um das letzte rückgängig zu machen.';

  @override
  String get guideStreaksTitle => 'Motivation';

  @override
  String get guideStreaksBody =>
      'Ein Flammen-Abzeichen zeigt, wie viele Tage in Folge du mindestens eine Mahlzeit protokolliert hast.';

  @override
  String get guideRemindersTitle => 'Tägliche Erinnerung';

  @override
  String get guideRemindersBody =>
      'Eine Benachrichtigung zur von dir gewählten Zeit, die dich erinnert, deine Mahlzeiten einzutragen — jederzeit über das Menü deaktivierbar.';

  @override
  String get guideProfileTitle => 'Profil und Ziel';

  @override
  String get guideProfileBody =>
      'Alter, biologisches Geschlecht, Größe, Gewicht, Aktivitätsniveau und Ziel — jederzeit bearbeitbar. Die App berechnet dein Kalorienziel bei jeder Änderung automatisch neu.';

  @override
  String get guidePrivacyTitle => 'Datenschutz';

  @override
  String get guidePrivacyBody =>
      'Deine Daten sind ausschließlich mit deinem Konto verknüpft und für andere Nutzer nicht sichtbar. Du kannst dein Konto und alle zugehörigen Daten jederzeit über das Menü löschen — die Löschung ist dauerhaft und sofort.';

  @override
  String get guideLanguagesTitle => 'Verfügbare Sprachen';

  @override
  String get guideLanguagesBody =>
      'Die App ist in 13 Sprachen verfügbar, die über das Menü ausgewählt werden — nicht nur automatisch anhand der Telefonsprache erkannt.';

  @override
  String get guidePremiumTitle => 'Premium und Abonnements';

  @override
  String get guidePremiumFreeBody =>
      'Kostenlos, dauerhaft: vollständiges Ernährungstagebuch, eine Foto-Analyse pro Tag, unbegrenzte Suche, unbegrenzte eigene Rezepte, grundlegende Fortschrittsdiagramme und Apple Health / Health Connect-Synchronisierung.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (mit einem Code aktiviert): 20 Foto-Analysen pro Tag und 20 KI-Suchen pro Tag zur automatischen Nährstoffergänzung, plus adaptiver Gesamtenergieumsatz und detaillierte Mikronährstoffe.';

  @override
  String get guidePremiumTrialNote =>
      'Neues Konto? Du bekommst eine 14-tägige Testphase: 3 Foto-Analysen pro Tag und bis zu 10 KI-Suchen inklusive, ohne Code.';

  @override
  String get guidePremiumRedeemButton => 'Ich habe einen Premium-Code';

  @override
  String get themeDialogTitle => 'Design';

  @override
  String get themeSystemDefault => 'Telefon-Design (Standard)';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeMenuEntry => 'Design';

  @override
  String get barcodeToggleTorch => 'Blitz umschalten';

  @override
  String get clearSelection => 'Auswahl löschen';

  @override
  String get accessCodeMenuEntry => 'Zugangscode';

  @override
  String get adminDashboardMenuEntry => 'Admin-Dashboard';

  @override
  String get accessCodeScreenTitle => 'Zugangscode';

  @override
  String get premiumCodeFieldLabel => 'Premium-Code';

  @override
  String get activatePremiumButton => 'Premium aktivieren';

  @override
  String premiumActivatedMessage(String date) {
    return 'Premium-Zugang aktiviert bis $date.';
  }

  @override
  String get iAmAdminLink => 'Ich bin Admin';

  @override
  String get adminPasswordFieldLabel => 'Admin-Passwort';

  @override
  String get adminTotpFieldLabel => 'Code aus der Authenticator-App';

  @override
  String get activateAdminButton => 'Admin aktivieren';

  @override
  String get adminActivatedMessage => 'Admin-Konto aktiviert.';

  @override
  String get adminDashboardTitle => 'Admin-Dashboard';

  @override
  String get totalUsersLabel => 'Nutzer insgesamt';

  @override
  String get activePremiumLabel => 'Aktives Premium';

  @override
  String get generateCodeSectionTitle => 'Premium-Code generieren';

  @override
  String get targetEmailLabel => 'Konto-E-Mail';

  @override
  String get durationDaysLabel => 'Dauer (Tage)';

  @override
  String get generateCodeButton => 'Code generieren';

  @override
  String get codeGeneratedTitle => 'Code generiert';

  @override
  String get generatedCodesSectionTitle => 'Generierte Codes';

  @override
  String get noCodesGeneratedYet => 'Noch keine Codes generiert.';

  @override
  String get codeStatusPending => 'unbenutzt';

  @override
  String get codeStatusRedeemed => 'benutzt';

  @override
  String get codeStatusRevoked => 'widerrufen';

  @override
  String durationDaysValue(int days) {
    return '$days Tage';
  }

  @override
  String get completeNutritionWithAiTooltip => 'Mit KI ergänzen';

  @override
  String get nutritionCompletedMessage => 'Nährwertdaten ergänzt.';

  @override
  String get aiCompletionNoResult =>
      'Die KI konnte keine verlässlichen Daten für dieses Lebensmittel finden.';

  @override
  String bulkNutritionCompletionButton(int count) {
    return 'Mit KI ergänzen ($count)';
  }

  @override
  String bulkNutritionCompletionProgress(int done, int total) {
    return '$done/$total ...';
  }

  @override
  String bulkNutritionCompletionPremiumLocked(int count) {
    return 'Premium-Funktion ($count Lebensmittel)';
  }

  @override
  String bulkNutritionCompletionResult(int completed, int total) {
    return '$completed von $total Lebensmitteln ergänzt.';
  }

  @override
  String get nutrientSourcesTitle => 'Nährstoffquellen';

  @override
  String get macroSourcesSectionTitle => 'Makronährstoffe';

  @override
  String get micronutrientSourcesSectionTitle => 'Mikronährstoffe';

  @override
  String get nutrientSourcesNoData => 'Nicht genug Daten für diesen Zeitraum.';

  @override
  String get nutrientSourcesOthers => 'andere Lebensmittel';
}

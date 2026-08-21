// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Vergeet niet je maaltijden bij te houden';

  @override
  String get dailyReminderBody =>
      'Een paar seconden zijn genoeg om je dagboek actueel en je reeks levend te houden.';

  @override
  String get dailyReminderChannelName => 'Dagelijkse herinnering';

  @override
  String get dailyReminderChannelDescription =>
      'Herinnering om de maaltijden van vandaag bij te houden';

  @override
  String get updateRequiredTitle => 'Een update is nodig';

  @override
  String get updateRequiredMessage =>
      'De versie van de app op deze telefoon wordt niet meer ondersteund. Installeer de nieuwste versie om door te gaan.';

  @override
  String get updateAvailableMessage =>
      'Er is een nieuwe versie van de app beschikbaar.';

  @override
  String get hydrationTitle => 'Hydratatie';

  @override
  String get hydrationUndoLastGlass => 'Laatste glas ongedaan maken';

  @override
  String hydrationAddGlass(int ml) {
    return 'Glas toevoegen ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'Adaptief TDEE';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Nog niet genoeg gegevens: je hebt minstens 14 geregistreerde dagen en 2 wegingen met minstens 10 dagen ertussen nodig, binnen de laatste 3 weken. Tot dan wordt de standaardformule (Mifflin-St Jeor) gebruikt.';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Berekend op basis van je eigen calorie-balans ($loggedDays/$windowDays dagen geregistreerd in de laatste 3 weken), niet alleen de standaardformule.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'Geschat TDEE';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Gewichtstrend';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/week';
  }

  @override
  String get adaptiveTdeeRejected =>
      'De schatting wijkt nog te veel af van de standaardformule om betrouwbaar te zijn — de standaardformule blijft gebruikt worden, tot er meer consistente gegevens verzameld zijn.';

  @override
  String get weeklySummaryTitle => 'Samenvatting van de week';

  @override
  String get weeklySummaryDaysLogged => 'Geregistreerde dagen';

  @override
  String get weeklySummaryAvgCalories => 'Gem. kcal/dag';

  @override
  String get weeklySummaryWorkouts => 'Workouts';

  @override
  String get weightEvolutionTitle => 'Gewichtsverloop';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Van $date ($startKg kg) tot vandaag ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Diepte-capture-capaciteit';

  @override
  String deviceCapabilityError(String error) {
    return 'Fout bij het controleren van de mogelijkheden:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR beschikbaar';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth beschikbaar';

  @override
  String get depthSourcePortraitLabel => 'Dubbele camera (portretdiepte)';

  @override
  String get depthSourceReferenceLabel => 'Geen dieptesensor';

  @override
  String get depthSourceUnknownLabel => 'Onbekend';

  @override
  String get depthSourceLidarDescription =>
      'Zeer nauwkeurige volumetrische schatting (~10-15% afwijking).';

  @override
  String get depthSourceArcoreDescription =>
      'Volumetrische schatting via de ARCore Depth API.';

  @override
  String get depthSourcePortraitDescription =>
      'Geschatte diepte via de dubbele camera, lagere nauwkeurigheid.';

  @override
  String get depthSourceReferenceDescription =>
      'De diameter van het bord wordt gebruikt als schaalreferentie (minder nauwkeurige schatting).';

  @override
  String get depthSourceUnknownDescription =>
      'Kon de capaciteit van het apparaat niet bepalen.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'dubbele camera';

  @override
  String get depthSourceReferenceShort => 'visuele referentie';

  @override
  String get depthSourceUnknownShort => 'onbekend';

  @override
  String get howItWorksTitle => 'Hoe we calorieën berekenen';

  @override
  String get howItWorksTooltip => 'Hoe berekenen we calorieën?';

  @override
  String get howItWorksIntro =>
      'De meeste voedingsapps schatten de portie op basis van één 2D-foto. Calorii Fit meet daadwerkelijk het volume van het eten op het bord, met behulp van de dieptekaart van je telefoon — daarom is de schatting nauwkeuriger.';

  @override
  String get howItWorksStep1Title => 'Fotografeer je bord';

  @override
  String get howItWorksStep1Description =>
      'Eén foto, geen speciale positionering nodig.';

  @override
  String get howItWorksStep2Title => 'Je telefoon legt de diepte vast';

  @override
  String get howItWorksStep2GenericDescription =>
      'Je telefoon gebruikt, afhankelijk van het model, LiDAR, ARCore Depth of een dubbele camera om te weten hoe hoog het eten is, niet alleen hoe het er van bovenaf uitziet.';

  @override
  String get howItWorksStep3Title => 'Claude identificeert de gerechten';

  @override
  String get howItWorksStep3Description =>
      'Het model herkent wat er op het bord staat en markeert de globale omtrek van elk gerecht — het berekent zelf geen calorieën, het identificeert alleen.';

  @override
  String get howItWorksStep4Title => 'Volume wordt grammen, dan calorieën';

  @override
  String get howItWorksStep4Description =>
      'De dieptekaart × de omtrek van elk gerecht geeft een volume in cm³. Een dichtheidstabel (specifiek voor elk type voedsel) zet het volume om in grammen, en de voedingsdatabase zet de grammen om in calorieën en macronutriënten.';

  @override
  String get howItWorksStep5Title => 'Jij bevestigt of corrigeert';

  @override
  String get howItWorksStep5Description =>
      'De automatische schatting wordt nooit direct opgeslagen — je ziet altijd een bevestigingsscherm waar je de portie kunt aanpassen of het geïdentificeerde gerecht kunt wijzigen.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Bekijk welke methode je telefoon gebruikt';

  @override
  String get howItWorksDepthLidar =>
      'Je telefoon heeft LiDAR — de meest nauwkeurige methode die vandaag beschikbaar is op een telefoon, met een typische afwijking van slechts 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Je telefoon gebruikt de ARCore Depth API om de scènediepte te schatten.';

  @override
  String get howItWorksDepthPortrait =>
      'Je telefoon schat de diepte via de dubbele camera (portretmodus) — minder nauwkeurig dan LiDAR, maar nog steeds beter dan een gewone foto.';

  @override
  String get howItWorksDepthReference =>
      'Je telefoon heeft geen dieptesensor, dus gebruiken we de standaarddiameter van een bord als schaalreferentie — de minst nauwkeurige methode, maar nog steeds beter dan een puur visuele schatting.';

  @override
  String get howItWorksDepthUnknown =>
      'We konden de methode die je telefoon gebruikt niet bepalen.';

  @override
  String get reminderPermissionDenied =>
      'Sta meldingen voor de app toe in de instellingen van je telefoon.';

  @override
  String get reminderTimePickerHelp => 'Tijdstip van herinnering';

  @override
  String get reminderDialogTitle => 'Dagelijkse herinnering';

  @override
  String get reminderDailyNotification => 'Dagelijkse melding';

  @override
  String get reminderDailyNotificationSubtitle =>
      'Een herinnering om je maaltijden bij te houden';

  @override
  String get reminderTimeLabel => 'Tijdstip';

  @override
  String get close => 'Sluiten';

  @override
  String get deleteAccountWrongPassword => 'Onjuist wachtwoord.';

  @override
  String deleteAccountFailed(String code) {
    return 'Kon account niet verwijderen ($code). Probeer het opnieuw.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Kon account niet verwijderen. Probeer het opnieuw.';

  @override
  String get deleteAccountTitle => 'Account verwijderen';

  @override
  String get deleteAccountExplanation =>
      'Dit verwijdert je account en alle gegevens permanent (profiel, voedingsdagboek, workouts, gewichten, onthouden gerechten). Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get password => 'Wachtwoord';

  @override
  String get cancel => 'Annuleren';

  @override
  String get deleteAccountConfirm => 'Definitief verwijderen';

  @override
  String get barcodeScanTitle => 'Barcode scannen';

  @override
  String barcodeNotFound(String barcode) {
    return 'Het product met code $barcode is niet gevonden.';
  }

  @override
  String get addManually => 'Handmatig toevoegen';

  @override
  String get scanAgain => 'Opnieuw scannen';

  @override
  String get bluetoothScaleTitle => 'Bluetooth-weegschaal';

  @override
  String get bluetoothScaleSearch => 'Weegschalen zoeken';

  @override
  String get bluetoothScaleIdleHint =>
      'Tik op \"Weegschalen zoeken\" en zet je weegschaal aan in de buurt van de telefoon.';

  @override
  String get bluetoothScaleSearching => 'Zoeken...';

  @override
  String get bluetoothScaleNoneFound => 'Nog geen weegschaal gevonden.';

  @override
  String get bluetoothScaleConnecting => 'Verbinden...';

  @override
  String get bluetoothScaleWeightSaved => 'Gewicht opgeslagen.';

  @override
  String errorPrefixed(String message) {
    return 'Fout: $message';
  }

  @override
  String get cameraNoneAvailable => 'Geen camera beschikbaar op dit apparaat.';

  @override
  String get cameraCaptureTitle => 'Fotografeer je bord';

  @override
  String get cameraCapturingStatus => 'Foto en diepte worden vastgelegd…';

  @override
  String get cameraAnalyzingStatus => 'Gerechten worden geïdentificeerd…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Klaar — bevestiging wordt geopend…';

  @override
  String get cameraStartingStatus => 'Camera wordt gestart…';

  @override
  String get cameraFrameHint => 'Kader het bord en tik op de sluiter';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Kon de foto niet starten/analyseren:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Je hebt de limiet van 20 fotoanalyses per dag bereikt. Probeer het morgen opnieuw.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Je moet ingelogd zijn om een foto te analyseren.';

  @override
  String get cameraNetworkErrorMessage =>
      'Kan geen verbinding maken. Controleer je internetverbinding en probeer het opnieuw.';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get authEnterEmailFirst =>
      'Voer eerst je e-mail in, zodat we je de resetlink kunnen sturen.';

  @override
  String get authPasswordResetSent =>
      'We hebben je een e-mail gestuurd om je wachtwoord opnieuw in te stellen.';

  @override
  String get authErrorInvalidEmail => 'Ongeldig e-mailadres.';

  @override
  String get authErrorUserNotFound =>
      'Er bestaat geen account met dit e-mailadres.';

  @override
  String get authErrorWrongCredentials => 'Onjuist e-mailadres of wachtwoord.';

  @override
  String get authErrorEmailInUse =>
      'Er bestaat al een account met dit e-mailadres.';

  @override
  String get authErrorWeakPassword =>
      'Het wachtwoord is te zwak (minimaal 6 tekens).';

  @override
  String get authErrorGeneric => 'Er ging iets mis. Probeer het opnieuw.';

  @override
  String get authWelcomeBack => 'Welkom terug';

  @override
  String get authLetsStart => 'Laten we beginnen';

  @override
  String get email => 'E-mail';

  @override
  String get authEnterValidEmail => 'Voer een geldig e-mailadres in';

  @override
  String get authPasswordMinLength => 'Minimaal 6 tekens';

  @override
  String get authSignIn => 'Inloggen';

  @override
  String get authCreateAccount => 'Account aanmaken';

  @override
  String get authNoAccountYet => 'Nog geen account? Maak er een aan';

  @override
  String get authHaveAccountAlready => 'Al een account? Log in';

  @override
  String get authForgotPassword => 'Wachtwoord vergeten?';

  @override
  String get activityWalkingCasual => 'Wandelen (rustig)';

  @override
  String get activityWalkingBrisk => 'Wandelen (stevig)';

  @override
  String get activityRunning => 'Hardlopen';

  @override
  String get activityRunningFast => 'Hardlopen (snel)';

  @override
  String get activityCycling => 'Fietsen (gemiddeld)';

  @override
  String get activityCyclingIntense => 'Fietsen (intensief)';

  @override
  String get activitySwimming => 'Zwemmen';

  @override
  String get activityStrengthTraining => 'Krachttraining';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Dansen';

  @override
  String get activityHiking => 'Wandeltocht';

  @override
  String get activityJumpRope => 'Touwtjespringen';

  @override
  String get activityFootball => 'Voetbal';

  @override
  String get activityBasketball => 'Basketbal';

  @override
  String get activityTennis => 'Tennis';

  @override
  String get activityOther => 'Andere activiteit';

  @override
  String get mealBreakfast => 'Ontbijt';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Avondeten';

  @override
  String get mealSnack => 'Snack';

  @override
  String get addWorkoutTitle => 'Workout toevoegen';

  @override
  String get addWorkoutFromActivity => 'Vanuit activiteit';

  @override
  String get addWorkoutDirectCalories => 'Directe calorieën';

  @override
  String get addWorkoutActivityTypeOptional => 'Type activiteit (optioneel)';

  @override
  String get addWorkoutCaloriesBurned => 'Verbrande calorieën';

  @override
  String get addWorkoutCaloriesHint => 'bijv. 250';

  @override
  String get save => 'Opslaan';

  @override
  String get addWorkoutActivityType => 'Type activiteit';

  @override
  String get addWorkoutDuration => 'Duur';

  @override
  String get minutes => 'minuten';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Schatting: $kcal kcal verbrand';
  }

  @override
  String get confirmFoodsTitle => 'Bevestig de gerechten';

  @override
  String get mealLabel => 'Maaltijd:';

  @override
  String get mixedPlateWarning =>
      'Bord met gemengde gerechten — controleer elk onderdeel, de identificatie kan minder nauwkeurig zijn.';

  @override
  String get noItemsLeft =>
      'Je hebt alle geïdentificeerde items verwijderd. Maak een nieuwe foto als je het opnieuw wilt proberen.';

  @override
  String get portionSmall => 'Klein';

  @override
  String get portionMedium => 'Gemiddeld';

  @override
  String get portionLarge => 'Groot';

  @override
  String get notOnPlateRemove => 'Niet op het bord — verwijderen';

  @override
  String roughEstimateNote(String source) {
    return 'Ruwe schatting ($source, geen dieptesensor)';
  }

  @override
  String get realNutritionDataBadge => 'echte data';

  @override
  String totalCalories(int kcal) {
    return 'Totaal: $kcal kcal';
  }

  @override
  String get activityLevelSedentary => 'Zittend (bureaubaan, geen beweging)';

  @override
  String get activityLevelLight =>
      'Lichte activiteit (beweging 1-3 dagen/week)';

  @override
  String get activityLevelModerate =>
      'Matige activiteit (beweging 3-5 dagen/week)';

  @override
  String get activityLevelActive => 'Actief (beweging 6-7 dagen/week)';

  @override
  String get activityLevelVeryActive =>
      'Zeer actief (intensieve dagelijkse beweging / fysiek werk)';

  @override
  String get goalLose => 'Afvallen';

  @override
  String get goalMaintain => 'Behouden';

  @override
  String get goalGain => 'Spieren opbouwen';

  @override
  String get progressPeriod7Days => '7 dagen';

  @override
  String get progressPeriod30Days => '30 dagen';

  @override
  String get progressPeriodWholeProgram => 'Hele programma';

  @override
  String get nutrientVitaminC => 'Vitamine C';

  @override
  String get nutrientVitaminD => 'Vitamine D';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientIron => 'IJzer';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientPotassium => 'Kalium';

  @override
  String get macroProtein => 'Eiwitten';

  @override
  String get macroCarbs => 'Koolhydraten';

  @override
  String get macroFat => 'Vetten';

  @override
  String onboardingAgeTooLow(int age) {
    return 'De app is bedoeld voor mensen van $age jaar en ouder.';
  }

  @override
  String get onboardingAgeInvalid => 'Ongeldige waarde.';

  @override
  String get onboardingAgeSexTitle => 'Leeftijd en biologisch geslacht';

  @override
  String get age => 'Leeftijd';

  @override
  String get years => 'jaar';

  @override
  String get sexFemale => 'Vrouwelijk';

  @override
  String get sexMale => 'Mannelijk';

  @override
  String get onboardingSexHint =>
      'Wordt alleen gebruikt om het basaal metabolisme te berekenen (Mifflin-St Jeor-formule).';

  @override
  String get onboardingHeightWeightTitle => 'Lengte en huidig gewicht';

  @override
  String get height => 'Lengte';

  @override
  String get weight => 'Gewicht';

  @override
  String get onboardingActivityTitle => 'Niveau van lichamelijke activiteit';

  @override
  String get onboardingGoalTitle => 'Wat is je doel?';

  @override
  String get onboardingLossRate => 'Gewenst afvaltempo';

  @override
  String get onboardingGainRate => 'Gewenst aankomtempo';

  @override
  String get kgPerWeek => 'kg/week';

  @override
  String get onboardingRateRecommendation =>
      'Aanbevolen: 0,25-0,75 kg/week voor een houdbaar tempo.';

  @override
  String get programStartDateLabel => 'Startdatum van het dieet';

  @override
  String get programStartDateHint =>
      'Anders dan de aanmaakdatum van je account — dit is het punt vanaf waar je de voortgang wilt meten.';

  @override
  String get disclaimerTitle => 'Voordat je begint';

  @override
  String get disclaimerIntro =>
      'Calorii Fit schat je caloriebehoefte en gewichtsverliestempo op basis van algemeen aanvaarde formules (Mifflin-St Jeor), geen individuele medische beoordeling.';

  @override
  String get disclaimerMedical =>
      'Het vervangt geen advies van een arts of diëtist — vooral als je een medische aandoening hebt, zwanger bent of borstvoeding geeft.';

  @override
  String get disclaimerAllergens =>
      'Het identificeren van gerechten op basis van een foto detecteert geen allergenen. Als je een ernstige allergie of intolerantie hebt, controleer dan altijd zelf de ingrediënten — vertrouw hiervoor niet op de app.';

  @override
  String get disclaimerEatingDisorders =>
      'Als je een moeilijke relatie met eten hebt gehad of hebt (eetstoornissen), praat dan met een arts voordat je calorieën gaat bijhouden — de app is niet bedoeld om die ondersteuning te vervangen.';

  @override
  String get disclaimerAcceptLabel =>
      'Ik begrijp dit en ga akkoord om de app hiermee rekening houdend te gebruiken.';

  @override
  String get finish => 'Voltooien';

  @override
  String get continueLabel => 'Doorgaan';

  @override
  String get progress => 'Voortgang';

  @override
  String get activityAndSync => 'Activiteit en synchronisatie';

  @override
  String get editProfileGoal => 'Profiel/doel bewerken';

  @override
  String get checkDeviceCapability => 'Apparaatcapaciteit controleren';

  @override
  String get myRecipes => 'Mijn recepten';

  @override
  String get signOut => 'Uitloggen';

  @override
  String get takePhoto => 'Foto maken';

  @override
  String get previousDay => 'Vorige dag';

  @override
  String get nextDay => 'Volgende dag';

  @override
  String get pickDayHelp => 'Kies een dag';

  @override
  String dateToday(String date) {
    return 'Vandaag, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Gisteren, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Morgen, $date';
  }

  @override
  String get setUpYourGoal => 'Stel je doel in';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal vandaag';
  }

  @override
  String get setUp => 'Instellen';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Doel: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Calorietekort';

  @override
  String get totalBurnedLabel => 'Totaal verbrand';

  @override
  String get totalConsumedLabel => 'Totaal geconsumeerd';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Je hebt de limiet met $overBy kcal overschreden (boven $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Overschrijd $kcal kcal niet, om je gewenste afvaltempo te halen.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Je hebt minstens $kcal kcal nodig voor je gewenste aankomtempo.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Blijf rond de $kcal kcal om te behouden.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Aanbevolen: $low–$high kcal';
  }

  @override
  String get addFood => 'Voedsel toevoegen';

  @override
  String get sportActivity => 'Lichamelijke activiteit';

  @override
  String get manualCaloriesEntered => 'Handmatig ingevoerde calorieën';

  @override
  String get addActivity => 'Activiteit toevoegen';

  @override
  String get caloricIntake => 'Calorie-inname';

  @override
  String get dailyCaloricDeficit => 'Dagelijks calorietekort';

  @override
  String get setUpProfileFirst =>
      'Stel eerst je profiel en doel in via het menu.';

  @override
  String get totalCaloriesLabel => 'Totaal aantal calorieën';

  @override
  String get avgPerDay => 'Gem./dag';

  @override
  String get estimatedLoss => 'Geschat verlies';

  @override
  String get macroBalanceTitle => 'Balans macronutriënten';

  @override
  String get macroBalanceNoData =>
      'Geen gerecht met bekende eiwitten/koolhydraten/vetten in deze periode.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (aanbevolen $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Micronutriënten (gem./dag)';

  @override
  String get micronutrientsNoData =>
      'Geen gerecht met vitamine-/mineraalgegevens in deze periode — zie de opmerking hieronder.';

  @override
  String get micronutrientsNoEntries =>
      'Geen gerechten geregistreerd in deze periode.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Vitamine-/mineraalgegevens beschikbaar voor $pct% van de geregistreerde gerechten ($withData/$total) — de rest (thuis gekookt, ongeëtiketteerde producten) heeft geen bekende gegevens en wordt niet meegenomen in het gemiddelde.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% van de dagelijkse waarde';
  }

  @override
  String get chartTargetLabel => 'Doel';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Gezondheid';

  @override
  String get healthConnectDescription =>
      'Haalt het gewicht en de lichamelijke activiteit op die door je horloge zijn geregistreerd, via het gezondheidsplatform van je telefoon.';

  @override
  String get bluetoothScaleSubtitle =>
      'Verbind rechtstreeks een slimme weegschaal';

  @override
  String get weightHistoryTitle => 'Gewichtsgeschiedenis';

  @override
  String get addLabel => 'Toevoegen';

  @override
  String get noEntriesYet => 'Nog geen items.';

  @override
  String get syncButton => 'Synchroniseren';

  @override
  String get syncAgain => 'Opnieuw synchroniseren';

  @override
  String get stepsToday => 'stappen vandaag';

  @override
  String get activeKcal => 'actieve kcal';

  @override
  String newWeightFetched(String kg) {
    return 'Nieuw gewicht opgehaald: $kg kg';
  }

  @override
  String newWorkoutsImported(int count) {
    return '$count nieuwe workouts geïmporteerd van je horloge.';
  }

  @override
  String get weightSourceManual => 'handmatig';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Gezondheid';

  @override
  String get weightSourceBluetoothScale => 'BT-weegschaal';

  @override
  String get addWeightTitle => 'Gewicht toevoegen';

  @override
  String get editWeightTitle => 'Gewicht bewerken';

  @override
  String get weighInDateHelp => 'Datum van weging';

  @override
  String get weighInTimeHelp => 'Tijdstip van weging';

  @override
  String get edit => 'Bewerken';

  @override
  String get delete => 'Verwijderen';

  @override
  String get chooseARecipe => 'Kies een recept';

  @override
  String get newRecipe => 'Nieuw recept';

  @override
  String get editRecipe => 'Recept bewerken';

  @override
  String get noRecipesYet =>
      'Je hebt nog geen recepten opgeslagen. Voeg er een toe met de knop hieronder.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings porties · $kcal kcal/portie';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name is vandaag toegevoegd.';
  }

  @override
  String addRecipeTo(String name) {
    return '\"$name\" toevoegen aan:';
  }

  @override
  String get recipeNameLabel => 'Naam van het recept';

  @override
  String get recipeNameHint => 'bijv. Mijn kipsalade';

  @override
  String get numberOfServings => 'Aantal porties';

  @override
  String get ingredients => 'Ingrediënten';

  @override
  String get addAtLeastOneIngredient => 'Voeg minstens één ingrediënt toe.';

  @override
  String get saveRecipe => 'Recept opslaan';

  @override
  String perServing(int grams, int kcal) {
    return 'Per portie ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Eiwitten $protein · Koolhydraten $carbs · Vetten $fat';
  }

  @override
  String get addIngredientTitle => 'Ingrediënt toevoegen';

  @override
  String get productNameLabel => 'Productnaam';

  @override
  String get noProductFound => 'Geen product gevonden.';

  @override
  String get searchWithAiButton => 'Zoeken met AI';

  @override
  String get aiSearchNoResult =>
      'AI kon geen betrouwbaar product vinden voor deze zoekopdracht.';

  @override
  String get aiEstimateBadge => 'AI-schatting';

  @override
  String get quantityLabel => 'Hoeveelheid';

  @override
  String get addIngredientButton => 'Ingrediënt toevoegen';

  @override
  String get editIngredientQuantityTitle => 'Hoeveelheid bewerken';

  @override
  String get chooseRecipeIconTitle => 'Kies een icoon';

  @override
  String get recipeIconSuggested => 'Voorgesteld';

  @override
  String get saveAsRecipeTooltip => 'Opslaan als recept';

  @override
  String get saveAsRecipeDialogTitle => 'Opslaan als nieuw recept';

  @override
  String recipeSavedConfirmation(String name) {
    return '\"$name\" is opgeslagen in je recepten.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Voedsel toevoegen — $meal';
  }

  @override
  String get productNameHint => 'bijv. Griekse yoghurt';

  @override
  String get enterProductName => 'Voer de productnaam in';

  @override
  String get frequentlyLogged => 'Vaak geregistreerd';

  @override
  String addCount(int count) {
    return 'Toevoegen ($count)';
  }

  @override
  String get calorieIndexLabel => 'Calorie-index (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Gegeten hoeveelheid';

  @override
  String get editGramsDialogTitle => 'Portie bewerken';

  @override
  String get requiredField => 'Verplicht veld';

  @override
  String get invalidValue => 'Ongeldige waarde';

  @override
  String get searchFailedCheckConnection =>
      'De zoekopdracht kon niet worden voltooid (controleer je verbinding).';

  @override
  String get addProductManually => 'Product handmatig toevoegen';

  @override
  String get macroProteinShort => 'E';

  @override
  String get macroCarbsShort => 'K';

  @override
  String get macroFatShort => 'V';

  @override
  String get macrosUnavailable => 'Macronutriënten niet beschikbaar';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Eiwitten $protein · Koolhydraten $carbs · Vetten $fat';
  }

  @override
  String get languageDialogTitle => 'Taal';

  @override
  String get languageSystemDefault => 'Telefoontaal (standaard)';

  @override
  String get languageMenuEntry => 'Taal';

  @override
  String get guideMenuEntry => 'Gebruikershandleiding';

  @override
  String get guideScreenTitle => 'Gebruikershandleiding';

  @override
  String get guideIntroTitle => 'Wat is Calorii Fit';

  @override
  String get guideIntroBody =>
      'Een voedingsapp die calorieën rechtstreeks schat aan de hand van een foto van je bord, met behulp van de dieptesensor van je telefoon — niet zomaar een gewone foto. Daarnaast houdt de app een volledig dagboek bij: maaltijden, sport, hydratatie, gewicht en je voortgang richting je doel.';

  @override
  String get guidePhotoTitle => 'Schatting via foto';

  @override
  String get guidePhotoBody =>
      'Je fotografeert je bord, je telefoon meet het volume met LiDAR, ARCore Depth of een dubbele camera, en de app identificeert de gerechten en berekent de portie. Je bevestigt of past het resultaat aan met een schuifregelaar of voorinstellingen — er wordt niets automatisch opgeslagen. Zonder dieptesensor wordt de diameter van het bord als referentie gebruikt, duidelijk gemarkeerd als ruwe schatting.';

  @override
  String get guideLogTitle => 'Dagelijks logboek';

  @override
  String get guideLogBody =>
      'Vier maaltijden per dag — Ontbijt, Lunch, Avondeten, Snack. Voeg gerechten toe via foto, zoeken, het scannen van een barcode, handmatig, vanuit je recepten of snel via een afvinklijst met je gebruikelijke gerechten.';

  @override
  String get guideRecipesTitle => 'Mijn recepten';

  @override
  String get guideRecipesBody =>
      'Sla een combinatie van ingrediënten op die je vaak eet en log ze met één tik. Je kunt voor elk recept een icoon kiezen (of de automatische suggestie overnemen) en de hoeveelheid van elk ingrediënt altijd bewerken. Wanneer je meerdere gerechten tegelijk toevoegt, kun je ze meteen opslaan als nieuw recept.';

  @override
  String get guideWorkoutsTitle => 'Lichamelijke activiteit';

  @override
  String get guideWorkoutsBody =>
      'Kies het type activiteit en de duur, de verbrande calorieën worden automatisch berekend — of voer ze rechtstreeks in als je ze al kent van een smartwatch. Verbrande calorieën worden afgetrokken van het dagbudget.';

  @override
  String get guideProgressTitle => 'Voortgang';

  @override
  String get guideProgressBody =>
      'Grafieken over 7 dagen, 30 dagen of het hele programma: gewichtsverloop (afgevlakt), adaptief TDEE berekend uit je eigen energiebalans, macronutriëntenbalans en dekking van micronutriënten. Synchroniseert met Apple Gezondheid / Health Connect en een Bluetooth-weegschaal.';

  @override
  String get guideHydrationTitle => 'Hydratatie';

  @override
  String get guideHydrationBody =>
      'Een eenvoudige dagelijkse teller voor glazen water — één tik om toe te voegen, één tik om de laatste ongedaan te maken.';

  @override
  String get guideStreaksTitle => 'Motivatie';

  @override
  String get guideStreaksBody =>
      'Een vlambadge toont hoeveel dagen achter elkaar je minstens één maaltijd hebt geregistreerd.';

  @override
  String get guideRemindersTitle => 'Dagelijkse herinnering';

  @override
  String get guideRemindersBody =>
      'Een melding, op het tijdstip dat jij kiest, die je eraan herinnert je maaltijden te registreren — op elk moment uit te schakelen via het menu.';

  @override
  String get guideProfileTitle => 'Profiel en doel';

  @override
  String get guideProfileBody =>
      'Leeftijd, biologisch geslacht, lengte, gewicht, activiteitsniveau en doel — op elk moment bewerkbaar. De app herberekent je caloriedoel automatisch bij elke wijziging.';

  @override
  String get guidePrivacyTitle => 'Privacy';

  @override
  String get guidePrivacyBody =>
      'Je gegevens zijn uitsluitend gekoppeld aan jouw account en niet zichtbaar voor andere gebruikers. Je kunt je account en alle bijbehorende gegevens op elk moment verwijderen via het menu — verwijdering is permanent en onmiddellijk.';

  @override
  String get guideLanguagesTitle => 'Beschikbare talen';

  @override
  String get guideLanguagesBody =>
      'De app is beschikbaar in 13 talen, gekozen via het menu — niet alleen automatisch gedetecteerd op basis van de telefoontaal.';

  @override
  String get guidePremiumTitle => 'Premium en abonnementen';

  @override
  String get guidePremiumDraftNote =>
      'Concept, niet definitief — het onderstaande plan is nog niet actief in de app. Er is momenteel geen in-app-betaling of functiebeperking.';

  @override
  String get guidePremiumFreeBody =>
      'Gratis, voor altijd: volledig voedingsdagboek, 20 fotoanalyses per dag, onbeperkt eigen recepten, basisvoortgangsgrafieken en synchronisatie met Apple Gezondheid / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (indicatieve prijs, onbevestigd): onbeperkte fotoanalyses, adaptief TDEE en gedetailleerde micronutriënten, plus prioritaire ondersteuning.';

  @override
  String get themeDialogTitle => 'Thema';

  @override
  String get themeSystemDefault => 'Telefoonthema (standaard)';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeMenuEntry => 'Thema';

  @override
  String get barcodeToggleTorch => 'Flitser aan/uit';

  @override
  String get clearSelection => 'Selectie wissen';

  @override
  String get accessCodeMenuEntry => 'Toegangscode';

  @override
  String get adminDashboardMenuEntry => 'Admin-dashboard';

  @override
  String get accessCodeScreenTitle => 'Toegangscode';

  @override
  String get premiumCodeFieldLabel => 'Premiumcode';

  @override
  String get activatePremiumButton => 'Premium activeren';

  @override
  String premiumActivatedMessage(String date) {
    return 'Premium toegang geactiveerd tot $date.';
  }

  @override
  String get iAmAdminLink => 'Ik ben admin';

  @override
  String get adminPasswordFieldLabel => 'Adminwachtwoord';

  @override
  String get activateAdminButton => 'Admin activeren';

  @override
  String get adminActivatedMessage => 'Adminaccount geactiveerd.';

  @override
  String get adminDashboardTitle => 'Admin-dashboard';

  @override
  String get totalUsersLabel => 'Totaal aantal gebruikers';

  @override
  String get activePremiumLabel => 'Actief premium';

  @override
  String get generateCodeSectionTitle => 'Premiumcode genereren';

  @override
  String get targetEmailLabel => 'E-mail van account';

  @override
  String get durationDaysLabel => 'Duur (dagen)';

  @override
  String get generateCodeButton => 'Code genereren';

  @override
  String get codeGeneratedTitle => 'Code gegenereerd';

  @override
  String get generatedCodesSectionTitle => 'Gegenereerde codes';

  @override
  String get noCodesGeneratedYet => 'Nog geen codes gegenereerd.';

  @override
  String get codeStatusPending => 'ongebruikt';

  @override
  String get codeStatusRedeemed => 'gebruikt';

  @override
  String get codeStatusRevoked => 'ingetrokken';

  @override
  String durationDaysValue(int days) {
    return '$days dagen';
  }
}

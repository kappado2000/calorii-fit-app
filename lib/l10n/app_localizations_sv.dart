// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Glöm inte att logga dina måltider';

  @override
  String get dailyReminderBody =>
      'Några sekunder räcker för att hålla din logg uppdaterad och din svit vid liv.';

  @override
  String get dailyReminderChannelName => 'Daglig påminnelse';

  @override
  String get dailyReminderChannelDescription =>
      'Påminnelse om att logga dagens måltider';

  @override
  String get updateRequiredTitle => 'En uppdatering behövs';

  @override
  String get updateRequiredMessage =>
      'Versionen av appen på den här telefonen stöds inte längre. Installera den senaste versionen för att fortsätta.';

  @override
  String get updateAvailableMessage => 'En ny version av appen är tillgänglig.';

  @override
  String get hydrationTitle => 'Vätskeintag';

  @override
  String get hydrationUndoLastGlass => 'Ångra senaste glaset';

  @override
  String hydrationAddGlass(int ml) {
    return 'Lägg till ett glas ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'Adaptivt TDEE';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Inte tillräckligt med data ännu: du behöver minst 14 loggade dagar och 2 vägningar med minst 10 dagars mellanrum, under de senaste 3 veckorna. Tills dess används standardformeln (Mifflin-St Jeor).';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Beräknat utifrån din egen kaloribalans ($loggedDays/$windowDays dagar loggade under de senaste 3 veckorna), inte bara standardformeln.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'Uppskattat TDEE';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Vikttrend';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/vecka';
  }

  @override
  String get adaptiveTdeeRejected =>
      'Uppskattningen avviker fortfarande för mycket från standardformeln för att vara pålitlig — standardformeln fortsätter att användas tills mer konsekvent data samlats in.';

  @override
  String get weeklySummaryTitle => 'Veckans sammanfattning';

  @override
  String get weeklySummaryDaysLogged => 'Loggade dagar';

  @override
  String get weeklySummaryAvgCalories => 'Snitt kcal/dag';

  @override
  String get weeklySummaryWorkouts => 'Träningspass';

  @override
  String get weightEvolutionTitle => 'Viktutveckling';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Från $date ($startKg kg) till idag ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Djupavkänningsförmåga';

  @override
  String deviceCapabilityError(String error) {
    return 'Fel vid kontroll av funktioner:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR tillgänglig';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth tillgänglig';

  @override
  String get depthSourcePortraitLabel => 'Dubbel kamera (porträttdjup)';

  @override
  String get depthSourceReferenceLabel => 'Ingen djupsensor';

  @override
  String get depthSourceUnknownLabel => 'Okänd';

  @override
  String get depthSourceLidarDescription =>
      'Högprecisionsvolymuppskattning (~10-15% fel).';

  @override
  String get depthSourceArcoreDescription =>
      'Volymuppskattning via ARCore Depth API.';

  @override
  String get depthSourcePortraitDescription =>
      'Ungefärligt djup från dubbelkameran, lägre precision.';

  @override
  String get depthSourceReferenceDescription =>
      'Tallrikens diameter kommer att användas som skalreferens (mindre exakt uppskattning).';

  @override
  String get depthSourceUnknownDescription =>
      'Det gick inte att fastställa enhetens förmåga.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'dubbel kamera';

  @override
  String get depthSourceReferenceShort => 'visuell referens';

  @override
  String get depthSourceUnknownShort => 'okänd';

  @override
  String get howItWorksTitle => 'Så beräknar vi kalorier';

  @override
  String get howItWorksTooltip => 'Hur beräknar vi kalorier?';

  @override
  String get howItWorksIntro =>
      'De flesta näringsappar gissar portionen från ett enda 2D-foto. Calorii Fit mäter faktiskt volymen på maten på tallriken, med hjälp av din telefons djupkarta — därför är uppskattningen mer exakt.';

  @override
  String get howItWorksStep1Title => 'Fotografera din tallrik';

  @override
  String get howItWorksStep1Description =>
      'Ett enda foto, ingen särskild placering behövs.';

  @override
  String get howItWorksStep2Title => 'Din telefon fångar djupet';

  @override
  String get howItWorksStep2GenericDescription =>
      'Din telefon använder, beroende på modell, LiDAR, ARCore Depth eller en dubbelkamera för att veta hur hög maten är, inte bara hur den ser ut uppifrån.';

  @override
  String get howItWorksStep3Title => 'Claude identifierar maten';

  @override
  String get howItWorksStep3Description =>
      'Modellen känner igen vad som finns på tallriken och markerar den ungefärliga konturen av varje maträtt — den beräknar inte kalorier själv, bara identifierar.';

  @override
  String get howItWorksStep4Title => 'Volym blir gram, sedan kalorier';

  @override
  String get howItWorksStep4Description =>
      'Djupkartan × konturen av varje maträtt ger en volym i cm³. En densitetstabell (specifik för varje typ av mat) omvandlar volymen till gram, och näringsdatabasen omvandlar gram till kalorier och makronäringsämnen.';

  @override
  String get howItWorksStep5Title => 'Du bekräftar eller korrigerar';

  @override
  String get howItWorksStep5Description =>
      'Den automatiska uppskattningen sparas aldrig direkt — du ser alltid en bekräftelseskärm där du kan justera portionen eller ändra den identifierade maten.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Se vilken metod din telefon använder';

  @override
  String get howItWorksDepthLidar =>
      'Din telefon har LiDAR — den mest exakta metoden som finns tillgänglig idag på en telefon, med ett typiskt fel på bara 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Din telefon använder ARCore Depth API för att uppskatta scenens djup.';

  @override
  String get howItWorksDepthPortrait =>
      'Din telefon uppskattar djupet via dubbelkameran (porträttläge) — mindre exakt än LiDAR, men ändå bättre än ett vanligt foto.';

  @override
  String get howItWorksDepthReference =>
      'Din telefon har ingen djupsensor, så vi använder standarddiametern på en tallrik som skalreferens — den minst exakta metoden, men fortfarande bättre än en rent visuell uppskattning.';

  @override
  String get howItWorksDepthUnknown =>
      'Vi kunde inte fastställa metoden som din telefon använder.';

  @override
  String get reminderPermissionDenied =>
      'Tillåt aviseringar för appen i din telefons inställningar.';

  @override
  String get reminderTimePickerHelp => 'Påminnelsetid';

  @override
  String get reminderDialogTitle => 'Daglig påminnelse';

  @override
  String get reminderDailyNotification => 'Daglig avisering';

  @override
  String get reminderDailyNotificationSubtitle =>
      'En påminnelse om att logga dina måltider';

  @override
  String get reminderTimeLabel => 'Tid';

  @override
  String get close => 'Stäng';

  @override
  String get deleteAccountWrongPassword => 'Fel lösenord.';

  @override
  String deleteAccountFailed(String code) {
    return 'Kunde inte ta bort kontot ($code). Försök igen.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Kunde inte ta bort kontot. Försök igen.';

  @override
  String get deleteAccountTitle => 'Ta bort konto';

  @override
  String get deleteAccountExplanation =>
      'Detta tar permanent bort ditt konto och all din data (profil, matdagbok, träningspass, vikter, sparade livsmedel). Denna åtgärd kan inte ångras.';

  @override
  String get password => 'Lösenord';

  @override
  String get showPassword => 'Visa lösenord';

  @override
  String get hidePassword => 'Dölj lösenord';

  @override
  String get cancel => 'Avbryt';

  @override
  String get deleteAccountConfirm => 'Ta bort permanent';

  @override
  String get barcodeScanTitle => 'Skanna streckkod';

  @override
  String barcodeNotFound(String barcode) {
    return 'Produkten med koden $barcode hittades inte.';
  }

  @override
  String get addManually => 'Lägg till manuellt';

  @override
  String get scanAgain => 'Skanna igen';

  @override
  String get bluetoothScaleTitle => 'Bluetooth-våg';

  @override
  String get bluetoothScaleSearch => 'Sök efter vågar';

  @override
  String get bluetoothScaleIdleHint =>
      'Tryck på \"Sök efter vågar\" och slå på din våg nära telefonen.';

  @override
  String get bluetoothScaleSearching => 'Söker...';

  @override
  String get bluetoothScaleNoneFound => 'Ingen våg hittad ännu.';

  @override
  String get bluetoothScaleConnecting => 'Ansluter...';

  @override
  String get bluetoothScaleWeightSaved => 'Vikt sparad.';

  @override
  String errorPrefixed(String message) {
    return 'Fel: $message';
  }

  @override
  String get cameraNoneAvailable =>
      'Ingen kamera tillgänglig på den här enheten.';

  @override
  String get cameraCaptureTitle => 'Fotografera din tallrik';

  @override
  String get cameraCapturingStatus => 'Fångar foto och djup…';

  @override
  String get cameraAnalyzingStatus => 'Identifierar maten…';

  @override
  String get cameraConfirmationOpeningStatus => 'Klart — öppnar bekräftelse…';

  @override
  String get cameraStartingStatus => 'Startar kameran…';

  @override
  String get cameraFrameHint => 'Rama in tallriken och tryck på slutaren';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Det gick inte att starta/analysera fotot:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Du har nått dagens gräns för fotoanalyser. Aktivera premium för fler analyser per dag.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Du måste vara inloggad för att analysera ett foto.';

  @override
  String get cameraNetworkErrorMessage =>
      'Det gick inte att ansluta. Kontrollera din internetanslutning och försök igen.';

  @override
  String get retry => 'Försök igen';

  @override
  String get authEnterEmailFirst =>
      'Ange din e-post först, så att vi kan skicka återställningslänken till dig.';

  @override
  String get authPasswordResetSent =>
      'Vi har skickat ett e-postmeddelande för återställning av lösenord till dig.';

  @override
  String get authErrorInvalidEmail => 'Ogiltig e-postadress.';

  @override
  String get authErrorUserNotFound =>
      'Det finns inget konto med den här e-posten.';

  @override
  String get authErrorWrongCredentials => 'Fel e-post eller lösenord.';

  @override
  String get authErrorEmailInUse =>
      'Det finns redan ett konto med den här e-posten.';

  @override
  String get authErrorWeakPassword =>
      'Lösenordet är för svagt (minst 6 tecken).';

  @override
  String get authErrorGeneric => 'Något gick fel. Försök igen.';

  @override
  String get authWelcomeBack => 'Välkommen tillbaka';

  @override
  String get authLetsStart => 'Nu kör vi';

  @override
  String get email => 'E-post';

  @override
  String get authEnterValidEmail => 'Ange en giltig e-post';

  @override
  String get authPasswordMinLength => 'Minst 6 tecken';

  @override
  String get authSignIn => 'Logga in';

  @override
  String get authCreateAccount => 'Skapa konto';

  @override
  String get authNoAccountYet => 'Inget konto än? Skapa ett';

  @override
  String get authHaveAccountAlready => 'Har du redan ett konto? Logga in';

  @override
  String get authForgotPassword => 'Glömt lösenordet?';

  @override
  String get activityWalkingCasual => 'Promenad (avslappnad)';

  @override
  String get activityWalkingBrisk => 'Promenad (rask)';

  @override
  String get activityRunning => 'Löpning';

  @override
  String get activityRunningFast => 'Löpning (snabb)';

  @override
  String get activityCycling => 'Cykling (måttlig)';

  @override
  String get activityCyclingIntense => 'Cykling (intensiv)';

  @override
  String get activitySwimming => 'Simning';

  @override
  String get activityStrengthTraining => 'Styrketräning';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Dans';

  @override
  String get activityHiking => 'Vandring';

  @override
  String get activityJumpRope => 'Hopprep';

  @override
  String get activityFootball => 'Fotboll';

  @override
  String get activityBasketball => 'Basket';

  @override
  String get activityTennis => 'Tennis';

  @override
  String get activityOther => 'Annan aktivitet';

  @override
  String get mealBreakfast => 'Frukost';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Middag';

  @override
  String get mealSnack => 'Mellanmål';

  @override
  String get addWorkoutTitle => 'Lägg till träningspass';

  @override
  String get addWorkoutFromActivity => 'Från aktivitet';

  @override
  String get addWorkoutDirectCalories => 'Direkta kalorier';

  @override
  String get addWorkoutActivityTypeOptional => 'Aktivitetstyp (valfritt)';

  @override
  String get addWorkoutCaloriesBurned => 'Förbrända kalorier';

  @override
  String get addWorkoutCaloriesHint => 't.ex. 250';

  @override
  String get save => 'Spara';

  @override
  String get addWorkoutActivityType => 'Aktivitetstyp';

  @override
  String get addWorkoutDuration => 'Varaktighet';

  @override
  String get minutes => 'minuter';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Uppskattning: $kcal kcal förbrända';
  }

  @override
  String get confirmFoodsTitle => 'Bekräfta maten';

  @override
  String get mealLabel => 'Måltid:';

  @override
  String get mixedPlateWarning =>
      'Tallrik med blandad mat — kontrollera varje del, identifieringen kan vara mindre exakt.';

  @override
  String get noItemsLeft =>
      'Du tog bort alla identifierade objekt. Ta ett nytt foto om du vill försöka igen.';

  @override
  String get portionSmall => 'Liten';

  @override
  String get portionMedium => 'Medel';

  @override
  String get portionLarge => 'Stor';

  @override
  String get notOnPlateRemove => 'Inte på tallriken — ta bort';

  @override
  String roughEstimateNote(String source) {
    return 'Grov uppskattning ($source, ingen djupsensor)';
  }

  @override
  String get realNutritionDataBadge => 'riktiga data';

  @override
  String totalCalories(int kcal) {
    return 'Totalt: $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Stillasittande (kontorsjobb, ingen träning)';

  @override
  String get activityLevelLight => 'Lätt aktivitet (träning 1-3 dagar/vecka)';

  @override
  String get activityLevelModerate =>
      'Måttlig aktivitet (träning 3-5 dagar/vecka)';

  @override
  String get activityLevelActive => 'Aktiv (träning 6-7 dagar/vecka)';

  @override
  String get activityLevelVeryActive =>
      'Mycket aktiv (intensiv daglig träning / fysiskt arbete)';

  @override
  String get goalLose => 'Gå ner i vikt';

  @override
  String get goalMaintain => 'Behålla vikten';

  @override
  String get goalGain => 'Bygga muskler';

  @override
  String get progressPeriod7Days => '7 dagar';

  @override
  String get progressPeriod30Days => '30 dagar';

  @override
  String get progressPeriodWholeProgram => 'Hela programmet';

  @override
  String get nutrientVitaminC => 'Vitamin C';

  @override
  String get nutrientVitaminD => 'Vitamin D';

  @override
  String get nutrientCalcium => 'Kalcium';

  @override
  String get nutrientIron => 'Järn';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientPotassium => 'Kalium';

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Kolhydrater';

  @override
  String get macroFat => 'Fett';

  @override
  String onboardingAgeTooLow(int age) {
    return 'Appen är avsedd för personer som är $age år eller äldre.';
  }

  @override
  String get onboardingAgeInvalid => 'Ogiltigt värde.';

  @override
  String get onboardingAgeSexTitle => 'Ålder och biologiskt kön';

  @override
  String get age => 'Ålder';

  @override
  String get years => 'år';

  @override
  String get sexFemale => 'Kvinna';

  @override
  String get sexMale => 'Man';

  @override
  String get onboardingSexHint =>
      'Används endast för att beräkna basalmetabolismen (Mifflin-St Jeor-formeln).';

  @override
  String get onboardingHeightWeightTitle => 'Längd och aktuell vikt';

  @override
  String get height => 'Längd';

  @override
  String get weight => 'Vikt';

  @override
  String get onboardingActivityTitle => 'Nivå av fysisk aktivitet';

  @override
  String get onboardingGoalTitle => 'Vad är ditt mål?';

  @override
  String get onboardingLossRate => 'Önskad viktnedgångstakt';

  @override
  String get onboardingGainRate => 'Önskad viktökningstakt';

  @override
  String get kgPerWeek => 'kg/vecka';

  @override
  String get onboardingRateRecommendation =>
      'Rekommenderat: 0,25-0,75 kg/vecka för en hållbar takt.';

  @override
  String get programStartDateLabel => 'Startdatum för dieten';

  @override
  String get programStartDateHint =>
      'Skiljer sig från datumet då kontot skapades — det här är utgångspunkten du vill mäta framstegen från.';

  @override
  String get disclaimerTitle => 'Innan du börjar';

  @override
  String get disclaimerIntro =>
      'Calorii Fit uppskattar ditt kaloribehov och din viktnedgångstakt baserat på allmänt accepterade formler (Mifflin-St Jeor), inte en individuell medicinsk bedömning.';

  @override
  String get disclaimerMedical =>
      'Det ersätter inte råd från en läkare eller dietist — särskilt om du har ett medicinskt tillstånd, är gravid eller ammar.';

  @override
  String get disclaimerAllergens =>
      'Identifiering av mat från ett foto upptäcker inte allergener. Om du har en allvarlig allergi eller intolerans, kontrollera alltid ingredienserna själv — lita inte på appen för det.';

  @override
  String get disclaimerEatingDisorders =>
      'Om du har haft eller har en svår relation till mat (ätstörningar), prata med en läkare innan du räknar kalorier — appen är inte avsedd att ersätta det stödet.';

  @override
  String get disclaimerAcceptLabel =>
      'Jag förstår och godkänner att använda appen med detta i åtanke.';

  @override
  String get finish => 'Slutför';

  @override
  String get continueLabel => 'Fortsätt';

  @override
  String get progress => 'Framsteg';

  @override
  String get activityAndSync => 'Aktivitet och synkronisering';

  @override
  String get editProfileGoal => 'Redigera profil/mål';

  @override
  String get checkDeviceCapability => 'Kontrollera enhetens förmåga';

  @override
  String get myRecipes => 'Mina recept';

  @override
  String get signOut => 'Logga ut';

  @override
  String get takePhoto => 'Ta ett foto';

  @override
  String get previousDay => 'Föregående dag';

  @override
  String get nextDay => 'Nästa dag';

  @override
  String get pickDayHelp => 'Välj en dag';

  @override
  String dateToday(String date) {
    return 'Idag, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Igår, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Imorgon, $date';
  }

  @override
  String get setUpYourGoal => 'Ställ in ditt mål';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal idag';
  }

  @override
  String get setUp => 'Ställ in';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Mål: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Kaloriunderskott';

  @override
  String get totalBurnedLabel => 'Totalt förbrända';

  @override
  String get totalConsumedLabel => 'Totalt konsumerade';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Du överskred gränsen med $overBy kcal (över $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Överskrid inte $kcal kcal, för att nå din önskade viktnedgångstakt.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Du behöver minst $kcal kcal för din önskade viktökningstakt.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Håll dig runt $kcal kcal för att behålla vikten.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Rekommenderat: $low–$high kcal';
  }

  @override
  String get addFood => 'Lägg till mat';

  @override
  String get sportActivity => 'Fysisk aktivitet';

  @override
  String get manualCaloriesEntered => 'Manuellt inmatade kalorier';

  @override
  String get addActivity => 'Lägg till aktivitet';

  @override
  String get caloricIntake => 'Kaloriintag';

  @override
  String get dailyCaloricDeficit => 'Dagligt kaloriunderskott';

  @override
  String get setUpProfileFirst =>
      'Ställ först in din profil och ditt mål från menyn.';

  @override
  String get totalCaloriesLabel => 'Totalt antal kalorier';

  @override
  String get avgPerDay => 'Snitt/dag';

  @override
  String get estimatedLoss => 'Uppskattad viktnedgång';

  @override
  String get macroBalanceTitle => 'Makronäringsbalans';

  @override
  String get macroBalanceNoData =>
      'Ingen mat med känt protein/kolhydrater/fett under denna period.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (rekommenderat $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Mikronäringsämnen (snitt/dag)';

  @override
  String get micronutrientsNoData =>
      'Ingen mat med vitamin-/mineraldata under denna period — se anteckningen nedan.';

  @override
  String get micronutrientsNoEntries => 'Ingen mat loggad under denna period.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Vitamin-/mineraldata tillgänglig för $pct% av den loggade maten ($withData/$total) — resten (hemlagad mat, produkter utan etikett) har inga kända data och ingår inte i genomsnittet.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% av dagsvärdet';
  }

  @override
  String get chartTargetLabel => 'Mål';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Hälsa';

  @override
  String get healthConnectDescription =>
      'Hämtar vikten och den fysiska aktiviteten som loggats av din klocka, via din telefons hälsoplattform.';

  @override
  String get bluetoothScaleSubtitle => 'Anslut en smart våg direkt';

  @override
  String get weightHistoryTitle => 'Vikthistorik';

  @override
  String get addLabel => 'Lägg till';

  @override
  String get noEntriesYet => 'Inga poster än.';

  @override
  String get syncButton => 'Synkronisera';

  @override
  String get syncAgain => 'Synkronisera igen';

  @override
  String get stepsToday => 'steg idag';

  @override
  String get activeKcal => 'aktiva kcal';

  @override
  String newWeightFetched(String kg) {
    return 'Ny vikt hämtad: $kg kg';
  }

  @override
  String newWorkoutsImported(int count) {
    return '$count nya träningspass importerade från din klocka.';
  }

  @override
  String get weightSourceManual => 'manuell';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Hälsa';

  @override
  String get weightSourceBluetoothScale => 'BT-våg';

  @override
  String get addWeightTitle => 'Lägg till vikt';

  @override
  String get editWeightTitle => 'Redigera vikt';

  @override
  String get weighInDateHelp => 'Datum för vägning';

  @override
  String get weighInTimeHelp => 'Tid för vägning';

  @override
  String get edit => 'Redigera';

  @override
  String get delete => 'Ta bort';

  @override
  String get chooseARecipe => 'Välj ett recept';

  @override
  String get newRecipe => 'Nytt recept';

  @override
  String get editRecipe => 'Redigera recept';

  @override
  String get noRecipesYet =>
      'Du har inte sparat några recept än. Lägg till ett med knappen nedan.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings portioner · $kcal kcal/portion';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name lades till idag.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Lägg till \"$name\" i:';
  }

  @override
  String get recipeNameLabel => 'Receptnamn';

  @override
  String get recipeNameHint => 't.ex. Min kycklingsallad';

  @override
  String get numberOfServings => 'Antal portioner';

  @override
  String get ingredients => 'Ingredienser';

  @override
  String get addAtLeastOneIngredient => 'Lägg till minst en ingrediens.';

  @override
  String get saveRecipe => 'Spara recept';

  @override
  String perServing(int grams, int kcal) {
    return 'Per portion ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Protein $protein · Kolhydrater $carbs · Fett $fat';
  }

  @override
  String get addIngredientTitle => 'Lägg till ingrediens';

  @override
  String get productNameLabel => 'Produktnamn';

  @override
  String get noProductFound => 'Ingen produkt hittad.';

  @override
  String get searchWithAiButton => 'Sök med AI';

  @override
  String get notFindingWhatYouWant => 'Hittar du inte det du letar efter?';

  @override
  String get aiSearchNoResult =>
      'AI kunde inte säkert hitta en produkt för den här sökningen.';

  @override
  String get aiEstimateBadge => 'AI-uppskattning';

  @override
  String get quantityLabel => 'Mängd';

  @override
  String get addIngredientButton => 'Lägg till ingrediens';

  @override
  String get editIngredientQuantityTitle => 'Redigera mängd';

  @override
  String get chooseRecipeIconTitle => 'Välj en ikon';

  @override
  String get recipeIconSuggested => 'Förslag';

  @override
  String get saveAsRecipeTooltip => 'Spara som recept';

  @override
  String get saveAsRecipeDialogTitle => 'Spara som nytt recept';

  @override
  String recipeSavedConfirmation(String name) {
    return '\"$name\" sparades i dina recept.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Lägg till mat — $meal';
  }

  @override
  String get productNameHint => 't.ex. Grekisk yoghurt';

  @override
  String get enterProductName => 'Ange produktnamnet';

  @override
  String get frequentlyLogged => 'Ofta loggad';

  @override
  String addCount(int count) {
    return 'Lägg till ($count)';
  }

  @override
  String get calorieIndexLabel => 'Kaloriindex (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Ätit mängd';

  @override
  String get editGramsDialogTitle => 'Redigera portion';

  @override
  String get requiredField => 'Obligatoriskt fält';

  @override
  String get invalidValue => 'Ogiltigt värde';

  @override
  String get searchFailedCheckConnection =>
      'Sökningen kunde inte slutföras (kontrollera din anslutning).';

  @override
  String get addProductManually => 'Lägg till produkt manuellt';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'K';

  @override
  String get macroFatShort => 'F';

  @override
  String get macrosUnavailable => 'Makronäringsämnen ej tillgängliga';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Protein $protein · Kolhydrater $carbs · Fett $fat';
  }

  @override
  String get languageDialogTitle => 'Språk';

  @override
  String get languageSystemDefault => 'Telefonens språk (standard)';

  @override
  String get languageMenuEntry => 'Språk';

  @override
  String get guideMenuEntry => 'Användarguide';

  @override
  String get guideScreenTitle => 'Användarguide';

  @override
  String get guideIntroTitle => 'Vad är Calorii Fit';

  @override
  String get guideIntroBody =>
      'En näringsapp som uppskattar kalorier direkt från ett foto av din tallrik, med hjälp av telefonens djupsensor — inte bara ett vanligt foto. Den håller också en fullständig dagbok: måltider, träning, vätskeintag, vikt och dina framsteg mot ditt mål.';

  @override
  String get guidePhotoTitle => 'Uppskattning från foto';

  @override
  String get guidePhotoBody =>
      'Du fotograferar tallriken, telefonen mäter dess volym med LiDAR, ARCore Depth eller en dubbelkamera, och appen identifierar maten och beräknar portionen. Du bekräftar eller justerar resultatet med ett skjutreglage eller förinställningar — inget sparas automatiskt. Utan djupsensor används tallrikens diameter som referens, tydligt markerad som en grov uppskattning.';

  @override
  String get guideLogTitle => 'Daglig logg';

  @override
  String get guideLogBody =>
      'Fyra måltider om dagen — Frukost, Lunch, Middag, Mellanmål. Lägg till mat via foto, sökning, streckkodsskanning, manuellt, från dina recept eller snabbt från en checklista med dina vanliga livsmedel. Tryck på en registrerad post för att ändra mängden. Om en sökning inte hittar exakt det du letar efter, tryck på \"Sök med AI\", och för en post som saknar näringsämnen, tryck på \"Komplettera med AI\". Du kan välja flera redan registrerade livsmedel och spara dem som ett nytt recept.';

  @override
  String get guideRecipesTitle => 'Mina recept';

  @override
  String get guideRecipesBody =>
      'Spara en kombination av ingredienser du äter ofta och logga den med en enda knapptryckning. Du kan välja en ikon för varje recept (eller acceptera det automatiska förslaget) och redigera mängden av vilken ingrediens som helst när som helst. När du lägger till flera livsmedel samtidigt kan du direkt spara dem som ett nytt recept.';

  @override
  String get guideWorkoutsTitle => 'Fysisk aktivitet';

  @override
  String get guideWorkoutsBody =>
      'Välj aktivitetstyp och varaktighet, så beräknas de förbrända kalorierna automatiskt — eller ange dem direkt om du redan känner till dem från en smart klocka. Förbrända kalorier dras av från dagens budget.';

  @override
  String get guideProgressTitle => 'Framsteg';

  @override
  String get guideProgressBody =>
      'Diagram över 7 dagar, 30 dagar eller hela programmet: viktutveckling (utjämnad), adaptivt TDEE beräknat från din egen energibalans, makronäringsbalans och täckning av mikronäringsämnen. Synkroniserar med Apple Hälsa / Health Connect och en Bluetooth-våg. Om flera poster saknar näringsämnen fyller \"Komplettera med AI\" i dem alla på en gång (premium eller provperiod). Ikonen i det övre fältet öppnar \"Näringskällor\": vilka livsmedel som bidrar mest, separat för makro- och mikronäringsämnen.';

  @override
  String get guideHydrationTitle => 'Vätskeintag';

  @override
  String get guideHydrationBody =>
      'En enkel daglig räknare för vattenglas — en knapptryckning för att lägga till, en för att ångra det senaste.';

  @override
  String get guideStreaksTitle => 'Motivation';

  @override
  String get guideStreaksBody =>
      'En flammärke visar hur många dagar i rad du har loggat minst en måltid.';

  @override
  String get guideRemindersTitle => 'Daglig påminnelse';

  @override
  String get guideRemindersBody =>
      'En avisering, vid den tid du väljer, som påminner dig om att logga dina måltider — kan stängas av när som helst från menyn.';

  @override
  String get guideProfileTitle => 'Profil och mål';

  @override
  String get guideProfileBody =>
      'Ålder, biologiskt kön, längd, vikt, aktivitetsnivå och mål — redigerbara när som helst. Appen räknar automatiskt om ditt kalorimål vid varje ändring.';

  @override
  String get guidePrivacyTitle => 'Integritet';

  @override
  String get guidePrivacyBody =>
      'Din data är uteslutande kopplad till ditt konto och är inte synlig för andra användare. Du kan radera ditt konto och all tillhörande data när som helst, från menyn — radering är permanent och omedelbar.';

  @override
  String get guideLanguagesTitle => 'Tillgängliga språk';

  @override
  String get guideLanguagesBody =>
      'Appen finns på 13 språk, valda från menyn — inte bara automatiskt upptäckta utifrån telefonens språk.';

  @override
  String get guidePremiumTitle => 'Premium och prenumerationer';

  @override
  String get guidePremiumFreeBody =>
      'Gratis, för alltid: fullständig matdagbok, en fotoanalys om dagen, obegränsad sökning, obegränsat med egna recept, grundläggande framstegsdiagram och synkronisering med Apple Hälsa / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (aktiverat med en kod): 20 fotoanalyser om dagen och 20 AI-sökningar om dagen för automatisk komplettering av näringsämnen, samt adaptivt TDEE och detaljerade mikronäringsämnen.';

  @override
  String get guidePremiumTrialNote =>
      'Nytt konto? Du får en 14-dagars provperiod: 3 fotoanalyser om dagen och upp till 10 AI-sökningar inkluderade, utan kod.';

  @override
  String get guidePremiumRedeemButton => 'Jag har en premiumkod';

  @override
  String get themeDialogTitle => 'Tema';

  @override
  String get themeSystemDefault => 'Telefonens tema (standard)';

  @override
  String get themeLight => 'Ljust';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get themeMenuEntry => 'Tema';

  @override
  String get barcodeToggleTorch => 'Växla blixt';

  @override
  String get clearSelection => 'Rensa val';

  @override
  String get accessCodeMenuEntry => 'Åtkomstkod';

  @override
  String get adminDashboardMenuEntry => 'Adminpanel';

  @override
  String get accessCodeScreenTitle => 'Åtkomstkod';

  @override
  String get premiumCodeFieldLabel => 'Premiumkod';

  @override
  String get activatePremiumButton => 'Aktivera premium';

  @override
  String premiumActivatedMessage(String date) {
    return 'Premiumåtkomst aktiverad till $date.';
  }

  @override
  String get iAmAdminLink => 'Jag är admin';

  @override
  String get adminPasswordFieldLabel => 'Adminlösenord';

  @override
  String get adminTotpFieldLabel => 'Kod från autentiseringsappen';

  @override
  String get activateAdminButton => 'Aktivera admin';

  @override
  String get adminActivatedMessage => 'Adminkonto aktiverat.';

  @override
  String get adminDashboardTitle => 'Adminpanel';

  @override
  String get totalUsersLabel => 'Totalt antal användare';

  @override
  String get activePremiumLabel => 'Aktiv premium';

  @override
  String get generateCodeSectionTitle => 'Generera premiumkod';

  @override
  String get targetEmailLabel => 'Kontots e-post';

  @override
  String get durationDaysLabel => 'Varaktighet (dagar)';

  @override
  String get generateCodeButton => 'Generera kod';

  @override
  String get codeGeneratedTitle => 'Kod genererad';

  @override
  String get generatedCodesSectionTitle => 'Genererade koder';

  @override
  String get noCodesGeneratedYet => 'Inga koder genererade än.';

  @override
  String get codeStatusPending => 'oanvänd';

  @override
  String get codeStatusRedeemed => 'använd';

  @override
  String get codeStatusRevoked => 'återkallad';

  @override
  String durationDaysValue(int days) {
    return '$days dagar';
  }

  @override
  String get completeNutritionWithAiTooltip => 'Komplettera med AI';

  @override
  String get nutritionCompletedMessage => 'Näringsdata kompletterad.';

  @override
  String get aiCompletionNoResult =>
      'AI kunde inte hitta säker data för det här livsmedlet.';

  @override
  String bulkNutritionCompletionButton(int count) {
    return 'Komplettera med AI ($count)';
  }

  @override
  String bulkNutritionCompletionProgress(int done, int total) {
    return '$done/$total...';
  }

  @override
  String bulkNutritionCompletionPremiumLocked(int count) {
    return 'Premiumfunktion ($count livsmedel)';
  }

  @override
  String bulkNutritionCompletionResult(int completed, int total) {
    return 'Kompletterade $completed av $total livsmedel.';
  }

  @override
  String get nutrientSourcesTitle => 'Näringskällor';

  @override
  String get macroSourcesSectionTitle => 'Makronäringsämnen';

  @override
  String get micronutrientSourcesSectionTitle => 'Mikronäringsämnen';

  @override
  String get nutrientSourcesNoData =>
      'Inte tillräckligt med data för denna period.';

  @override
  String get nutrientSourcesOthers => 'andra livsmedel';
}

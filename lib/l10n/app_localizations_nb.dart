// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Ikke glem å registrere måltidene dine';

  @override
  String get dailyReminderBody =>
      'Noen sekunder er nok for å holde loggen din oppdatert og rekken din i live.';

  @override
  String get dailyReminderChannelName => 'Daglig påminnelse';

  @override
  String get dailyReminderChannelDescription =>
      'Påminnelse om å registrere dagens måltider';

  @override
  String get updateRequiredTitle => 'En oppdatering er nødvendig';

  @override
  String get updateRequiredMessage =>
      'Versjonen av appen på denne telefonen støttes ikke lenger. Installer den nyeste versjonen for å fortsette.';

  @override
  String get updateAvailableMessage =>
      'En ny versjon av appen er tilgjengelig.';

  @override
  String get hydrationTitle => 'Væskeinntak';

  @override
  String get hydrationUndoLastGlass => 'Angre siste glass';

  @override
  String hydrationAddGlass(int ml) {
    return 'Legg til et glass ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'Adaptivt TDEE';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Ikke nok data ennå: du trenger minst 14 registrerte dager og 2 veiinger med minst 10 dagers mellomrom, i løpet av de siste 3 ukene. Inntil da brukes standardformelen (Mifflin-St Jeor).';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Beregnet ut fra din egen kaloribalanse ($loggedDays/$windowDays dager registrert de siste 3 ukene), ikke bare standardformelen.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'Estimert TDEE';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Vekttrend';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/uke';
  }

  @override
  String get adaptiveTdeeRejected =>
      'Estimatet avviker fortsatt for mye fra standardformelen til å være pålitelig — standardformelen brukes fortsatt, inntil mer konsistente data samles inn.';

  @override
  String get weeklySummaryTitle => 'Ukens sammendrag';

  @override
  String get weeklySummaryDaysLogged => 'Registrerte dager';

  @override
  String get weeklySummaryAvgCalories => 'Gj.snitt kcal/dag';

  @override
  String get weeklySummaryWorkouts => 'Treningsøkter';

  @override
  String get weightEvolutionTitle => 'Vektutvikling';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Fra $date ($startKg kg) til i dag ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Dybdefangst-evne';

  @override
  String deviceCapabilityError(String error) {
    return 'Feil ved kontroll av funksjoner:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR tilgjengelig';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth tilgjengelig';

  @override
  String get depthSourcePortraitLabel => 'Dobbeltkamera (portrettdybde)';

  @override
  String get depthSourceReferenceLabel => 'Ingen dybdesensor';

  @override
  String get depthSourceUnknownLabel => 'Ukjent';

  @override
  String get depthSourceLidarDescription =>
      'Høypresisjons volumestimat (~10-15% feil).';

  @override
  String get depthSourceArcoreDescription =>
      'Volumestimat via ARCore Depth API.';

  @override
  String get depthSourcePortraitDescription =>
      'Omtrentlig dybde fra dobbeltkameraet, lavere presisjon.';

  @override
  String get depthSourceReferenceDescription =>
      'Tallerkenens diameter vil bli brukt som skalareferanse (mindre presist estimat).';

  @override
  String get depthSourceUnknownDescription =>
      'Kunne ikke fastslå enhetens evne.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'dobbeltkamera';

  @override
  String get depthSourceReferenceShort => 'visuell referanse';

  @override
  String get depthSourceUnknownShort => 'ukjent';

  @override
  String get howItWorksTitle => 'Hvordan vi beregner kalorier';

  @override
  String get howItWorksTooltip => 'Hvordan beregner vi kalorier?';

  @override
  String get howItWorksIntro =>
      'De fleste ernæringsapper gjetter porsjonen fra et enkelt 2D-bilde. Calorii Fit måler faktisk volumet av maten på tallerkenen, ved hjelp av telefonens dybdekart — derfor er estimatet mer nøyaktig.';

  @override
  String get howItWorksStep1Title => 'Fotografer tallerkenen din';

  @override
  String get howItWorksStep1Description =>
      'Ett enkelt bilde, ingen spesiell plassering nødvendig.';

  @override
  String get howItWorksStep2Title => 'Telefonen din fanger dybden';

  @override
  String get howItWorksStep2GenericDescription =>
      'Telefonen din bruker, avhengig av modell, LiDAR, ARCore Depth eller et dobbeltkamera for å vite hvor høy maten er, ikke bare hvordan den ser ut ovenfra.';

  @override
  String get howItWorksStep3Title => 'Claude identifiserer maten';

  @override
  String get howItWorksStep3Description =>
      'Modellen gjenkjenner hva som er på tallerkenen og markerer det omtrentlige omrisset av hver rett — den beregner ikke kalorier selv, bare identifiserer.';

  @override
  String get howItWorksStep4Title => 'Volum blir til gram, deretter kalorier';

  @override
  String get howItWorksStep4Description =>
      'Dybdekartet × omrisset av hver rett gir et volum i cm³. En tetthetstabell (spesifikk for hver type mat) omdanner volumet til gram, og næringsdatabasen omdanner grammene til kalorier og makronæringsstoffer.';

  @override
  String get howItWorksStep5Title => 'Du bekrefter eller korrigerer';

  @override
  String get howItWorksStep5Description =>
      'Det automatiske estimatet lagres aldri direkte — du ser alltid en bekreftelsesskjerm der du kan justere porsjonen eller endre den identifiserte maten.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Se hvilken metode telefonen din bruker';

  @override
  String get howItWorksDepthLidar =>
      'Telefonen din har LiDAR — den mest presise metoden som er tilgjengelig i dag på en telefon, med en typisk feilmargin på bare 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Telefonen din bruker ARCore Depth API for å estimere dybden i scenen.';

  @override
  String get howItWorksDepthPortrait =>
      'Telefonen din estimerer dybden via dobbeltkameraet (portrettmodus) — mindre presist enn LiDAR, men fortsatt bedre enn et vanlig bilde.';

  @override
  String get howItWorksDepthReference =>
      'Telefonen din har ingen dybdesensor, så vi bruker standarddiameteren til en tallerken som skalareferanse — den minst presise metoden, men fortsatt bedre enn et rent visuelt estimat.';

  @override
  String get howItWorksDepthUnknown =>
      'Vi kunne ikke fastslå metoden telefonen din bruker.';

  @override
  String get reminderPermissionDenied =>
      'Tillat varsler for appen i telefoninnstillingene dine.';

  @override
  String get reminderTimePickerHelp => 'Påminnelsestidspunkt';

  @override
  String get reminderDialogTitle => 'Daglig påminnelse';

  @override
  String get reminderDailyNotification => 'Daglig varsel';

  @override
  String get reminderDailyNotificationSubtitle =>
      'En påminnelse om å registrere måltidene dine';

  @override
  String get reminderTimeLabel => 'Tidspunkt';

  @override
  String get close => 'Lukk';

  @override
  String get deleteAccountWrongPassword => 'Feil passord.';

  @override
  String deleteAccountFailed(String code) {
    return 'Kunne ikke slette kontoen ($code). Prøv igjen.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Kunne ikke slette kontoen. Prøv igjen.';

  @override
  String get deleteAccountTitle => 'Slett konto';

  @override
  String get deleteAccountExplanation =>
      'Dette sletter kontoen din og alle dataene dine permanent (profil, matdagbok, treningsøkter, vekter, husket mat). Denne handlingen kan ikke angres.';

  @override
  String get password => 'Passord';

  @override
  String get cancel => 'Avbryt';

  @override
  String get deleteAccountConfirm => 'Slett permanent';

  @override
  String get barcodeScanTitle => 'Skann strekkode';

  @override
  String barcodeNotFound(String barcode) {
    return 'Produktet med koden $barcode ble ikke funnet.';
  }

  @override
  String get addManually => 'Legg til manuelt';

  @override
  String get scanAgain => 'Skann igjen';

  @override
  String get bluetoothScaleTitle => 'Bluetooth-vekt';

  @override
  String get bluetoothScaleSearch => 'Søk etter vekter';

  @override
  String get bluetoothScaleIdleHint =>
      'Trykk på «Søk etter vekter» og slå på vekten din nær telefonen.';

  @override
  String get bluetoothScaleSearching => 'Søker...';

  @override
  String get bluetoothScaleNoneFound => 'Ingen vekt funnet ennå.';

  @override
  String get bluetoothScaleConnecting => 'Kobler til...';

  @override
  String get bluetoothScaleWeightSaved => 'Vekt lagret.';

  @override
  String errorPrefixed(String message) {
    return 'Feil: $message';
  }

  @override
  String get cameraNoneAvailable =>
      'Ikke noe kamera tilgjengelig på denne enheten.';

  @override
  String get cameraCaptureTitle => 'Fotografer tallerkenen din';

  @override
  String get cameraCapturingStatus => 'Fanger bildet og dybden…';

  @override
  String get cameraAnalyzingStatus => 'Identifiserer maten…';

  @override
  String get cameraConfirmationOpeningStatus => 'Ferdig — åpner bekreftelsen…';

  @override
  String get cameraStartingStatus => 'Starter kameraet…';

  @override
  String get cameraFrameHint => 'Ramm inn tallerkenen og trykk på utløseren';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Kunne ikke starte/analysere bildet:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Du har nådd grensen på 20 bildeanalyser per dag. Prøv igjen i morgen.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Du må være logget inn for å analysere et bilde.';

  @override
  String get cameraNetworkErrorMessage =>
      'Kunne ikke koble til. Sjekk internettforbindelsen din og prøv igjen.';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get authEnterEmailFirst =>
      'Skriv inn e-posten din først, slik at vi kan sende deg tilbakestillingslenken.';

  @override
  String get authPasswordResetSent =>
      'Vi har sendt deg en e-post for tilbakestilling av passord.';

  @override
  String get authErrorInvalidEmail => 'Ugyldig e-postadresse.';

  @override
  String get authErrorUserNotFound =>
      'Det finnes ingen konto med denne e-posten.';

  @override
  String get authErrorWrongCredentials => 'Feil e-post eller passord.';

  @override
  String get authErrorEmailInUse =>
      'Det finnes allerede en konto med denne e-posten.';

  @override
  String get authErrorWeakPassword => 'Passordet er for svakt (minst 6 tegn).';

  @override
  String get authErrorGeneric => 'Noe gikk galt. Prøv igjen.';

  @override
  String get authWelcomeBack => 'Velkommen tilbake';

  @override
  String get authLetsStart => 'La oss begynne';

  @override
  String get email => 'E-post';

  @override
  String get authEnterValidEmail => 'Skriv inn en gyldig e-post';

  @override
  String get authPasswordMinLength => 'Minst 6 tegn';

  @override
  String get authSignIn => 'Logg inn';

  @override
  String get authCreateAccount => 'Opprett konto';

  @override
  String get authNoAccountYet => 'Ingen konto ennå? Opprett en';

  @override
  String get authHaveAccountAlready => 'Har du allerede en konto? Logg inn';

  @override
  String get authForgotPassword => 'Glemt passordet?';

  @override
  String get activityWalkingCasual => 'Gåtur (avslappet)';

  @override
  String get activityWalkingBrisk => 'Gåtur (rask)';

  @override
  String get activityRunning => 'Løping';

  @override
  String get activityRunningFast => 'Løping (rask)';

  @override
  String get activityCycling => 'Sykling (moderat)';

  @override
  String get activityCyclingIntense => 'Sykling (intensiv)';

  @override
  String get activitySwimming => 'Svømming';

  @override
  String get activityStrengthTraining => 'Styrketrening';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Dans';

  @override
  String get activityHiking => 'Fjelltur';

  @override
  String get activityJumpRope => 'Hoppetau';

  @override
  String get activityFootball => 'Fotball';

  @override
  String get activityBasketball => 'Basketball';

  @override
  String get activityTennis => 'Tennis';

  @override
  String get activityOther => 'Annen aktivitet';

  @override
  String get mealBreakfast => 'Frokost';

  @override
  String get mealLunch => 'Lunsj';

  @override
  String get mealDinner => 'Middag';

  @override
  String get mealSnack => 'Mellommåltid';

  @override
  String get addWorkoutTitle => 'Legg til treningsøkt';

  @override
  String get addWorkoutFromActivity => 'Fra aktivitet';

  @override
  String get addWorkoutDirectCalories => 'Direkte kalorier';

  @override
  String get addWorkoutActivityTypeOptional => 'Aktivitetstype (valgfritt)';

  @override
  String get addWorkoutCaloriesBurned => 'Forbrente kalorier';

  @override
  String get addWorkoutCaloriesHint => 'f.eks. 250';

  @override
  String get save => 'Lagre';

  @override
  String get addWorkoutActivityType => 'Aktivitetstype';

  @override
  String get addWorkoutDuration => 'Varighet';

  @override
  String get minutes => 'minutter';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Estimat: $kcal kcal forbrent';
  }

  @override
  String get confirmFoodsTitle => 'Bekreft maten';

  @override
  String get mealLabel => 'Måltid:';

  @override
  String get mixedPlateWarning =>
      'Tallerken med blandet mat — sjekk hvert element, identifiseringen kan være mindre nøyaktig.';

  @override
  String get noItemsLeft =>
      'Du fjernet alle identifiserte elementer. Ta et nytt bilde hvis du vil prøve igjen.';

  @override
  String get portionSmall => 'Liten';

  @override
  String get portionMedium => 'Middels';

  @override
  String get portionLarge => 'Stor';

  @override
  String get notOnPlateRemove => 'Ikke på tallerkenen — fjern';

  @override
  String roughEstimateNote(String source) {
    return 'Grovt estimat ($source, ingen dybdesensor)';
  }

  @override
  String totalCalories(int kcal) {
    return 'Totalt: $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Stillesittende (kontorjobb, ingen trening)';

  @override
  String get activityLevelLight => 'Lett aktivitet (trening 1-3 dager/uke)';

  @override
  String get activityLevelModerate =>
      'Moderat aktivitet (trening 3-5 dager/uke)';

  @override
  String get activityLevelActive => 'Aktiv (trening 6-7 dager/uke)';

  @override
  String get activityLevelVeryActive =>
      'Svært aktiv (intensiv daglig trening / fysisk arbeid)';

  @override
  String get goalLose => 'Gå ned i vekt';

  @override
  String get goalMaintain => 'Vedlikeholde';

  @override
  String get goalGain => 'Bygge muskler';

  @override
  String get progressPeriod7Days => '7 dager';

  @override
  String get progressPeriod30Days => '30 dager';

  @override
  String get progressPeriodWholeProgram => 'Hele programmet';

  @override
  String get nutrientVitaminC => 'Vitamin C';

  @override
  String get nutrientVitaminD => 'Vitamin D';

  @override
  String get nutrientCalcium => 'Kalsium';

  @override
  String get nutrientIron => 'Jern';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientPotassium => 'Kalium';

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Karbohydrater';

  @override
  String get macroFat => 'Fett';

  @override
  String onboardingAgeTooLow(int age) {
    return 'Appen er beregnet for personer på $age år og eldre.';
  }

  @override
  String get onboardingAgeInvalid => 'Ugyldig verdi.';

  @override
  String get onboardingAgeSexTitle => 'Alder og biologisk kjønn';

  @override
  String get age => 'Alder';

  @override
  String get years => 'år';

  @override
  String get sexFemale => 'Kvinne';

  @override
  String get sexMale => 'Mann';

  @override
  String get onboardingSexHint =>
      'Brukes kun til å beregne basalstoffskiftet (Mifflin-St Jeor-formelen).';

  @override
  String get onboardingHeightWeightTitle => 'Høyde og nåværende vekt';

  @override
  String get height => 'Høyde';

  @override
  String get weight => 'Vekt';

  @override
  String get onboardingActivityTitle => 'Nivå av fysisk aktivitet';

  @override
  String get onboardingGoalTitle => 'Hva er målet ditt?';

  @override
  String get onboardingLossRate => 'Ønsket nedgangstempo';

  @override
  String get onboardingGainRate => 'Ønsket økningstempo';

  @override
  String get kgPerWeek => 'kg/uke';

  @override
  String get onboardingRateRecommendation =>
      'Anbefalt: 0,25-0,75 kg/uke for et bærekraftig tempo.';

  @override
  String get disclaimerTitle => 'Før du starter';

  @override
  String get disclaimerIntro =>
      'Calorii Fit estimerer kaloribehovet ditt og vektnedgangstempoet basert på generelt aksepterte formler (Mifflin-St Jeor), ikke en individuell medisinsk vurdering.';

  @override
  String get disclaimerMedical =>
      'Det erstatter ikke råd fra en lege eller ernæringsfysiolog — spesielt hvis du har en medisinsk tilstand, er gravid eller ammer.';

  @override
  String get disclaimerAllergens =>
      'Identifisering av mat fra et bilde oppdager ikke allergener. Hvis du har en alvorlig allergi eller intoleranse, sjekk alltid ingrediensene selv — ikke stol på appen for dette.';

  @override
  String get disclaimerEatingDisorders =>
      'Hvis du har hatt eller har et vanskelig forhold til mat (spiseforstyrrelser), snakk med en lege før du teller kalorier — appen er ikke ment å erstatte den støtten.';

  @override
  String get disclaimerAcceptLabel =>
      'Jeg forstår og godtar å bruke appen med dette i tankene.';

  @override
  String get finish => 'Fullfør';

  @override
  String get continueLabel => 'Fortsett';

  @override
  String get progress => 'Fremgang';

  @override
  String get activityAndSync => 'Aktivitet og synkronisering';

  @override
  String get editProfileGoal => 'Rediger profil/mål';

  @override
  String get checkDeviceCapability => 'Sjekk enhetens evne';

  @override
  String get myRecipes => 'Mine oppskrifter';

  @override
  String get signOut => 'Logg ut';

  @override
  String get takePhoto => 'Ta et bilde';

  @override
  String get previousDay => 'Forrige dag';

  @override
  String get nextDay => 'Neste dag';

  @override
  String get pickDayHelp => 'Velg en dag';

  @override
  String dateToday(String date) {
    return 'I dag, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'I går, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'I morgen, $date';
  }

  @override
  String get setUpYourGoal => 'Sett opp målet ditt';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal i dag';
  }

  @override
  String get setUp => 'Sett opp';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Mål: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Kaloriunderskudd';

  @override
  String get totalBurnedLabel => 'Totalt forbrent';

  @override
  String get totalConsumedLabel => 'Totalt konsumert';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Du overskred grensen med $overBy kcal (over $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Ikke overskrid $kcal kcal, for å nå ditt ønskede nedgangstempo.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Du trenger minst $kcal kcal for ditt ønskede økningstempo.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Hold deg rundt $kcal kcal for å vedlikeholde vekten.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Anbefalt: $low–$high kcal';
  }

  @override
  String get addFood => 'Legg til mat';

  @override
  String get sportActivity => 'Fysisk aktivitet';

  @override
  String get manualCaloriesEntered => 'Manuelt registrerte kalorier';

  @override
  String get addActivity => 'Legg til aktivitet';

  @override
  String get caloricIntake => 'Kaloriinntak';

  @override
  String get dailyCaloricDeficit => 'Daglig kaloriunderskudd';

  @override
  String get setUpProfileFirst =>
      'Sett først opp profilen og målet ditt fra menyen.';

  @override
  String get totalCaloriesLabel => 'Totalt antall kalorier';

  @override
  String get avgPerDay => 'Gj.snitt/dag';

  @override
  String get estimatedLoss => 'Estimert nedgang';

  @override
  String get macroBalanceTitle => 'Makronæringsbalanse';

  @override
  String get macroBalanceNoData =>
      'Ingen mat med kjent protein/karbohydrater/fett i denne perioden.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (anbefalt $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Mikronæringsstoffer (gj.snitt/dag)';

  @override
  String get micronutrientsNoData =>
      'Ingen mat med vitamin-/mineraldata i denne perioden — se merknaden nedenfor.';

  @override
  String get micronutrientsNoEntries =>
      'Ingen mat registrert i denne perioden.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Vitamin-/mineraldata tilgjengelig for $pct% av den registrerte maten ($withData/$total) — resten (hjemmelaget mat, umerkede produkter) har ingen kjente data og er ikke inkludert i gjennomsnittet.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% av dagsverdien';
  }

  @override
  String get chartTargetLabel => 'Mål';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Helse';

  @override
  String get healthConnectDescription =>
      'Henter vekten og den fysiske aktiviteten registrert av klokken din, via telefonens helseplattform.';

  @override
  String get bluetoothScaleSubtitle => 'Koble til en smart vekt direkte';

  @override
  String get weightHistoryTitle => 'Vekthistorikk';

  @override
  String get addLabel => 'Legg til';

  @override
  String get noEntriesYet => 'Ingen oppføringer ennå.';

  @override
  String get syncButton => 'Synkroniser';

  @override
  String get syncAgain => 'Synkroniser igjen';

  @override
  String get stepsToday => 'skritt i dag';

  @override
  String get activeKcal => 'aktive kcal';

  @override
  String newWeightFetched(String kg) {
    return 'Ny vekt hentet: $kg kg';
  }

  @override
  String get weightSourceManual => 'manuell';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Helse';

  @override
  String get weightSourceBluetoothScale => 'BT-vekt';

  @override
  String get addWeightTitle => 'Legg til vekt';

  @override
  String get editWeightTitle => 'Rediger vekt';

  @override
  String get weighInDateHelp => 'Dato for veiing';

  @override
  String get weighInTimeHelp => 'Tidspunkt for veiing';

  @override
  String get edit => 'Rediger';

  @override
  String get delete => 'Slett';

  @override
  String get chooseARecipe => 'Velg en oppskrift';

  @override
  String get newRecipe => 'Ny oppskrift';

  @override
  String get editRecipe => 'Rediger oppskrift';

  @override
  String get noRecipesYet =>
      'Du har ikke lagret noen oppskrifter ennå. Legg til en med knappen nedenfor.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings porsjoner · $kcal kcal/porsjon';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name ble lagt til i dag.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Legg til «$name» i:';
  }

  @override
  String get recipeNameLabel => 'Oppskriftens navn';

  @override
  String get recipeNameHint => 'f.eks. Min kyllingsalat';

  @override
  String get numberOfServings => 'Antall porsjoner';

  @override
  String get ingredients => 'Ingredienser';

  @override
  String get addAtLeastOneIngredient => 'Legg til minst én ingrediens.';

  @override
  String get saveRecipe => 'Lagre oppskrift';

  @override
  String perServing(int grams, int kcal) {
    return 'Per porsjon ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Protein $protein · Karbohydrater $carbs · Fett $fat';
  }

  @override
  String get addIngredientTitle => 'Legg til ingrediens';

  @override
  String get productNameLabel => 'Produktnavn';

  @override
  String get noProductFound => 'Ingen produkt funnet.';

  @override
  String get quantityLabel => 'Mengde';

  @override
  String get addIngredientButton => 'Legg til ingrediens';

  @override
  String get editIngredientQuantityTitle => 'Rediger mengde';

  @override
  String get chooseRecipeIconTitle => 'Velg et ikon';

  @override
  String get recipeIconSuggested => 'Forslag';

  @override
  String get saveAsRecipeTooltip => 'Lagre som oppskrift';

  @override
  String get saveAsRecipeDialogTitle => 'Lagre som ny oppskrift';

  @override
  String recipeSavedConfirmation(String name) {
    return '«$name» ble lagret i oppskriftene dine.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Legg til mat — $meal';
  }

  @override
  String get productNameHint => 'f.eks. Gresk yoghurt';

  @override
  String get enterProductName => 'Skriv inn produktnavnet';

  @override
  String get frequentlyLogged => 'Ofte registrert';

  @override
  String addCount(int count) {
    return 'Legg til ($count)';
  }

  @override
  String get calorieIndexLabel => 'Kaloriindeks (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Spist mengde';

  @override
  String get requiredField => 'Obligatorisk felt';

  @override
  String get invalidValue => 'Ugyldig verdi';

  @override
  String get searchFailedCheckConnection =>
      'Søket kunne ikke fullføres (sjekk tilkoblingen din).';

  @override
  String get addProductManually => 'Legg til produkt manuelt';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'K';

  @override
  String get macroFatShort => 'F';

  @override
  String get macrosUnavailable => 'Makronæringsstoffer ikke tilgjengelig';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Protein $protein · Karbohydrater $carbs · Fett $fat';
  }

  @override
  String get languageDialogTitle => 'Språk';

  @override
  String get languageSystemDefault => 'Telefonens språk (standard)';

  @override
  String get languageMenuEntry => 'Språk';

  @override
  String get guideMenuEntry => 'Brukerveiledning';

  @override
  String get guideScreenTitle => 'Brukerveiledning';

  @override
  String get guideIntroTitle => 'Hva er Calorii Fit';

  @override
  String get guideIntroBody =>
      'En ernæringsapp som anslår kalorier direkte fra et bilde av tallerkenen din, ved hjelp av telefonens dybdesensor — ikke bare et vanlig bilde. Den fører også en fullstendig dagbok: måltider, trening, væskeinntak, vekt og fremgangen din mot målet.';

  @override
  String get guidePhotoTitle => 'Estimering fra bilde';

  @override
  String get guidePhotoBody =>
      'Du fotograferer tallerkenen, telefonen måler volumet med LiDAR, ARCore Depth eller et dobbeltkamera, og appen identifiserer maten og beregner porsjonen. Du bekrefter eller justerer resultatet med en glidebryter eller forhåndsinnstillinger — ingenting lagres automatisk. Uten dybdesensor brukes tallerkenens diameter som referanse, tydelig merket som et grovt estimat.';

  @override
  String get guideLogTitle => 'Daglig logg';

  @override
  String get guideLogBody =>
      'Fire måltider om dagen — Frokost, Lunsj, Middag, Mellommåltid. Legg til mat via bilde, søk, skanning av strekkode, manuelt, fra oppskriftene dine eller raskt fra en huke-av-liste med vanlig mat.';

  @override
  String get guideRecipesTitle => 'Mine oppskrifter';

  @override
  String get guideRecipesBody =>
      'Lagre en kombinasjon av ingredienser du ofte spiser, og registrer den med ett trykk. Du kan velge et ikon for hver oppskrift (eller godta det automatiske forslaget) og redigere mengden av en hvilken som helst ingrediens når som helst. Når du legger til flere matvarer samtidig, kan du lagre dem umiddelbart som en ny oppskrift.';

  @override
  String get guideWorkoutsTitle => 'Fysisk aktivitet';

  @override
  String get guideWorkoutsBody =>
      'Velg aktivitetstype og varighet, så beregnes forbrente kalorier automatisk — eller angi dem direkte hvis du allerede vet dem fra en smartklokke. Forbrente kalorier trekkes fra dagens budsjett.';

  @override
  String get guideProgressTitle => 'Fremgang';

  @override
  String get guideProgressBody =>
      'Grafer over 7 dager, 30 dager eller hele programmet: vektutvikling (utjevnet), adaptivt TDEE beregnet fra din egen energibalanse, makronæringsbalanse og dekning av mikronæringsstoffer. Synkroniserer med Apple Helse / Health Connect og en Bluetooth-vekt.';

  @override
  String get guideHydrationTitle => 'Væskeinntak';

  @override
  String get guideHydrationBody =>
      'En enkel daglig teller for vannglass — ett trykk for å legge til, ett trykk for å angre det siste.';

  @override
  String get guideStreaksTitle => 'Motivasjon';

  @override
  String get guideStreaksBody =>
      'Et flammemerke viser hvor mange dager på rad du har registrert minst ett måltid.';

  @override
  String get guideRemindersTitle => 'Daglig påminnelse';

  @override
  String get guideRemindersBody =>
      'Et varsel, på tidspunktet du velger, som minner deg på å registrere måltidene dine — kan slås av når som helst fra menyen.';

  @override
  String get guideProfileTitle => 'Profil og mål';

  @override
  String get guideProfileBody =>
      'Alder, biologisk kjønn, høyde, vekt, aktivitetsnivå og mål — redigerbare når som helst. Appen beregner kalorimålet ditt automatisk på nytt ved enhver endring.';

  @override
  String get guidePrivacyTitle => 'Personvern';

  @override
  String get guidePrivacyBody =>
      'Dataene dine er utelukkende knyttet til kontoen din og er ikke synlige for andre brukere. Du kan slette kontoen din og alle tilknyttede data når som helst, fra menyen — slettingen er permanent og umiddelbar.';

  @override
  String get guideLanguagesTitle => 'Tilgjengelige språk';

  @override
  String get guideLanguagesBody =>
      'Appen er tilgjengelig på 13 språk, valgt fra menyen — ikke bare automatisk oppdaget fra telefonens språk.';

  @override
  String get guidePremiumTitle => 'Premium og abonnementer';

  @override
  String get guidePremiumDraftNote =>
      'Utkast, ikke ferdigstilt — planen nedenfor er ikke aktiv i appen ennå. Det finnes foreløpig ingen betaling i appen eller funksjonsbegrensning.';

  @override
  String get guidePremiumFreeBody =>
      'Gratis, for alltid: fullstendig matdagbok, 20 bildeanalyser om dagen, ubegrenset med egne oppskrifter, grunnleggende fremgangsgrafer og synkronisering med Apple Helse / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (veiledende pris, ubekreftet): ubegrensede bildeanalyser, adaptivt TDEE og detaljerte mikronæringsstoffer, pluss prioritert støtte.';

  @override
  String get themeDialogTitle => 'Tema';

  @override
  String get themeSystemDefault => 'Telefonens tema (standard)';

  @override
  String get themeLight => 'Lyst';

  @override
  String get themeDark => 'Mørkt';

  @override
  String get themeMenuEntry => 'Tema';

  @override
  String get barcodeToggleTorch => 'Slå av/på blits';

  @override
  String get clearSelection => 'Fjern valg';
}

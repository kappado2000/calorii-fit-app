// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Glem ikke at registrere dine måltider';

  @override
  String get dailyReminderBody =>
      'Nogle få sekunder er nok til at holde din log opdateret og din stribe i live.';

  @override
  String get dailyReminderChannelName => 'Daglig påmindelse';

  @override
  String get dailyReminderChannelDescription =>
      'Påmindelse om at registrere dagens måltider';

  @override
  String get updateRequiredTitle => 'En opdatering er nødvendig';

  @override
  String get updateRequiredMessage =>
      'Versionen af appen på denne telefon understøttes ikke længere. Installer den nyeste version for at fortsætte.';

  @override
  String get updateAvailableMessage => 'En ny version af appen er tilgængelig.';

  @override
  String get hydrationTitle => 'Væskeindtag';

  @override
  String get hydrationUndoLastGlass => 'Fortryd sidste glas';

  @override
  String hydrationAddGlass(int ml) {
    return 'Tilføj et glas ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'Adaptivt TDEE';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Ikke nok data endnu: du skal bruge mindst 14 registrerede dage og 2 vejninger med mindst 10 dages mellemrum, inden for de sidste 3 uger. Indtil da bruges standardformlen (Mifflin-St Jeor).';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Beregnet ud fra din egen kaloribalance ($loggedDays/$windowDays dage registreret de sidste 3 uger), ikke kun standardformlen.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'Estimeret TDEE';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Vægttendens';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/uge';
  }

  @override
  String get adaptiveTdeeRejected =>
      'Estimatet afviger stadig for meget fra standardformlen til at være pålideligt — standardformlen bruges fortsat, indtil mere konsistente data er indsamlet.';

  @override
  String get weeklySummaryTitle => 'Ugens oversigt';

  @override
  String get weeklySummaryDaysLogged => 'Registrerede dage';

  @override
  String get weeklySummaryAvgCalories => 'Gns. kcal/dag';

  @override
  String get weeklySummaryWorkouts => 'Træningspas';

  @override
  String get weightEvolutionTitle => 'Vægtudvikling';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Fra $date ($startKg kg) til i dag ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Dybdeopfangningsevne';

  @override
  String deviceCapabilityError(String error) {
    return 'Fejl ved kontrol af funktioner:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR tilgængelig';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth tilgængelig';

  @override
  String get depthSourcePortraitLabel => 'Dobbeltkamera (portrætdybde)';

  @override
  String get depthSourceReferenceLabel => 'Ingen dybdesensor';

  @override
  String get depthSourceUnknownLabel => 'Ukendt';

  @override
  String get depthSourceLidarDescription =>
      'Højpræcisions volumenestimat (~10-15% fejl).';

  @override
  String get depthSourceArcoreDescription =>
      'Volumenestimat via ARCore Depth API.';

  @override
  String get depthSourcePortraitDescription =>
      'Omtrentlig dybde fra dobbeltkameraet, lavere præcision.';

  @override
  String get depthSourceReferenceDescription =>
      'Tallerkenens diameter vil blive brugt som skalareference (mindre præcist estimat).';

  @override
  String get depthSourceUnknownDescription =>
      'Kunne ikke fastslå enhedens evne.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'dobbeltkamera';

  @override
  String get depthSourceReferenceShort => 'visuel reference';

  @override
  String get depthSourceUnknownShort => 'ukendt';

  @override
  String get howItWorksTitle => 'Sådan beregner vi kalorier';

  @override
  String get howItWorksTooltip => 'Hvordan beregner vi kalorier?';

  @override
  String get howItWorksIntro =>
      'De fleste ernæringsapps gætter portionen ud fra et enkelt 2D-foto. Calorii Fit måler faktisk volumen af maden på tallerkenen ved hjælp af din telefons dybdekort — derfor er estimatet mere præcist.';

  @override
  String get howItWorksStep1Title => 'Fotografer din tallerken';

  @override
  String get howItWorksStep1Description =>
      'Ét enkelt foto, ingen særlig placering nødvendig.';

  @override
  String get howItWorksStep2Title => 'Din telefon opfanger dybden';

  @override
  String get howItWorksStep2GenericDescription =>
      'Din telefon bruger, afhængigt af modellen, LiDAR, ARCore Depth eller et dobbeltkamera for at vide, hvor høj maden er, ikke kun hvordan den ser ud oppefra.';

  @override
  String get howItWorksStep3Title => 'Claude identificerer maden';

  @override
  String get howItWorksStep3Description =>
      'Modellen genkender, hvad der er på tallerkenen, og markerer den omtrentlige kontur af hver ret — den beregner ikke selv kalorier, kun identificerer.';

  @override
  String get howItWorksStep4Title =>
      'Volumen bliver til gram, derefter kalorier';

  @override
  String get howItWorksStep4Description =>
      'Dybdekortet × konturen af hver ret giver et volumen i cm³. En densitetstabel (specifik for hver madtype) omdanner volumen til gram, og næringsdatabasen omdanner grammene til kalorier og makronæringsstoffer.';

  @override
  String get howItWorksStep5Title => 'Du bekræfter eller retter';

  @override
  String get howItWorksStep5Description =>
      'Det automatiske estimat gemmes aldrig direkte — du ser altid en bekræftelsesskærm, hvor du kan justere portionen eller ændre den identificerede mad.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Se hvilken metode din telefon bruger';

  @override
  String get howItWorksDepthLidar =>
      'Din telefon har LiDAR — den mest præcise metode, der findes i dag på en telefon, med en typisk fejlmargin på kun 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Din telefon bruger ARCore Depth API til at estimere scenens dybde.';

  @override
  String get howItWorksDepthPortrait =>
      'Din telefon estimerer dybden via dobbeltkameraet (portrættilstand) — mindre præcist end LiDAR, men stadig bedre end et almindeligt foto.';

  @override
  String get howItWorksDepthReference =>
      'Din telefon har ingen dybdesensor, så vi bruger standarddiameteren for en tallerken som skalareference — den mindst præcise metode, men stadig bedre end et rent visuelt estimat.';

  @override
  String get howItWorksDepthUnknown =>
      'Vi kunne ikke fastslå den metode, din telefon bruger.';

  @override
  String get reminderPermissionDenied =>
      'Tillad notifikationer for appen i din telefons indstillinger.';

  @override
  String get reminderTimePickerHelp => 'Påmindelsestidspunkt';

  @override
  String get reminderDialogTitle => 'Daglig påmindelse';

  @override
  String get reminderDailyNotification => 'Daglig notifikation';

  @override
  String get reminderDailyNotificationSubtitle =>
      'En påmindelse om at registrere dine måltider';

  @override
  String get reminderTimeLabel => 'Tidspunkt';

  @override
  String get close => 'Luk';

  @override
  String get deleteAccountWrongPassword => 'Forkert adgangskode.';

  @override
  String deleteAccountFailed(String code) {
    return 'Kunne ikke slette kontoen ($code). Prøv igen.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Kunne ikke slette kontoen. Prøv igen.';

  @override
  String get deleteAccountTitle => 'Slet konto';

  @override
  String get deleteAccountExplanation =>
      'Dette sletter permanent din konto og alle dine data (profil, madlog, træningspas, vægte, huskede fødevarer). Denne handling kan ikke fortrydes.';

  @override
  String get password => 'Adgangskode';

  @override
  String get cancel => 'Annuller';

  @override
  String get deleteAccountConfirm => 'Slet permanent';

  @override
  String get barcodeScanTitle => 'Scan stregkode';

  @override
  String barcodeNotFound(String barcode) {
    return 'Produktet med koden $barcode blev ikke fundet.';
  }

  @override
  String get addManually => 'Tilføj manuelt';

  @override
  String get scanAgain => 'Scan igen';

  @override
  String get bluetoothScaleTitle => 'Bluetooth-vægt';

  @override
  String get bluetoothScaleSearch => 'Søg efter vægte';

  @override
  String get bluetoothScaleIdleHint =>
      'Tryk på \"Søg efter vægte\" og tænd din vægt tæt på telefonen.';

  @override
  String get bluetoothScaleSearching => 'Søger...';

  @override
  String get bluetoothScaleNoneFound => 'Ingen vægt fundet endnu.';

  @override
  String get bluetoothScaleConnecting => 'Forbinder...';

  @override
  String get bluetoothScaleWeightSaved => 'Vægt gemt.';

  @override
  String errorPrefixed(String message) {
    return 'Fejl: $message';
  }

  @override
  String get cameraNoneAvailable => 'Intet kamera tilgængeligt på denne enhed.';

  @override
  String get cameraCaptureTitle => 'Fotografer din tallerken';

  @override
  String get cameraCapturingStatus => 'Optager foto og dybde…';

  @override
  String get cameraAnalyzingStatus => 'Identificerer maden…';

  @override
  String get cameraConfirmationOpeningStatus => 'Færdig — åbner bekræftelsen…';

  @override
  String get cameraStartingStatus => 'Starter kameraet…';

  @override
  String get cameraFrameHint => 'Indram tallerkenen og tryk på udløseren';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Kunne ikke starte/analysere billedet:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Du har nået grænsen på 20 fotoanalyser om dagen. Prøv igen i morgen.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Du skal være logget ind for at analysere et billede.';

  @override
  String get cameraNetworkErrorMessage =>
      'Kunne ikke oprette forbindelse. Tjek din internetforbindelse, og prøv igen.';

  @override
  String get retry => 'Prøv igen';

  @override
  String get authEnterEmailFirst =>
      'Indtast din e-mail først, så vi kan sende dig nulstillingslinket.';

  @override
  String get authPasswordResetSent =>
      'Vi har sendt dig en e-mail til nulstilling af adgangskode.';

  @override
  String get authErrorInvalidEmail => 'Ugyldig e-mailadresse.';

  @override
  String get authErrorUserNotFound =>
      'Der findes ingen konto med denne e-mail.';

  @override
  String get authErrorWrongCredentials => 'Forkert e-mail eller adgangskode.';

  @override
  String get authErrorEmailInUse =>
      'Der findes allerede en konto med denne e-mail.';

  @override
  String get authErrorWeakPassword =>
      'Adgangskoden er for svag (minimum 6 tegn).';

  @override
  String get authErrorGeneric => 'Noget gik galt. Prøv igen.';

  @override
  String get authWelcomeBack => 'Velkommen tilbage';

  @override
  String get authLetsStart => 'Lad os komme i gang';

  @override
  String get email => 'E-mail';

  @override
  String get authEnterValidEmail => 'Indtast en gyldig e-mail';

  @override
  String get authPasswordMinLength => 'Minimum 6 tegn';

  @override
  String get authSignIn => 'Log ind';

  @override
  String get authCreateAccount => 'Opret konto';

  @override
  String get authNoAccountYet => 'Ingen konto endnu? Opret en';

  @override
  String get authHaveAccountAlready => 'Har du allerede en konto? Log ind';

  @override
  String get authForgotPassword => 'Glemt adgangskode?';

  @override
  String get activityWalkingCasual => 'Gåtur (afslappet)';

  @override
  String get activityWalkingBrisk => 'Gåtur (rask)';

  @override
  String get activityRunning => 'Løb';

  @override
  String get activityRunningFast => 'Løb (hurtigt)';

  @override
  String get activityCycling => 'Cykling (moderat)';

  @override
  String get activityCyclingIntense => 'Cykling (intensiv)';

  @override
  String get activitySwimming => 'Svømning';

  @override
  String get activityStrengthTraining => 'Styrketræning';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Dans';

  @override
  String get activityHiking => 'Vandretur';

  @override
  String get activityJumpRope => 'Sjipning';

  @override
  String get activityFootball => 'Fodbold';

  @override
  String get activityBasketball => 'Basketball';

  @override
  String get activityTennis => 'Tennis';

  @override
  String get activityOther => 'Anden aktivitet';

  @override
  String get mealBreakfast => 'Morgenmad';

  @override
  String get mealLunch => 'Frokost';

  @override
  String get mealDinner => 'Aftensmad';

  @override
  String get mealSnack => 'Snack';

  @override
  String get addWorkoutTitle => 'Tilføj træningspas';

  @override
  String get addWorkoutFromActivity => 'Fra aktivitet';

  @override
  String get addWorkoutDirectCalories => 'Direkte kalorier';

  @override
  String get addWorkoutActivityTypeOptional => 'Aktivitetstype (valgfrit)';

  @override
  String get addWorkoutCaloriesBurned => 'Forbrændte kalorier';

  @override
  String get addWorkoutCaloriesHint => 'f.eks. 250';

  @override
  String get save => 'Gem';

  @override
  String get addWorkoutActivityType => 'Aktivitetstype';

  @override
  String get addWorkoutDuration => 'Varighed';

  @override
  String get minutes => 'minutter';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Estimat: $kcal kcal forbrændt';
  }

  @override
  String get confirmFoodsTitle => 'Bekræft maden';

  @override
  String get mealLabel => 'Måltid:';

  @override
  String get mixedPlateWarning =>
      'Tallerken med blandet mad — tjek hvert element, identifikationen kan være mindre præcis.';

  @override
  String get noItemsLeft =>
      'Du fjernede alle identificerede elementer. Tag et nyt foto, hvis du vil prøve igen.';

  @override
  String get portionSmall => 'Lille';

  @override
  String get portionMedium => 'Mellem';

  @override
  String get portionLarge => 'Stor';

  @override
  String get notOnPlateRemove => 'Ikke på tallerkenen — fjern';

  @override
  String roughEstimateNote(String source) {
    return 'Groft estimat ($source, ingen dybdesensor)';
  }

  @override
  String totalCalories(int kcal) {
    return 'I alt: $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Stillesiddende (kontorjob, ingen motion)';

  @override
  String get activityLevelLight => 'Let aktivitet (motion 1-3 dage/uge)';

  @override
  String get activityLevelModerate => 'Moderat aktivitet (motion 3-5 dage/uge)';

  @override
  String get activityLevelActive => 'Aktiv (motion 6-7 dage/uge)';

  @override
  String get activityLevelVeryActive =>
      'Meget aktiv (intensiv daglig motion / fysisk arbejde)';

  @override
  String get goalLose => 'Tabe sig';

  @override
  String get goalMaintain => 'Vedligeholde';

  @override
  String get goalGain => 'Opbygge muskler';

  @override
  String get progressPeriod7Days => '7 dage';

  @override
  String get progressPeriod30Days => '30 dage';

  @override
  String get progressPeriodWholeProgram => 'Hele programmet';

  @override
  String get nutrientVitaminC => 'Vitamin C';

  @override
  String get nutrientVitaminD => 'Vitamin D';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientIron => 'Jern';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientPotassium => 'Kalium';

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Kulhydrater';

  @override
  String get macroFat => 'Fedt';

  @override
  String onboardingAgeTooLow(int age) {
    return 'Appen er beregnet til personer på $age år og derover.';
  }

  @override
  String get onboardingAgeInvalid => 'Ugyldig værdi.';

  @override
  String get onboardingAgeSexTitle => 'Alder og biologisk køn';

  @override
  String get age => 'Alder';

  @override
  String get years => 'år';

  @override
  String get sexFemale => 'Kvinde';

  @override
  String get sexMale => 'Mand';

  @override
  String get onboardingSexHint =>
      'Bruges kun til at beregne basalstofskiftet (Mifflin-St Jeor-formlen).';

  @override
  String get onboardingHeightWeightTitle => 'Højde og nuværende vægt';

  @override
  String get height => 'Højde';

  @override
  String get weight => 'Vægt';

  @override
  String get onboardingActivityTitle => 'Niveau af fysisk aktivitet';

  @override
  String get onboardingGoalTitle => 'Hvad er dit mål?';

  @override
  String get onboardingLossRate => 'Ønsket vægttabstempo';

  @override
  String get onboardingGainRate => 'Ønsket vægtøgningstempo';

  @override
  String get kgPerWeek => 'kg/uge';

  @override
  String get onboardingRateRecommendation =>
      'Anbefalet: 0,25-0,75 kg/uge for et bæredygtigt tempo.';

  @override
  String get disclaimerTitle => 'Før du starter';

  @override
  String get disclaimerIntro =>
      'Calorii Fit estimerer dit kaloriebehov og vægttabstempo baseret på generelt accepterede formler (Mifflin-St Jeor), ikke en individuel medicinsk vurdering.';

  @override
  String get disclaimerMedical =>
      'Det erstatter ikke råd fra en læge eller diætist — især hvis du har en medicinsk tilstand, er gravid eller ammer.';

  @override
  String get disclaimerAllergens =>
      'Identifikation af mad ud fra et foto registrerer ikke allergener. Hvis du har en alvorlig allergi eller intolerance, skal du altid selv tjekke ingredienserne — stol ikke på appen for dette.';

  @override
  String get disclaimerEatingDisorders =>
      'Hvis du har haft eller har et vanskeligt forhold til mad (spiseforstyrrelser), skal du tale med en læge, før du tæller kalorier — appen er ikke beregnet til at erstatte den støtte.';

  @override
  String get disclaimerAcceptLabel =>
      'Jeg forstår og accepterer at bruge appen med dette in mente.';

  @override
  String get finish => 'Afslut';

  @override
  String get continueLabel => 'Fortsæt';

  @override
  String get progress => 'Fremskridt';

  @override
  String get activityAndSync => 'Aktivitet og synkronisering';

  @override
  String get editProfileGoal => 'Rediger profil/mål';

  @override
  String get checkDeviceCapability => 'Tjek enhedens evne';

  @override
  String get myRecipes => 'Mine opskrifter';

  @override
  String get signOut => 'Log ud';

  @override
  String get takePhoto => 'Tag et foto';

  @override
  String get previousDay => 'Forrige dag';

  @override
  String get nextDay => 'Næste dag';

  @override
  String get pickDayHelp => 'Vælg en dag';

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
  String get setUpYourGoal => 'Opsæt dit mål';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal i dag';
  }

  @override
  String get setUp => 'Opsæt';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Mål: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Kalorieunderskud';

  @override
  String get totalBurnedLabel => 'I alt forbrændt';

  @override
  String get totalConsumedLabel => 'I alt indtaget';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Du overskred grænsen med $overBy kcal (over $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Overskrid ikke $kcal kcal, for at nå dit ønskede vægttabstempo.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Du skal bruge mindst $kcal kcal til dit ønskede vægtøgningstempo.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Hold dig omkring $kcal kcal for at vedligeholde vægten.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Anbefalet: $low–$high kcal';
  }

  @override
  String get addFood => 'Tilføj mad';

  @override
  String get sportActivity => 'Fysisk aktivitet';

  @override
  String get manualCaloriesEntered => 'Manuelt indtastede kalorier';

  @override
  String get addActivity => 'Tilføj aktivitet';

  @override
  String get caloricIntake => 'Kalorieindtag';

  @override
  String get dailyCaloricDeficit => 'Dagligt kalorieunderskud';

  @override
  String get setUpProfileFirst =>
      'Opsæt først din profil og dit mål fra menuen.';

  @override
  String get totalCaloriesLabel => 'Kalorier i alt';

  @override
  String get avgPerDay => 'Gns./dag';

  @override
  String get estimatedLoss => 'Estimeret vægttab';

  @override
  String get macroBalanceTitle => 'Makronæringsbalance';

  @override
  String get macroBalanceNoData =>
      'Ingen mad med kendt protein/kulhydrater/fedt i denne periode.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (anbefalet $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Mikronæringsstoffer (gns./dag)';

  @override
  String get micronutrientsNoData =>
      'Ingen mad med vitamin-/mineraldata i denne periode — se noten nedenfor.';

  @override
  String get micronutrientsNoEntries =>
      'Ingen mad registreret i denne periode.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Vitamin-/mineraldata tilgængelige for $pct% af den registrerede mad ($withData/$total) — resten (hjemmelavet mad, umærkede produkter) har ingen kendte data og indgår ikke i gennemsnittet.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% af dagsværdien';
  }

  @override
  String get chartTargetLabel => 'Mål';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Health';

  @override
  String get healthConnectDescription =>
      'Henter vægten og den fysiske aktivitet, som dit ur har registreret, via din telefons sundhedsplatform.';

  @override
  String get bluetoothScaleSubtitle => 'Forbind en smart vægt direkte';

  @override
  String get weightHistoryTitle => 'Vægthistorik';

  @override
  String get addLabel => 'Tilføj';

  @override
  String get noEntriesYet => 'Ingen registreringer endnu.';

  @override
  String get syncButton => 'Synkroniser';

  @override
  String get syncAgain => 'Synkroniser igen';

  @override
  String get stepsToday => 'skridt i dag';

  @override
  String get activeKcal => 'aktive kcal';

  @override
  String newWeightFetched(String kg) {
    return 'Ny vægt hentet: $kg kg';
  }

  @override
  String get weightSourceManual => 'manuel';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Health';

  @override
  String get weightSourceBluetoothScale => 'BT-vægt';

  @override
  String get addWeightTitle => 'Tilføj vægt';

  @override
  String get editWeightTitle => 'Rediger vægt';

  @override
  String get weighInDateHelp => 'Dato for vejning';

  @override
  String get weighInTimeHelp => 'Tidspunkt for vejning';

  @override
  String get edit => 'Rediger';

  @override
  String get delete => 'Slet';

  @override
  String get chooseARecipe => 'Vælg en opskrift';

  @override
  String get newRecipe => 'Ny opskrift';

  @override
  String get editRecipe => 'Rediger opskrift';

  @override
  String get noRecipesYet =>
      'Du har ikke gemt nogen opskrifter endnu. Tilføj en med knappen nedenfor.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings portioner · $kcal kcal/portion';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name blev tilføjet i dag.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Tilføj \"$name\" til:';
  }

  @override
  String get recipeNameLabel => 'Opskriftens navn';

  @override
  String get recipeNameHint => 'f.eks. Min kyllingesalat';

  @override
  String get numberOfServings => 'Antal portioner';

  @override
  String get ingredients => 'Ingredienser';

  @override
  String get addAtLeastOneIngredient => 'Tilføj mindst én ingrediens.';

  @override
  String get saveRecipe => 'Gem opskrift';

  @override
  String perServing(int grams, int kcal) {
    return 'Pr. portion ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Protein $protein · Kulhydrater $carbs · Fedt $fat';
  }

  @override
  String get addIngredientTitle => 'Tilføj ingrediens';

  @override
  String get productNameLabel => 'Produktnavn';

  @override
  String get noProductFound => 'Intet produkt fundet.';

  @override
  String get quantityLabel => 'Mængde';

  @override
  String get addIngredientButton => 'Tilføj ingrediens';

  @override
  String get editIngredientQuantityTitle => 'Rediger mængde';

  @override
  String get chooseRecipeIconTitle => 'Vælg et ikon';

  @override
  String get recipeIconSuggested => 'Forslag';

  @override
  String get saveAsRecipeTooltip => 'Gem som opskrift';

  @override
  String get saveAsRecipeDialogTitle => 'Gem som ny opskrift';

  @override
  String recipeSavedConfirmation(String name) {
    return '\"$name\" blev gemt i dine opskrifter.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Tilføj mad — $meal';
  }

  @override
  String get productNameHint => 'f.eks. Græsk yoghurt';

  @override
  String get enterProductName => 'Indtast produktnavnet';

  @override
  String get frequentlyLogged => 'Ofte registreret';

  @override
  String addCount(int count) {
    return 'Tilføj ($count)';
  }

  @override
  String get calorieIndexLabel => 'Kalorieindeks (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Spist mængde';

  @override
  String get requiredField => 'Påkrævet felt';

  @override
  String get invalidValue => 'Ugyldig værdi';

  @override
  String get searchFailedCheckConnection =>
      'Søgningen kunne ikke gennemføres (tjek din forbindelse).';

  @override
  String get addProductManually => 'Tilføj produkt manuelt';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'K';

  @override
  String get macroFatShort => 'F';

  @override
  String get macrosUnavailable => 'Makronæringsstoffer ikke tilgængelige';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Protein $protein · Kulhydrater $carbs · Fedt $fat';
  }

  @override
  String get languageDialogTitle => 'Sprog';

  @override
  String get languageSystemDefault => 'Telefonens sprog (standard)';

  @override
  String get languageMenuEntry => 'Sprog';

  @override
  String get guideMenuEntry => 'Brugervejledning';

  @override
  String get guideScreenTitle => 'Brugervejledning';

  @override
  String get guideIntroTitle => 'Hvad er Calorii Fit';

  @override
  String get guideIntroBody =>
      'En ernæringsapp, der estimerer kalorier direkte ud fra et billede af din tallerken, ved hjælp af telefonens dybdesensor — ikke bare et almindeligt billede. Den fører også en fuldstændig dagbog: måltider, motion, væskeindtag, vægt og din fremgang mod dit mål.';

  @override
  String get guidePhotoTitle => 'Estimering fra billede';

  @override
  String get guidePhotoBody =>
      'Du fotograferer din tallerken, telefonen måler dens volumen ved hjælp af LiDAR, ARCore Depth eller et dobbeltkamera, og appen identificerer maden og beregner portionen. Du bekræfter eller justerer resultatet med en skyder eller forudindstillinger — intet gemmes automatisk. Uden dybdesensor bruges tallerkenens diameter som reference, tydeligt markeret som et groft estimat.';

  @override
  String get guideLogTitle => 'Daglig log';

  @override
  String get guideLogBody =>
      'Fire måltider om dagen — Morgenmad, Frokost, Aftensmad, Snack. Tilføj mad via billede, søgning, stregkodescanning, manuelt, fra dine opskrifter eller hurtigt fra en afkrydsningsliste med din sædvanlige mad.';

  @override
  String get guideRecipesTitle => 'Mine opskrifter';

  @override
  String get guideRecipesBody =>
      'Gem en kombination af ingredienser, du ofte spiser, og registrer den med ét tryk. Du kan vælge et ikon til hver opskrift (eller acceptere det automatiske forslag) og redigere mængden af enhver ingrediens når som helst. Når du tilføjer flere fødevarer på én gang, kan du med det samme gemme dem som en ny opskrift.';

  @override
  String get guideWorkoutsTitle => 'Fysisk aktivitet';

  @override
  String get guideWorkoutsBody =>
      'Vælg aktivitetstype og varighed, så beregnes forbrændte kalorier automatisk — eller indtast dem direkte, hvis du allerede kender dem fra et smartwatch. Forbrændte kalorier trækkes fra dagens budget.';

  @override
  String get guideProgressTitle => 'Fremskridt';

  @override
  String get guideProgressBody =>
      'Grafer over 7 dage, 30 dage eller hele programmet: vægtudvikling (udjævnet), adaptivt TDEE beregnet ud fra din egen energibalance, makronæringsbalance og dækning af mikronæringsstoffer. Synkroniserer med Apple Health / Health Connect og en Bluetooth-vægt.';

  @override
  String get guideHydrationTitle => 'Væskeindtag';

  @override
  String get guideHydrationBody =>
      'En simpel daglig tæller for glas vand — ét tryk for at tilføje, ét tryk for at fortryde det seneste.';

  @override
  String get guideStreaksTitle => 'Motivation';

  @override
  String get guideStreaksBody =>
      'Et flammemærke viser, hvor mange dage i træk du har registreret mindst ét måltid.';

  @override
  String get guideRemindersTitle => 'Daglig påmindelse';

  @override
  String get guideRemindersBody =>
      'En notifikation, på det tidspunkt du vælger, der minder dig om at registrere dine måltider — kan slås fra når som helst fra menuen.';

  @override
  String get guideProfileTitle => 'Profil og mål';

  @override
  String get guideProfileBody =>
      'Alder, biologisk køn, højde, vægt, aktivitetsniveau og mål — kan redigeres når som helst. Appen genberegner automatisk dit kaloriemål ved enhver ændring.';

  @override
  String get guidePrivacyTitle => 'Privatliv';

  @override
  String get guidePrivacyBody =>
      'Dine data er udelukkende knyttet til din konto og er ikke synlige for andre brugere. Du kan slette din konto og alle tilknyttede data når som helst, fra menuen — sletning er permanent og øjeblikkelig.';

  @override
  String get guideLanguagesTitle => 'Tilgængelige sprog';

  @override
  String get guideLanguagesBody =>
      'Appen er tilgængelig på 13 sprog, valgt fra menuen — ikke kun registreret automatisk ud fra telefonens sprog.';

  @override
  String get guidePremiumTitle => 'Premium og abonnementer';

  @override
  String get guidePremiumDraftNote =>
      'Udkast, ikke færdiggjort — planen nedenfor er endnu ikke aktiv i appen. Der er i øjeblikket ingen betaling i appen eller funktionsbegrænsning.';

  @override
  String get guidePremiumFreeBody =>
      'Gratis, for altid: fuldstændig maddagbog, 20 fotoanalyser om dagen, ubegrænsede egne opskrifter, grundlæggende fremskridtsgrafer og synkronisering med Apple Health / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (vejledende pris, ubekræftet): ubegrænsede fotoanalyser, adaptivt TDEE og detaljerede mikronæringsstoffer, dataeksport og prioriteret support.';

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
  String get barcodeToggleTorch => 'Skift blitz';

  @override
  String get clearSelection => 'Ryd valg';
}

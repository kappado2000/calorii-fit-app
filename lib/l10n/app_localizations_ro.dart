// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Nu uita să-ți loghezi mesele';

  @override
  String get dailyReminderBody =>
      'Câteva secunde acum îți țin jurnalul la zi și streak-ul viu.';

  @override
  String get dailyReminderChannelName => 'Memento zilnic';

  @override
  String get dailyReminderChannelDescription =>
      'Memento să-ți loghezi mesele din ziua curentă';

  @override
  String get updateRequiredTitle => 'E nevoie de o actualizare';

  @override
  String get updateRequiredMessage =>
      'Versiunea aplicației de pe acest telefon nu mai este suportată. Instalează cea mai nouă versiune pentru a continua.';

  @override
  String get updateAvailableMessage =>
      'O versiune nouă a aplicației este disponibilă.';

  @override
  String get hydrationTitle => 'Hidratare';

  @override
  String get hydrationUndoLastGlass => 'Anulează ultimul pahar';

  @override
  String hydrationAddGlass(int ml) {
    return 'Adaugă un pahar ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'TDEE adaptiv';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Încă nu ai suficiente date: îți trebuie cel puțin 14 zile logate și 2 cântăriri la minim 10 zile distanță, în ultimele 3 săptămâni. Până atunci se folosește formula standard (Mifflin-St Jeor).';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Calculat din propriul tău echilibru caloric ($loggedDays/$windowDays zile logate în ultimele 3 săptămâni), nu doar din formula standard.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'TDEE estimat';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Trend greutate';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/săpt.';
  }

  @override
  String get adaptiveTdeeRejected =>
      'Estimarea diferă prea mult de formula standard ca să fie de încredere încă — se folosește în continuare formula standard, până se adună mai multe date consistente.';

  @override
  String get weeklySummaryTitle => 'Rezumatul săptămânii';

  @override
  String get weeklySummaryDaysLogged => 'Zile logate';

  @override
  String get weeklySummaryAvgCalories => 'Medie kcal/zi';

  @override
  String get weeklySummaryWorkouts => 'Antrenamente';

  @override
  String get weightEvolutionTitle => 'Evoluția greutății';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'De la $date ($startKg kg) până azi ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Capabilitate captură adâncime';

  @override
  String deviceCapabilityError(String error) {
    return 'Eroare la verificarea capabilităților:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR disponibil';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth disponibil';

  @override
  String get depthSourcePortraitLabel => 'Cameră duală (portrait depth)';

  @override
  String get depthSourceReferenceLabel => 'Fără senzor de adâncime';

  @override
  String get depthSourceUnknownLabel => 'Necunoscut';

  @override
  String get depthSourceLidarDescription =>
      'Estimare volumetrică de înaltă precizie (~10-15% eroare).';

  @override
  String get depthSourceArcoreDescription =>
      'Estimare volumetrică prin ARCore Depth API.';

  @override
  String get depthSourcePortraitDescription =>
      'Adâncime aproximativă din camera duală, precizie redusă.';

  @override
  String get depthSourceReferenceDescription =>
      'Se va folosi diametrul farfuriei ca referință de scară (estimare mai puțin precisă).';

  @override
  String get depthSourceUnknownDescription =>
      'Nu s-a putut determina capabilitatea device-ului.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'cameră duală';

  @override
  String get depthSourceReferenceShort => 'referință vizuală';

  @override
  String get depthSourceUnknownShort => 'necunoscut';

  @override
  String get howItWorksTitle => 'Cum calculăm caloriile';

  @override
  String get howItWorksTooltip => 'Cum calculăm caloriile?';

  @override
  String get howItWorksIntro =>
      'Majoritatea aplicațiilor de nutriție ghicesc porția dintr-o singură fotografie 2D. Calorii Fit măsoară efectiv volumul mâncării de pe farfurie, folosind harta de adâncime a telefonului tău — de asta estimarea e mai precisă.';

  @override
  String get howItWorksStep1Title => 'Fotografiezi farfuria';

  @override
  String get howItWorksStep1Description =>
      'O singură poză, fără poziționare specială.';

  @override
  String get howItWorksStep2Title => 'Telefonul captează adâncimea';

  @override
  String get howItWorksStep2GenericDescription =>
      'Telefonul tău folosește LiDAR, ARCore Depth sau camera duală, în funcție de model, ca să știe cât de înaltă e mâncarea, nu doar cum arată de sus.';

  @override
  String get howItWorksStep3Title => 'Claude identifică alimentele';

  @override
  String get howItWorksStep3Description =>
      'Modelul recunoaște ce e pe farfurie și marchează conturul aproximativ al fiecărui aliment — nu calculează el caloriile, doar identifică.';

  @override
  String get howItWorksStep4Title => 'Volumul devine grame, apoi calorii';

  @override
  String get howItWorksStep4Description =>
      'Harta de adâncime × conturul fiecărui aliment dă un volum în cm³. Un tabel de densități (specific fiecărui tip de aliment) transformă volumul în grame, iar baza de date nutrițională transformă gramele în calorii și macro-nutrienți.';

  @override
  String get howItWorksStep5Title => 'Tu confirmi sau corectezi';

  @override
  String get howItWorksStep5Description =>
      'Estimarea automată nu se salvează niciodată direct — vezi mereu un ecran de confirmare unde poți ajusta porția sau schimba alimentul identificat.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Vezi ce metodă folosește telefonul tău';

  @override
  String get howItWorksDepthLidar =>
      'Telefonul tău are LiDAR — cea mai precisă metodă disponibilă azi pe un telefon, cu o eroare tipică de doar 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Telefonul tău folosește ARCore Depth API pentru a estima adâncimea scenei.';

  @override
  String get howItWorksDepthPortrait =>
      'Telefonul tău estimează adâncimea din camera duală (mod portret) — mai puțin precis decât LiDAR, dar tot mai bun decât o poză simplă.';

  @override
  String get howItWorksDepthReference =>
      'Telefonul tău nu are senzor de adâncime, așa că folosim diametrul standard al unei farfurii ca referință de scară — cea mai puțin precisă metodă, dar tot mai bună decât o ghicire pur vizuală.';

  @override
  String get howItWorksDepthUnknown =>
      'Nu am putut determina metoda folosită de telefonul tău.';

  @override
  String get reminderPermissionDenied =>
      'Permite notificările pentru aplicație din setările telefonului.';

  @override
  String get reminderTimePickerHelp => 'Ora mementoului';

  @override
  String get reminderDialogTitle => 'Memento zilnic';

  @override
  String get reminderDailyNotification => 'Notificare zilnică';

  @override
  String get reminderDailyNotificationSubtitle =>
      'O rememorare să-ți loghezi mesele';

  @override
  String get reminderTimeLabel => 'Ora';

  @override
  String get close => 'Închide';

  @override
  String get deleteAccountWrongPassword => 'Parolă greșită.';

  @override
  String deleteAccountFailed(String code) {
    return 'Nu am putut șterge contul ($code). Încearcă din nou.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Nu am putut șterge contul. Încearcă din nou.';

  @override
  String get deleteAccountTitle => 'Ștergere cont';

  @override
  String get deleteAccountExplanation =>
      'Se șterg definitiv contul și toate datele tale (profil, jurnal de mese, antrenamente, greutăți, alimente memorate). Acțiunea nu poate fi anulată.';

  @override
  String get password => 'Parolă';

  @override
  String get cancel => 'Anulează';

  @override
  String get deleteAccountConfirm => 'Șterge definitiv';

  @override
  String get barcodeScanTitle => 'Scanează codul de bare';

  @override
  String barcodeNotFound(String barcode) {
    return 'Produsul cu codul $barcode nu a fost găsit.';
  }

  @override
  String get addManually => 'Adaugă manual';

  @override
  String get scanAgain => 'Scanează din nou';

  @override
  String get bluetoothScaleTitle => 'Cântar Bluetooth';

  @override
  String get bluetoothScaleSearch => 'Caută cântare';

  @override
  String get bluetoothScaleIdleHint =>
      'Apasă \"Caută cântare\" și pornește-ți cântarul lângă telefon.';

  @override
  String get bluetoothScaleSearching => 'Se caută...';

  @override
  String get bluetoothScaleNoneFound => 'Niciun cântar găsit încă.';

  @override
  String get bluetoothScaleConnecting => 'Se conectează...';

  @override
  String get bluetoothScaleWeightSaved => 'Greutate salvată.';

  @override
  String errorPrefixed(String message) {
    return 'Eroare: $message';
  }

  @override
  String get cameraNoneAvailable =>
      'Nicio cameră disponibilă pe acest dispozitiv.';

  @override
  String get cameraCaptureTitle => 'Fotografiază farfuria';

  @override
  String get cameraCapturingStatus => 'Se capturează fotografia și adâncimea…';

  @override
  String get cameraAnalyzingStatus => 'Se identifică alimentele…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Gata — se deschide confirmarea…';

  @override
  String get cameraStartingStatus => 'Se pornește camera…';

  @override
  String get cameraFrameHint => 'Încadrează farfuria și apasă declanșatorul';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Nu am putut porni/analiza fotografia:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Ai atins limita zilnică de analize foto. Activează premium pentru mai multe analize pe zi.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Trebuie să fii autentificat pentru a analiza o fotografie.';

  @override
  String get cameraNetworkErrorMessage =>
      'Nu s-a putut realiza conexiunea. Verifică internetul și încearcă din nou.';

  @override
  String get retry => 'Încearcă din nou';

  @override
  String get authEnterEmailFirst =>
      'Introdu emailul mai întâi, ca să-ți trimitem linkul de resetare.';

  @override
  String get authPasswordResetSent =>
      'Ți-am trimis un email de resetare a parolei.';

  @override
  String get authErrorInvalidEmail => 'Adresă de email invalidă.';

  @override
  String get authErrorUserNotFound => 'Nu există niciun cont cu acest email.';

  @override
  String get authErrorWrongCredentials => 'Email sau parolă greșită.';

  @override
  String get authErrorEmailInUse => 'Există deja un cont cu acest email.';

  @override
  String get authErrorWeakPassword =>
      'Parola e prea slabă (minim 6 caractere).';

  @override
  String get authErrorGeneric => 'A apărut o eroare. Încearcă din nou.';

  @override
  String get authWelcomeBack => 'Bine ai revenit';

  @override
  String get authLetsStart => 'Hai să începem';

  @override
  String get email => 'Email';

  @override
  String get authEnterValidEmail => 'Introdu un email valid';

  @override
  String get authPasswordMinLength => 'Minim 6 caractere';

  @override
  String get authSignIn => 'Autentificare';

  @override
  String get authCreateAccount => 'Creează cont';

  @override
  String get authNoAccountYet => 'Nu ai cont? Creează unul';

  @override
  String get authHaveAccountAlready => 'Ai deja cont? Autentifică-te';

  @override
  String get authForgotPassword => 'Ai uitat parola?';

  @override
  String get activityWalkingCasual => 'Mers pe jos (lejer)';

  @override
  String get activityWalkingBrisk => 'Mers pe jos (alert)';

  @override
  String get activityRunning => 'Alergare';

  @override
  String get activityRunningFast => 'Alergare rapidă';

  @override
  String get activityCycling => 'Ciclism (moderat)';

  @override
  String get activityCyclingIntense => 'Ciclism (intens)';

  @override
  String get activitySwimming => 'Înot';

  @override
  String get activityStrengthTraining => 'Antrenament de forță';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Dans';

  @override
  String get activityHiking => 'Drumeție';

  @override
  String get activityJumpRope => 'Sărit coarda';

  @override
  String get activityFootball => 'Fotbal';

  @override
  String get activityBasketball => 'Baschet';

  @override
  String get activityTennis => 'Tenis';

  @override
  String get activityOther => 'Altă activitate';

  @override
  String get mealBreakfast => 'Dimineață';

  @override
  String get mealLunch => 'Prânz';

  @override
  String get mealDinner => 'Seară';

  @override
  String get mealSnack => 'Gustare';

  @override
  String get addWorkoutTitle => 'Adaugă activitate sportivă';

  @override
  String get addWorkoutFromActivity => 'Din activitate';

  @override
  String get addWorkoutDirectCalories => 'Calorii directe';

  @override
  String get addWorkoutActivityTypeOptional => 'Tip activitate (opțional)';

  @override
  String get addWorkoutCaloriesBurned => 'Calorii arse';

  @override
  String get addWorkoutCaloriesHint => 'ex. 250';

  @override
  String get save => 'Salvează';

  @override
  String get addWorkoutActivityType => 'Tip activitate';

  @override
  String get addWorkoutDuration => 'Durată';

  @override
  String get minutes => 'minute';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Estimare: $kcal kcal arse';
  }

  @override
  String get confirmFoodsTitle => 'Confirmă alimentele';

  @override
  String get mealLabel => 'Masă:';

  @override
  String get mixedPlateWarning =>
      'Farfurie cu alimente amestecate — verifică fiecare element, identificarea poate fi mai puțin precisă.';

  @override
  String get noItemsLeft =>
      'Ai eliminat toate elementele identificate. Fotografiază din nou dacă vrei să reîncerci.';

  @override
  String get portionSmall => 'Mic';

  @override
  String get portionMedium => 'Mediu';

  @override
  String get portionLarge => 'Mare';

  @override
  String get notOnPlateRemove => 'Nu e pe farfurie — elimină';

  @override
  String roughEstimateNote(String source) {
    return 'Estimare aproximativă ($source, fără senzor de adâncime)';
  }

  @override
  String get realNutritionDataBadge => 'date reale';

  @override
  String totalCalories(int kcal) {
    return 'Total: $kcal kcal';
  }

  @override
  String get activityLevelSedentary => 'Sedentar (muncă de birou, fără sport)';

  @override
  String get activityLevelLight => 'Activitate ușoară (sport 1-3 zile/săpt.)';

  @override
  String get activityLevelModerate =>
      'Activitate moderată (sport 3-5 zile/săpt.)';

  @override
  String get activityLevelActive => 'Activ (sport 6-7 zile/săpt.)';

  @override
  String get activityLevelVeryActive =>
      'Foarte activ (sport intens zilnic / muncă fizică)';

  @override
  String get goalLose => 'Slăbit';

  @override
  String get goalMaintain => 'Menținere';

  @override
  String get goalGain => 'Masă musculară';

  @override
  String get progressPeriod7Days => '7 zile';

  @override
  String get progressPeriod30Days => '30 zile';

  @override
  String get progressPeriodWholeProgram => 'Tot programul';

  @override
  String get nutrientVitaminC => 'Vitamina C';

  @override
  String get nutrientVitaminD => 'Vitamina D';

  @override
  String get nutrientCalcium => 'Calciu';

  @override
  String get nutrientIron => 'Fier';

  @override
  String get nutrientMagnesium => 'Magneziu';

  @override
  String get nutrientPotassium => 'Potasiu';

  @override
  String get macroProtein => 'Proteine';

  @override
  String get macroCarbs => 'Carbohidrați';

  @override
  String get macroFat => 'Grăsimi';

  @override
  String onboardingAgeTooLow(int age) {
    return 'Aplicația e destinată persoanelor de la $age ani în sus.';
  }

  @override
  String get onboardingAgeInvalid => 'Valoare invalidă.';

  @override
  String get onboardingAgeSexTitle => 'Câțiva ani și sexul biologic';

  @override
  String get age => 'Vârstă';

  @override
  String get years => 'ani';

  @override
  String get sexFemale => 'Femeie';

  @override
  String get sexMale => 'Bărbat';

  @override
  String get onboardingSexHint =>
      'Folosit doar pentru calculul metabolismului bazal (formula Mifflin-St Jeor).';

  @override
  String get onboardingHeightWeightTitle => 'Înălțime și greutate actuală';

  @override
  String get height => 'Înălțime';

  @override
  String get weight => 'Greutate';

  @override
  String get onboardingActivityTitle => 'Nivel de activitate fizică';

  @override
  String get onboardingGoalTitle => 'Care e obiectivul tău?';

  @override
  String get onboardingLossRate => 'Ritm de slăbit dorit';

  @override
  String get onboardingGainRate => 'Ritm de creștere dorit';

  @override
  String get kgPerWeek => 'kg/săptămână';

  @override
  String get onboardingRateRecommendation =>
      'Recomandat: 0.25-0.75 kg/săptămână pentru un ritm sustenabil.';

  @override
  String get programStartDateLabel => 'Data de start a dietei';

  @override
  String get programStartDateHint =>
      'Diferă de data creării contului — e momentul de la care vrei să măsurăm progresul.';

  @override
  String get disclaimerTitle => 'Înainte să începi';

  @override
  String get disclaimerIntro =>
      'Calorii Fit estimează necesarul caloric și ritmul de slăbit pe baza unor formule general acceptate (Mifflin-St Jeor), nu pe baza unei evaluări medicale individuale.';

  @override
  String get disclaimerMedical =>
      'Nu înlocuiește sfatul unui medic sau nutriționist — mai ales dacă ai o afecțiune medicală, ești însărcinată sau alăptezi.';

  @override
  String get disclaimerAllergens =>
      'Identificarea alimentelor din fotografie nu detectează alergeni. Dacă ai o alergie sau intoleranță severă, verifică mereu ingredientele chiar tu, nu te baza pe aplicație pentru asta.';

  @override
  String get disclaimerEatingDisorders =>
      'Dacă ai avut sau ai o relație dificilă cu alimentația (tulburări de alimentație), discută cu un medic înainte de a urmări calorii — aplicația nu e gândită să înlocuiască acel sprijin.';

  @override
  String get disclaimerAcceptLabel =>
      'Am înțeles și sunt de acord să folosesc aplicația în cunoștință de cauză.';

  @override
  String get finish => 'Finalizează';

  @override
  String get continueLabel => 'Continuă';

  @override
  String get progress => 'Progres';

  @override
  String get activityAndSync => 'Activitate & sincronizare';

  @override
  String get editProfileGoal => 'Editează profil/obiectiv';

  @override
  String get checkDeviceCapability => 'Verifică capabilitate device';

  @override
  String get myRecipes => 'Rețetele mele';

  @override
  String get signOut => 'Deconectare';

  @override
  String get takePhoto => 'Fotografiază';

  @override
  String get previousDay => 'Ziua anterioară';

  @override
  String get nextDay => 'Ziua următoare';

  @override
  String get pickDayHelp => 'Alege ziua';

  @override
  String dateToday(String date) {
    return 'Azi, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Ieri, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Mâine, $date';
  }

  @override
  String get setUpYourGoal => 'Configurează-ți obiectivul';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal azi';
  }

  @override
  String get setUp => 'Setează';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Ținta: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Deficit caloric';

  @override
  String get totalBurnedLabel => 'Total arse';

  @override
  String get totalConsumedLabel => 'Total consumate';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Ai depășit limita cu $overBy kcal (peste $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Nu depăși $kcal kcal, ca să atingi ritmul de slăbit propus.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Ai nevoie de cel puțin $kcal kcal pentru ritmul de creștere propus.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Rămâi în jurul a $kcal kcal pentru menținere.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Valoare recomandată: $low–$high kcal';
  }

  @override
  String get addFood => 'Adaugă aliment';

  @override
  String get sportActivity => 'Activitate sportivă';

  @override
  String get manualCaloriesEntered => 'Calorii introduse manual';

  @override
  String get addActivity => 'Adaugă activitate';

  @override
  String get caloricIntake => 'Aport caloric';

  @override
  String get dailyCaloricDeficit => 'Deficit caloric zilnic';

  @override
  String get setUpProfileFirst =>
      'Setează-ți mai întâi profilul și obiectivul din meniu.';

  @override
  String get totalCaloriesLabel => 'Total calorii';

  @override
  String get avgPerDay => 'Medie/zi';

  @override
  String get estimatedLoss => 'Scădere estimată';

  @override
  String get macroBalanceTitle => 'Echilibru macronutrienți';

  @override
  String get macroBalanceNoData =>
      'Niciun aliment cu proteine/carbohidrați/grăsimi cunoscute în această perioadă.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (recomandat $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Micronutrienți (medie/zi)';

  @override
  String get micronutrientsNoData =>
      'Niciun aliment cu date despre vitamine/minerale în această perioadă — vezi nota de mai jos.';

  @override
  String get micronutrientsNoEntries =>
      'Fără alimente înregistrate în această perioadă.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Date de vitamine/minerale disponibile pentru $pct% din alimentele înregistrate ($withData/$total) — restul (mâncare de casă, produse fără etichetă) nu au date cunoscute și nu sunt incluse în medie.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% din doza zilnică';
  }

  @override
  String get chartTargetLabel => 'Țintă';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Health';

  @override
  String get healthConnectDescription =>
      'Preia greutatea și activitatea fizică înregistrată de ceasul tău, prin platforma de sănătate a telefonului.';

  @override
  String get bluetoothScaleSubtitle => 'Conectează direct un cântar inteligent';

  @override
  String get weightHistoryTitle => 'Istoric greutate';

  @override
  String get addLabel => 'Adaugă';

  @override
  String get noEntriesYet => 'Nicio înregistrare încă.';

  @override
  String get syncButton => 'Sincronizează';

  @override
  String get syncAgain => 'Sincronizează din nou';

  @override
  String get stepsToday => 'pași azi';

  @override
  String get activeKcal => 'kcal active';

  @override
  String newWeightFetched(String kg) {
    return 'Greutate nouă preluată: $kg kg';
  }

  @override
  String newWorkoutsImported(int count) {
    return '$count antrenamente noi, importate din ceas.';
  }

  @override
  String get weightSourceManual => 'manual';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Health';

  @override
  String get weightSourceBluetoothScale => 'cântar BT';

  @override
  String get addWeightTitle => 'Adaugă greutate';

  @override
  String get editWeightTitle => 'Editează greutatea';

  @override
  String get weighInDateHelp => 'Data cântăririi';

  @override
  String get weighInTimeHelp => 'Ora cântăririi';

  @override
  String get edit => 'Editează';

  @override
  String get delete => 'Șterge';

  @override
  String get chooseARecipe => 'Alege o rețetă';

  @override
  String get newRecipe => 'Rețetă nouă';

  @override
  String get editRecipe => 'Editează rețeta';

  @override
  String get noRecipesYet =>
      'Nu ai nicio rețetă salvată încă. Adaugă una din butonul de mai jos.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings porții · $kcal kcal/porție';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name a fost adăugată azi.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Adaugă „$name\" la:';
  }

  @override
  String get recipeNameLabel => 'Denumire rețetă';

  @override
  String get recipeNameHint => 'ex. Salata mea de pui';

  @override
  String get numberOfServings => 'Număr de porții';

  @override
  String get ingredients => 'Ingrediente';

  @override
  String get addAtLeastOneIngredient => 'Adaugă cel puțin un ingredient.';

  @override
  String get saveRecipe => 'Salvează rețeta';

  @override
  String perServing(int grams, int kcal) {
    return 'Per porție ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Proteine $protein · Carbohidrați $carbs · Grăsimi $fat';
  }

  @override
  String get addIngredientTitle => 'Adaugă ingredient';

  @override
  String get productNameLabel => 'Denumire produs';

  @override
  String get noProductFound => 'Niciun produs găsit.';

  @override
  String get searchWithAiButton => 'Caută cu AI';

  @override
  String get aiSearchNoResult =>
      'AI nu a găsit un produs sigur pentru această căutare.';

  @override
  String get aiEstimateBadge => 'estimare AI';

  @override
  String get quantityLabel => 'Cantitate';

  @override
  String get addIngredientButton => 'Adaugă ingredientul';

  @override
  String get editIngredientQuantityTitle => 'Editează cantitatea';

  @override
  String get chooseRecipeIconTitle => 'Alege o iconiță';

  @override
  String get recipeIconSuggested => 'Sugestie';

  @override
  String get saveAsRecipeTooltip => 'Salvează ca rețetă';

  @override
  String get saveAsRecipeDialogTitle => 'Salvează ca rețetă nouă';

  @override
  String recipeSavedConfirmation(String name) {
    return '„$name” a fost salvată în rețetele tale.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Adaugă aliment — $meal';
  }

  @override
  String get productNameHint => 'ex. Iaurt grecesc';

  @override
  String get enterProductName => 'Introdu denumirea produsului';

  @override
  String get frequentlyLogged => 'Înregistrate frecvent';

  @override
  String addCount(int count) {
    return 'Adaugă ($count)';
  }

  @override
  String get calorieIndexLabel => 'Indice caloric (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Cantitate consumată';

  @override
  String get editGramsDialogTitle => 'Modifică gramajul';

  @override
  String get requiredField => 'Câmp obligatoriu';

  @override
  String get invalidValue => 'Valoare invalidă';

  @override
  String get searchFailedCheckConnection =>
      'Căutarea nu a putut fi realizată (verifică conexiunea).';

  @override
  String get addProductManually => 'Adaugă produs manual';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'C';

  @override
  String get macroFatShort => 'G';

  @override
  String get macrosUnavailable => 'Macro-nutrienți indisponibili';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Proteine $protein · Carbohidrați $carbs · Grăsimi $fat';
  }

  @override
  String get languageDialogTitle => 'Limbă';

  @override
  String get languageSystemDefault => 'Limba telefonului (implicit)';

  @override
  String get languageMenuEntry => 'Limbă';

  @override
  String get guideMenuEntry => 'Ghid de utilizare';

  @override
  String get guideScreenTitle => 'Ghid de utilizare';

  @override
  String get guideIntroTitle => 'Ce este Calorii Fit';

  @override
  String get guideIntroBody =>
      'O aplicație de nutriție care estimează caloriile direct dintr-o fotografie a farfuriei, folosind senzorul de adâncime al telefonului, nu doar o poză obișnuită. Pe lângă asta, ține jurnalul complet: mese, sport, hidratare, greutate și progresul spre obiectivul tău.';

  @override
  String get guidePhotoTitle => 'Estimarea din fotografie';

  @override
  String get guidePhotoBody =>
      'Fotografiezi farfuria, telefonul îi măsoară volumul folosind LiDAR, ARCore Depth sau camera duală, iar aplicația identifică alimentele și calculează porția. Tu confirmi sau ajustezi rezultatul cu un slider sau presetări — nimic nu se salvează automat. Fără senzor de adâncime, se folosește diametrul farfuriei ca reper, marcat clar drept estimare aproximativă.';

  @override
  String get guideLogTitle => 'Jurnalul zilnic';

  @override
  String get guideLogBody =>
      'Patru mese pe zi — Dimineață, Prânz, Seară, Gustare. Adaugi alimente din fotografie, din căutare, prin scanarea codului de bare, manual, din rețetele tale sau rapid dintr-o listă de bifat cu alimentele obișnuite.';

  @override
  String get guideRecipesTitle => 'Rețetele mele';

  @override
  String get guideRecipesBody =>
      'Salvezi o combinație de ingrediente pe care o mănânci des și o loghezi dintr-o singură atingere. Poți alege o iconiță pentru fiecare rețetă (sau accepți sugestia automată) și poți edita oricând cantitatea fiecărui ingredient. Când adaugi mai multe alimente deodată, le poți salva pe loc ca rețetă nouă.';

  @override
  String get guideWorkoutsTitle => 'Activitate fizică';

  @override
  String get guideWorkoutsBody =>
      'Alegi tipul de sport și durata, iar caloriile arse se calculează automat — sau le introduci direct, dacă le știi deja de la un ceas smart. Caloriile arse se scad din bugetul zilei.';

  @override
  String get guideProgressTitle => 'Progres';

  @override
  String get guideProgressBody =>
      'Grafice pe 7 zile, 30 de zile sau tot programul: evoluția greutății (netezită), TDEE adaptiv calculat din propriul tău echilibru energetic, balanța macro-urilor și acoperirea micronutrienților. Se sincronizează cu Apple Health / Health Connect și cu un cântar Bluetooth.';

  @override
  String get guideHydrationTitle => 'Hidratare';

  @override
  String get guideHydrationBody =>
      'Un contor simplu de pahare de apă pe zi — o atingere ca să adaugi, o atingere ca să anulezi ultimul.';

  @override
  String get guideStreaksTitle => 'Motivație';

  @override
  String get guideStreaksBody =>
      'O insignă cu flacără arată câte zile la rând ai logat cel puțin o masă.';

  @override
  String get guideRemindersTitle => 'Memento zilnic';

  @override
  String get guideRemindersBody =>
      'O notificare, la ora aleasă de tine, care îți amintește să-ți loghezi mesele — dezactivabilă oricând din meniu.';

  @override
  String get guideProfileTitle => 'Profil și obiectiv';

  @override
  String get guideProfileBody =>
      'Vârstă, sex biologic, înălțime, greutate, nivel de activitate și obiectiv — editabile oricând. Aplicația recalculează automat ținta calorică la orice schimbare.';

  @override
  String get guidePrivacyTitle => 'Confidențialitate';

  @override
  String get guidePrivacyBody =>
      'Datele tale sunt legate exclusiv de contul tău și nu sunt vizibile altor utilizatori. Poți șterge contul și toate datele asociate oricând, din meniu — ștergerea e permanentă și imediată.';

  @override
  String get guideLanguagesTitle => 'Limbi disponibile';

  @override
  String get guideLanguagesBody =>
      'Aplicația e disponibilă în 13 limbi, alese din meniu — nu doar detectate automat din limba telefonului.';

  @override
  String get guidePremiumTitle => 'Premium și abonamente';

  @override
  String get guidePremiumDraftNote =>
      'Ciornă, nefinalizată — planul de mai jos nu e încă activ în aplicație. Nu există plată în-app sau blocare de funcții momentan.';

  @override
  String get guidePremiumFreeBody =>
      'Gratuit, permanent: jurnal alimentar complet, 20 de analize foto pe zi, rețete proprii nelimitate, grafice de progres de bază și sincronizare cu Apple Health / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (preț orientativ, neconfirmat): analize foto nelimitate, TDEE adaptiv și micronutrienți detaliați, plus suport prioritar.';

  @override
  String get themeDialogTitle => 'Temă';

  @override
  String get themeSystemDefault => 'Tema telefonului (implicit)';

  @override
  String get themeLight => 'Luminoasă';

  @override
  String get themeDark => 'Întunecată';

  @override
  String get themeMenuEntry => 'Temă';

  @override
  String get barcodeToggleTorch => 'Comută blițul';

  @override
  String get clearSelection => 'Șterge selecția';

  @override
  String get accessCodeMenuEntry => 'Cod de acces';

  @override
  String get adminDashboardMenuEntry => 'Panou admin';

  @override
  String get accessCodeScreenTitle => 'Cod de acces';

  @override
  String get premiumCodeFieldLabel => 'Cod premium';

  @override
  String get activatePremiumButton => 'Activează premium';

  @override
  String premiumActivatedMessage(String date) {
    return 'Acces premium activat până la $date.';
  }

  @override
  String get iAmAdminLink => 'Sunt admin';

  @override
  String get adminPasswordFieldLabel => 'Parolă admin';

  @override
  String get activateAdminButton => 'Activează admin';

  @override
  String get adminActivatedMessage => 'Cont admin activat.';

  @override
  String get adminDashboardTitle => 'Panou admin';

  @override
  String get totalUsersLabel => 'Utilizatori totali';

  @override
  String get activePremiumLabel => 'Premium activ';

  @override
  String get generateCodeSectionTitle => 'Generează cod premium';

  @override
  String get targetEmailLabel => 'Email cont';

  @override
  String get durationDaysLabel => 'Durată (zile)';

  @override
  String get generateCodeButton => 'Generează cod';

  @override
  String get codeGeneratedTitle => 'Cod generat';

  @override
  String get generatedCodesSectionTitle => 'Coduri generate';

  @override
  String get noCodesGeneratedYet => 'Niciun cod generat încă.';

  @override
  String get codeStatusPending => 'neutilizat';

  @override
  String get codeStatusRedeemed => 'folosit';

  @override
  String get codeStatusRevoked => 'revocat';

  @override
  String durationDaysValue(int days) {
    return '$days zile';
  }

  @override
  String get completeNutritionWithAiTooltip => 'Completează cu AI';

  @override
  String get nutritionCompletedMessage => 'Date nutriționale completate.';

  @override
  String get aiCompletionNoResult =>
      'AI nu a găsit date sigure pentru acest aliment.';

  @override
  String bulkNutritionCompletionButton(int count) {
    return 'Completează cu AI ($count)';
  }

  @override
  String bulkNutritionCompletionProgress(int done, int total) {
    return '$done/$total...';
  }

  @override
  String bulkNutritionCompletionPremiumLocked(int count) {
    return 'Funcție premium ($count alimente)';
  }

  @override
  String bulkNutritionCompletionResult(int completed, int total) {
    return 'Completat $completed din $total alimente.';
  }
}

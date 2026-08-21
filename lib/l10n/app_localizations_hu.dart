// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Ne felejtsd el rögzíteni az étkezéseidet';

  @override
  String get dailyReminderBody =>
      'Néhány másodperc elég ahhoz, hogy a naplód naprakész legyen, és a sorozatod folytatódjon.';

  @override
  String get dailyReminderChannelName => 'Napi emlékeztető';

  @override
  String get dailyReminderChannelDescription =>
      'Emlékeztető a mai étkezések rögzítésére';

  @override
  String get updateRequiredTitle => 'Frissítés szükséges';

  @override
  String get updateRequiredMessage =>
      'Az alkalmazás verziója ezen a telefonon már nem támogatott. A folytatáshoz telepítsd a legújabb verziót.';

  @override
  String get updateAvailableMessage => 'Az alkalmazás új verziója érhető el.';

  @override
  String get hydrationTitle => 'Folyadékbevitel';

  @override
  String get hydrationUndoLastGlass => 'Utolsó pohár visszavonása';

  @override
  String hydrationAddGlass(int ml) {
    return 'Pohár hozzáadása ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'Adaptív TDEE';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Még nincs elég adat: legalább 14 rögzített napra és 2, legalább 10 nap különbséggel elvégzett mérésre van szükség az elmúlt 3 hétben. Addig a standard képlet (Mifflin-St Jeor) van használatban.';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'A saját kalóriaegyensúlyod alapján számítva ($loggedDays/$windowDays nap rögzítve az elmúlt 3 hétben), nem csak a standard képlet alapján.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'Becsült TDEE';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Testsúly-trend';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/hét';
  }

  @override
  String get adaptiveTdeeRejected =>
      'A becslés még mindig túlságosan eltér a standard képlettől ahhoz, hogy megbízható legyen — a standard képlet marad használatban, amíg több konzisztens adat nem gyűlik össze.';

  @override
  String get weeklySummaryTitle => 'A hét összefoglalója';

  @override
  String get weeklySummaryDaysLogged => 'Rögzített napok';

  @override
  String get weeklySummaryAvgCalories => 'Átl. kcal/nap';

  @override
  String get weeklySummaryWorkouts => 'Edzések';

  @override
  String get weightEvolutionTitle => 'Testsúly alakulása';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return '$date ($startKg kg) óta mostanáig ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Mélységérzékelési képesség';

  @override
  String deviceCapabilityError(String error) {
    return 'Hiba a képességek ellenőrzésekor:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR elérhető';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth elérhető';

  @override
  String get depthSourcePortraitLabel => 'Dupla kamera (portré mélység)';

  @override
  String get depthSourceReferenceLabel => 'Nincs mélységérzékelő';

  @override
  String get depthSourceUnknownLabel => 'Ismeretlen';

  @override
  String get depthSourceLidarDescription =>
      'Nagy pontosságú térfogatbecslés (~10-15% hiba).';

  @override
  String get depthSourceArcoreDescription =>
      'Térfogatbecslés az ARCore Depth API-n keresztül.';

  @override
  String get depthSourcePortraitDescription =>
      'Hozzávetőleges mélység a dupla kamerából, alacsonyabb pontosság.';

  @override
  String get depthSourceReferenceDescription =>
      'A tányér átmérője lesz használva léptékreferenciaként (kevésbé pontos becslés).';

  @override
  String get depthSourceUnknownDescription =>
      'Nem sikerült megállapítani az eszköz képességét.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'dupla kamera';

  @override
  String get depthSourceReferenceShort => 'vizuális referencia';

  @override
  String get depthSourceUnknownShort => 'ismeretlen';

  @override
  String get howItWorksTitle => 'Hogyan számoljuk a kalóriákat';

  @override
  String get howItWorksTooltip => 'Hogyan számoljuk a kalóriákat?';

  @override
  String get howItWorksIntro =>
      'A legtöbb táplálkozási alkalmazás egyetlen 2D fotóból becsüli meg az adagot. A Calorii Fit valójában megméri az étel térfogatát a tányéron, a telefonod mélységtérképe segítségével — ezért pontosabb a becslés.';

  @override
  String get howItWorksStep1Title => 'Fényképezd le a tányérodat';

  @override
  String get howItWorksStep1Description =>
      'Egyetlen fotó, különleges pozicionálás nélkül.';

  @override
  String get howItWorksStep2Title => 'A telefonod rögzíti a mélységet';

  @override
  String get howItWorksStep2GenericDescription =>
      'A telefonod modelltől függően LiDAR-t, ARCore Depth-et vagy dupla kamerát használ, hogy tudja, milyen magas az étel, nem csak azt, hogy felülről nézve hogyan néz ki.';

  @override
  String get howItWorksStep3Title => 'A Claude azonosítja az ételeket';

  @override
  String get howItWorksStep3Description =>
      'A modell felismeri, mi van a tányéron, és megjelöli az egyes ételek hozzávetőleges körvonalát — magát a kalóriaértéket nem számítja ki, csak azonosít.';

  @override
  String get howItWorksStep4Title => 'A térfogatból gramm, majd kalória lesz';

  @override
  String get howItWorksStep4Description =>
      'A mélységtérkép × az egyes ételek körvonala térfogatot ad cm³-ben. Egy sűrűségtáblázat (ételtípusonként specifikus) átalakítja a térfogatot grammá, a tápanyagadatbázis pedig a grammot kalóriává és makrotápanyagokká.';

  @override
  String get howItWorksStep5Title => 'Te erősíted meg vagy javítod';

  @override
  String get howItWorksStep5Description =>
      'Az automatikus becslés soha nem kerül közvetlenül mentésre — mindig látsz egy megerősítő képernyőt, ahol módosíthatod az adagot vagy megváltoztathatod az azonosított ételt.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Nézd meg, melyik módszert használja a telefonod';

  @override
  String get howItWorksDepthLidar =>
      'A telefonodban van LiDAR — a jelenleg elérhető legpontosabb módszer egy telefonon, mindössze 10-15%-os tipikus hibával.';

  @override
  String get howItWorksDepthArcore =>
      'A telefonod az ARCore Depth API-t használja a jelenet mélységének becslésére.';

  @override
  String get howItWorksDepthPortrait =>
      'A telefonod a dupla kamerán (portré módon) keresztül becsüli meg a mélységet — kevésbé pontos, mint a LiDAR, de még mindig jobb, mint egy egyszerű fotó.';

  @override
  String get howItWorksDepthReference =>
      'A telefonodnak nincs mélységérzékelője, ezért egy tányér szabványos átmérőjét használjuk léptékreferenciaként — ez a legkevésbé pontos módszer, de még mindig jobb, mint egy tisztán vizuális becslés.';

  @override
  String get howItWorksDepthUnknown =>
      'Nem sikerült megállapítanunk, melyik módszert használja a telefonod.';

  @override
  String get reminderPermissionDenied =>
      'Engedélyezd az értesítéseket az alkalmazás számára a telefon beállításaiban.';

  @override
  String get reminderTimePickerHelp => 'Emlékeztető időpontja';

  @override
  String get reminderDialogTitle => 'Napi emlékeztető';

  @override
  String get reminderDailyNotification => 'Napi értesítés';

  @override
  String get reminderDailyNotificationSubtitle =>
      'Emlékeztető az étkezéseid rögzítésére';

  @override
  String get reminderTimeLabel => 'Időpont';

  @override
  String get close => 'Bezárás';

  @override
  String get deleteAccountWrongPassword => 'Helytelen jelszó.';

  @override
  String deleteAccountFailed(String code) {
    return 'Nem sikerült törölni a fiókot ($code). Próbáld újra.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Nem sikerült törölni a fiókot. Próbáld újra.';

  @override
  String get deleteAccountTitle => 'Fiók törlése';

  @override
  String get deleteAccountExplanation =>
      'Ez véglegesen törli a fiókodat és minden adatodat (profil, étkezési napló, edzések, testsúlyok, megjegyzett ételek). Ez a művelet nem vonható vissza.';

  @override
  String get password => 'Jelszó';

  @override
  String get cancel => 'Mégse';

  @override
  String get deleteAccountConfirm => 'Végleges törlés';

  @override
  String get barcodeScanTitle => 'Vonalkód beolvasása';

  @override
  String barcodeNotFound(String barcode) {
    return 'A(z) $barcode kódú termék nem található.';
  }

  @override
  String get addManually => 'Manuális hozzáadás';

  @override
  String get scanAgain => 'Új beolvasás';

  @override
  String get bluetoothScaleTitle => 'Bluetooth mérleg';

  @override
  String get bluetoothScaleSearch => 'Mérlegek keresése';

  @override
  String get bluetoothScaleIdleHint =>
      'Koppints a \"Mérlegek keresése\" gombra, és kapcsold be a mérleget a telefon közelében.';

  @override
  String get bluetoothScaleSearching => 'Keresés...';

  @override
  String get bluetoothScaleNoneFound => 'Még nem található mérleg.';

  @override
  String get bluetoothScaleConnecting => 'Csatlakozás...';

  @override
  String get bluetoothScaleWeightSaved => 'Testsúly mentve.';

  @override
  String errorPrefixed(String message) {
    return 'Hiba: $message';
  }

  @override
  String get cameraNoneAvailable => 'Nincs elérhető kamera ezen az eszközön.';

  @override
  String get cameraCaptureTitle => 'Fényképezd le a tányérodat';

  @override
  String get cameraCapturingStatus => 'Fotó és mélység rögzítése…';

  @override
  String get cameraAnalyzingStatus => 'Ételek azonosítása…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Kész — megerősítés megnyitása…';

  @override
  String get cameraStartingStatus => 'Kamera indítása…';

  @override
  String get cameraFrameHint =>
      'Keretezd be a tányért, és koppints a zárkioldóra';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Nem sikerült elindítani/elemezni a fotót:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Elérted a napi fotóelemzési limitet. Aktiváld a prémiumot a több napi elemzésért.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Be kell jelentkezned egy fotó elemzéséhez.';

  @override
  String get cameraNetworkErrorMessage =>
      'Nem sikerült csatlakozni. Ellenőrizd az internetkapcsolatot, és próbáld újra.';

  @override
  String get retry => 'Újra';

  @override
  String get authEnterEmailFirst =>
      'Először add meg az e-mail címedet, hogy elküldhessük a visszaállítási linket.';

  @override
  String get authPasswordResetSent =>
      'Elküldtük a jelszó-visszaállító e-mailt.';

  @override
  String get authErrorInvalidEmail => 'Érvénytelen e-mail cím.';

  @override
  String get authErrorUserNotFound =>
      'Nem létezik fiók ezzel az e-mail címmel.';

  @override
  String get authErrorWrongCredentials => 'Helytelen e-mail cím vagy jelszó.';

  @override
  String get authErrorEmailInUse => 'Már létezik fiók ezzel az e-mail címmel.';

  @override
  String get authErrorWeakPassword =>
      'A jelszó túl gyenge (minimum 6 karakter).';

  @override
  String get authErrorGeneric => 'Valami hiba történt. Próbáld újra.';

  @override
  String get authWelcomeBack => 'Üdvözlünk újra';

  @override
  String get authLetsStart => 'Kezdjük';

  @override
  String get email => 'E-mail';

  @override
  String get authEnterValidEmail => 'Adj meg egy érvényes e-mail címet';

  @override
  String get authPasswordMinLength => 'Minimum 6 karakter';

  @override
  String get authSignIn => 'Bejelentkezés';

  @override
  String get authCreateAccount => 'Fiók létrehozása';

  @override
  String get authNoAccountYet => 'Még nincs fiókod? Hozz létre egyet';

  @override
  String get authHaveAccountAlready => 'Már van fiókod? Jelentkezz be';

  @override
  String get authForgotPassword => 'Elfelejtetted a jelszavad?';

  @override
  String get activityWalkingCasual => 'Séta (nyugodt)';

  @override
  String get activityWalkingBrisk => 'Séta (gyors)';

  @override
  String get activityRunning => 'Futás';

  @override
  String get activityRunningFast => 'Futás (gyors)';

  @override
  String get activityCycling => 'Kerékpározás (mérsékelt)';

  @override
  String get activityCyclingIntense => 'Kerékpározás (intenzív)';

  @override
  String get activitySwimming => 'Úszás';

  @override
  String get activityStrengthTraining => 'Erősítő edzés';

  @override
  String get activityYoga => 'Jóga';

  @override
  String get activityDancing => 'Tánc';

  @override
  String get activityHiking => 'Túrázás';

  @override
  String get activityJumpRope => 'Ugrókötelezés';

  @override
  String get activityFootball => 'Futball';

  @override
  String get activityBasketball => 'Kosárlabda';

  @override
  String get activityTennis => 'Tenisz';

  @override
  String get activityOther => 'Egyéb tevékenység';

  @override
  String get mealBreakfast => 'Reggeli';

  @override
  String get mealLunch => 'Ebéd';

  @override
  String get mealDinner => 'Vacsora';

  @override
  String get mealSnack => 'Nassolás';

  @override
  String get addWorkoutTitle => 'Edzés hozzáadása';

  @override
  String get addWorkoutFromActivity => 'Tevékenységből';

  @override
  String get addWorkoutDirectCalories => 'Közvetlen kalóriák';

  @override
  String get addWorkoutActivityTypeOptional =>
      'Tevékenység típusa (opcionális)';

  @override
  String get addWorkoutCaloriesBurned => 'Elégetett kalóriák';

  @override
  String get addWorkoutCaloriesHint => 'pl. 250';

  @override
  String get save => 'Mentés';

  @override
  String get addWorkoutActivityType => 'Tevékenység típusa';

  @override
  String get addWorkoutDuration => 'Időtartam';

  @override
  String get minutes => 'perc';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Becslés: $kcal kcal elégetve';
  }

  @override
  String get confirmFoodsTitle => 'Ételek megerősítése';

  @override
  String get mealLabel => 'Étkezés:';

  @override
  String get mixedPlateWarning =>
      'Vegyes ételekkel teli tányér — ellenőrizz minden tételt, az azonosítás kevésbé pontos lehet.';

  @override
  String get noItemsLeft =>
      'Eltávolítottad az összes azonosított elemet. Készíts új fotót, ha újra szeretnéd próbálni.';

  @override
  String get portionSmall => 'Kicsi';

  @override
  String get portionMedium => 'Közepes';

  @override
  String get portionLarge => 'Nagy';

  @override
  String get notOnPlateRemove => 'Nincs a tányéron — eltávolítás';

  @override
  String roughEstimateNote(String source) {
    return 'Hozzávetőleges becslés ($source, mélységérzékelő nélkül)';
  }

  @override
  String get realNutritionDataBadge => 'valós adatok';

  @override
  String totalCalories(int kcal) {
    return 'Összesen: $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Ülő életmód (irodai munka, nincs edzés)';

  @override
  String get activityLevelLight => 'Enyhe aktivitás (edzés heti 1-3 napon)';

  @override
  String get activityLevelModerate =>
      'Mérsékelt aktivitás (edzés heti 3-5 napon)';

  @override
  String get activityLevelActive => 'Aktív (edzés heti 6-7 napon)';

  @override
  String get activityLevelVeryActive =>
      'Nagyon aktív (intenzív napi edzés / fizikai munka)';

  @override
  String get goalLose => 'Fogyás';

  @override
  String get goalMaintain => 'Fenntartás';

  @override
  String get goalGain => 'Izomépítés';

  @override
  String get progressPeriod7Days => '7 nap';

  @override
  String get progressPeriod30Days => '30 nap';

  @override
  String get progressPeriodWholeProgram => 'Teljes program';

  @override
  String get nutrientVitaminC => 'C-vitamin';

  @override
  String get nutrientVitaminD => 'D-vitamin';

  @override
  String get nutrientCalcium => 'Kalcium';

  @override
  String get nutrientIron => 'Vas';

  @override
  String get nutrientMagnesium => 'Magnézium';

  @override
  String get nutrientPotassium => 'Kálium';

  @override
  String get macroProtein => 'Fehérje';

  @override
  String get macroCarbs => 'Szénhidrát';

  @override
  String get macroFat => 'Zsír';

  @override
  String onboardingAgeTooLow(int age) {
    return 'Az alkalmazás $age éves és idősebb személyek számára készült.';
  }

  @override
  String get onboardingAgeInvalid => 'Érvénytelen érték.';

  @override
  String get onboardingAgeSexTitle => 'Kor és biológiai nem';

  @override
  String get age => 'Kor';

  @override
  String get years => 'év';

  @override
  String get sexFemale => 'Nő';

  @override
  String get sexMale => 'Férfi';

  @override
  String get onboardingSexHint =>
      'Csak az alap anyagcsere kiszámításához használjuk (Mifflin-St Jeor képlet).';

  @override
  String get onboardingHeightWeightTitle =>
      'Testmagasság és jelenlegi testsúly';

  @override
  String get height => 'Testmagasság';

  @override
  String get weight => 'Testsúly';

  @override
  String get onboardingActivityTitle => 'Fizikai aktivitás szintje';

  @override
  String get onboardingGoalTitle => 'Mi a célod?';

  @override
  String get onboardingLossRate => 'Kívánt fogyási ütem';

  @override
  String get onboardingGainRate => 'Kívánt hízási ütem';

  @override
  String get kgPerWeek => 'kg/hét';

  @override
  String get onboardingRateRecommendation =>
      'Ajánlott: 0,25-0,75 kg/hét a fenntartható ütemhez.';

  @override
  String get programStartDateLabel => 'A diéta kezdő dátuma';

  @override
  String get programStartDateHint =>
      'Eltér a fiók létrehozásának dátumától — ettől a ponttól szeretnéd mérni a haladást.';

  @override
  String get disclaimerTitle => 'Mielőtt elkezded';

  @override
  String get disclaimerIntro =>
      'A Calorii Fit az általánosan elfogadott képletek (Mifflin-St Jeor) alapján becsüli meg a kalóriaigényedet és a fogyás ütemét, nem egyéni orvosi felmérés alapján.';

  @override
  String get disclaimerMedical =>
      'Nem helyettesíti az orvos vagy dietetikus tanácsát — különösen, ha egészségügyi állapotod van, terhes vagy, vagy szoptatsz.';

  @override
  String get disclaimerAllergens =>
      'Az ételek fotóból történő azonosítása nem érzékeli az allergéneket. Ha súlyos allergiád vagy intoleranciád van, mindig magad ellenőrizd az összetevőket — ehhez ne hagyatkozz az alkalmazásra.';

  @override
  String get disclaimerEatingDisorders =>
      'Ha nehéz kapcsolatod volt vagy van az étellel (étkezési zavarok), beszélj orvossal, mielőtt kalóriát számolnál — az alkalmazás nem arra való, hogy helyettesítse ezt a támogatást.';

  @override
  String get disclaimerAcceptLabel =>
      'Megértem, és elfogadom, hogy ezt figyelembe véve használom az alkalmazást.';

  @override
  String get finish => 'Befejezés';

  @override
  String get continueLabel => 'Folytatás';

  @override
  String get progress => 'Előrehaladás';

  @override
  String get activityAndSync => 'Aktivitás és szinkronizálás';

  @override
  String get editProfileGoal => 'Profil/cél szerkesztése';

  @override
  String get checkDeviceCapability => 'Eszközképesség ellenőrzése';

  @override
  String get myRecipes => 'Receptjeim';

  @override
  String get signOut => 'Kijelentkezés';

  @override
  String get takePhoto => 'Fotó készítése';

  @override
  String get previousDay => 'Előző nap';

  @override
  String get nextDay => 'Következő nap';

  @override
  String get pickDayHelp => 'Válassz egy napot';

  @override
  String dateToday(String date) {
    return 'Ma, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Tegnap, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Holnap, $date';
  }

  @override
  String get setUpYourGoal => 'Állítsd be a célodat';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal ma';
  }

  @override
  String get setUp => 'Beállítás';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Cél: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Kalóriadeficit';

  @override
  String get totalBurnedLabel => 'Összesen elégetve';

  @override
  String get totalConsumedLabel => 'Összesen elfogyasztva';

  @override
  String overLimitCaption(String overBy, String limit) {
    return '$overBy kcal-val túllépted a limitet ($limit kcal fölött).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Ne lépd túl a(z) $kcal kcal-t, hogy elérd a kívánt fogyási ütemet.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Legalább $kcal kcal-ra van szükséged a kívánt hízási ütemhez.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Maradj a(z) $kcal kcal körül a fenntartáshoz.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Ajánlott: $low–$high kcal';
  }

  @override
  String get addFood => 'Étel hozzáadása';

  @override
  String get sportActivity => 'Fizikai tevékenység';

  @override
  String get manualCaloriesEntered => 'Manuálisan megadott kalóriák';

  @override
  String get addActivity => 'Tevékenység hozzáadása';

  @override
  String get caloricIntake => 'Kalóriabevitel';

  @override
  String get dailyCaloricDeficit => 'Napi kalóriadeficit';

  @override
  String get setUpProfileFirst =>
      'Először állítsd be a profilodat és a célodat a menüből.';

  @override
  String get totalCaloriesLabel => 'Kalóriák összesen';

  @override
  String get avgPerDay => 'Átl./nap';

  @override
  String get estimatedLoss => 'Becsült fogyás';

  @override
  String get macroBalanceTitle => 'Makrotápanyag-egyensúly';

  @override
  String get macroBalanceNoData =>
      'Nincs ismert fehérje-/szénhidrát-/zsírtartalmú étel ebben az időszakban.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (ajánlott $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Mikrotápanyagok (átl./nap)';

  @override
  String get micronutrientsNoData =>
      'Nincs vitamin-/ásványianyag-adattal rendelkező étel ebben az időszakban — lásd a lenti megjegyzést.';

  @override
  String get micronutrientsNoEntries =>
      'Nincs rögzített étel ebben az időszakban.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Vitamin-/ásványianyag-adatok elérhetők a rögzített ételek $pct%-ához ($withData/$total) — a többinél (házi főzés, címke nélküli termékek) nincs ismert adat, ezért nem szerepelnek az átlagban.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · a napi érték $percent%-a';
  }

  @override
  String get chartTargetLabel => 'Cél';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Health';

  @override
  String get healthConnectDescription =>
      'Lekéri az órád által rögzített testsúlyt és fizikai aktivitást a telefonod egészségügyi platformján keresztül.';

  @override
  String get bluetoothScaleSubtitle =>
      'Csatlakoztass közvetlenül egy okosmérleget';

  @override
  String get weightHistoryTitle => 'Testsúly-előzmények';

  @override
  String get addLabel => 'Hozzáadás';

  @override
  String get noEntriesYet => 'Még nincsenek bejegyzések.';

  @override
  String get syncButton => 'Szinkronizálás';

  @override
  String get syncAgain => 'Újra szinkronizálás';

  @override
  String get stepsToday => 'lépés ma';

  @override
  String get activeKcal => 'aktív kcal';

  @override
  String newWeightFetched(String kg) {
    return 'Új testsúly lekérve: $kg kg';
  }

  @override
  String newWorkoutsImported(int count) {
    return '$count új edzés importálva az órádról.';
  }

  @override
  String get weightSourceManual => 'manuális';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Health';

  @override
  String get weightSourceBluetoothScale => 'BT mérleg';

  @override
  String get addWeightTitle => 'Testsúly hozzáadása';

  @override
  String get editWeightTitle => 'Testsúly szerkesztése';

  @override
  String get weighInDateHelp => 'Mérés dátuma';

  @override
  String get weighInTimeHelp => 'Mérés időpontja';

  @override
  String get edit => 'Szerkesztés';

  @override
  String get delete => 'Törlés';

  @override
  String get chooseARecipe => 'Válassz egy receptet';

  @override
  String get newRecipe => 'Új recept';

  @override
  String get editRecipe => 'Recept szerkesztése';

  @override
  String get noRecipesYet =>
      'Még nem mentettél receptet. Adj hozzá egyet a lenti gombbal.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings adag · $kcal kcal/adag';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name ma lett hozzáadva.';
  }

  @override
  String addRecipeTo(String name) {
    return '\"$name\" hozzáadása ehhez:';
  }

  @override
  String get recipeNameLabel => 'Recept neve';

  @override
  String get recipeNameHint => 'pl. Csirkesalátám';

  @override
  String get numberOfServings => 'Adagok száma';

  @override
  String get ingredients => 'Összetevők';

  @override
  String get addAtLeastOneIngredient => 'Adj hozzá legalább egy összetevőt.';

  @override
  String get saveRecipe => 'Recept mentése';

  @override
  String perServing(int grams, int kcal) {
    return 'Adagonként ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Fehérje $protein · Szénhidrát $carbs · Zsír $fat';
  }

  @override
  String get addIngredientTitle => 'Összetevő hozzáadása';

  @override
  String get productNameLabel => 'Termék neve';

  @override
  String get noProductFound => 'Nem található termék.';

  @override
  String get searchWithAiButton => 'Keresés AI-val';

  @override
  String get aiSearchNoResult =>
      'Az AI nem talált biztos terméket erre a keresésre.';

  @override
  String get aiEstimateBadge => 'AI becslés';

  @override
  String get quantityLabel => 'Mennyiség';

  @override
  String get addIngredientButton => 'Összetevő hozzáadása';

  @override
  String get editIngredientQuantityTitle => 'Mennyiség szerkesztése';

  @override
  String get chooseRecipeIconTitle => 'Válassz ikont';

  @override
  String get recipeIconSuggested => 'Javasolt';

  @override
  String get saveAsRecipeTooltip => 'Mentés receptként';

  @override
  String get saveAsRecipeDialogTitle => 'Mentés új receptként';

  @override
  String recipeSavedConfirmation(String name) {
    return '„$name” elmentve a receptjeid közé.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Étel hozzáadása — $meal';
  }

  @override
  String get productNameHint => 'pl. Görög joghurt';

  @override
  String get enterProductName => 'Add meg a termék nevét';

  @override
  String get frequentlyLogged => 'Gyakran rögzített';

  @override
  String addCount(int count) {
    return 'Hozzáadás ($count)';
  }

  @override
  String get calorieIndexLabel => 'Kalóriaindex (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Elfogyasztott mennyiség';

  @override
  String get editGramsDialogTitle => 'Adag szerkesztése';

  @override
  String get requiredField => 'Kötelező mező';

  @override
  String get invalidValue => 'Érvénytelen érték';

  @override
  String get searchFailedCheckConnection =>
      'A keresést nem sikerült befejezni (ellenőrizd a kapcsolatot).';

  @override
  String get addProductManually => 'Termék manuális hozzáadása';

  @override
  String get macroProteinShort => 'F';

  @override
  String get macroCarbsShort => 'Sz';

  @override
  String get macroFatShort => 'Zs';

  @override
  String get macrosUnavailable => 'Makrotápanyagok nem elérhetők';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Fehérje $protein · Szénhidrát $carbs · Zsír $fat';
  }

  @override
  String get languageDialogTitle => 'Nyelv';

  @override
  String get languageSystemDefault => 'Telefon nyelve (alapértelmezett)';

  @override
  String get languageMenuEntry => 'Nyelv';

  @override
  String get guideMenuEntry => 'Használati útmutató';

  @override
  String get guideScreenTitle => 'Használati útmutató';

  @override
  String get guideIntroTitle => 'Mi a Calorii Fit';

  @override
  String get guideIntroBody =>
      'Egy táplálkozási alkalmazás, amely közvetlenül a tányérodról készült fotó alapján becsüli meg a kalóriákat, a telefonod mélységérzékelőjét használva — nem csak egy hétköznapi fotót. Emellett teljes naplót vezet: étkezések, sport, folyadékbevitel, testsúly és a célod felé tett előrehaladásod.';

  @override
  String get guidePhotoTitle => 'Becslés fotóból';

  @override
  String get guidePhotoBody =>
      'Lefényképezed a tányérodat, a telefonod LiDAR, ARCore Depth vagy dupla kamera segítségével méri meg a térfogatát, az alkalmazás pedig azonosítja az ételeket és kiszámítja az adagot. Az eredményt csúszkával vagy előre beállított értékekkel erősíted meg vagy módosítod — semmi nem kerül automatikusan mentésre. Mélységérzékelő nélkül a tányér átmérője szolgál referenciaként, egyértelműen hozzávetőleges becslésként jelölve.';

  @override
  String get guideLogTitle => 'Napi napló';

  @override
  String get guideLogBody =>
      'Napi négy étkezés — Reggeli, Ebéd, Vacsora, Nassolás. Adj hozzá ételeket fotóból, keresésből, vonalkód beolvasásával, kézzel, a receptjeidből, vagy gyorsan a megszokott ételeid pipálható listájából.';

  @override
  String get guideRecipesTitle => 'Receptjeim';

  @override
  String get guideRecipesBody =>
      'Mentsd el az összetevők egy olyan kombinációját, amelyet gyakran eszel, és egyetlen érintéssel rögzítsd. Minden recepthez választhatsz ikont (vagy elfogadhatod az automatikus javaslatot), és bármikor szerkesztheted bármelyik összetevő mennyiségét. Amikor egyszerre több ételt adsz hozzá, azonnal elmentheted őket új receptként.';

  @override
  String get guideWorkoutsTitle => 'Fizikai tevékenység';

  @override
  String get guideWorkoutsBody =>
      'Válaszd ki a tevékenység típusát és időtartamát, az elégetett kalóriák automatikusan kiszámolódnak — vagy add meg közvetlenül, ha már ismered őket egy okosórából. Az elégetett kalóriák levonásra kerülnek a napi keretből.';

  @override
  String get guideProgressTitle => 'Előrehaladás';

  @override
  String get guideProgressBody =>
      'Grafikonok 7 napra, 30 napra vagy a teljes programra: testsúly-alakulás (simított), a saját energiaegyensúlyodból számított adaptív TDEE, makrotápanyag-egyensúly és mikrotápanyag-lefedettség. Szinkronizál az Apple Health / Health Connect szolgáltatással és egy Bluetooth mérleggel.';

  @override
  String get guideHydrationTitle => 'Folyadékbevitel';

  @override
  String get guideHydrationBody =>
      'Egyszerű napi vizespohár-számláló — egy érintés a hozzáadáshoz, egy érintés az utolsó visszavonásához.';

  @override
  String get guideStreaksTitle => 'Motiváció';

  @override
  String get guideStreaksBody =>
      'Egy lángjelvény mutatja, hány egymást követő napon rögzítettél legalább egy étkezést.';

  @override
  String get guideRemindersTitle => 'Napi emlékeztető';

  @override
  String get guideRemindersBody =>
      'Egy általad választott időpontban érkező értesítés, amely emlékeztet az étkezéseid rögzítésére — bármikor kikapcsolható a menüből.';

  @override
  String get guideProfileTitle => 'Profil és cél';

  @override
  String get guideProfileBody =>
      'Kor, biológiai nem, testmagasság, testsúly, aktivitási szint és cél — bármikor szerkeszthető. Az alkalmazás minden változtatáskor automatikusan újraszámolja a kalóriacélodat.';

  @override
  String get guidePrivacyTitle => 'Adatvédelem';

  @override
  String get guidePrivacyBody =>
      'Az adataid kizárólag a fiókodhoz vannak kötve, és más felhasználók számára nem láthatók. Bármikor törölheted a fiókodat és az összes hozzá tartozó adatot a menüből — a törlés végleges és azonnali.';

  @override
  String get guideLanguagesTitle => 'Elérhető nyelvek';

  @override
  String get guideLanguagesBody =>
      'Az alkalmazás 13 nyelven érhető el, a menüből választhatók — nem csak automatikusan felismerve a telefon nyelve alapján.';

  @override
  String get guidePremiumTitle => 'Prémium és előfizetések';

  @override
  String get guidePremiumDraftNote =>
      'Piszkozat, nem véglegesített — az alábbi terv még nem aktív az alkalmazásban. Jelenleg nincs alkalmazáson belüli fizetés vagy funkciókorlátozás.';

  @override
  String get guidePremiumFreeBody =>
      'Ingyenes, örökre: teljes étkezési napló, napi 20 fotóelemzés, korlátlan saját recept, alap előrehaladási grafikonok és Apple Health / Health Connect szinkronizálás.';

  @override
  String get guidePremiumPaidBody =>
      'Prémium (tájékoztató jellegű, nem megerősített ár): korlátlan fotóelemzés, adaptív TDEE és részletes mikrotápanyagok, valamint elsőbbségi támogatás.';

  @override
  String get themeDialogTitle => 'Téma';

  @override
  String get themeSystemDefault => 'Telefon témája (alapértelmezett)';

  @override
  String get themeLight => 'Világos';

  @override
  String get themeDark => 'Sötét';

  @override
  String get themeMenuEntry => 'Téma';

  @override
  String get barcodeToggleTorch => 'Vaku be/ki';

  @override
  String get clearSelection => 'Kijelölés törlése';

  @override
  String get accessCodeMenuEntry => 'Hozzáférési kód';

  @override
  String get adminDashboardMenuEntry => 'Admin irányítópult';

  @override
  String get accessCodeScreenTitle => 'Hozzáférési kód';

  @override
  String get premiumCodeFieldLabel => 'Prémium kód';

  @override
  String get activatePremiumButton => 'Prémium aktiválása';

  @override
  String premiumActivatedMessage(String date) {
    return 'Prémium hozzáférés aktiválva eddig: $date.';
  }

  @override
  String get iAmAdminLink => 'Admin vagyok';

  @override
  String get adminPasswordFieldLabel => 'Admin jelszó';

  @override
  String get activateAdminButton => 'Admin aktiválása';

  @override
  String get adminActivatedMessage => 'Admin fiók aktiválva.';

  @override
  String get adminDashboardTitle => 'Admin irányítópult';

  @override
  String get totalUsersLabel => 'Felhasználók összesen';

  @override
  String get activePremiumLabel => 'Aktív prémium';

  @override
  String get generateCodeSectionTitle => 'Prémium kód generálása';

  @override
  String get targetEmailLabel => 'Fiók email címe';

  @override
  String get durationDaysLabel => 'Időtartam (nap)';

  @override
  String get generateCodeButton => 'Kód generálása';

  @override
  String get codeGeneratedTitle => 'Kód generálva';

  @override
  String get generatedCodesSectionTitle => 'Generált kódok';

  @override
  String get noCodesGeneratedYet => 'Még nincs generált kód.';

  @override
  String get codeStatusPending => 'felhasználatlan';

  @override
  String get codeStatusRedeemed => 'felhasznált';

  @override
  String get codeStatusRevoked => 'visszavonva';

  @override
  String durationDaysValue(int days) {
    return '$days nap';
  }

  @override
  String get completeNutritionWithAiTooltip => 'Kiegészítés AI-val';

  @override
  String get nutritionCompletedMessage => 'Tápanyagadatok kiegészítve.';

  @override
  String get aiCompletionNoResult =>
      'Az AI nem talált biztos adatot ehhez az ételhez.';

  @override
  String bulkNutritionCompletionButton(int count) {
    return 'Kiegészítés AI-val ($count)';
  }

  @override
  String bulkNutritionCompletionProgress(int done, int total) {
    return '$done/$total...';
  }

  @override
  String bulkNutritionCompletionPremiumLocked(int count) {
    return 'Prémium funkció ($count étel)';
  }

  @override
  String bulkNutritionCompletionResult(int completed, int total) {
    return '$completed/$total étel kiegészítve.';
  }
}

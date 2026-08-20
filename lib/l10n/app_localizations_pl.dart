// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Nie zapomnij zapisać swoich posiłków';

  @override
  String get dailyReminderBody =>
      'Kilka sekund wystarczy, aby twój dziennik był aktualny, a seria trwała.';

  @override
  String get dailyReminderChannelName => 'Codzienne przypomnienie';

  @override
  String get dailyReminderChannelDescription =>
      'Przypomnienie o zapisaniu dzisiejszych posiłków';

  @override
  String get updateRequiredTitle => 'Wymagana jest aktualizacja';

  @override
  String get updateRequiredMessage =>
      'Wersja aplikacji na tym telefonie nie jest już obsługiwana. Zainstaluj najnowszą wersję, aby kontynuować.';

  @override
  String get updateAvailableMessage => 'Dostępna jest nowa wersja aplikacji.';

  @override
  String get hydrationTitle => 'Nawodnienie';

  @override
  String get hydrationUndoLastGlass => 'Cofnij ostatnią szklankę';

  @override
  String hydrationAddGlass(int ml) {
    return 'Dodaj szklankę ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'Adaptacyjne TDEE';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Wciąż za mało danych: potrzeba co najmniej 14 zapisanych dni i 2 ważeń w odstępie co najmniej 10 dni, w ciągu ostatnich 3 tygodni. Do tego czasu używana jest standardowa formuła (Mifflin-St Jeor).';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Obliczone na podstawie twojego własnego bilansu kalorycznego ($loggedDays/$windowDays dni zapisanych w ciągu ostatnich 3 tygodni), a nie tylko standardowej formuły.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'Szacowane TDEE';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Trend wagi';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/tydzień';
  }

  @override
  String get adaptiveTdeeRejected =>
      'Szacunek wciąż zbytnio odbiega od standardowej formuły, by można było mu ufać — nadal stosowana jest standardowa formuła, dopóki nie zgromadzą się bardziej spójne dane.';

  @override
  String get weeklySummaryTitle => 'Podsumowanie tygodnia';

  @override
  String get weeklySummaryDaysLogged => 'Zapisane dni';

  @override
  String get weeklySummaryAvgCalories => 'Śr. kcal/dzień';

  @override
  String get weeklySummaryWorkouts => 'Treningi';

  @override
  String get weightEvolutionTitle => 'Zmiana wagi';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Od $date ($startKg kg) do dziś ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Możliwość przechwytywania głębi';

  @override
  String deviceCapabilityError(String error) {
    return 'Błąd podczas sprawdzania możliwości:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR dostępny';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth dostępny';

  @override
  String get depthSourcePortraitLabel => 'Podwójny aparat (głębia portretowa)';

  @override
  String get depthSourceReferenceLabel => 'Brak czujnika głębi';

  @override
  String get depthSourceUnknownLabel => 'Nieznane';

  @override
  String get depthSourceLidarDescription =>
      'Wysoce precyzyjne oszacowanie objętości (~10-15% błędu).';

  @override
  String get depthSourceArcoreDescription =>
      'Oszacowanie objętości za pomocą API ARCore Depth.';

  @override
  String get depthSourcePortraitDescription =>
      'Przybliżona głębia z podwójnego aparatu, niższa precyzja.';

  @override
  String get depthSourceReferenceDescription =>
      'Średnica talerza zostanie użyta jako punkt odniesienia skali (mniej precyzyjne oszacowanie).';

  @override
  String get depthSourceUnknownDescription =>
      'Nie udało się określić możliwości urządzenia.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'podwójny aparat';

  @override
  String get depthSourceReferenceShort => 'odniesienie wizualne';

  @override
  String get depthSourceUnknownShort => 'nieznane';

  @override
  String get howItWorksTitle => 'Jak obliczamy kalorie';

  @override
  String get howItWorksTooltip => 'Jak obliczamy kalorie?';

  @override
  String get howItWorksIntro =>
      'Większość aplikacji żywieniowych zgaduje porcję na podstawie pojedynczego zdjęcia 2D. Calorii Fit rzeczywiście mierzy objętość jedzenia na talerzu, korzystając z mapy głębi twojego telefonu — dlatego szacunek jest dokładniejszy.';

  @override
  String get howItWorksStep1Title => 'Sfotografuj swój talerz';

  @override
  String get howItWorksStep1Description =>
      'Jedno zdjęcie, bez specjalnego ustawiania.';

  @override
  String get howItWorksStep2Title => 'Twój telefon przechwytuje głębię';

  @override
  String get howItWorksStep2GenericDescription =>
      'Twój telefon, w zależności od modelu, używa LiDAR, ARCore Depth lub podwójnego aparatu, aby wiedzieć, jak wysokie jest jedzenie, a nie tylko jak wygląda z góry.';

  @override
  String get howItWorksStep3Title => 'Claude identyfikuje potrawy';

  @override
  String get howItWorksStep3Description =>
      'Model rozpoznaje, co jest na talerzu, i zaznacza przybliżony kontur każdej potrawy — sam nie oblicza kalorii, tylko identyfikuje.';

  @override
  String get howItWorksStep4Title =>
      'Objętość zamienia się w gramy, potem w kalorie';

  @override
  String get howItWorksStep4Description =>
      'Mapa głębi × kontur każdej potrawy daje objętość w cm³. Tabela gęstości (specyficzna dla każdego rodzaju jedzenia) zamienia objętość na gramy, a baza danych żywieniowych zamienia gramy na kalorie i makroskładniki.';

  @override
  String get howItWorksStep5Title => 'Ty potwierdzasz lub poprawiasz';

  @override
  String get howItWorksStep5Description =>
      'Automatyczne oszacowanie nigdy nie jest zapisywane bezpośrednio — zawsze widzisz ekran potwierdzenia, na którym możesz dostosować porcję lub zmienić zidentyfikowaną potrawę.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Zobacz, jakiej metody używa twój telefon';

  @override
  String get howItWorksDepthLidar =>
      'Twój telefon ma LiDAR — najdokładniejszą metodę dostępną dziś w telefonie, z typowym błędem wynoszącym zaledwie 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Twój telefon używa API ARCore Depth do oszacowania głębi sceny.';

  @override
  String get howItWorksDepthPortrait =>
      'Twój telefon szacuje głębię za pomocą podwójnego aparatu (tryb portretowy) — mniej dokładny niż LiDAR, ale wciąż lepszy niż zwykłe zdjęcie.';

  @override
  String get howItWorksDepthReference =>
      'Twój telefon nie ma czujnika głębi, więc używamy standardowej średnicy talerza jako punktu odniesienia skali — najmniej dokładna metoda, ale wciąż lepsza niż czysto wizualne oszacowanie.';

  @override
  String get howItWorksDepthUnknown =>
      'Nie udało nam się określić metody używanej przez twój telefon.';

  @override
  String get reminderPermissionDenied =>
      'Zezwól na powiadomienia dla aplikacji w ustawieniach telefonu.';

  @override
  String get reminderTimePickerHelp => 'Godzina przypomnienia';

  @override
  String get reminderDialogTitle => 'Codzienne przypomnienie';

  @override
  String get reminderDailyNotification => 'Codzienne powiadomienie';

  @override
  String get reminderDailyNotificationSubtitle =>
      'Przypomnienie o zapisaniu posiłków';

  @override
  String get reminderTimeLabel => 'Godzina';

  @override
  String get close => 'Zamknij';

  @override
  String get deleteAccountWrongPassword => 'Nieprawidłowe hasło.';

  @override
  String deleteAccountFailed(String code) {
    return 'Nie udało się usunąć konta ($code). Spróbuj ponownie.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Nie udało się usunąć konta. Spróbuj ponownie.';

  @override
  String get deleteAccountTitle => 'Usuń konto';

  @override
  String get deleteAccountExplanation =>
      'To trwale usuwa twoje konto i wszystkie twoje dane (profil, dziennik posiłków, treningi, wagi, zapamiętane produkty). Tej czynności nie można cofnąć.';

  @override
  String get password => 'Hasło';

  @override
  String get cancel => 'Anuluj';

  @override
  String get deleteAccountConfirm => 'Usuń trwale';

  @override
  String get barcodeScanTitle => 'Skanuj kod kreskowy';

  @override
  String barcodeNotFound(String barcode) {
    return 'Nie znaleziono produktu o kodzie $barcode.';
  }

  @override
  String get addManually => 'Dodaj ręcznie';

  @override
  String get scanAgain => 'Skanuj ponownie';

  @override
  String get bluetoothScaleTitle => 'Waga Bluetooth';

  @override
  String get bluetoothScaleSearch => 'Szukaj wag';

  @override
  String get bluetoothScaleIdleHint =>
      'Dotknij \"Szukaj wag\" i włącz wagę w pobliżu telefonu.';

  @override
  String get bluetoothScaleSearching => 'Wyszukiwanie...';

  @override
  String get bluetoothScaleNoneFound => 'Nie znaleziono jeszcze żadnej wagi.';

  @override
  String get bluetoothScaleConnecting => 'Łączenie...';

  @override
  String get bluetoothScaleWeightSaved => 'Waga zapisana.';

  @override
  String errorPrefixed(String message) {
    return 'Błąd: $message';
  }

  @override
  String get cameraNoneAvailable => 'Brak dostępnego aparatu w tym urządzeniu.';

  @override
  String get cameraCaptureTitle => 'Sfotografuj swój talerz';

  @override
  String get cameraCapturingStatus => 'Przechwytywanie zdjęcia i głębi…';

  @override
  String get cameraAnalyzingStatus => 'Identyfikowanie potraw…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Gotowe — otwieranie potwierdzenia…';

  @override
  String get cameraStartingStatus => 'Uruchamianie aparatu…';

  @override
  String get cameraFrameHint => 'Ustaw talerz w kadrze i dotknij migawki';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Nie udało się uruchomić/przeanalizować zdjęcia:\n$message';
  }

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get authEnterEmailFirst =>
      'Najpierw podaj swój e-mail, abyśmy mogli wysłać ci link do resetowania.';

  @override
  String get authPasswordResetSent =>
      'Wysłaliśmy ci e-mail z resetowaniem hasła.';

  @override
  String get authErrorInvalidEmail => 'Nieprawidłowy adres e-mail.';

  @override
  String get authErrorUserNotFound =>
      'Nie istnieje konto z tym adresem e-mail.';

  @override
  String get authErrorWrongCredentials => 'Nieprawidłowy e-mail lub hasło.';

  @override
  String get authErrorEmailInUse => 'Konto z tym adresem e-mail już istnieje.';

  @override
  String get authErrorWeakPassword =>
      'Hasło jest zbyt słabe (minimum 6 znaków).';

  @override
  String get authErrorGeneric => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get authWelcomeBack => 'Witaj ponownie';

  @override
  String get authLetsStart => 'Zaczynajmy';

  @override
  String get email => 'E-mail';

  @override
  String get authEnterValidEmail => 'Podaj prawidłowy e-mail';

  @override
  String get authPasswordMinLength => 'Minimum 6 znaków';

  @override
  String get authSignIn => 'Zaloguj się';

  @override
  String get authCreateAccount => 'Utwórz konto';

  @override
  String get authNoAccountYet => 'Brak konta? Utwórz je';

  @override
  String get authHaveAccountAlready => 'Masz już konto? Zaloguj się';

  @override
  String get authForgotPassword => 'Zapomniałeś hasła?';

  @override
  String get activityWalkingCasual => 'Spacer (spokojny)';

  @override
  String get activityWalkingBrisk => 'Spacer (szybki)';

  @override
  String get activityRunning => 'Bieganie';

  @override
  String get activityRunningFast => 'Bieganie (szybkie)';

  @override
  String get activityCycling => 'Jazda na rowerze (umiarkowana)';

  @override
  String get activityCyclingIntense => 'Jazda na rowerze (intensywna)';

  @override
  String get activitySwimming => 'Pływanie';

  @override
  String get activityStrengthTraining => 'Trening siłowy';

  @override
  String get activityYoga => 'Joga';

  @override
  String get activityDancing => 'Taniec';

  @override
  String get activityHiking => 'Wędrówka';

  @override
  String get activityJumpRope => 'Skakanka';

  @override
  String get activityFootball => 'Piłka nożna';

  @override
  String get activityBasketball => 'Koszykówka';

  @override
  String get activityTennis => 'Tenis';

  @override
  String get activityOther => 'Inna aktywność';

  @override
  String get mealBreakfast => 'Śniadanie';

  @override
  String get mealLunch => 'Obiad';

  @override
  String get mealDinner => 'Kolacja';

  @override
  String get mealSnack => 'Przekąska';

  @override
  String get addWorkoutTitle => 'Dodaj trening';

  @override
  String get addWorkoutFromActivity => 'Z aktywności';

  @override
  String get addWorkoutDirectCalories => 'Bezpośrednie kalorie';

  @override
  String get addWorkoutActivityTypeOptional =>
      'Rodzaj aktywności (opcjonalnie)';

  @override
  String get addWorkoutCaloriesBurned => 'Spalone kalorie';

  @override
  String get addWorkoutCaloriesHint => 'np. 250';

  @override
  String get save => 'Zapisz';

  @override
  String get addWorkoutActivityType => 'Rodzaj aktywności';

  @override
  String get addWorkoutDuration => 'Czas trwania';

  @override
  String get minutes => 'minuty';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Szacunek: $kcal kcal spalonych';
  }

  @override
  String get confirmFoodsTitle => 'Potwierdź potrawy';

  @override
  String get mealLabel => 'Posiłek:';

  @override
  String get mixedPlateWarning =>
      'Talerz z mieszanymi potrawami — sprawdź każdy element, identyfikacja może być mniej dokładna.';

  @override
  String get noItemsLeft =>
      'Usunąłeś wszystkie zidentyfikowane elementy. Zrób nowe zdjęcie, jeśli chcesz spróbować ponownie.';

  @override
  String get portionSmall => 'Mała';

  @override
  String get portionMedium => 'Średnia';

  @override
  String get portionLarge => 'Duża';

  @override
  String get notOnPlateRemove => 'Nie ma na talerzu — usuń';

  @override
  String roughEstimateNote(String source) {
    return 'Przybliżone oszacowanie ($source, brak czujnika głębi)';
  }

  @override
  String totalCalories(int kcal) {
    return 'Razem: $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Siedzący tryb życia (praca biurowa, brak ćwiczeń)';

  @override
  String get activityLevelLight =>
      'Lekka aktywność (ćwiczenia 1-3 dni/tydzień)';

  @override
  String get activityLevelModerate =>
      'Umiarkowana aktywność (ćwiczenia 3-5 dni/tydzień)';

  @override
  String get activityLevelActive => 'Aktywny (ćwiczenia 6-7 dni/tydzień)';

  @override
  String get activityLevelVeryActive =>
      'Bardzo aktywny (intensywne codzienne ćwiczenia / praca fizyczna)';

  @override
  String get goalLose => 'Schudnąć';

  @override
  String get goalMaintain => 'Utrzymać wagę';

  @override
  String get goalGain => 'Zbudować mięśnie';

  @override
  String get progressPeriod7Days => '7 dni';

  @override
  String get progressPeriod30Days => '30 dni';

  @override
  String get progressPeriodWholeProgram => 'Cały program';

  @override
  String get nutrientVitaminC => 'Witamina C';

  @override
  String get nutrientVitaminD => 'Witamina D';

  @override
  String get nutrientCalcium => 'Wapń';

  @override
  String get nutrientIron => 'Żelazo';

  @override
  String get nutrientMagnesium => 'Magnez';

  @override
  String get nutrientPotassium => 'Potas';

  @override
  String get macroProtein => 'Białko';

  @override
  String get macroCarbs => 'Węglowodany';

  @override
  String get macroFat => 'Tłuszcz';

  @override
  String onboardingAgeTooLow(int age) {
    return 'Aplikacja jest przeznaczona dla osób w wieku $age lat i starszych.';
  }

  @override
  String get onboardingAgeInvalid => 'Nieprawidłowa wartość.';

  @override
  String get onboardingAgeSexTitle => 'Wiek i płeć biologiczna';

  @override
  String get age => 'Wiek';

  @override
  String get years => 'lat';

  @override
  String get sexFemale => 'Kobieta';

  @override
  String get sexMale => 'Mężczyzna';

  @override
  String get onboardingSexHint =>
      'Używane tylko do obliczenia podstawowej przemiany materii (formuła Mifflin-St Jeor).';

  @override
  String get onboardingHeightWeightTitle => 'Wzrost i obecna waga';

  @override
  String get height => 'Wzrost';

  @override
  String get weight => 'Waga';

  @override
  String get onboardingActivityTitle => 'Poziom aktywności fizycznej';

  @override
  String get onboardingGoalTitle => 'Jaki jest twój cel?';

  @override
  String get onboardingLossRate => 'Pożądane tempo utraty wagi';

  @override
  String get onboardingGainRate => 'Pożądane tempo przyrostu wagi';

  @override
  String get kgPerWeek => 'kg/tydzień';

  @override
  String get onboardingRateRecommendation =>
      'Zalecane: 0,25-0,75 kg/tydzień dla trwałego tempa.';

  @override
  String get disclaimerTitle => 'Zanim zaczniesz';

  @override
  String get disclaimerIntro =>
      'Calorii Fit szacuje twoje zapotrzebowanie kaloryczne i tempo utraty wagi na podstawie ogólnie przyjętych formuł (Mifflin-St Jeor), a nie indywidualnej oceny medycznej.';

  @override
  String get disclaimerMedical =>
      'Nie zastępuje porady lekarza lub dietetyka — zwłaszcza jeśli masz schorzenie, jesteś w ciąży lub karmisz piersią.';

  @override
  String get disclaimerAllergens =>
      'Identyfikacja potraw ze zdjęcia nie wykrywa alergenów. Jeśli masz poważną alergię lub nietolerancję, zawsze sam sprawdzaj składniki — nie polegaj w tym na aplikacji.';

  @override
  String get disclaimerEatingDisorders =>
      'Jeśli miałeś lub masz trudną relację z jedzeniem (zaburzenia odżywiania), porozmawiaj z lekarzem przed liczeniem kalorii — aplikacja nie ma na celu zastąpienia tego wsparcia.';

  @override
  String get disclaimerAcceptLabel =>
      'Rozumiem i zgadzam się na korzystanie z aplikacji, mając to na uwadze.';

  @override
  String get finish => 'Zakończ';

  @override
  String get continueLabel => 'Kontynuuj';

  @override
  String get progress => 'Postęp';

  @override
  String get activityAndSync => 'Aktywność i synchronizacja';

  @override
  String get editProfileGoal => 'Edytuj profil/cel';

  @override
  String get checkDeviceCapability => 'Sprawdź możliwości urządzenia';

  @override
  String get myRecipes => 'Moje przepisy';

  @override
  String get signOut => 'Wyloguj się';

  @override
  String get takePhoto => 'Zrób zdjęcie';

  @override
  String get previousDay => 'Poprzedni dzień';

  @override
  String get nextDay => 'Następny dzień';

  @override
  String get pickDayHelp => 'Wybierz dzień';

  @override
  String dateToday(String date) {
    return 'Dziś, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Wczoraj, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Jutro, $date';
  }

  @override
  String get setUpYourGoal => 'Skonfiguruj swój cel';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal dzisiaj';
  }

  @override
  String get setUp => 'Skonfiguruj';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Cel: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Deficyt kaloryczny';

  @override
  String get totalBurnedLabel => 'Łącznie spalone';

  @override
  String get totalConsumedLabel => 'Łącznie spożyte';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Przekroczyłeś limit o $overBy kcal (ponad $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Nie przekraczaj $kcal kcal, aby osiągnąć docelowe tempo utraty wagi.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Potrzebujesz co najmniej $kcal kcal dla docelowego tempa przyrostu wagi.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Pozostań w okolicach $kcal kcal, aby utrzymać wagę.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Zalecane: $low–$high kcal';
  }

  @override
  String get addFood => 'Dodaj produkt';

  @override
  String get sportActivity => 'Aktywność fizyczna';

  @override
  String get manualCaloriesEntered => 'Ręcznie wprowadzone kalorie';

  @override
  String get addActivity => 'Dodaj aktywność';

  @override
  String get caloricIntake => 'Spożycie kalorii';

  @override
  String get dailyCaloricDeficit => 'Dzienny deficyt kaloryczny';

  @override
  String get setUpProfileFirst =>
      'Najpierw skonfiguruj swój profil i cel z menu.';

  @override
  String get totalCaloriesLabel => 'Łączna liczba kalorii';

  @override
  String get avgPerDay => 'Śr./dzień';

  @override
  String get estimatedLoss => 'Szacowana utrata';

  @override
  String get macroBalanceTitle => 'Bilans makroskładników';

  @override
  String get macroBalanceNoData =>
      'Brak potrawy ze znanym białkiem/węglowodanami/tłuszczem w tym okresie.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (zalecane $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Mikroskładniki (śr./dzień)';

  @override
  String get micronutrientsNoData =>
      'Brak potrawy z danymi o witaminach/minerałach w tym okresie — zobacz uwagę poniżej.';

  @override
  String get micronutrientsNoEntries => 'Brak zapisanych potraw w tym okresie.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Dane o witaminach/minerałach dostępne dla $pct% zapisanych potraw ($withData/$total) — reszta (domowe gotowanie, produkty bez etykiet) nie ma znanych danych i nie jest uwzględniana w średniej.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% wartości dziennej';
  }

  @override
  String get chartTargetLabel => 'Cel';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Zdrowie';

  @override
  String get healthConnectDescription =>
      'Pobiera wagę i aktywność fizyczną zarejestrowane przez twój zegarek, za pośrednictwem platformy zdrowotnej twojego telefonu.';

  @override
  String get bluetoothScaleSubtitle => 'Połącz bezpośrednio inteligentną wagę';

  @override
  String get weightHistoryTitle => 'Historia wagi';

  @override
  String get addLabel => 'Dodaj';

  @override
  String get noEntriesYet => 'Brak wpisów.';

  @override
  String get syncButton => 'Synchronizuj';

  @override
  String get syncAgain => 'Synchronizuj ponownie';

  @override
  String get stepsToday => 'kroków dzisiaj';

  @override
  String get activeKcal => 'aktywne kcal';

  @override
  String newWeightFetched(String kg) {
    return 'Pobrano nową wagę: $kg kg';
  }

  @override
  String get weightSourceManual => 'ręcznie';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Zdrowie';

  @override
  String get weightSourceBluetoothScale => 'Waga BT';

  @override
  String get addWeightTitle => 'Dodaj wagę';

  @override
  String get editWeightTitle => 'Edytuj wagę';

  @override
  String get weighInDateHelp => 'Data ważenia';

  @override
  String get weighInTimeHelp => 'Godzina ważenia';

  @override
  String get edit => 'Edytuj';

  @override
  String get delete => 'Usuń';

  @override
  String get chooseARecipe => 'Wybierz przepis';

  @override
  String get newRecipe => 'Nowy przepis';

  @override
  String get editRecipe => 'Edytuj przepis';

  @override
  String get noRecipesYet =>
      'Nie zapisałeś jeszcze żadnych przepisów. Dodaj jeden za pomocą przycisku poniżej.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings porcji · $kcal kcal/porcja';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name zostało dodane dzisiaj.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Dodaj \"$name\" do:';
  }

  @override
  String get recipeNameLabel => 'Nazwa przepisu';

  @override
  String get recipeNameHint => 'np. Moja sałatka z kurczakiem';

  @override
  String get numberOfServings => 'Liczba porcji';

  @override
  String get ingredients => 'Składniki';

  @override
  String get addAtLeastOneIngredient => 'Dodaj co najmniej jeden składnik.';

  @override
  String get saveRecipe => 'Zapisz przepis';

  @override
  String perServing(int grams, int kcal) {
    return 'Na porcję ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Białko $protein · Węglowodany $carbs · Tłuszcz $fat';
  }

  @override
  String get addIngredientTitle => 'Dodaj składnik';

  @override
  String get productNameLabel => 'Nazwa produktu';

  @override
  String get noProductFound => 'Nie znaleziono produktu.';

  @override
  String get quantityLabel => 'Ilość';

  @override
  String get addIngredientButton => 'Dodaj składnik';

  @override
  String get editIngredientQuantityTitle => 'Edytuj ilość';

  @override
  String get chooseRecipeIconTitle => 'Wybierz ikonę';

  @override
  String get recipeIconSuggested => 'Sugestia';

  @override
  String get saveAsRecipeTooltip => 'Zapisz jako przepis';

  @override
  String get saveAsRecipeDialogTitle => 'Zapisz jako nowy przepis';

  @override
  String recipeSavedConfirmation(String name) {
    return '\"$name\" zostało zapisane w Twoich przepisach.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Dodaj produkt — $meal';
  }

  @override
  String get productNameHint => 'np. Jogurt grecki';

  @override
  String get enterProductName => 'Wpisz nazwę produktu';

  @override
  String get frequentlyLogged => 'Często zapisywane';

  @override
  String addCount(int count) {
    return 'Dodaj ($count)';
  }

  @override
  String get calorieIndexLabel => 'Wskaźnik kaloryczny (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Spożyta ilość';

  @override
  String get requiredField => 'Pole wymagane';

  @override
  String get invalidValue => 'Nieprawidłowa wartość';

  @override
  String get searchFailedCheckConnection =>
      'Wyszukiwanie nie powiodło się (sprawdź swoje połączenie).';

  @override
  String get addProductManually => 'Dodaj produkt ręcznie';

  @override
  String get macroProteinShort => 'B';

  @override
  String get macroCarbsShort => 'W';

  @override
  String get macroFatShort => 'T';

  @override
  String get macrosUnavailable => 'Makroskładniki niedostępne';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Białko $protein · Węglowodany $carbs · Tłuszcz $fat';
  }

  @override
  String get languageDialogTitle => 'Język';

  @override
  String get languageSystemDefault => 'Język telefonu (domyślny)';

  @override
  String get languageMenuEntry => 'Język';

  @override
  String get guideMenuEntry => 'Przewodnik użytkownika';

  @override
  String get guideScreenTitle => 'Przewodnik użytkownika';

  @override
  String get guideIntroTitle => 'Czym jest Calorii Fit';

  @override
  String get guideIntroBody =>
      'Aplikacja żywieniowa, która szacuje kalorie bezpośrednio ze zdjęcia talerza, wykorzystując czujnik głębi telefonu — nie tylko zwykłe zdjęcie. Prowadzi też pełny dziennik: posiłki, sport, nawodnienie, wagę i postępy w realizacji celu.';

  @override
  String get guidePhotoTitle => 'Szacowanie ze zdjęcia';

  @override
  String get guidePhotoBody =>
      'Fotografujesz talerz, telefon mierzy jego objętość za pomocą LiDAR, ARCore Depth lub podwójnego aparatu, a aplikacja identyfikuje potrawy i oblicza porcję. Potwierdzasz lub korygujesz wynik suwakiem lub ustawieniami wstępnymi — nic nie zapisuje się automatycznie. Bez czujnika głębi używana jest średnica talerza jako punkt odniesienia, wyraźnie oznaczona jako szacunek przybliżony.';

  @override
  String get guideLogTitle => 'Dziennik dnia';

  @override
  String get guideLogBody =>
      'Cztery posiłki dziennie — Śniadanie, Obiad, Kolacja, Przekąska. Dodawaj potrawy ze zdjęcia, wyszukiwania, skanowania kodu kreskowego, ręcznie, z Twoich przepisów lub szybko z listy zwykle spożywanych potraw.';

  @override
  String get guideRecipesTitle => 'Moje przepisy';

  @override
  String get guideRecipesBody =>
      'Zapisz kombinację składników, którą często jesz, i zarejestruj ją jednym dotknięciem. Możesz wybrać ikonę dla każdego przepisu (lub zaakceptować automatyczną sugestię) i w dowolnym momencie edytować ilość każdego składnika. Gdy dodajesz kilka potraw naraz, możesz od razu zapisać je jako nowy przepis.';

  @override
  String get guideWorkoutsTitle => 'Aktywność fizyczna';

  @override
  String get guideWorkoutsBody =>
      'Wybierz rodzaj aktywności i czas trwania, a spalone kalorie zostaną obliczone automatycznie — lub wpisz je bezpośrednio, jeśli znasz je już ze smartwatcha. Spalone kalorie są odejmowane od budżetu dnia.';

  @override
  String get guideProgressTitle => 'Postęp';

  @override
  String get guideProgressBody =>
      'Wykresy za 7 dni, 30 dni lub cały program: zmiana wagi (wygładzona), adaptacyjne TDEE obliczone na podstawie Twojego własnego bilansu energetycznego, bilans makroskładników i pokrycie mikroskładników. Synchronizacja z Apple Zdrowie / Health Connect oraz wagą Bluetooth.';

  @override
  String get guideHydrationTitle => 'Nawodnienie';

  @override
  String get guideHydrationBody =>
      'Prosty dzienny licznik szklanek wody — jedno dotknięcie, by dodać, jedno, by cofnąć ostatnią.';

  @override
  String get guideStreaksTitle => 'Motywacja';

  @override
  String get guideStreaksBody =>
      'Odznaka z płomieniem pokazuje, ile dni z rzędu zarejestrowałeś przynajmniej jeden posiłek.';

  @override
  String get guideRemindersTitle => 'Codzienne przypomnienie';

  @override
  String get guideRemindersBody =>
      'Powiadomienie, o wybranej przez Ciebie porze, przypominające o zapisaniu posiłków — możliwe do wyłączenia w każdej chwili z menu.';

  @override
  String get guideProfileTitle => 'Profil i cel';

  @override
  String get guideProfileBody =>
      'Wiek, płeć biologiczna, wzrost, waga, poziom aktywności i cel — edytowalne w każdej chwili. Aplikacja automatycznie przelicza cel kaloryczny przy każdej zmianie.';

  @override
  String get guidePrivacyTitle => 'Prywatność';

  @override
  String get guidePrivacyBody =>
      'Twoje dane są powiązane wyłącznie z Twoim kontem i niewidoczne dla innych użytkowników. Możesz usunąć swoje konto i wszystkie powiązane dane w dowolnym momencie z menu — usunięcie jest trwałe i natychmiastowe.';

  @override
  String get guideLanguagesTitle => 'Dostępne języki';

  @override
  String get guideLanguagesBody =>
      'Aplikacja jest dostępna w 13 językach, wybieranych z menu — nie tylko wykrywanych automatycznie na podstawie języka telefonu.';

  @override
  String get guidePremiumTitle => 'Premium i subskrypcje';

  @override
  String get guidePremiumDraftNote =>
      'Wersja robocza, niedokończona — poniższy plan nie jest jeszcze aktywny w aplikacji. Obecnie nie ma płatności w aplikacji ani ograniczeń funkcji.';

  @override
  String get guidePremiumFreeBody =>
      'Bezpłatnie, na zawsze: pełny dziennik żywienia, 20 analiz zdjęć dziennie, nieograniczona liczba własnych przepisów, podstawowe wykresy postępu i synchronizacja z Apple Zdrowie / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (cena orientacyjna, niepotwierdzona): nieograniczone analizy zdjęć, adaptacyjne TDEE i szczegółowe mikroskładniki, eksport danych i priorytetowe wsparcie.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Don\'t forget to log your meals';

  @override
  String get dailyReminderBody =>
      'A few seconds now keeps your log up to date and your streak alive.';

  @override
  String get dailyReminderChannelName => 'Daily reminder';

  @override
  String get dailyReminderChannelDescription =>
      'Reminder to log today\'s meals';

  @override
  String get updateRequiredTitle => 'An update is needed';

  @override
  String get updateRequiredMessage =>
      'The version of the app on this phone is no longer supported. Install the latest version to continue.';

  @override
  String get updateAvailableMessage => 'A new version of the app is available.';

  @override
  String get hydrationTitle => 'Hydration';

  @override
  String get hydrationUndoLastGlass => 'Undo last glass';

  @override
  String hydrationAddGlass(int ml) {
    return 'Add a glass ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'Adaptive TDEE';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Not enough data yet: you need at least 14 logged days and 2 weigh-ins at least 10 days apart, within the last 3 weeks. Until then, the standard formula (Mifflin-St Jeor) is used.';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Calculated from your own calorie balance ($loggedDays/$windowDays days logged in the last 3 weeks), not just the standard formula.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'Estimated TDEE';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Weight trend';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/week';
  }

  @override
  String get adaptiveTdeeRejected =>
      'The estimate differs too much from the standard formula to be trusted yet — the standard formula is still being used, until more consistent data builds up.';

  @override
  String get weeklySummaryTitle => 'This week\'s summary';

  @override
  String get weeklySummaryDaysLogged => 'Days logged';

  @override
  String get weeklySummaryAvgCalories => 'Avg kcal/day';

  @override
  String get weeklySummaryWorkouts => 'Workouts';

  @override
  String get weightEvolutionTitle => 'Weight evolution';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'From $date ($startKg kg) to today ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Depth capture capability';

  @override
  String deviceCapabilityError(String error) {
    return 'Error checking capabilities:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR available';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth available';

  @override
  String get depthSourcePortraitLabel => 'Dual camera (portrait depth)';

  @override
  String get depthSourceReferenceLabel => 'No depth sensor';

  @override
  String get depthSourceUnknownLabel => 'Unknown';

  @override
  String get depthSourceLidarDescription =>
      'High-precision volumetric estimate (~10-15% error).';

  @override
  String get depthSourceArcoreDescription =>
      'Volumetric estimate via ARCore Depth API.';

  @override
  String get depthSourcePortraitDescription =>
      'Approximate depth from the dual camera, lower precision.';

  @override
  String get depthSourceReferenceDescription =>
      'The plate\'s diameter will be used as a scale reference (less precise estimate).';

  @override
  String get depthSourceUnknownDescription =>
      'Could not determine the device\'s capability.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'dual camera';

  @override
  String get depthSourceReferenceShort => 'visual reference';

  @override
  String get depthSourceUnknownShort => 'unknown';

  @override
  String get howItWorksTitle => 'How we calculate calories';

  @override
  String get howItWorksTooltip => 'How do we calculate calories?';

  @override
  String get howItWorksIntro =>
      'Most nutrition apps guess the portion from a single 2D photo. Calorii Fit actually measures the volume of the food on the plate, using your phone\'s depth map — that\'s why the estimate is more accurate.';

  @override
  String get howItWorksStep1Title => 'Photograph your plate';

  @override
  String get howItWorksStep1Description =>
      'A single photo, no special positioning.';

  @override
  String get howItWorksStep2Title => 'Your phone captures depth';

  @override
  String get howItWorksStep2GenericDescription =>
      'Your phone uses LiDAR, ARCore Depth, or a dual camera, depending on the model, to know how tall the food is, not just what it looks like from above.';

  @override
  String get howItWorksStep3Title => 'Claude identifies the foods';

  @override
  String get howItWorksStep3Description =>
      'The model recognizes what\'s on the plate and marks the approximate outline of each food item — it doesn\'t calculate calories itself, only identifies.';

  @override
  String get howItWorksStep4Title => 'Volume becomes grams, then calories';

  @override
  String get howItWorksStep4Description =>
      'The depth map × each food\'s outline gives a volume in cm³. A density table (specific to each type of food) converts the volume into grams, and the nutrition database converts the grams into calories and macronutrients.';

  @override
  String get howItWorksStep5Title => 'You confirm or correct';

  @override
  String get howItWorksStep5Description =>
      'The automatic estimate is never saved directly — you always see a confirmation screen where you can adjust the portion or change the identified food.';

  @override
  String get howItWorksSeeDeviceMethod => 'See which method your phone uses';

  @override
  String get howItWorksDepthLidar =>
      'Your phone has LiDAR — the most precise method available on a phone today, with a typical error of just 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Your phone uses the ARCore Depth API to estimate scene depth.';

  @override
  String get howItWorksDepthPortrait =>
      'Your phone estimates depth from the dual camera (portrait mode) — less precise than LiDAR, but still better than a plain photo.';

  @override
  String get howItWorksDepthReference =>
      'Your phone has no depth sensor, so we use a plate\'s standard diameter as a scale reference — the least precise method, but still better than a purely visual guess.';

  @override
  String get howItWorksDepthUnknown =>
      'We couldn\'t determine the method your phone uses.';

  @override
  String get reminderPermissionDenied =>
      'Allow notifications for the app in your phone\'s settings.';

  @override
  String get reminderTimePickerHelp => 'Reminder time';

  @override
  String get reminderDialogTitle => 'Daily reminder';

  @override
  String get reminderDailyNotification => 'Daily notification';

  @override
  String get reminderDailyNotificationSubtitle =>
      'A reminder to log your meals';

  @override
  String get reminderTimeLabel => 'Time';

  @override
  String get close => 'Close';

  @override
  String get deleteAccountWrongPassword => 'Wrong password.';

  @override
  String deleteAccountFailed(String code) {
    return 'Couldn\'t delete the account ($code). Try again.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Couldn\'t delete the account. Try again.';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountExplanation =>
      'This permanently deletes your account and all your data (profile, meal log, workouts, weights, remembered foods). This action cannot be undone.';

  @override
  String get password => 'Password';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAccountConfirm => 'Delete permanently';

  @override
  String get barcodeScanTitle => 'Scan barcode';

  @override
  String barcodeNotFound(String barcode) {
    return 'The product with code $barcode wasn\'t found.';
  }

  @override
  String get addManually => 'Add manually';

  @override
  String get scanAgain => 'Scan again';

  @override
  String get bluetoothScaleTitle => 'Bluetooth scale';

  @override
  String get bluetoothScaleSearch => 'Search for scales';

  @override
  String get bluetoothScaleIdleHint =>
      'Tap \"Search for scales\" and turn on your scale near the phone.';

  @override
  String get bluetoothScaleSearching => 'Searching...';

  @override
  String get bluetoothScaleNoneFound => 'No scale found yet.';

  @override
  String get bluetoothScaleConnecting => 'Connecting...';

  @override
  String get bluetoothScaleWeightSaved => 'Weight saved.';

  @override
  String errorPrefixed(String message) {
    return 'Error: $message';
  }

  @override
  String get cameraNoneAvailable => 'No camera available on this device.';

  @override
  String get cameraCaptureTitle => 'Photograph your plate';

  @override
  String get cameraCapturingStatus => 'Capturing the photo and depth…';

  @override
  String get cameraAnalyzingStatus => 'Identifying the foods…';

  @override
  String get cameraConfirmationOpeningStatus => 'Done — opening confirmation…';

  @override
  String get cameraStartingStatus => 'Starting the camera…';

  @override
  String get cameraFrameHint => 'Frame the plate and tap the shutter';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Couldn\'t start/analyze the photo:\n$message';
  }

  @override
  String get retry => 'Try again';

  @override
  String get authEnterEmailFirst =>
      'Enter your email first, so we can send you the reset link.';

  @override
  String get authPasswordResetSent => 'We\'ve sent you a password reset email.';

  @override
  String get authErrorInvalidEmail => 'Invalid email address.';

  @override
  String get authErrorUserNotFound => 'No account exists with this email.';

  @override
  String get authErrorWrongCredentials => 'Wrong email or password.';

  @override
  String get authErrorEmailInUse =>
      'An account with this email already exists.';

  @override
  String get authErrorWeakPassword =>
      'The password is too weak (minimum 6 characters).';

  @override
  String get authErrorGeneric => 'Something went wrong. Try again.';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authLetsStart => 'Let\'s get started';

  @override
  String get email => 'Email';

  @override
  String get authEnterValidEmail => 'Enter a valid email';

  @override
  String get authPasswordMinLength => 'Minimum 6 characters';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authNoAccountYet => 'No account? Create one';

  @override
  String get authHaveAccountAlready => 'Already have an account? Sign in';

  @override
  String get authForgotPassword => 'Forgot your password?';

  @override
  String get activityWalkingCasual => 'Walking (casual)';

  @override
  String get activityWalkingBrisk => 'Walking (brisk)';

  @override
  String get activityRunning => 'Running';

  @override
  String get activityRunningFast => 'Running (fast)';

  @override
  String get activityCycling => 'Cycling (moderate)';

  @override
  String get activityCyclingIntense => 'Cycling (intense)';

  @override
  String get activitySwimming => 'Swimming';

  @override
  String get activityStrengthTraining => 'Strength training';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Dancing';

  @override
  String get activityHiking => 'Hiking';

  @override
  String get activityJumpRope => 'Jump rope';

  @override
  String get activityFootball => 'Football';

  @override
  String get activityBasketball => 'Basketball';

  @override
  String get activityTennis => 'Tennis';

  @override
  String get activityOther => 'Other activity';

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealSnack => 'Snack';

  @override
  String get addWorkoutTitle => 'Add a workout';

  @override
  String get addWorkoutFromActivity => 'From activity';

  @override
  String get addWorkoutDirectCalories => 'Direct calories';

  @override
  String get addWorkoutActivityTypeOptional => 'Activity type (optional)';

  @override
  String get addWorkoutCaloriesBurned => 'Calories burned';

  @override
  String get addWorkoutCaloriesHint => 'e.g. 250';

  @override
  String get save => 'Save';

  @override
  String get addWorkoutActivityType => 'Activity type';

  @override
  String get addWorkoutDuration => 'Duration';

  @override
  String get minutes => 'minutes';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Estimate: $kcal kcal burned';
  }

  @override
  String get confirmFoodsTitle => 'Confirm the foods';

  @override
  String get mealLabel => 'Meal:';

  @override
  String get mixedPlateWarning =>
      'Plate with mixed foods — check each item, identification may be less accurate.';

  @override
  String get noItemsLeft =>
      'You removed all identified items. Take a new photo if you\'d like to try again.';

  @override
  String get portionSmall => 'Small';

  @override
  String get portionMedium => 'Medium';

  @override
  String get portionLarge => 'Large';

  @override
  String get notOnPlateRemove => 'Not on the plate — remove';

  @override
  String roughEstimateNote(String source) {
    return 'Rough estimate ($source, no depth sensor)';
  }

  @override
  String totalCalories(int kcal) {
    return 'Total: $kcal kcal';
  }

  @override
  String get activityLevelSedentary => 'Sedentary (desk job, no exercise)';

  @override
  String get activityLevelLight => 'Light activity (exercise 1-3 days/week)';

  @override
  String get activityLevelModerate =>
      'Moderate activity (exercise 3-5 days/week)';

  @override
  String get activityLevelActive => 'Active (exercise 6-7 days/week)';

  @override
  String get activityLevelVeryActive =>
      'Very active (intense daily exercise / physical job)';

  @override
  String get goalLose => 'Lose weight';

  @override
  String get goalMaintain => 'Maintain';

  @override
  String get goalGain => 'Build muscle';

  @override
  String get progressPeriod7Days => '7 days';

  @override
  String get progressPeriod30Days => '30 days';

  @override
  String get progressPeriodWholeProgram => 'Whole program';

  @override
  String get nutrientVitaminC => 'Vitamin C';

  @override
  String get nutrientVitaminD => 'Vitamin D';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientIron => 'Iron';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientPotassium => 'Potassium';

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Carbs';

  @override
  String get macroFat => 'Fat';

  @override
  String onboardingAgeTooLow(int age) {
    return 'The app is for people aged $age and up.';
  }

  @override
  String get onboardingAgeInvalid => 'Invalid value.';

  @override
  String get onboardingAgeSexTitle => 'Age and biological sex';

  @override
  String get age => 'Age';

  @override
  String get years => 'years';

  @override
  String get sexFemale => 'Female';

  @override
  String get sexMale => 'Male';

  @override
  String get onboardingSexHint =>
      'Used only to calculate basal metabolic rate (Mifflin-St Jeor formula).';

  @override
  String get onboardingHeightWeightTitle => 'Height and current weight';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get onboardingActivityTitle => 'Physical activity level';

  @override
  String get onboardingGoalTitle => 'What\'s your goal?';

  @override
  String get onboardingLossRate => 'Desired loss rate';

  @override
  String get onboardingGainRate => 'Desired gain rate';

  @override
  String get kgPerWeek => 'kg/week';

  @override
  String get onboardingRateRecommendation =>
      'Recommended: 0.25-0.75 kg/week for a sustainable pace.';

  @override
  String get disclaimerTitle => 'Before you start';

  @override
  String get disclaimerIntro =>
      'Calorii Fit estimates your calorie needs and weight-loss pace based on generally accepted formulas (Mifflin-St Jeor), not an individual medical assessment.';

  @override
  String get disclaimerMedical =>
      'It doesn\'t replace advice from a doctor or dietitian — especially if you have a medical condition, are pregnant, or breastfeeding.';

  @override
  String get disclaimerAllergens =>
      'Identifying foods from a photo doesn\'t detect allergens. If you have a severe allergy or intolerance, always check the ingredients yourself — don\'t rely on the app for that.';

  @override
  String get disclaimerEatingDisorders =>
      'If you\'ve had or have a difficult relationship with food (eating disorders), talk to a doctor before tracking calories — the app isn\'t meant to replace that support.';

  @override
  String get disclaimerAcceptLabel =>
      'I understand and agree to use the app with this in mind.';

  @override
  String get finish => 'Finish';

  @override
  String get continueLabel => 'Continue';

  @override
  String get progress => 'Progress';

  @override
  String get activityAndSync => 'Activity & sync';

  @override
  String get editProfileGoal => 'Edit profile/goal';

  @override
  String get checkDeviceCapability => 'Check device capability';

  @override
  String get myRecipes => 'My recipes';

  @override
  String get signOut => 'Sign out';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get pickDayHelp => 'Pick a day';

  @override
  String dateToday(String date) {
    return 'Today, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Yesterday, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Tomorrow, $date';
  }

  @override
  String get setUpYourGoal => 'Set up your goal';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal today';
  }

  @override
  String get setUp => 'Set up';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Target: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Calorie deficit';

  @override
  String get totalBurnedLabel => 'Total burned';

  @override
  String get totalConsumedLabel => 'Total consumed';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'You exceeded the limit by $overBy kcal (over $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Don\'t exceed $kcal kcal, to hit your target loss pace.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'You need at least $kcal kcal for your target gain pace.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Stay around $kcal kcal to maintain.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Recommended: $low–$high kcal';
  }

  @override
  String get addFood => 'Add food';

  @override
  String get sportActivity => 'Physical activity';

  @override
  String get manualCaloriesEntered => 'Manually entered calories';

  @override
  String get addActivity => 'Add activity';

  @override
  String get caloricIntake => 'Calorie intake';

  @override
  String get dailyCaloricDeficit => 'Daily calorie deficit';

  @override
  String get setUpProfileFirst =>
      'First set up your profile and goal from the menu.';

  @override
  String get totalCaloriesLabel => 'Total calories';

  @override
  String get avgPerDay => 'Avg/day';

  @override
  String get estimatedLoss => 'Estimated loss';

  @override
  String get macroBalanceTitle => 'Macronutrient balance';

  @override
  String get macroBalanceNoData =>
      'No food with known protein/carbs/fat in this period.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (recommended $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Micronutrients (avg/day)';

  @override
  String get micronutrientsNoData =>
      'No food with vitamin/mineral data in this period — see the note below.';

  @override
  String get micronutrientsNoEntries => 'No foods logged in this period.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Vitamin/mineral data available for $pct% of the logged foods ($withData/$total) — the rest (home cooking, unlabeled products) have no known data and aren\'t included in the average.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% of the daily value';
  }

  @override
  String get chartTargetLabel => 'Target';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Health';

  @override
  String get healthConnectDescription =>
      'Pulls the weight and physical activity logged by your watch, through your phone\'s health platform.';

  @override
  String get bluetoothScaleSubtitle => 'Connect a smart scale directly';

  @override
  String get weightHistoryTitle => 'Weight history';

  @override
  String get addLabel => 'Add';

  @override
  String get noEntriesYet => 'No entries yet.';

  @override
  String get syncButton => 'Sync';

  @override
  String get syncAgain => 'Sync again';

  @override
  String get stepsToday => 'steps today';

  @override
  String get activeKcal => 'active kcal';

  @override
  String newWeightFetched(String kg) {
    return 'New weight fetched: $kg kg';
  }

  @override
  String get weightSourceManual => 'manual';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Health';

  @override
  String get weightSourceBluetoothScale => 'BT scale';

  @override
  String get addWeightTitle => 'Add weight';

  @override
  String get editWeightTitle => 'Edit weight';

  @override
  String get weighInDateHelp => 'Weigh-in date';

  @override
  String get weighInTimeHelp => 'Weigh-in time';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get chooseARecipe => 'Choose a recipe';

  @override
  String get newRecipe => 'New recipe';

  @override
  String get editRecipe => 'Edit recipe';

  @override
  String get noRecipesYet =>
      'You haven\'t saved any recipes yet. Add one using the button below.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings servings · $kcal kcal/serving';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name was added today.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Add \"$name\" to:';
  }

  @override
  String get recipeNameLabel => 'Recipe name';

  @override
  String get recipeNameHint => 'e.g. My chicken salad';

  @override
  String get numberOfServings => 'Number of servings';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get addAtLeastOneIngredient => 'Add at least one ingredient.';

  @override
  String get saveRecipe => 'Save recipe';

  @override
  String perServing(int grams, int kcal) {
    return 'Per serving ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Protein $protein · Carbs $carbs · Fat $fat';
  }

  @override
  String get addIngredientTitle => 'Add ingredient';

  @override
  String get productNameLabel => 'Product name';

  @override
  String get noProductFound => 'No product found.';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get addIngredientButton => 'Add ingredient';

  @override
  String addFoodTitle(String meal) {
    return 'Add food — $meal';
  }

  @override
  String get productNameHint => 'e.g. Greek yogurt';

  @override
  String get enterProductName => 'Enter the product name';

  @override
  String get frequentlyLogged => 'Frequently logged';

  @override
  String addCount(int count) {
    return 'Add ($count)';
  }

  @override
  String get calorieIndexLabel => 'Calorie index (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Quantity eaten';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidValue => 'Invalid value';

  @override
  String get searchFailedCheckConnection =>
      'The search couldn\'t be completed (check your connection).';

  @override
  String get addProductManually => 'Add product manually';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'C';

  @override
  String get macroFatShort => 'F';

  @override
  String get macrosUnavailable => 'Macronutrients unavailable';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Protein $protein · Carbs $carbs · Fat $fat';
  }

  @override
  String get languageDialogTitle => 'Language';

  @override
  String get languageSystemDefault => 'Phone language (default)';

  @override
  String get languageMenuEntry => 'Language';
}

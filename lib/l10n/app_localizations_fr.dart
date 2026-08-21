// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'N\'oubliez pas de noter vos repas';

  @override
  String get dailyReminderBody =>
      'Quelques secondes suffisent pour garder votre journal à jour et votre série active.';

  @override
  String get dailyReminderChannelName => 'Rappel quotidien';

  @override
  String get dailyReminderChannelDescription =>
      'Rappel pour noter les repas du jour';

  @override
  String get updateRequiredTitle => 'Une mise à jour est nécessaire';

  @override
  String get updateRequiredMessage =>
      'La version de l\'application sur ce téléphone n\'est plus prise en charge. Installez la dernière version pour continuer.';

  @override
  String get updateAvailableMessage =>
      'Une nouvelle version de l\'application est disponible.';

  @override
  String get hydrationTitle => 'Hydratation';

  @override
  String get hydrationUndoLastGlass => 'Annuler le dernier verre';

  @override
  String hydrationAddGlass(int ml) {
    return 'Ajouter un verre ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'DEJ adaptatif';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Pas encore assez de données : il faut au moins 14 jours enregistrés et 2 pesées espacées d\'au moins 10 jours, dans les 3 dernières semaines. En attendant, la formule standard (Mifflin-St Jeor) est utilisée.';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Calculé à partir de votre propre bilan calorique ($loggedDays/$windowDays jours enregistrés lors des 3 dernières semaines), pas seulement de la formule standard.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'DEJ estimé';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Tendance de poids';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/semaine';
  }

  @override
  String get adaptiveTdeeRejected =>
      'L\'estimation diffère trop de la formule standard pour être fiable pour l\'instant — la formule standard reste utilisée, jusqu\'à ce que des données plus cohérentes s\'accumulent.';

  @override
  String get weeklySummaryTitle => 'Résumé de la semaine';

  @override
  String get weeklySummaryDaysLogged => 'Jours enregistrés';

  @override
  String get weeklySummaryAvgCalories => 'Kcal/jour moy.';

  @override
  String get weeklySummaryWorkouts => 'Séances';

  @override
  String get weightEvolutionTitle => 'Évolution du poids';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Du $date ($startKg kg) à aujourd\'hui ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Capacité de capture de profondeur';

  @override
  String deviceCapabilityError(String error) {
    return 'Erreur lors de la vérification des capacités :\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR disponible';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth disponible';

  @override
  String get depthSourcePortraitLabel => 'Double caméra (profondeur portrait)';

  @override
  String get depthSourceReferenceLabel => 'Aucun capteur de profondeur';

  @override
  String get depthSourceUnknownLabel => 'Inconnu';

  @override
  String get depthSourceLidarDescription =>
      'Estimation volumétrique haute précision (~10-15 % d\'erreur).';

  @override
  String get depthSourceArcoreDescription =>
      'Estimation volumétrique via l\'API ARCore Depth.';

  @override
  String get depthSourcePortraitDescription =>
      'Profondeur approximative via la double caméra, précision plus faible.';

  @override
  String get depthSourceReferenceDescription =>
      'Le diamètre de l\'assiette sera utilisé comme référence d\'échelle (estimation moins précise).';

  @override
  String get depthSourceUnknownDescription =>
      'Impossible de déterminer la capacité de l\'appareil.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'double caméra';

  @override
  String get depthSourceReferenceShort => 'référence visuelle';

  @override
  String get depthSourceUnknownShort => 'inconnu';

  @override
  String get howItWorksTitle => 'Comment nous calculons les calories';

  @override
  String get howItWorksTooltip => 'Comment calculons-nous les calories ?';

  @override
  String get howItWorksIntro =>
      'La plupart des applications nutritionnelles devinent la portion à partir d\'une seule photo 2D. Calorii Fit mesure réellement le volume des aliments dans l\'assiette, grâce à la carte de profondeur de votre téléphone — c\'est pourquoi l\'estimation est plus précise.';

  @override
  String get howItWorksStep1Title => 'Photographiez votre assiette';

  @override
  String get howItWorksStep1Description =>
      'Une seule photo, aucun positionnement particulier.';

  @override
  String get howItWorksStep2Title => 'Votre téléphone capture la profondeur';

  @override
  String get howItWorksStep2GenericDescription =>
      'Votre téléphone utilise le LiDAR, l\'ARCore Depth ou une double caméra, selon le modèle, pour savoir la hauteur des aliments, pas seulement leur apparence vue de dessus.';

  @override
  String get howItWorksStep3Title => 'Claude identifie les aliments';

  @override
  String get howItWorksStep3Description =>
      'Le modèle reconnaît ce qui se trouve dans l\'assiette et marque le contour approximatif de chaque aliment — il ne calcule pas lui-même les calories, il identifie seulement.';

  @override
  String get howItWorksStep4Title =>
      'Le volume devient des grammes, puis des calories';

  @override
  String get howItWorksStep4Description =>
      'La carte de profondeur × le contour de chaque aliment donne un volume en cm³. Une table de densités (spécifique à chaque type d\'aliment) convertit le volume en grammes, et la base nutritionnelle convertit les grammes en calories et macronutriments.';

  @override
  String get howItWorksStep5Title => 'Vous confirmez ou corrigez';

  @override
  String get howItWorksStep5Description =>
      'L\'estimation automatique n\'est jamais enregistrée directement — vous voyez toujours un écran de confirmation où vous pouvez ajuster la portion ou changer l\'aliment identifié.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Voir la méthode utilisée par votre téléphone';

  @override
  String get howItWorksDepthLidar =>
      'Votre téléphone possède un LiDAR — la méthode la plus précise disponible sur un téléphone aujourd\'hui, avec une erreur typique de seulement 10-15 %.';

  @override
  String get howItWorksDepthArcore =>
      'Votre téléphone utilise l\'API ARCore Depth pour estimer la profondeur de la scène.';

  @override
  String get howItWorksDepthPortrait =>
      'Votre téléphone estime la profondeur via la double caméra (mode portrait) — moins précis que le LiDAR, mais mieux qu\'une simple photo.';

  @override
  String get howItWorksDepthReference =>
      'Votre téléphone n\'a pas de capteur de profondeur, nous utilisons donc le diamètre standard d\'une assiette comme référence d\'échelle — la méthode la moins précise, mais toujours meilleure qu\'une estimation purement visuelle.';

  @override
  String get howItWorksDepthUnknown =>
      'Nous n\'avons pas pu déterminer la méthode utilisée par votre téléphone.';

  @override
  String get reminderPermissionDenied =>
      'Autorisez les notifications pour l\'application dans les réglages de votre téléphone.';

  @override
  String get reminderTimePickerHelp => 'Heure du rappel';

  @override
  String get reminderDialogTitle => 'Rappel quotidien';

  @override
  String get reminderDailyNotification => 'Notification quotidienne';

  @override
  String get reminderDailyNotificationSubtitle =>
      'Un rappel pour noter vos repas';

  @override
  String get reminderTimeLabel => 'Heure';

  @override
  String get close => 'Fermer';

  @override
  String get deleteAccountWrongPassword => 'Mot de passe incorrect.';

  @override
  String deleteAccountFailed(String code) {
    return 'Impossible de supprimer le compte ($code). Réessayez.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Impossible de supprimer le compte. Réessayez.';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountExplanation =>
      'Cette action supprime définitivement votre compte et toutes vos données (profil, journal alimentaire, séances, poids, aliments mémorisés). Cette action est irréversible.';

  @override
  String get password => 'Mot de passe';

  @override
  String get cancel => 'Annuler';

  @override
  String get deleteAccountConfirm => 'Supprimer définitivement';

  @override
  String get barcodeScanTitle => 'Scanner un code-barres';

  @override
  String barcodeNotFound(String barcode) {
    return 'Le produit avec le code $barcode est introuvable.';
  }

  @override
  String get addManually => 'Ajouter manuellement';

  @override
  String get scanAgain => 'Scanner à nouveau';

  @override
  String get bluetoothScaleTitle => 'Balance Bluetooth';

  @override
  String get bluetoothScaleSearch => 'Rechercher des balances';

  @override
  String get bluetoothScaleIdleHint =>
      'Appuyez sur « Rechercher des balances » et allumez votre balance près du téléphone.';

  @override
  String get bluetoothScaleSearching => 'Recherche en cours...';

  @override
  String get bluetoothScaleNoneFound =>
      'Aucune balance trouvée pour l\'instant.';

  @override
  String get bluetoothScaleConnecting => 'Connexion...';

  @override
  String get bluetoothScaleWeightSaved => 'Poids enregistré.';

  @override
  String errorPrefixed(String message) {
    return 'Erreur : $message';
  }

  @override
  String get cameraNoneAvailable =>
      'Aucune caméra disponible sur cet appareil.';

  @override
  String get cameraCaptureTitle => 'Photographiez votre assiette';

  @override
  String get cameraCapturingStatus =>
      'Capture de la photo et de la profondeur…';

  @override
  String get cameraAnalyzingStatus => 'Identification des aliments…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Terminé — ouverture de la confirmation…';

  @override
  String get cameraStartingStatus => 'Démarrage de la caméra…';

  @override
  String get cameraFrameHint =>
      'Cadrez l\'assiette et appuyez sur le déclencheur';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Impossible de démarrer/analyser la photo :\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Vous avez atteint la limite quotidienne d\'analyses photo. Activez premium pour plus d\'analyses par jour.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Vous devez être connecté pour analyser une photo.';

  @override
  String get cameraNetworkErrorMessage =>
      'Impossible de se connecter. Vérifiez votre connexion internet et réessayez.';

  @override
  String get retry => 'Réessayer';

  @override
  String get authEnterEmailFirst =>
      'Entrez d\'abord votre email, pour que nous puissions vous envoyer le lien de réinitialisation.';

  @override
  String get authPasswordResetSent =>
      'Nous vous avons envoyé un email de réinitialisation du mot de passe.';

  @override
  String get authErrorInvalidEmail => 'Adresse email invalide.';

  @override
  String get authErrorUserNotFound => 'Aucun compte n\'existe avec cet email.';

  @override
  String get authErrorWrongCredentials => 'Email ou mot de passe incorrect.';

  @override
  String get authErrorEmailInUse => 'Un compte avec cet email existe déjà.';

  @override
  String get authErrorWeakPassword =>
      'Le mot de passe est trop faible (minimum 6 caractères).';

  @override
  String get authErrorGeneric => 'Une erreur s\'est produite. Réessayez.';

  @override
  String get authWelcomeBack => 'Content de vous revoir';

  @override
  String get authLetsStart => 'Commençons';

  @override
  String get email => 'Email';

  @override
  String get authEnterValidEmail => 'Entrez un email valide';

  @override
  String get authPasswordMinLength => 'Minimum 6 caractères';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authCreateAccount => 'Créer un compte';

  @override
  String get authNoAccountYet => 'Pas de compte ? Créez-en un';

  @override
  String get authHaveAccountAlready => 'Déjà un compte ? Connectez-vous';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get activityWalkingCasual => 'Marche (tranquille)';

  @override
  String get activityWalkingBrisk => 'Marche (rapide)';

  @override
  String get activityRunning => 'Course à pied';

  @override
  String get activityRunningFast => 'Course à pied (rapide)';

  @override
  String get activityCycling => 'Vélo (modéré)';

  @override
  String get activityCyclingIntense => 'Vélo (intense)';

  @override
  String get activitySwimming => 'Natation';

  @override
  String get activityStrengthTraining => 'Musculation';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Danse';

  @override
  String get activityHiking => 'Randonnée';

  @override
  String get activityJumpRope => 'Corde à sauter';

  @override
  String get activityFootball => 'Football';

  @override
  String get activityBasketball => 'Basketball';

  @override
  String get activityTennis => 'Tennis';

  @override
  String get activityOther => 'Autre activité';

  @override
  String get mealBreakfast => 'Petit-déjeuner';

  @override
  String get mealLunch => 'Déjeuner';

  @override
  String get mealDinner => 'Dîner';

  @override
  String get mealSnack => 'Collation';

  @override
  String get addWorkoutTitle => 'Ajouter une séance';

  @override
  String get addWorkoutFromActivity => 'Depuis une activité';

  @override
  String get addWorkoutDirectCalories => 'Calories directes';

  @override
  String get addWorkoutActivityTypeOptional => 'Type d\'activité (optionnel)';

  @override
  String get addWorkoutCaloriesBurned => 'Calories brûlées';

  @override
  String get addWorkoutCaloriesHint => 'p. ex. 250';

  @override
  String get save => 'Enregistrer';

  @override
  String get addWorkoutActivityType => 'Type d\'activité';

  @override
  String get addWorkoutDuration => 'Durée';

  @override
  String get minutes => 'minutes';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Estimation : $kcal kcal brûlées';
  }

  @override
  String get confirmFoodsTitle => 'Confirmer les aliments';

  @override
  String get mealLabel => 'Repas :';

  @override
  String get mixedPlateWarning =>
      'Assiette avec aliments mixtes — vérifiez chaque élément, l\'identification peut être moins précise.';

  @override
  String get noItemsLeft =>
      'Vous avez retiré tous les éléments identifiés. Prenez une nouvelle photo si vous voulez réessayer.';

  @override
  String get portionSmall => 'Petite';

  @override
  String get portionMedium => 'Moyenne';

  @override
  String get portionLarge => 'Grande';

  @override
  String get notOnPlateRemove => 'Pas dans l\'assiette — retirer';

  @override
  String roughEstimateNote(String source) {
    return 'Estimation approximative ($source, sans capteur de profondeur)';
  }

  @override
  String get realNutritionDataBadge => 'données réelles';

  @override
  String totalCalories(int kcal) {
    return 'Total : $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Sédentaire (travail de bureau, pas d\'exercice)';

  @override
  String get activityLevelLight =>
      'Activité légère (exercice 1-3 jours/semaine)';

  @override
  String get activityLevelModerate =>
      'Activité modérée (exercice 3-5 jours/semaine)';

  @override
  String get activityLevelActive => 'Actif (exercice 6-7 jours/semaine)';

  @override
  String get activityLevelVeryActive =>
      'Très actif (exercice intense quotidien / travail physique)';

  @override
  String get goalLose => 'Perdre du poids';

  @override
  String get goalMaintain => 'Maintenir';

  @override
  String get goalGain => 'Prendre du muscle';

  @override
  String get progressPeriod7Days => '7 jours';

  @override
  String get progressPeriod30Days => '30 jours';

  @override
  String get progressPeriodWholeProgram => 'Programme entier';

  @override
  String get nutrientVitaminC => 'Vitamine C';

  @override
  String get nutrientVitaminD => 'Vitamine D';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientIron => 'Fer';

  @override
  String get nutrientMagnesium => 'Magnésium';

  @override
  String get nutrientPotassium => 'Potassium';

  @override
  String get macroProtein => 'Protéines';

  @override
  String get macroCarbs => 'Glucides';

  @override
  String get macroFat => 'Lipides';

  @override
  String onboardingAgeTooLow(int age) {
    return 'L\'application est destinée aux personnes de $age ans et plus.';
  }

  @override
  String get onboardingAgeInvalid => 'Valeur invalide.';

  @override
  String get onboardingAgeSexTitle => 'Âge et sexe biologique';

  @override
  String get age => 'Âge';

  @override
  String get years => 'ans';

  @override
  String get sexFemale => 'Féminin';

  @override
  String get sexMale => 'Masculin';

  @override
  String get onboardingSexHint =>
      'Utilisé uniquement pour calculer le métabolisme de base (formule Mifflin-St Jeor).';

  @override
  String get onboardingHeightWeightTitle => 'Taille et poids actuel';

  @override
  String get height => 'Taille';

  @override
  String get weight => 'Poids';

  @override
  String get onboardingActivityTitle => 'Niveau d\'activité physique';

  @override
  String get onboardingGoalTitle => 'Quel est votre objectif ?';

  @override
  String get onboardingLossRate => 'Rythme de perte souhaité';

  @override
  String get onboardingGainRate => 'Rythme de prise souhaité';

  @override
  String get kgPerWeek => 'kg/semaine';

  @override
  String get onboardingRateRecommendation =>
      'Recommandé : 0,25-0,75 kg/semaine pour un rythme durable.';

  @override
  String get programStartDateLabel => 'Date de début du régime';

  @override
  String get programStartDateHint =>
      'Différente de la date de création du compte — c\'est le point de départ pour mesurer les progrès.';

  @override
  String get disclaimerTitle => 'Avant de commencer';

  @override
  String get disclaimerIntro =>
      'Calorii Fit estime vos besoins caloriques et votre rythme de perte de poids selon des formules généralement admises (Mifflin-St Jeor), pas une évaluation médicale individuelle.';

  @override
  String get disclaimerMedical =>
      'Cela ne remplace pas les conseils d\'un médecin ou d\'un diététicien — surtout si vous avez une condition médicale, êtes enceinte ou allaitez.';

  @override
  String get disclaimerAllergens =>
      'L\'identification des aliments à partir d\'une photo ne détecte pas les allergènes. Si vous avez une allergie ou une intolérance sévère, vérifiez toujours vous-même les ingrédients — ne comptez pas sur l\'application pour cela.';

  @override
  String get disclaimerEatingDisorders =>
      'Si vous avez eu ou avez une relation difficile avec la nourriture (troubles alimentaires), parlez-en à un médecin avant de suivre les calories — l\'application n\'est pas conçue pour remplacer ce soutien.';

  @override
  String get disclaimerAcceptLabel =>
      'Je comprends et j\'accepte d\'utiliser l\'application en tenant compte de cela.';

  @override
  String get finish => 'Terminer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get progress => 'Progrès';

  @override
  String get activityAndSync => 'Activité et synchronisation';

  @override
  String get editProfileGoal => 'Modifier le profil/objectif';

  @override
  String get checkDeviceCapability => 'Vérifier la capacité de l\'appareil';

  @override
  String get myRecipes => 'Mes recettes';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get previousDay => 'Jour précédent';

  @override
  String get nextDay => 'Jour suivant';

  @override
  String get pickDayHelp => 'Choisir un jour';

  @override
  String dateToday(String date) {
    return 'Aujourd\'hui, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Hier, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Demain, $date';
  }

  @override
  String get setUpYourGoal => 'Configurez votre objectif';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal aujourd\'hui';
  }

  @override
  String get setUp => 'Configurer';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Objectif : $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Déficit calorique';

  @override
  String get totalBurnedLabel => 'Total brûlé';

  @override
  String get totalConsumedLabel => 'Total consommé';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Vous avez dépassé la limite de $overBy kcal (au-delà de $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Ne dépassez pas $kcal kcal, pour atteindre votre rythme de perte cible.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Vous avez besoin d\'au moins $kcal kcal pour votre rythme de prise cible.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Restez autour de $kcal kcal pour maintenir.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Recommandé : $low–$high kcal';
  }

  @override
  String get addFood => 'Ajouter un aliment';

  @override
  String get sportActivity => 'Activité physique';

  @override
  String get manualCaloriesEntered => 'Calories saisies manuellement';

  @override
  String get addActivity => 'Ajouter une activité';

  @override
  String get caloricIntake => 'Apport calorique';

  @override
  String get dailyCaloricDeficit => 'Déficit calorique quotidien';

  @override
  String get setUpProfileFirst =>
      'Configurez d\'abord votre profil et objectif depuis le menu.';

  @override
  String get totalCaloriesLabel => 'Total des calories';

  @override
  String get avgPerDay => 'Moy./jour';

  @override
  String get estimatedLoss => 'Perte estimée';

  @override
  String get macroBalanceTitle => 'Équilibre des macronutriments';

  @override
  String get macroBalanceNoData =>
      'Aucun aliment avec protéines/glucides/lipides connus sur cette période.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share % (recommandé $min-$max %)';
  }

  @override
  String get micronutrientsTitle => 'Micronutriments (moy./jour)';

  @override
  String get micronutrientsNoData =>
      'Aucun aliment avec données vitamines/minéraux sur cette période — voir la note ci-dessous.';

  @override
  String get micronutrientsNoEntries =>
      'Aucun aliment enregistré sur cette période.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Données vitamines/minéraux disponibles pour $pct % des aliments enregistrés ($withData/$total) — le reste (cuisine maison, produits non étiquetés) n\'a pas de données connues et n\'est pas inclus dans la moyenne.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent % de la valeur journalière';
  }

  @override
  String get chartTargetLabel => 'Objectif';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Santé';

  @override
  String get healthConnectDescription =>
      'Récupère le poids et l\'activité physique enregistrés par votre montre, via la plateforme santé de votre téléphone.';

  @override
  String get bluetoothScaleSubtitle =>
      'Connectez directement une balance intelligente';

  @override
  String get weightHistoryTitle => 'Historique du poids';

  @override
  String get addLabel => 'Ajouter';

  @override
  String get noEntriesYet => 'Aucune entrée pour l\'instant.';

  @override
  String get syncButton => 'Synchroniser';

  @override
  String get syncAgain => 'Synchroniser à nouveau';

  @override
  String get stepsToday => 'pas aujourd\'hui';

  @override
  String get activeKcal => 'kcal actives';

  @override
  String newWeightFetched(String kg) {
    return 'Nouveau poids récupéré : $kg kg';
  }

  @override
  String newWorkoutsImported(int count) {
    return '$count nouvelles séances importées depuis votre montre.';
  }

  @override
  String get weightSourceManual => 'manuel';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Santé';

  @override
  String get weightSourceBluetoothScale => 'Balance BT';

  @override
  String get addWeightTitle => 'Ajouter un poids';

  @override
  String get editWeightTitle => 'Modifier le poids';

  @override
  String get weighInDateHelp => 'Date de pesée';

  @override
  String get weighInTimeHelp => 'Heure de pesée';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get chooseARecipe => 'Choisir une recette';

  @override
  String get newRecipe => 'Nouvelle recette';

  @override
  String get editRecipe => 'Modifier la recette';

  @override
  String get noRecipesYet =>
      'Vous n\'avez pas encore enregistré de recettes. Ajoutez-en une avec le bouton ci-dessous.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings portions · $kcal kcal/portion';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name a été ajouté aujourd\'hui.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Ajouter « $name » à :';
  }

  @override
  String get recipeNameLabel => 'Nom de la recette';

  @override
  String get recipeNameHint => 'p. ex. Ma salade au poulet';

  @override
  String get numberOfServings => 'Nombre de portions';

  @override
  String get ingredients => 'Ingrédients';

  @override
  String get addAtLeastOneIngredient => 'Ajoutez au moins un ingrédient.';

  @override
  String get saveRecipe => 'Enregistrer la recette';

  @override
  String perServing(int grams, int kcal) {
    return 'Par portion ($grams g) : $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Protéines $protein · Glucides $carbs · Lipides $fat';
  }

  @override
  String get addIngredientTitle => 'Ajouter un ingrédient';

  @override
  String get productNameLabel => 'Nom du produit';

  @override
  String get noProductFound => 'Aucun produit trouvé.';

  @override
  String get searchWithAiButton => 'Rechercher avec l\'IA';

  @override
  String get notFindingWhatYouWant =>
      'Vous ne trouvez pas ce que vous cherchez ?';

  @override
  String get aiSearchNoResult =>
      'L\'IA n\'a pas trouvé de produit fiable pour cette recherche.';

  @override
  String get aiEstimateBadge => 'estimation IA';

  @override
  String get quantityLabel => 'Quantité';

  @override
  String get addIngredientButton => 'Ajouter l\'ingrédient';

  @override
  String get editIngredientQuantityTitle => 'Modifier la quantité';

  @override
  String get chooseRecipeIconTitle => 'Choisir une icône';

  @override
  String get recipeIconSuggested => 'Suggestion';

  @override
  String get saveAsRecipeTooltip => 'Enregistrer comme recette';

  @override
  String get saveAsRecipeDialogTitle => 'Enregistrer comme nouvelle recette';

  @override
  String recipeSavedConfirmation(String name) {
    return '« $name » a été enregistré dans vos recettes.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Ajouter un aliment — $meal';
  }

  @override
  String get productNameHint => 'p. ex. Yaourt grec';

  @override
  String get enterProductName => 'Entrez le nom du produit';

  @override
  String get frequentlyLogged => 'Fréquemment enregistré';

  @override
  String addCount(int count) {
    return 'Ajouter ($count)';
  }

  @override
  String get calorieIndexLabel => 'Indice calorique (kcal / 100 g)';

  @override
  String get quantityEatenLabel => 'Quantité consommée';

  @override
  String get editGramsDialogTitle => 'Modifier la portion';

  @override
  String get requiredField => 'Champ requis';

  @override
  String get invalidValue => 'Valeur invalide';

  @override
  String get searchFailedCheckConnection =>
      'La recherche n\'a pas abouti (vérifiez votre connexion).';

  @override
  String get addProductManually => 'Ajouter le produit manuellement';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'G';

  @override
  String get macroFatShort => 'L';

  @override
  String get macrosUnavailable => 'Macronutriments indisponibles';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Protéines $protein · Glucides $carbs · Lipides $fat';
  }

  @override
  String get languageDialogTitle => 'Langue';

  @override
  String get languageSystemDefault => 'Langue du téléphone (par défaut)';

  @override
  String get languageMenuEntry => 'Langue';

  @override
  String get guideMenuEntry => 'Guide d\'utilisation';

  @override
  String get guideScreenTitle => 'Guide d\'utilisation';

  @override
  String get guideIntroTitle => 'Qu\'est-ce que Calorii Fit';

  @override
  String get guideIntroBody =>
      'Une application de nutrition qui estime les calories directement à partir d\'une photo de votre assiette, en utilisant le capteur de profondeur de votre téléphone — pas seulement une photo ordinaire. Elle tient aussi un journal complet : repas, sport, hydratation, poids et votre progression vers votre objectif.';

  @override
  String get guidePhotoTitle => 'Estimation par photo';

  @override
  String get guidePhotoBody =>
      'Vous photographiez votre assiette, votre téléphone en mesure le volume grâce au LiDAR, à l\'ARCore Depth ou à une double caméra, et l\'application identifie les aliments et calcule la portion. Vous confirmez ou ajustez le résultat avec un curseur ou des préréglages — rien n\'est enregistré automatiquement. Sans capteur de profondeur, le diamètre de l\'assiette est utilisé comme référence, clairement indiqué comme une estimation approximative.';

  @override
  String get guideLogTitle => 'Journal quotidien';

  @override
  String get guideLogBody =>
      'Quatre repas par jour — Petit-déjeuner, Déjeuner, Dîner, Collation. Ajoutez des aliments par photo, par recherche, en scannant un code-barres, manuellement, depuis vos recettes, ou rapidement depuis une liste à cocher de vos aliments habituels.';

  @override
  String get guideRecipesTitle => 'Mes recettes';

  @override
  String get guideRecipesBody =>
      'Enregistrez une combinaison d\'ingrédients que vous mangez souvent et enregistrez-la en un seul geste. Vous pouvez choisir une icône pour chaque recette (ou accepter la suggestion automatique) et modifier la quantité de n\'importe quel ingrédient à tout moment. Lorsque vous ajoutez plusieurs aliments à la fois, vous pouvez les enregistrer immédiatement comme une nouvelle recette.';

  @override
  String get guideWorkoutsTitle => 'Activité physique';

  @override
  String get guideWorkoutsBody =>
      'Choisissez le type d\'activité et la durée, les calories brûlées sont calculées automatiquement — ou saisissez-les directement si vous les connaissez déjà grâce à une montre connectée. Les calories brûlées sont déduites du budget du jour.';

  @override
  String get guideProgressTitle => 'Progrès';

  @override
  String get guideProgressBody =>
      'Graphiques sur 7 jours, 30 jours ou tout le programme : évolution du poids (lissée), DEJ adaptatif calculé à partir de votre propre bilan énergétique, équilibre des macronutriments et couverture des micronutriments. Synchronisation avec Apple Santé / Health Connect et une balance Bluetooth.';

  @override
  String get guideHydrationTitle => 'Hydratation';

  @override
  String get guideHydrationBody =>
      'Un simple compteur de verres d\'eau quotidien — un geste pour ajouter, un geste pour annuler le dernier.';

  @override
  String get guideStreaksTitle => 'Motivation';

  @override
  String get guideStreaksBody =>
      'Un badge flamme indique combien de jours consécutifs vous avez enregistré au moins un repas.';

  @override
  String get guideRemindersTitle => 'Rappel quotidien';

  @override
  String get guideRemindersBody =>
      'Une notification, à l\'heure que vous choisissez, qui vous rappelle d\'enregistrer vos repas — désactivable à tout moment depuis le menu.';

  @override
  String get guideProfileTitle => 'Profil et objectif';

  @override
  String get guideProfileBody =>
      'Âge, sexe biologique, taille, poids, niveau d\'activité et objectif — modifiables à tout moment. L\'application recalcule automatiquement votre objectif calorique à chaque changement.';

  @override
  String get guidePrivacyTitle => 'Confidentialité';

  @override
  String get guidePrivacyBody =>
      'Vos données sont liées exclusivement à votre compte et ne sont visibles par aucun autre utilisateur. Vous pouvez supprimer votre compte et toutes les données associées à tout moment, depuis le menu — la suppression est permanente et immédiate.';

  @override
  String get guideLanguagesTitle => 'Langues disponibles';

  @override
  String get guideLanguagesBody =>
      'L\'application est disponible en 13 langues, choisies depuis le menu — pas seulement détectées automatiquement à partir de la langue de votre téléphone.';

  @override
  String get guidePremiumTitle => 'Premium et abonnements';

  @override
  String get guidePremiumDraftNote =>
      'Brouillon, non finalisé — le plan ci-dessous n\'est pas encore actif dans l\'application. Il n\'y a actuellement aucun paiement intégré ni limitation de fonctionnalités.';

  @override
  String get guidePremiumFreeBody =>
      'Gratuit, pour toujours : journal alimentaire complet, 20 analyses photo par jour, recettes personnelles illimitées, graphiques de progression de base et synchronisation Apple Santé / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (prix indicatif, non confirmé) : analyses photo illimitées, DEJ adaptatif et micronutriments détaillés, plus un support prioritaire.';

  @override
  String get themeDialogTitle => 'Thème';

  @override
  String get themeSystemDefault => 'Thème du téléphone (par défaut)';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeMenuEntry => 'Thème';

  @override
  String get barcodeToggleTorch => 'Activer/désactiver le flash';

  @override
  String get clearSelection => 'Effacer la sélection';

  @override
  String get accessCodeMenuEntry => 'Code d\'accès';

  @override
  String get adminDashboardMenuEntry => 'Tableau de bord admin';

  @override
  String get accessCodeScreenTitle => 'Code d\'accès';

  @override
  String get premiumCodeFieldLabel => 'Code premium';

  @override
  String get activatePremiumButton => 'Activer premium';

  @override
  String premiumActivatedMessage(String date) {
    return 'Accès premium activé jusqu\'au $date.';
  }

  @override
  String get iAmAdminLink => 'Je suis admin';

  @override
  String get adminPasswordFieldLabel => 'Mot de passe admin';

  @override
  String get adminTotpFieldLabel =>
      'Code de l\'application d\'authentification';

  @override
  String get activateAdminButton => 'Activer admin';

  @override
  String get adminActivatedMessage => 'Compte admin activé.';

  @override
  String get adminDashboardTitle => 'Tableau de bord admin';

  @override
  String get totalUsersLabel => 'Utilisateurs au total';

  @override
  String get activePremiumLabel => 'Premium actif';

  @override
  String get generateCodeSectionTitle => 'Générer un code premium';

  @override
  String get targetEmailLabel => 'E-mail du compte';

  @override
  String get durationDaysLabel => 'Durée (jours)';

  @override
  String get generateCodeButton => 'Générer le code';

  @override
  String get codeGeneratedTitle => 'Code généré';

  @override
  String get generatedCodesSectionTitle => 'Codes générés';

  @override
  String get noCodesGeneratedYet => 'Aucun code généré pour l\'instant.';

  @override
  String get codeStatusPending => 'non utilisé';

  @override
  String get codeStatusRedeemed => 'utilisé';

  @override
  String get codeStatusRevoked => 'révoqué';

  @override
  String durationDaysValue(int days) {
    return '$days jours';
  }

  @override
  String get completeNutritionWithAiTooltip => 'Compléter avec l\'IA';

  @override
  String get nutritionCompletedMessage => 'Données nutritionnelles complétées.';

  @override
  String get aiCompletionNoResult =>
      'L\'IA n\'a pas trouvé de données fiables pour cet aliment.';

  @override
  String bulkNutritionCompletionButton(int count) {
    return 'Compléter avec l\'IA ($count)';
  }

  @override
  String bulkNutritionCompletionProgress(int done, int total) {
    return '$done/$total...';
  }

  @override
  String bulkNutritionCompletionPremiumLocked(int count) {
    return 'Fonction premium ($count aliments)';
  }

  @override
  String bulkNutritionCompletionResult(int completed, int total) {
    return '$completed sur $total aliments complétés.';
  }
}

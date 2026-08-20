// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'No olvides registrar tus comidas';

  @override
  String get dailyReminderBody =>
      'Unos segundos bastan para mantener tu registro actualizado y tu racha viva.';

  @override
  String get dailyReminderChannelName => 'Recordatorio diario';

  @override
  String get dailyReminderChannelDescription =>
      'Recordatorio para registrar las comidas de hoy';

  @override
  String get updateRequiredTitle => 'Se necesita una actualización';

  @override
  String get updateRequiredMessage =>
      'La versión de la app en este teléfono ya no es compatible. Instala la última versión para continuar.';

  @override
  String get updateAvailableMessage =>
      'Hay una nueva versión de la app disponible.';

  @override
  String get hydrationTitle => 'Hidratación';

  @override
  String get hydrationUndoLastGlass => 'Deshacer último vaso';

  @override
  String hydrationAddGlass(int ml) {
    return 'Añadir un vaso ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'GET adaptativo';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Aún no hay suficientes datos: necesitas al menos 14 días registrados y 2 pesajes separados por al menos 10 días, en las últimas 3 semanas. Mientras tanto, se usa la fórmula estándar (Mifflin-St Jeor).';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Calculado a partir de tu propio balance calórico ($loggedDays/$windowDays días registrados en las últimas 3 semanas), no solo de la fórmula estándar.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'GET estimado';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Tendencia de peso';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/semana';
  }

  @override
  String get adaptiveTdeeRejected =>
      'La estimación difiere todavía demasiado de la fórmula estándar para ser fiable — se sigue usando la fórmula estándar, hasta que se acumulen datos más consistentes.';

  @override
  String get weeklySummaryTitle => 'Resumen de la semana';

  @override
  String get weeklySummaryDaysLogged => 'Días registrados';

  @override
  String get weeklySummaryAvgCalories => 'Kcal/día prom.';

  @override
  String get weeklySummaryWorkouts => 'Entrenamientos';

  @override
  String get weightEvolutionTitle => 'Evolución del peso';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Del $date ($startKg kg) a hoy ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Capacidad de captura de profundidad';

  @override
  String deviceCapabilityError(String error) {
    return 'Error al verificar las capacidades:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR disponible';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth disponible';

  @override
  String get depthSourcePortraitLabel => 'Cámara dual (profundidad retrato)';

  @override
  String get depthSourceReferenceLabel => 'Sin sensor de profundidad';

  @override
  String get depthSourceUnknownLabel => 'Desconocido';

  @override
  String get depthSourceLidarDescription =>
      'Estimación volumétrica de alta precisión (~10-15% de error).';

  @override
  String get depthSourceArcoreDescription =>
      'Estimación volumétrica mediante la API ARCore Depth.';

  @override
  String get depthSourcePortraitDescription =>
      'Profundidad aproximada de la cámara dual, precisión menor.';

  @override
  String get depthSourceReferenceDescription =>
      'Se usará el diámetro del plato como referencia de escala (estimación menos precisa).';

  @override
  String get depthSourceUnknownDescription =>
      'No se pudo determinar la capacidad del dispositivo.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'cámara dual';

  @override
  String get depthSourceReferenceShort => 'referencia visual';

  @override
  String get depthSourceUnknownShort => 'desconocido';

  @override
  String get howItWorksTitle => 'Cómo calculamos las calorías';

  @override
  String get howItWorksTooltip => '¿Cómo calculamos las calorías?';

  @override
  String get howItWorksIntro =>
      'La mayoría de las apps de nutrición estiman la porción a partir de una sola foto 2D. Calorii Fit mide realmente el volumen de la comida en el plato, usando el mapa de profundidad de tu teléfono — por eso la estimación es más precisa.';

  @override
  String get howItWorksStep1Title => 'Fotografía tu plato';

  @override
  String get howItWorksStep1Description =>
      'Una sola foto, sin posicionamiento especial.';

  @override
  String get howItWorksStep2Title => 'Tu teléfono capta la profundidad';

  @override
  String get howItWorksStep2GenericDescription =>
      'Tu teléfono usa LiDAR, ARCore Depth o una cámara dual, según el modelo, para saber qué tan alta es la comida, no solo su aspecto desde arriba.';

  @override
  String get howItWorksStep3Title => 'Claude identifica los alimentos';

  @override
  String get howItWorksStep3Description =>
      'El modelo reconoce lo que hay en el plato y marca el contorno aproximado de cada alimento — no calcula las calorías por sí mismo, solo identifica.';

  @override
  String get howItWorksStep4Title =>
      'El volumen se convierte en gramos, luego en calorías';

  @override
  String get howItWorksStep4Description =>
      'El mapa de profundidad × el contorno de cada alimento da un volumen en cm³. Una tabla de densidades (específica para cada tipo de alimento) convierte el volumen en gramos, y la base de datos nutricional convierte los gramos en calorías y macronutrientes.';

  @override
  String get howItWorksStep5Title => 'Confirmas o corriges';

  @override
  String get howItWorksStep5Description =>
      'La estimación automática nunca se guarda directamente — siempre ves una pantalla de confirmación donde puedes ajustar la porción o cambiar el alimento identificado.';

  @override
  String get howItWorksSeeDeviceMethod => 'Ver qué método usa tu teléfono';

  @override
  String get howItWorksDepthLidar =>
      'Tu teléfono tiene LiDAR — el método más preciso disponible hoy en un teléfono, con un error típico de solo 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Tu teléfono usa la API ARCore Depth para estimar la profundidad de la escena.';

  @override
  String get howItWorksDepthPortrait =>
      'Tu teléfono estima la profundidad mediante la cámara dual (modo retrato) — menos preciso que el LiDAR, pero mejor que una foto simple.';

  @override
  String get howItWorksDepthReference =>
      'Tu teléfono no tiene sensor de profundidad, así que usamos el diámetro estándar de un plato como referencia de escala — el método menos preciso, pero aún mejor que una estimación puramente visual.';

  @override
  String get howItWorksDepthUnknown =>
      'No pudimos determinar el método que usa tu teléfono.';

  @override
  String get reminderPermissionDenied =>
      'Permite las notificaciones para la app en la configuración de tu teléfono.';

  @override
  String get reminderTimePickerHelp => 'Hora del recordatorio';

  @override
  String get reminderDialogTitle => 'Recordatorio diario';

  @override
  String get reminderDailyNotification => 'Notificación diaria';

  @override
  String get reminderDailyNotificationSubtitle =>
      'Un recordatorio para registrar tus comidas';

  @override
  String get reminderTimeLabel => 'Hora';

  @override
  String get close => 'Cerrar';

  @override
  String get deleteAccountWrongPassword => 'Contraseña incorrecta.';

  @override
  String deleteAccountFailed(String code) {
    return 'No se pudo eliminar la cuenta ($code). Inténtalo de nuevo.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'No se pudo eliminar la cuenta. Inténtalo de nuevo.';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountExplanation =>
      'Esto elimina permanentemente tu cuenta y todos tus datos (perfil, registro de comidas, entrenamientos, pesos, alimentos recordados). Esta acción no se puede deshacer.';

  @override
  String get password => 'Contraseña';

  @override
  String get cancel => 'Cancelar';

  @override
  String get deleteAccountConfirm => 'Eliminar permanentemente';

  @override
  String get barcodeScanTitle => 'Escanear código de barras';

  @override
  String barcodeNotFound(String barcode) {
    return 'No se encontró el producto con el código $barcode.';
  }

  @override
  String get addManually => 'Añadir manualmente';

  @override
  String get scanAgain => 'Escanear de nuevo';

  @override
  String get bluetoothScaleTitle => 'Báscula Bluetooth';

  @override
  String get bluetoothScaleSearch => 'Buscar básculas';

  @override
  String get bluetoothScaleIdleHint =>
      'Toca \"Buscar básculas\" y enciende tu báscula cerca del teléfono.';

  @override
  String get bluetoothScaleSearching => 'Buscando...';

  @override
  String get bluetoothScaleNoneFound =>
      'Todavía no se encontró ninguna báscula.';

  @override
  String get bluetoothScaleConnecting => 'Conectando...';

  @override
  String get bluetoothScaleWeightSaved => 'Peso guardado.';

  @override
  String errorPrefixed(String message) {
    return 'Error: $message';
  }

  @override
  String get cameraNoneAvailable =>
      'No hay ninguna cámara disponible en este dispositivo.';

  @override
  String get cameraCaptureTitle => 'Fotografía tu plato';

  @override
  String get cameraCapturingStatus => 'Capturando la foto y la profundidad…';

  @override
  String get cameraAnalyzingStatus => 'Identificando los alimentos…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Listo — abriendo la confirmación…';

  @override
  String get cameraStartingStatus => 'Iniciando la cámara…';

  @override
  String get cameraFrameHint => 'Encuadra el plato y toca el disparador';

  @override
  String cameraErrorPrefixed(String message) {
    return 'No se pudo iniciar/analizar la foto:\n$message';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get authEnterEmailFirst =>
      'Introduce primero tu correo, para poder enviarte el enlace de restablecimiento.';

  @override
  String get authPasswordResetSent =>
      'Te hemos enviado un correo para restablecer la contraseña.';

  @override
  String get authErrorInvalidEmail => 'Dirección de correo no válida.';

  @override
  String get authErrorUserNotFound =>
      'No existe ninguna cuenta con este correo.';

  @override
  String get authErrorWrongCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get authErrorEmailInUse => 'Ya existe una cuenta con este correo.';

  @override
  String get authErrorWeakPassword =>
      'La contraseña es demasiado débil (mínimo 6 caracteres).';

  @override
  String get authErrorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get authWelcomeBack => 'Bienvenido de nuevo';

  @override
  String get authLetsStart => 'Empecemos';

  @override
  String get email => 'Correo electrónico';

  @override
  String get authEnterValidEmail => 'Introduce un correo válido';

  @override
  String get authPasswordMinLength => 'Mínimo 6 caracteres';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authNoAccountYet => '¿Sin cuenta? Crea una';

  @override
  String get authHaveAccountAlready => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get activityWalkingCasual => 'Caminar (ligero)';

  @override
  String get activityWalkingBrisk => 'Caminar (rápido)';

  @override
  String get activityRunning => 'Correr';

  @override
  String get activityRunningFast => 'Correr (rápido)';

  @override
  String get activityCycling => 'Ciclismo (moderado)';

  @override
  String get activityCyclingIntense => 'Ciclismo (intenso)';

  @override
  String get activitySwimming => 'Natación';

  @override
  String get activityStrengthTraining => 'Entrenamiento de fuerza';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Baile';

  @override
  String get activityHiking => 'Senderismo';

  @override
  String get activityJumpRope => 'Saltar la cuerda';

  @override
  String get activityFootball => 'Fútbol';

  @override
  String get activityBasketball => 'Baloncesto';

  @override
  String get activityTennis => 'Tenis';

  @override
  String get activityOther => 'Otra actividad';

  @override
  String get mealBreakfast => 'Desayuno';

  @override
  String get mealLunch => 'Almuerzo';

  @override
  String get mealDinner => 'Cena';

  @override
  String get mealSnack => 'Snack';

  @override
  String get addWorkoutTitle => 'Añadir un entrenamiento';

  @override
  String get addWorkoutFromActivity => 'Desde actividad';

  @override
  String get addWorkoutDirectCalories => 'Calorías directas';

  @override
  String get addWorkoutActivityTypeOptional => 'Tipo de actividad (opcional)';

  @override
  String get addWorkoutCaloriesBurned => 'Calorías quemadas';

  @override
  String get addWorkoutCaloriesHint => 'p. ej. 250';

  @override
  String get save => 'Guardar';

  @override
  String get addWorkoutActivityType => 'Tipo de actividad';

  @override
  String get addWorkoutDuration => 'Duración';

  @override
  String get minutes => 'minutos';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Estimación: $kcal kcal quemadas';
  }

  @override
  String get confirmFoodsTitle => 'Confirmar los alimentos';

  @override
  String get mealLabel => 'Comida:';

  @override
  String get mixedPlateWarning =>
      'Plato con alimentos mixtos — revisa cada elemento, la identificación puede ser menos precisa.';

  @override
  String get noItemsLeft =>
      'Eliminaste todos los elementos identificados. Toma una nueva foto si quieres intentarlo de nuevo.';

  @override
  String get portionSmall => 'Pequeña';

  @override
  String get portionMedium => 'Mediana';

  @override
  String get portionLarge => 'Grande';

  @override
  String get notOnPlateRemove => 'No está en el plato — eliminar';

  @override
  String roughEstimateNote(String source) {
    return 'Estimación aproximada ($source, sin sensor de profundidad)';
  }

  @override
  String totalCalories(int kcal) {
    return 'Total: $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Sedentario (trabajo de oficina, sin ejercicio)';

  @override
  String get activityLevelLight =>
      'Actividad ligera (ejercicio 1-3 días/semana)';

  @override
  String get activityLevelModerate =>
      'Actividad moderada (ejercicio 3-5 días/semana)';

  @override
  String get activityLevelActive => 'Activo (ejercicio 6-7 días/semana)';

  @override
  String get activityLevelVeryActive =>
      'Muy activo (ejercicio intenso diario / trabajo físico)';

  @override
  String get goalLose => 'Perder peso';

  @override
  String get goalMaintain => 'Mantener';

  @override
  String get goalGain => 'Ganar músculo';

  @override
  String get progressPeriod7Days => '7 días';

  @override
  String get progressPeriod30Days => '30 días';

  @override
  String get progressPeriodWholeProgram => 'Programa completo';

  @override
  String get nutrientVitaminC => 'Vitamina C';

  @override
  String get nutrientVitaminD => 'Vitamina D';

  @override
  String get nutrientCalcium => 'Calcio';

  @override
  String get nutrientIron => 'Hierro';

  @override
  String get nutrientMagnesium => 'Magnesio';

  @override
  String get nutrientPotassium => 'Potasio';

  @override
  String get macroProtein => 'Proteína';

  @override
  String get macroCarbs => 'Carbohidratos';

  @override
  String get macroFat => 'Grasa';

  @override
  String onboardingAgeTooLow(int age) {
    return 'La app está pensada para personas de $age años en adelante.';
  }

  @override
  String get onboardingAgeInvalid => 'Valor no válido.';

  @override
  String get onboardingAgeSexTitle => 'Edad y sexo biológico';

  @override
  String get age => 'Edad';

  @override
  String get years => 'años';

  @override
  String get sexFemale => 'Femenino';

  @override
  String get sexMale => 'Masculino';

  @override
  String get onboardingSexHint =>
      'Se usa solo para calcular la tasa metabólica basal (fórmula Mifflin-St Jeor).';

  @override
  String get onboardingHeightWeightTitle => 'Altura y peso actual';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get onboardingActivityTitle => 'Nivel de actividad física';

  @override
  String get onboardingGoalTitle => '¿Cuál es tu objetivo?';

  @override
  String get onboardingLossRate => 'Ritmo de pérdida deseado';

  @override
  String get onboardingGainRate => 'Ritmo de ganancia deseado';

  @override
  String get kgPerWeek => 'kg/semana';

  @override
  String get onboardingRateRecommendation =>
      'Recomendado: 0,25-0,75 kg/semana para un ritmo sostenible.';

  @override
  String get disclaimerTitle => 'Antes de empezar';

  @override
  String get disclaimerIntro =>
      'Calorii Fit estima tus necesidades calóricas y ritmo de pérdida de peso según fórmulas generalmente aceptadas (Mifflin-St Jeor), no una evaluación médica individual.';

  @override
  String get disclaimerMedical =>
      'No sustituye el consejo de un médico o dietista — especialmente si tienes una condición médica, estás embarazada o en lactancia.';

  @override
  String get disclaimerAllergens =>
      'La identificación de alimentos a partir de una foto no detecta alérgenos. Si tienes una alergia o intolerancia grave, revisa siempre los ingredientes tú mismo — no confíes en la app para eso.';

  @override
  String get disclaimerEatingDisorders =>
      'Si has tenido o tienes una relación difícil con la comida (trastornos alimentarios), habla con un médico antes de contar calorías — la app no está pensada para sustituir ese apoyo.';

  @override
  String get disclaimerAcceptLabel =>
      'Entiendo y acepto usar la app teniendo esto en cuenta.';

  @override
  String get finish => 'Finalizar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get progress => 'Progreso';

  @override
  String get activityAndSync => 'Actividad y sincronización';

  @override
  String get editProfileGoal => 'Editar perfil/objetivo';

  @override
  String get checkDeviceCapability => 'Verificar capacidad del dispositivo';

  @override
  String get myRecipes => 'Mis recetas';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get takePhoto => 'Tomar una foto';

  @override
  String get previousDay => 'Día anterior';

  @override
  String get nextDay => 'Día siguiente';

  @override
  String get pickDayHelp => 'Elegir un día';

  @override
  String dateToday(String date) {
    return 'Hoy, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Ayer, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Mañana, $date';
  }

  @override
  String get setUpYourGoal => 'Configura tu objetivo';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal hoy';
  }

  @override
  String get setUp => 'Configurar';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Objetivo: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Déficit calórico';

  @override
  String get totalBurnedLabel => 'Total quemado';

  @override
  String get totalConsumedLabel => 'Total consumido';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Superaste el límite en $overBy kcal (más de $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'No superes $kcal kcal, para lograr tu ritmo de pérdida objetivo.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Necesitas al menos $kcal kcal para tu ritmo de ganancia objetivo.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Mantente alrededor de $kcal kcal para mantener el peso.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Recomendado: $low–$high kcal';
  }

  @override
  String get addFood => 'Añadir alimento';

  @override
  String get sportActivity => 'Actividad física';

  @override
  String get manualCaloriesEntered => 'Calorías introducidas manualmente';

  @override
  String get addActivity => 'Añadir actividad';

  @override
  String get caloricIntake => 'Ingesta calórica';

  @override
  String get dailyCaloricDeficit => 'Déficit calórico diario';

  @override
  String get setUpProfileFirst =>
      'Primero configura tu perfil y objetivo desde el menú.';

  @override
  String get totalCaloriesLabel => 'Calorías totales';

  @override
  String get avgPerDay => 'Prom./día';

  @override
  String get estimatedLoss => 'Pérdida estimada';

  @override
  String get macroBalanceTitle => 'Balance de macronutrientes';

  @override
  String get macroBalanceNoData =>
      'Ningún alimento con proteína/carbohidratos/grasa conocidos en este período.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (recomendado $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Micronutrientes (prom./día)';

  @override
  String get micronutrientsNoData =>
      'Ningún alimento con datos de vitaminas/minerales en este período — ver la nota abajo.';

  @override
  String get micronutrientsNoEntries =>
      'No hay alimentos registrados en este período.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Datos de vitaminas/minerales disponibles para el $pct% de los alimentos registrados ($withData/$total) — el resto (comida casera, productos sin etiquetar) no tiene datos conocidos y no se incluye en el promedio.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% del valor diario';
  }

  @override
  String get chartTargetLabel => 'Objetivo';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Salud';

  @override
  String get healthConnectDescription =>
      'Obtiene el peso y la actividad física registrados por tu reloj, a través de la plataforma de salud de tu teléfono.';

  @override
  String get bluetoothScaleSubtitle =>
      'Conecta directamente una báscula inteligente';

  @override
  String get weightHistoryTitle => 'Historial de peso';

  @override
  String get addLabel => 'Añadir';

  @override
  String get noEntriesYet => 'Todavía no hay entradas.';

  @override
  String get syncButton => 'Sincronizar';

  @override
  String get syncAgain => 'Sincronizar de nuevo';

  @override
  String get stepsToday => 'pasos hoy';

  @override
  String get activeKcal => 'kcal activas';

  @override
  String newWeightFetched(String kg) {
    return 'Nuevo peso obtenido: $kg kg';
  }

  @override
  String get weightSourceManual => 'manual';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Salud';

  @override
  String get weightSourceBluetoothScale => 'Báscula BT';

  @override
  String get addWeightTitle => 'Añadir peso';

  @override
  String get editWeightTitle => 'Editar peso';

  @override
  String get weighInDateHelp => 'Fecha del pesaje';

  @override
  String get weighInTimeHelp => 'Hora del pesaje';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get chooseARecipe => 'Elegir una receta';

  @override
  String get newRecipe => 'Nueva receta';

  @override
  String get editRecipe => 'Editar receta';

  @override
  String get noRecipesYet =>
      'Todavía no has guardado recetas. Añade una con el botón de abajo.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings porciones · $kcal kcal/porción';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name se añadió hoy.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Añadir \"$name\" a:';
  }

  @override
  String get recipeNameLabel => 'Nombre de la receta';

  @override
  String get recipeNameHint => 'p. ej. Mi ensalada de pollo';

  @override
  String get numberOfServings => 'Número de porciones';

  @override
  String get ingredients => 'Ingredientes';

  @override
  String get addAtLeastOneIngredient => 'Añade al menos un ingrediente.';

  @override
  String get saveRecipe => 'Guardar receta';

  @override
  String perServing(int grams, int kcal) {
    return 'Por porción ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Proteína $protein · Carbohidratos $carbs · Grasa $fat';
  }

  @override
  String get addIngredientTitle => 'Añadir ingrediente';

  @override
  String get productNameLabel => 'Nombre del producto';

  @override
  String get noProductFound => 'No se encontró ningún producto.';

  @override
  String get quantityLabel => 'Cantidad';

  @override
  String get addIngredientButton => 'Añadir ingrediente';

  @override
  String get editIngredientQuantityTitle => 'Editar cantidad';

  @override
  String get chooseRecipeIconTitle => 'Elegir un icono';

  @override
  String get recipeIconSuggested => 'Sugerido';

  @override
  String get saveAsRecipeTooltip => 'Guardar como receta';

  @override
  String get saveAsRecipeDialogTitle => 'Guardar como receta nueva';

  @override
  String recipeSavedConfirmation(String name) {
    return '\"$name\" se guardó en tus recetas.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Añadir alimento — $meal';
  }

  @override
  String get productNameHint => 'p. ej. Yogur griego';

  @override
  String get enterProductName => 'Introduce el nombre del producto';

  @override
  String get frequentlyLogged => 'Registrado frecuentemente';

  @override
  String addCount(int count) {
    return 'Añadir ($count)';
  }

  @override
  String get calorieIndexLabel => 'Índice calórico (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Cantidad consumida';

  @override
  String get requiredField => 'Campo obligatorio';

  @override
  String get invalidValue => 'Valor no válido';

  @override
  String get searchFailedCheckConnection =>
      'La búsqueda no se pudo completar (revisa tu conexión).';

  @override
  String get addProductManually => 'Añadir producto manualmente';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'C';

  @override
  String get macroFatShort => 'G';

  @override
  String get macrosUnavailable => 'Macronutrientes no disponibles';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Proteína $protein · Carbohidratos $carbs · Grasa $fat';
  }

  @override
  String get languageDialogTitle => 'Idioma';

  @override
  String get languageSystemDefault => 'Idioma del teléfono (predeterminado)';

  @override
  String get languageMenuEntry => 'Idioma';

  @override
  String get guideMenuEntry => 'Guía de uso';

  @override
  String get guideScreenTitle => 'Guía de uso';

  @override
  String get guideIntroTitle => 'Qué es Calorii Fit';

  @override
  String get guideIntroBody =>
      'Una app de nutrición que estima las calorías directamente a partir de una foto de tu plato, usando el sensor de profundidad de tu teléfono, no solo una foto normal. Además, lleva un diario completo: comidas, deporte, hidratación, peso y tu progreso hacia tu objetivo.';

  @override
  String get guidePhotoTitle => 'Estimación por foto';

  @override
  String get guidePhotoBody =>
      'Fotografías tu plato, tu teléfono mide su volumen usando LiDAR, ARCore Depth o una cámara dual, y la app identifica los alimentos y calcula la porción. Confirmas o ajustas el resultado con un control deslizante o preajustes — nada se guarda automáticamente. Sin sensor de profundidad, se usa el diámetro del plato como referencia, marcado claramente como estimación aproximada.';

  @override
  String get guideLogTitle => 'Registro diario';

  @override
  String get guideLogBody =>
      'Cuatro comidas al día — Desayuno, Almuerzo, Cena, Snack. Añade alimentos desde una foto, desde la búsqueda, escaneando un código de barras, manualmente, desde tus recetas o rápidamente desde una lista de tus alimentos habituales.';

  @override
  String get guideRecipesTitle => 'Mis recetas';

  @override
  String get guideRecipesBody =>
      'Guarda una combinación de ingredientes que comes a menudo y regístrala con un solo toque. Puedes elegir un icono para cada receta (o aceptar la sugerencia automática) y editar la cantidad de cualquier ingrediente en cualquier momento. Cuando añades varios alimentos a la vez, puedes guardarlos al instante como una receta nueva.';

  @override
  String get guideWorkoutsTitle => 'Actividad física';

  @override
  String get guideWorkoutsBody =>
      'Eliges el tipo de actividad y la duración, y las calorías quemadas se calculan automáticamente — o las introduces directamente si ya las conoces por un reloj inteligente. Las calorías quemadas se restan del presupuesto del día.';

  @override
  String get guideProgressTitle => 'Progreso';

  @override
  String get guideProgressBody =>
      'Gráficos de 7 días, 30 días o todo el programa: evolución del peso (suavizada), GET adaptativo calculado a partir de tu propio balance energético, balance de macronutrientes y cobertura de micronutrientes. Se sincroniza con Apple Salud / Health Connect y una báscula Bluetooth.';

  @override
  String get guideHydrationTitle => 'Hidratación';

  @override
  String get guideHydrationBody =>
      'Un contador diario simple de vasos de agua — un toque para añadir, un toque para deshacer el último.';

  @override
  String get guideStreaksTitle => 'Motivación';

  @override
  String get guideStreaksBody =>
      'Una insignia de llama muestra cuántos días seguidos has registrado al menos una comida.';

  @override
  String get guideRemindersTitle => 'Recordatorio diario';

  @override
  String get guideRemindersBody =>
      'Una notificación, a la hora que elijas, que te recuerda registrar tus comidas — desactivable en cualquier momento desde el menú.';

  @override
  String get guideProfileTitle => 'Perfil y objetivo';

  @override
  String get guideProfileBody =>
      'Edad, sexo biológico, altura, peso, nivel de actividad y objetivo — editables en cualquier momento. La app recalcula automáticamente tu objetivo calórico con cada cambio.';

  @override
  String get guidePrivacyTitle => 'Privacidad';

  @override
  String get guidePrivacyBody =>
      'Tus datos están vinculados exclusivamente a tu cuenta y no son visibles para otros usuarios. Puedes eliminar tu cuenta y todos los datos asociados en cualquier momento, desde el menú — la eliminación es permanente e inmediata.';

  @override
  String get guideLanguagesTitle => 'Idiomas disponibles';

  @override
  String get guideLanguagesBody =>
      'La app está disponible en 13 idiomas, elegidos desde el menú — no solo detectados automáticamente según el idioma del teléfono.';

  @override
  String get guidePremiumTitle => 'Premium y suscripciones';

  @override
  String get guidePremiumDraftNote =>
      'Borrador, sin finalizar — el plan siguiente aún no está activo en la app. Actualmente no hay pago dentro de la app ni limitación de funciones.';

  @override
  String get guidePremiumFreeBody =>
      'Gratis, para siempre: diario alimentario completo, 20 análisis de fotos al día, recetas propias ilimitadas, gráficos de progreso básicos y sincronización con Apple Salud / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (precio orientativo, sin confirmar): análisis de fotos ilimitados, GET adaptativo y micronutrientes detallados, exportación de datos y soporte prioritario.';
}

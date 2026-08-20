// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Non dimenticare di registrare i tuoi pasti';

  @override
  String get dailyReminderBody =>
      'Bastano pochi secondi per tenere aggiornato il tuo diario e mantenere viva la tua serie.';

  @override
  String get dailyReminderChannelName => 'Promemoria giornaliero';

  @override
  String get dailyReminderChannelDescription =>
      'Promemoria per registrare i pasti di oggi';

  @override
  String get updateRequiredTitle => 'È necessario un aggiornamento';

  @override
  String get updateRequiredMessage =>
      'La versione dell\'app su questo telefono non è più supportata. Installa l\'ultima versione per continuare.';

  @override
  String get updateAvailableMessage =>
      'È disponibile una nuova versione dell\'app.';

  @override
  String get hydrationTitle => 'Idratazione';

  @override
  String get hydrationUndoLastGlass => 'Annulla ultimo bicchiere';

  @override
  String hydrationAddGlass(int ml) {
    return 'Aggiungi un bicchiere ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'TDEE adattivo';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Dati non ancora sufficienti: servono almeno 14 giorni registrati e 2 pesate distanziate di almeno 10 giorni, nelle ultime 3 settimane. Nel frattempo viene usata la formula standard (Mifflin-St Jeor).';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Calcolato dal tuo bilancio calorico effettivo ($loggedDays/$windowDays giorni registrati nelle ultime 3 settimane), non solo dalla formula standard.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'TDEE stimato';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Tendenza del peso';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/settimana';
  }

  @override
  String get adaptiveTdeeRejected =>
      'La stima differisce ancora troppo dalla formula standard per essere affidabile — la formula standard resta in uso, finché non si accumulano dati più coerenti.';

  @override
  String get weeklySummaryTitle => 'Riepilogo della settimana';

  @override
  String get weeklySummaryDaysLogged => 'Giorni registrati';

  @override
  String get weeklySummaryAvgCalories => 'Kcal/giorno medie';

  @override
  String get weeklySummaryWorkouts => 'Allenamenti';

  @override
  String get weightEvolutionTitle => 'Evoluzione del peso';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'Dal $date ($startKg kg) a oggi ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Capacità di rilevamento profondità';

  @override
  String deviceCapabilityError(String error) {
    return 'Errore durante la verifica delle capacità:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR disponibile';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth disponibile';

  @override
  String get depthSourcePortraitLabel =>
      'Doppia fotocamera (profondità ritratto)';

  @override
  String get depthSourceReferenceLabel => 'Nessun sensore di profondità';

  @override
  String get depthSourceUnknownLabel => 'Sconosciuto';

  @override
  String get depthSourceLidarDescription =>
      'Stima volumetrica ad alta precisione (~10-15% di errore).';

  @override
  String get depthSourceArcoreDescription =>
      'Stima volumetrica tramite l\'API ARCore Depth.';

  @override
  String get depthSourcePortraitDescription =>
      'Profondità approssimativa dalla doppia fotocamera, precisione inferiore.';

  @override
  String get depthSourceReferenceDescription =>
      'Il diametro del piatto sarà usato come riferimento di scala (stima meno precisa).';

  @override
  String get depthSourceUnknownDescription =>
      'Impossibile determinare la capacità del dispositivo.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'doppia fotocamera';

  @override
  String get depthSourceReferenceShort => 'riferimento visivo';

  @override
  String get depthSourceUnknownShort => 'sconosciuto';

  @override
  String get howItWorksTitle => 'Come calcoliamo le calorie';

  @override
  String get howItWorksTooltip => 'Come calcoliamo le calorie?';

  @override
  String get howItWorksIntro =>
      'La maggior parte delle app nutrizionali stima la porzione da una singola foto 2D. Calorii Fit misura effettivamente il volume del cibo nel piatto, usando la mappa di profondità del tuo telefono — per questo la stima è più accurata.';

  @override
  String get howItWorksStep1Title => 'Fotografa il tuo piatto';

  @override
  String get howItWorksStep1Description =>
      'Una sola foto, nessun posizionamento speciale.';

  @override
  String get howItWorksStep2Title => 'Il telefono cattura la profondità';

  @override
  String get howItWorksStep2GenericDescription =>
      'Il telefono usa LiDAR, ARCore Depth o una doppia fotocamera, a seconda del modello, per sapere quanto è alto il cibo, non solo come appare dall\'alto.';

  @override
  String get howItWorksStep3Title => 'Claude identifica gli alimenti';

  @override
  String get howItWorksStep3Description =>
      'Il modello riconosce cosa c\'è nel piatto e segna il contorno approssimativo di ogni alimento — non calcola le calorie da solo, identifica soltanto.';

  @override
  String get howItWorksStep4Title => 'Il volume diventa grammi, poi calorie';

  @override
  String get howItWorksStep4Description =>
      'La mappa di profondità × il contorno di ogni alimento dà un volume in cm³. Una tabella delle densità (specifica per ogni tipo di alimento) converte il volume in grammi, e il database nutrizionale converte i grammi in calorie e macronutrienti.';

  @override
  String get howItWorksStep5Title => 'Confermi o correggi';

  @override
  String get howItWorksStep5Description =>
      'La stima automatica non viene mai salvata direttamente — vedi sempre una schermata di conferma dove puoi regolare la porzione o cambiare l\'alimento identificato.';

  @override
  String get howItWorksSeeDeviceMethod =>
      'Vedi quale metodo usa il tuo telefono';

  @override
  String get howItWorksDepthLidar =>
      'Il tuo telefono ha il LiDAR — il metodo più preciso disponibile oggi su un telefono, con un errore tipico di solo il 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Il tuo telefono usa l\'API ARCore Depth per stimare la profondità della scena.';

  @override
  String get howItWorksDepthPortrait =>
      'Il tuo telefono stima la profondità dalla doppia fotocamera (modalità ritratto) — meno preciso del LiDAR, ma comunque meglio di una foto semplice.';

  @override
  String get howItWorksDepthReference =>
      'Il tuo telefono non ha un sensore di profondità, quindi usiamo il diametro standard di un piatto come riferimento di scala — il metodo meno preciso, ma comunque migliore di una stima puramente visiva.';

  @override
  String get howItWorksDepthUnknown =>
      'Non siamo riusciti a determinare il metodo usato dal tuo telefono.';

  @override
  String get reminderPermissionDenied =>
      'Consenti le notifiche per l\'app nelle impostazioni del tuo telefono.';

  @override
  String get reminderTimePickerHelp => 'Orario del promemoria';

  @override
  String get reminderDialogTitle => 'Promemoria giornaliero';

  @override
  String get reminderDailyNotification => 'Notifica giornaliera';

  @override
  String get reminderDailyNotificationSubtitle =>
      'Un promemoria per registrare i tuoi pasti';

  @override
  String get reminderTimeLabel => 'Orario';

  @override
  String get close => 'Chiudi';

  @override
  String get deleteAccountWrongPassword => 'Password errata.';

  @override
  String deleteAccountFailed(String code) {
    return 'Impossibile eliminare l\'account ($code). Riprova.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Impossibile eliminare l\'account. Riprova.';

  @override
  String get deleteAccountTitle => 'Elimina account';

  @override
  String get deleteAccountExplanation =>
      'Questo elimina definitivamente il tuo account e tutti i tuoi dati (profilo, diario alimentare, allenamenti, pesi, alimenti memorizzati). Questa azione non può essere annullata.';

  @override
  String get password => 'Password';

  @override
  String get cancel => 'Annulla';

  @override
  String get deleteAccountConfirm => 'Elimina definitivamente';

  @override
  String get barcodeScanTitle => 'Scansiona codice a barre';

  @override
  String barcodeNotFound(String barcode) {
    return 'Il prodotto con il codice $barcode non è stato trovato.';
  }

  @override
  String get addManually => 'Aggiungi manualmente';

  @override
  String get scanAgain => 'Scansiona di nuovo';

  @override
  String get bluetoothScaleTitle => 'Bilancia Bluetooth';

  @override
  String get bluetoothScaleSearch => 'Cerca bilance';

  @override
  String get bluetoothScaleIdleHint =>
      'Tocca \"Cerca bilance\" e accendi la bilancia vicino al telefono.';

  @override
  String get bluetoothScaleSearching => 'Ricerca in corso...';

  @override
  String get bluetoothScaleNoneFound => 'Nessuna bilancia trovata finora.';

  @override
  String get bluetoothScaleConnecting => 'Connessione...';

  @override
  String get bluetoothScaleWeightSaved => 'Peso salvato.';

  @override
  String errorPrefixed(String message) {
    return 'Errore: $message';
  }

  @override
  String get cameraNoneAvailable =>
      'Nessuna fotocamera disponibile su questo dispositivo.';

  @override
  String get cameraCaptureTitle => 'Fotografa il tuo piatto';

  @override
  String get cameraCapturingStatus =>
      'Acquisizione della foto e della profondità…';

  @override
  String get cameraAnalyzingStatus => 'Identificazione degli alimenti…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Fatto — apertura della conferma…';

  @override
  String get cameraStartingStatus => 'Avvio della fotocamera…';

  @override
  String get cameraFrameHint => 'Inquadra il piatto e tocca lo scatto';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Impossibile avviare/analizzare la foto:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Hai raggiunto il limite di 20 analisi foto al giorno. Riprova domani.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Devi aver effettuato l\'accesso per analizzare una foto.';

  @override
  String get cameraNetworkErrorMessage =>
      'Impossibile connettersi. Controlla la tua connessione internet e riprova.';

  @override
  String get retry => 'Riprova';

  @override
  String get authEnterEmailFirst =>
      'Inserisci prima la tua email, così possiamo inviarti il link di reimpostazione.';

  @override
  String get authPasswordResetSent =>
      'Ti abbiamo inviato un\'email per reimpostare la password.';

  @override
  String get authErrorInvalidEmail => 'Indirizzo email non valido.';

  @override
  String get authErrorUserNotFound =>
      'Non esiste alcun account con questa email.';

  @override
  String get authErrorWrongCredentials => 'Email o password errati.';

  @override
  String get authErrorEmailInUse => 'Esiste già un account con questa email.';

  @override
  String get authErrorWeakPassword =>
      'La password è troppo debole (minimo 6 caratteri).';

  @override
  String get authErrorGeneric => 'Qualcosa è andato storto. Riprova.';

  @override
  String get authWelcomeBack => 'Bentornato';

  @override
  String get authLetsStart => 'Iniziamo';

  @override
  String get email => 'Email';

  @override
  String get authEnterValidEmail => 'Inserisci un\'email valida';

  @override
  String get authPasswordMinLength => 'Minimo 6 caratteri';

  @override
  String get authSignIn => 'Accedi';

  @override
  String get authCreateAccount => 'Crea account';

  @override
  String get authNoAccountYet => 'Nessun account? Creane uno';

  @override
  String get authHaveAccountAlready => 'Hai già un account? Accedi';

  @override
  String get authForgotPassword => 'Password dimenticata?';

  @override
  String get activityWalkingCasual => 'Camminata (leggera)';

  @override
  String get activityWalkingBrisk => 'Camminata (veloce)';

  @override
  String get activityRunning => 'Corsa';

  @override
  String get activityRunningFast => 'Corsa (veloce)';

  @override
  String get activityCycling => 'Ciclismo (moderato)';

  @override
  String get activityCyclingIntense => 'Ciclismo (intenso)';

  @override
  String get activitySwimming => 'Nuoto';

  @override
  String get activityStrengthTraining => 'Allenamento con i pesi';

  @override
  String get activityYoga => 'Yoga';

  @override
  String get activityDancing => 'Ballo';

  @override
  String get activityHiking => 'Escursionismo';

  @override
  String get activityJumpRope => 'Corda per saltare';

  @override
  String get activityFootball => 'Calcio';

  @override
  String get activityBasketball => 'Basket';

  @override
  String get activityTennis => 'Tennis';

  @override
  String get activityOther => 'Altra attività';

  @override
  String get mealBreakfast => 'Colazione';

  @override
  String get mealLunch => 'Pranzo';

  @override
  String get mealDinner => 'Cena';

  @override
  String get mealSnack => 'Spuntino';

  @override
  String get addWorkoutTitle => 'Aggiungi un allenamento';

  @override
  String get addWorkoutFromActivity => 'Da attività';

  @override
  String get addWorkoutDirectCalories => 'Calorie dirette';

  @override
  String get addWorkoutActivityTypeOptional => 'Tipo di attività (opzionale)';

  @override
  String get addWorkoutCaloriesBurned => 'Calorie bruciate';

  @override
  String get addWorkoutCaloriesHint => 'es. 250';

  @override
  String get save => 'Salva';

  @override
  String get addWorkoutActivityType => 'Tipo di attività';

  @override
  String get addWorkoutDuration => 'Durata';

  @override
  String get minutes => 'minuti';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Stima: $kcal kcal bruciate';
  }

  @override
  String get confirmFoodsTitle => 'Conferma gli alimenti';

  @override
  String get mealLabel => 'Pasto:';

  @override
  String get mixedPlateWarning =>
      'Piatto con alimenti misti — controlla ogni elemento, l\'identificazione potrebbe essere meno accurata.';

  @override
  String get noItemsLeft =>
      'Hai rimosso tutti gli elementi identificati. Scatta una nuova foto se vuoi riprovare.';

  @override
  String get portionSmall => 'Piccola';

  @override
  String get portionMedium => 'Media';

  @override
  String get portionLarge => 'Grande';

  @override
  String get notOnPlateRemove => 'Non nel piatto — rimuovi';

  @override
  String roughEstimateNote(String source) {
    return 'Stima approssimativa ($source, senza sensore di profondità)';
  }

  @override
  String totalCalories(int kcal) {
    return 'Totale: $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Sedentario (lavoro d\'ufficio, niente esercizio)';

  @override
  String get activityLevelLight =>
      'Attività leggera (esercizio 1-3 giorni/settimana)';

  @override
  String get activityLevelModerate =>
      'Attività moderata (esercizio 3-5 giorni/settimana)';

  @override
  String get activityLevelActive => 'Attivo (esercizio 6-7 giorni/settimana)';

  @override
  String get activityLevelVeryActive =>
      'Molto attivo (esercizio intenso quotidiano / lavoro fisico)';

  @override
  String get goalLose => 'Perdere peso';

  @override
  String get goalMaintain => 'Mantenere';

  @override
  String get goalGain => 'Aumentare massa muscolare';

  @override
  String get progressPeriod7Days => '7 giorni';

  @override
  String get progressPeriod30Days => '30 giorni';

  @override
  String get progressPeriodWholeProgram => 'Intero programma';

  @override
  String get nutrientVitaminC => 'Vitamina C';

  @override
  String get nutrientVitaminD => 'Vitamina D';

  @override
  String get nutrientCalcium => 'Calcio';

  @override
  String get nutrientIron => 'Ferro';

  @override
  String get nutrientMagnesium => 'Magnesio';

  @override
  String get nutrientPotassium => 'Potassio';

  @override
  String get macroProtein => 'Proteine';

  @override
  String get macroCarbs => 'Carboidrati';

  @override
  String get macroFat => 'Grassi';

  @override
  String onboardingAgeTooLow(int age) {
    return 'L\'app è pensata per persone dai $age anni in su.';
  }

  @override
  String get onboardingAgeInvalid => 'Valore non valido.';

  @override
  String get onboardingAgeSexTitle => 'Età e sesso biologico';

  @override
  String get age => 'Età';

  @override
  String get years => 'anni';

  @override
  String get sexFemale => 'Femminile';

  @override
  String get sexMale => 'Maschile';

  @override
  String get onboardingSexHint =>
      'Usato solo per calcolare il metabolismo basale (formula Mifflin-St Jeor).';

  @override
  String get onboardingHeightWeightTitle => 'Altezza e peso attuale';

  @override
  String get height => 'Altezza';

  @override
  String get weight => 'Peso';

  @override
  String get onboardingActivityTitle => 'Livello di attività fisica';

  @override
  String get onboardingGoalTitle => 'Qual è il tuo obiettivo?';

  @override
  String get onboardingLossRate => 'Ritmo di perdita desiderato';

  @override
  String get onboardingGainRate => 'Ritmo di aumento desiderato';

  @override
  String get kgPerWeek => 'kg/settimana';

  @override
  String get onboardingRateRecommendation =>
      'Consigliato: 0,25-0,75 kg/settimana per un ritmo sostenibile.';

  @override
  String get disclaimerTitle => 'Prima di iniziare';

  @override
  String get disclaimerIntro =>
      'Calorii Fit stima il tuo fabbisogno calorico e il ritmo di perdita di peso in base a formule generalmente accettate (Mifflin-St Jeor), non una valutazione medica individuale.';

  @override
  String get disclaimerMedical =>
      'Non sostituisce il consiglio di un medico o di un dietologo — soprattutto se hai una condizione medica, sei incinta o allatti.';

  @override
  String get disclaimerAllergens =>
      'L\'identificazione degli alimenti da una foto non rileva gli allergeni. Se hai un\'allergia o un\'intolleranza grave, controlla sempre tu stesso gli ingredienti — non affidarti all\'app per questo.';

  @override
  String get disclaimerEatingDisorders =>
      'Se hai avuto o hai un rapporto difficile con il cibo (disturbi alimentari), parlane con un medico prima di contare le calorie — l\'app non è pensata per sostituire quel supporto.';

  @override
  String get disclaimerAcceptLabel =>
      'Capisco e accetto di usare l\'app tenendo conto di questo.';

  @override
  String get finish => 'Fine';

  @override
  String get continueLabel => 'Continua';

  @override
  String get progress => 'Progresso';

  @override
  String get activityAndSync => 'Attività e sincronizzazione';

  @override
  String get editProfileGoal => 'Modifica profilo/obiettivo';

  @override
  String get checkDeviceCapability => 'Verifica capacità del dispositivo';

  @override
  String get myRecipes => 'Le mie ricette';

  @override
  String get signOut => 'Esci';

  @override
  String get takePhoto => 'Scatta una foto';

  @override
  String get previousDay => 'Giorno precedente';

  @override
  String get nextDay => 'Giorno successivo';

  @override
  String get pickDayHelp => 'Scegli un giorno';

  @override
  String dateToday(String date) {
    return 'Oggi, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Ieri, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Domani, $date';
  }

  @override
  String get setUpYourGoal => 'Imposta il tuo obiettivo';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal oggi';
  }

  @override
  String get setUp => 'Imposta';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Obiettivo: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Deficit calorico';

  @override
  String get totalBurnedLabel => 'Totale bruciato';

  @override
  String get totalConsumedLabel => 'Totale consumato';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Hai superato il limite di $overBy kcal (oltre $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Non superare $kcal kcal, per raggiungere il tuo ritmo di perdita target.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Hai bisogno di almeno $kcal kcal per il tuo ritmo di aumento target.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Resta intorno a $kcal kcal per mantenere.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Consigliato: $low–$high kcal';
  }

  @override
  String get addFood => 'Aggiungi alimento';

  @override
  String get sportActivity => 'Attività fisica';

  @override
  String get manualCaloriesEntered => 'Calorie inserite manualmente';

  @override
  String get addActivity => 'Aggiungi attività';

  @override
  String get caloricIntake => 'Apporto calorico';

  @override
  String get dailyCaloricDeficit => 'Deficit calorico giornaliero';

  @override
  String get setUpProfileFirst =>
      'Prima imposta il tuo profilo e obiettivo dal menu.';

  @override
  String get totalCaloriesLabel => 'Calorie totali';

  @override
  String get avgPerDay => 'Media/giorno';

  @override
  String get estimatedLoss => 'Perdita stimata';

  @override
  String get macroBalanceTitle => 'Bilancio dei macronutrienti';

  @override
  String get macroBalanceNoData =>
      'Nessun alimento con proteine/carboidrati/grassi noti in questo periodo.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (consigliato $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Micronutrienti (media/giorno)';

  @override
  String get micronutrientsNoData =>
      'Nessun alimento con dati su vitamine/minerali in questo periodo — vedi la nota sotto.';

  @override
  String get micronutrientsNoEntries =>
      'Nessun alimento registrato in questo periodo.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Dati su vitamine/minerali disponibili per il $pct% degli alimenti registrati ($withData/$total) — il resto (cucina casalinga, prodotti senza etichetta) non ha dati noti e non è incluso nella media.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% del valore giornaliero';
  }

  @override
  String get chartTargetLabel => 'Obiettivo';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Salute';

  @override
  String get healthConnectDescription =>
      'Recupera il peso e l\'attività fisica registrati dal tuo orologio, tramite la piattaforma salute del tuo telefono.';

  @override
  String get bluetoothScaleSubtitle =>
      'Collega direttamente una bilancia smart';

  @override
  String get weightHistoryTitle => 'Cronologia del peso';

  @override
  String get addLabel => 'Aggiungi';

  @override
  String get noEntriesYet => 'Nessuna voce finora.';

  @override
  String get syncButton => 'Sincronizza';

  @override
  String get syncAgain => 'Sincronizza di nuovo';

  @override
  String get stepsToday => 'passi oggi';

  @override
  String get activeKcal => 'kcal attive';

  @override
  String newWeightFetched(String kg) {
    return 'Nuovo peso recuperato: $kg kg';
  }

  @override
  String get weightSourceManual => 'manuale';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Salute';

  @override
  String get weightSourceBluetoothScale => 'Bilancia BT';

  @override
  String get addWeightTitle => 'Aggiungi peso';

  @override
  String get editWeightTitle => 'Modifica peso';

  @override
  String get weighInDateHelp => 'Data della pesata';

  @override
  String get weighInTimeHelp => 'Ora della pesata';

  @override
  String get edit => 'Modifica';

  @override
  String get delete => 'Elimina';

  @override
  String get chooseARecipe => 'Scegli una ricetta';

  @override
  String get newRecipe => 'Nuova ricetta';

  @override
  String get editRecipe => 'Modifica ricetta';

  @override
  String get noRecipesYet =>
      'Non hai ancora salvato ricette. Aggiungine una con il pulsante qui sotto.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings porzioni · $kcal kcal/porzione';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name è stato aggiunto oggi.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Aggiungi \"$name\" a:';
  }

  @override
  String get recipeNameLabel => 'Nome della ricetta';

  @override
  String get recipeNameHint => 'es. La mia insalata di pollo';

  @override
  String get numberOfServings => 'Numero di porzioni';

  @override
  String get ingredients => 'Ingredienti';

  @override
  String get addAtLeastOneIngredient => 'Aggiungi almeno un ingrediente.';

  @override
  String get saveRecipe => 'Salva ricetta';

  @override
  String perServing(int grams, int kcal) {
    return 'Per porzione ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Proteine $protein · Carboidrati $carbs · Grassi $fat';
  }

  @override
  String get addIngredientTitle => 'Aggiungi ingrediente';

  @override
  String get productNameLabel => 'Nome del prodotto';

  @override
  String get noProductFound => 'Nessun prodotto trovato.';

  @override
  String get quantityLabel => 'Quantità';

  @override
  String get addIngredientButton => 'Aggiungi ingrediente';

  @override
  String get editIngredientQuantityTitle => 'Modifica quantità';

  @override
  String get chooseRecipeIconTitle => 'Scegli un\'icona';

  @override
  String get recipeIconSuggested => 'Suggerito';

  @override
  String get saveAsRecipeTooltip => 'Salva come ricetta';

  @override
  String get saveAsRecipeDialogTitle => 'Salva come nuova ricetta';

  @override
  String recipeSavedConfirmation(String name) {
    return '\"$name\" è stata salvata tra le tue ricette.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Aggiungi alimento — $meal';
  }

  @override
  String get productNameHint => 'es. Yogurt greco';

  @override
  String get enterProductName => 'Inserisci il nome del prodotto';

  @override
  String get frequentlyLogged => 'Registrato frequentemente';

  @override
  String addCount(int count) {
    return 'Aggiungi ($count)';
  }

  @override
  String get calorieIndexLabel => 'Indice calorico (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Quantità consumata';

  @override
  String get requiredField => 'Campo obbligatorio';

  @override
  String get invalidValue => 'Valore non valido';

  @override
  String get searchFailedCheckConnection =>
      'La ricerca non è andata a buon fine (controlla la connessione).';

  @override
  String get addProductManually => 'Aggiungi prodotto manualmente';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'C';

  @override
  String get macroFatShort => 'G';

  @override
  String get macrosUnavailable => 'Macronutrienti non disponibili';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Proteine $protein · Carboidrati $carbs · Grassi $fat';
  }

  @override
  String get languageDialogTitle => 'Lingua';

  @override
  String get languageSystemDefault => 'Lingua del telefono (predefinita)';

  @override
  String get languageMenuEntry => 'Lingua';

  @override
  String get guideMenuEntry => 'Guida all\'uso';

  @override
  String get guideScreenTitle => 'Guida all\'uso';

  @override
  String get guideIntroTitle => 'Cos\'è Calorii Fit';

  @override
  String get guideIntroBody =>
      'Un\'app di nutrizione che stima le calorie direttamente da una foto del tuo piatto, usando il sensore di profondità del telefono — non solo una foto normale. Tiene inoltre un diario completo: pasti, sport, idratazione, peso e i tuoi progressi verso l\'obiettivo.';

  @override
  String get guidePhotoTitle => 'Stima dalla fotografia';

  @override
  String get guidePhotoBody =>
      'Fotografi il piatto, il telefono ne misura il volume usando LiDAR, ARCore Depth o una doppia fotocamera, e l\'app identifica gli alimenti e calcola la porzione. Confermi o correggi il risultato con uno slider o preimpostazioni — nulla viene salvato automaticamente. Senza sensore di profondità, si usa il diametro del piatto come riferimento, indicato chiaramente come stima approssimativa.';

  @override
  String get guideLogTitle => 'Diario giornaliero';

  @override
  String get guideLogBody =>
      'Quattro pasti al giorno — Colazione, Pranzo, Cena, Spuntino. Aggiungi alimenti da foto, ricerca, scansione del codice a barre, manualmente, dalle tue ricette o rapidamente da una lista di alimenti abituali.';

  @override
  String get guideRecipesTitle => 'Le mie ricette';

  @override
  String get guideRecipesBody =>
      'Salva una combinazione di ingredienti che mangi spesso e registrala con un solo tocco. Puoi scegliere un\'icona per ogni ricetta (o accettare il suggerimento automatico) e modificare la quantità di qualsiasi ingrediente in qualsiasi momento. Quando aggiungi più alimenti contemporaneamente, puoi salvarli subito come nuova ricetta.';

  @override
  String get guideWorkoutsTitle => 'Attività fisica';

  @override
  String get guideWorkoutsBody =>
      'Scegli il tipo di attività e la durata, le calorie bruciate vengono calcolate automaticamente — oppure inseriscile direttamente se le conosci già da uno smartwatch. Le calorie bruciate vengono sottratte dal budget della giornata.';

  @override
  String get guideProgressTitle => 'Progresso';

  @override
  String get guideProgressBody =>
      'Grafici su 7 giorni, 30 giorni o l\'intero programma: evoluzione del peso (levigata), TDEE adattivo calcolato dal tuo bilancio energetico reale, bilancio dei macronutrienti e copertura dei micronutrienti. Sincronizzazione con Apple Salute / Health Connect e una bilancia Bluetooth.';

  @override
  String get guideHydrationTitle => 'Idratazione';

  @override
  String get guideHydrationBody =>
      'Un semplice contatore giornaliero di bicchieri d\'acqua — un tocco per aggiungere, un tocco per annullare l\'ultimo.';

  @override
  String get guideStreaksTitle => 'Motivazione';

  @override
  String get guideStreaksBody =>
      'Un distintivo a fiamma mostra per quanti giorni consecutivi hai registrato almeno un pasto.';

  @override
  String get guideRemindersTitle => 'Promemoria giornaliero';

  @override
  String get guideRemindersBody =>
      'Una notifica, all\'orario scelto da te, che ti ricorda di registrare i pasti — disattivabile in qualsiasi momento dal menu.';

  @override
  String get guideProfileTitle => 'Profilo e obiettivo';

  @override
  String get guideProfileBody =>
      'Età, sesso biologico, altezza, peso, livello di attività e obiettivo — modificabili in qualsiasi momento. L\'app ricalcola automaticamente l\'obiettivo calorico a ogni modifica.';

  @override
  String get guidePrivacyTitle => 'Privacy';

  @override
  String get guidePrivacyBody =>
      'I tuoi dati sono collegati esclusivamente al tuo account e non sono visibili ad altri utenti. Puoi eliminare il tuo account e tutti i dati associati in qualsiasi momento, dal menu — l\'eliminazione è permanente e immediata.';

  @override
  String get guideLanguagesTitle => 'Lingue disponibili';

  @override
  String get guideLanguagesBody =>
      'L\'app è disponibile in 13 lingue, scelte dal menu — non solo rilevate automaticamente dalla lingua del telefono.';

  @override
  String get guidePremiumTitle => 'Premium e abbonamenti';

  @override
  String get guidePremiumDraftNote =>
      'Bozza, non definitiva — il piano seguente non è ancora attivo nell\'app. Al momento non ci sono pagamenti in-app né limitazioni delle funzionalità.';

  @override
  String get guidePremiumFreeBody =>
      'Gratuito, per sempre: diario alimentare completo, 20 analisi foto al giorno, ricette personali illimitate, grafici di progresso di base e sincronizzazione Apple Salute / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (prezzo indicativo, non confermato): analisi foto illimitate, TDEE adattivo e micronutrienti dettagliati, esportazione dati e assistenza prioritaria.';

  @override
  String get themeDialogTitle => 'Tema';

  @override
  String get themeSystemDefault => 'Tema del telefono (predefinito)';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeMenuEntry => 'Tema';

  @override
  String get barcodeToggleTorch => 'Attiva/disattiva flash';

  @override
  String get clearSelection => 'Cancella selezione';
}

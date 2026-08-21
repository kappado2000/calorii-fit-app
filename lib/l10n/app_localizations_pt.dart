// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Calorii Fit';

  @override
  String get dailyReminderTitle => 'Não se esqueça de registrar suas refeições';

  @override
  String get dailyReminderBody =>
      'Alguns segundos bastam para manter seu diário atualizado e sua sequência viva.';

  @override
  String get dailyReminderChannelName => 'Lembrete diário';

  @override
  String get dailyReminderChannelDescription =>
      'Lembrete para registrar as refeições de hoje';

  @override
  String get updateRequiredTitle => 'É necessária uma atualização';

  @override
  String get updateRequiredMessage =>
      'A versão do aplicativo neste telefone não é mais compatível. Instale a versão mais recente para continuar.';

  @override
  String get updateAvailableMessage =>
      'Uma nova versão do aplicativo está disponível.';

  @override
  String get hydrationTitle => 'Hidratação';

  @override
  String get hydrationUndoLastGlass => 'Desfazer último copo';

  @override
  String hydrationAddGlass(int ml) {
    return 'Adicionar um copo ($ml ml)';
  }

  @override
  String get adaptiveTdeeTitle => 'GET adaptativo';

  @override
  String get adaptiveTdeeNotEnoughData =>
      'Ainda não há dados suficientes: são necessários pelo menos 14 dias registrados e 2 pesagens com pelo menos 10 dias de diferença, nas últimas 3 semanas. Até lá, é usada a fórmula padrão (Mifflin-St Jeor).';

  @override
  String adaptiveTdeeExplanation(int loggedDays, int windowDays) {
    return 'Calculado a partir do seu próprio balanço calórico ($loggedDays/$windowDays dias registrados nas últimas 3 semanas), não apenas da fórmula padrão.';
  }

  @override
  String get adaptiveTdeeEstimatedLabel => 'GET estimado';

  @override
  String get adaptiveTdeeWeightTrendLabel => 'Tendência de peso';

  @override
  String weightTrendValue(String sign, String value) {
    return '$sign$value kg/semana';
  }

  @override
  String get adaptiveTdeeRejected =>
      'A estimativa ainda difere demais da fórmula padrão para ser confiável — a fórmula padrão continua sendo usada, até que dados mais consistentes se acumulem.';

  @override
  String get weeklySummaryTitle => 'Resumo da semana';

  @override
  String get weeklySummaryDaysLogged => 'Dias registrados';

  @override
  String get weeklySummaryAvgCalories => 'Kcal/dia médio';

  @override
  String get weeklySummaryWorkouts => 'Treinos';

  @override
  String get weightEvolutionTitle => 'Evolução do peso';

  @override
  String weightEvolutionSubtitle(String date, String startKg, String latestKg) {
    return 'De $date ($startKg kg) até hoje ($latestKg kg)';
  }

  @override
  String get deviceCapabilityTitle => 'Capacidade de captura de profundidade';

  @override
  String deviceCapabilityError(String error) {
    return 'Erro ao verificar as capacidades:\n$error';
  }

  @override
  String get depthSourceLidarLabel => 'LiDAR disponível';

  @override
  String get depthSourceArcoreLabel => 'ARCore Depth disponível';

  @override
  String get depthSourcePortraitLabel => 'Câmera dupla (profundidade retrato)';

  @override
  String get depthSourceReferenceLabel => 'Sem sensor de profundidade';

  @override
  String get depthSourceUnknownLabel => 'Desconhecido';

  @override
  String get depthSourceLidarDescription =>
      'Estimativa volumétrica de alta precisão (~10-15% de erro).';

  @override
  String get depthSourceArcoreDescription =>
      'Estimativa volumétrica via API ARCore Depth.';

  @override
  String get depthSourcePortraitDescription =>
      'Profundidade aproximada pela câmera dupla, precisão menor.';

  @override
  String get depthSourceReferenceDescription =>
      'O diâmetro do prato será usado como referência de escala (estimativa menos precisa).';

  @override
  String get depthSourceUnknownDescription =>
      'Não foi possível determinar a capacidade do dispositivo.';

  @override
  String get depthSourceLidarShort => 'LiDAR';

  @override
  String get depthSourceArcoreShort => 'ARCore Depth';

  @override
  String get depthSourcePortraitShort => 'câmera dupla';

  @override
  String get depthSourceReferenceShort => 'referência visual';

  @override
  String get depthSourceUnknownShort => 'desconhecido';

  @override
  String get howItWorksTitle => 'Como calculamos as calorias';

  @override
  String get howItWorksTooltip => 'Como calculamos as calorias?';

  @override
  String get howItWorksIntro =>
      'A maioria dos aplicativos de nutrição estima a porção a partir de uma única foto 2D. O Calorii Fit realmente mede o volume da comida no prato, usando o mapa de profundidade do seu telefone — por isso a estimativa é mais precisa.';

  @override
  String get howItWorksStep1Title => 'Fotografe seu prato';

  @override
  String get howItWorksStep1Description =>
      'Uma única foto, sem posicionamento especial.';

  @override
  String get howItWorksStep2Title => 'Seu telefone captura a profundidade';

  @override
  String get howItWorksStep2GenericDescription =>
      'Seu telefone usa LiDAR, ARCore Depth ou câmera dupla, dependendo do modelo, para saber a altura da comida, não apenas sua aparência de cima.';

  @override
  String get howItWorksStep3Title => 'Claude identifica os alimentos';

  @override
  String get howItWorksStep3Description =>
      'O modelo reconhece o que está no prato e marca o contorno aproximado de cada alimento — ele não calcula as calorias, apenas identifica.';

  @override
  String get howItWorksStep4Title => 'O volume vira gramas, depois calorias';

  @override
  String get howItWorksStep4Description =>
      'O mapa de profundidade × o contorno de cada alimento dá um volume em cm³. Uma tabela de densidades (específica para cada tipo de alimento) converte o volume em gramas, e o banco de dados nutricional converte as gramas em calorias e macronutrientes.';

  @override
  String get howItWorksStep5Title => 'Você confirma ou corrige';

  @override
  String get howItWorksStep5Description =>
      'A estimativa automática nunca é salva diretamente — você sempre vê uma tela de confirmação onde pode ajustar a porção ou trocar o alimento identificado.';

  @override
  String get howItWorksSeeDeviceMethod => 'Ver qual método seu telefone usa';

  @override
  String get howItWorksDepthLidar =>
      'Seu telefone tem LiDAR — o método mais preciso disponível hoje em um telefone, com erro típico de apenas 10-15%.';

  @override
  String get howItWorksDepthArcore =>
      'Seu telefone usa a API ARCore Depth para estimar a profundidade da cena.';

  @override
  String get howItWorksDepthPortrait =>
      'Seu telefone estima a profundidade pela câmera dupla (modo retrato) — menos preciso que o LiDAR, mas ainda melhor que uma foto simples.';

  @override
  String get howItWorksDepthReference =>
      'Seu telefone não tem sensor de profundidade, então usamos o diâmetro padrão de um prato como referência de escala — o método menos preciso, mas ainda melhor que uma estimativa puramente visual.';

  @override
  String get howItWorksDepthUnknown =>
      'Não conseguimos determinar o método que seu telefone usa.';

  @override
  String get reminderPermissionDenied =>
      'Permita notificações para o aplicativo nas configurações do seu telefone.';

  @override
  String get reminderTimePickerHelp => 'Horário do lembrete';

  @override
  String get reminderDialogTitle => 'Lembrete diário';

  @override
  String get reminderDailyNotification => 'Notificação diária';

  @override
  String get reminderDailyNotificationSubtitle =>
      'Um lembrete para registrar suas refeições';

  @override
  String get reminderTimeLabel => 'Horário';

  @override
  String get close => 'Fechar';

  @override
  String get deleteAccountWrongPassword => 'Senha incorreta.';

  @override
  String deleteAccountFailed(String code) {
    return 'Não foi possível excluir a conta ($code). Tente novamente.';
  }

  @override
  String get deleteAccountFailedGeneric =>
      'Não foi possível excluir a conta. Tente novamente.';

  @override
  String get deleteAccountTitle => 'Excluir conta';

  @override
  String get deleteAccountExplanation =>
      'Isso exclui permanentemente sua conta e todos os seus dados (perfil, diário alimentar, treinos, pesos, alimentos memorizados). Esta ação não pode ser desfeita.';

  @override
  String get password => 'Senha';

  @override
  String get cancel => 'Cancelar';

  @override
  String get deleteAccountConfirm => 'Excluir permanentemente';

  @override
  String get barcodeScanTitle => 'Escanear código de barras';

  @override
  String barcodeNotFound(String barcode) {
    return 'O produto com o código $barcode não foi encontrado.';
  }

  @override
  String get addManually => 'Adicionar manualmente';

  @override
  String get scanAgain => 'Escanear novamente';

  @override
  String get bluetoothScaleTitle => 'Balança Bluetooth';

  @override
  String get bluetoothScaleSearch => 'Buscar balanças';

  @override
  String get bluetoothScaleIdleHint =>
      'Toque em \"Buscar balanças\" e ligue sua balança perto do telefone.';

  @override
  String get bluetoothScaleSearching => 'Buscando...';

  @override
  String get bluetoothScaleNoneFound => 'Nenhuma balança encontrada ainda.';

  @override
  String get bluetoothScaleConnecting => 'Conectando...';

  @override
  String get bluetoothScaleWeightSaved => 'Peso salvo.';

  @override
  String errorPrefixed(String message) {
    return 'Erro: $message';
  }

  @override
  String get cameraNoneAvailable =>
      'Nenhuma câmera disponível neste dispositivo.';

  @override
  String get cameraCaptureTitle => 'Fotografe seu prato';

  @override
  String get cameraCapturingStatus => 'Capturando a foto e a profundidade…';

  @override
  String get cameraAnalyzingStatus => 'Identificando os alimentos…';

  @override
  String get cameraConfirmationOpeningStatus =>
      'Concluído — abrindo a confirmação…';

  @override
  String get cameraStartingStatus => 'Iniciando a câmera…';

  @override
  String get cameraFrameHint => 'Enquadre o prato e toque no obturador';

  @override
  String cameraErrorPrefixed(String message) {
    return 'Não foi possível iniciar/analisar a foto:\n$message';
  }

  @override
  String get cameraQuotaExceededMessage =>
      'Você atingiu o limite de 20 análises de fotos por dia. Tente novamente amanhã.';

  @override
  String get cameraUnauthenticatedMessage =>
      'Você precisa estar conectado para analisar uma foto.';

  @override
  String get cameraNetworkErrorMessage =>
      'Não foi possível conectar. Verifique sua conexão com a internet e tente novamente.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get authEnterEmailFirst =>
      'Digite seu e-mail primeiro, para que possamos enviar o link de redefinição.';

  @override
  String get authPasswordResetSent =>
      'Enviamos um e-mail de redefinição de senha para você.';

  @override
  String get authErrorInvalidEmail => 'Endereço de e-mail inválido.';

  @override
  String get authErrorUserNotFound => 'Não existe conta com este e-mail.';

  @override
  String get authErrorWrongCredentials => 'E-mail ou senha incorretos.';

  @override
  String get authErrorEmailInUse => 'Já existe uma conta com este e-mail.';

  @override
  String get authErrorWeakPassword =>
      'A senha é muito fraca (mínimo de 6 caracteres).';

  @override
  String get authErrorGeneric => 'Algo deu errado. Tente novamente.';

  @override
  String get authWelcomeBack => 'Bem-vindo de volta';

  @override
  String get authLetsStart => 'Vamos começar';

  @override
  String get email => 'E-mail';

  @override
  String get authEnterValidEmail => 'Digite um e-mail válido';

  @override
  String get authPasswordMinLength => 'Mínimo de 6 caracteres';

  @override
  String get authSignIn => 'Entrar';

  @override
  String get authCreateAccount => 'Criar conta';

  @override
  String get authNoAccountYet => 'Ainda sem conta? Crie uma';

  @override
  String get authHaveAccountAlready => 'Já tem conta? Entrar';

  @override
  String get authForgotPassword => 'Esqueceu sua senha?';

  @override
  String get activityWalkingCasual => 'Caminhada (leve)';

  @override
  String get activityWalkingBrisk => 'Caminhada (rápida)';

  @override
  String get activityRunning => 'Corrida';

  @override
  String get activityRunningFast => 'Corrida (rápida)';

  @override
  String get activityCycling => 'Ciclismo (moderado)';

  @override
  String get activityCyclingIntense => 'Ciclismo (intenso)';

  @override
  String get activitySwimming => 'Natação';

  @override
  String get activityStrengthTraining => 'Musculação';

  @override
  String get activityYoga => 'Ioga';

  @override
  String get activityDancing => 'Dança';

  @override
  String get activityHiking => 'Caminhada em trilha';

  @override
  String get activityJumpRope => 'Pular corda';

  @override
  String get activityFootball => 'Futebol';

  @override
  String get activityBasketball => 'Basquete';

  @override
  String get activityTennis => 'Tênis';

  @override
  String get activityOther => 'Outra atividade';

  @override
  String get mealBreakfast => 'Café da manhã';

  @override
  String get mealLunch => 'Almoço';

  @override
  String get mealDinner => 'Jantar';

  @override
  String get mealSnack => 'Lanche';

  @override
  String get addWorkoutTitle => 'Adicionar treino';

  @override
  String get addWorkoutFromActivity => 'A partir de atividade';

  @override
  String get addWorkoutDirectCalories => 'Calorias diretas';

  @override
  String get addWorkoutActivityTypeOptional => 'Tipo de atividade (opcional)';

  @override
  String get addWorkoutCaloriesBurned => 'Calorias queimadas';

  @override
  String get addWorkoutCaloriesHint => 'ex.: 250';

  @override
  String get save => 'Salvar';

  @override
  String get addWorkoutActivityType => 'Tipo de atividade';

  @override
  String get addWorkoutDuration => 'Duração';

  @override
  String get minutes => 'minutos';

  @override
  String addWorkoutEstimate(int kcal) {
    return 'Estimativa: $kcal kcal queimadas';
  }

  @override
  String get confirmFoodsTitle => 'Confirmar os alimentos';

  @override
  String get mealLabel => 'Refeição:';

  @override
  String get mixedPlateWarning =>
      'Prato com alimentos mistos — verifique cada item, a identificação pode ser menos precisa.';

  @override
  String get noItemsLeft =>
      'Você removeu todos os itens identificados. Tire uma nova foto se quiser tentar novamente.';

  @override
  String get portionSmall => 'Pequena';

  @override
  String get portionMedium => 'Média';

  @override
  String get portionLarge => 'Grande';

  @override
  String get notOnPlateRemove => 'Não está no prato — remover';

  @override
  String roughEstimateNote(String source) {
    return 'Estimativa aproximada ($source, sem sensor de profundidade)';
  }

  @override
  String get realNutritionDataBadge => 'dados reais';

  @override
  String totalCalories(int kcal) {
    return 'Total: $kcal kcal';
  }

  @override
  String get activityLevelSedentary =>
      'Sedentário (trabalho de escritório, sem exercício)';

  @override
  String get activityLevelLight => 'Atividade leve (exercício 1-3 dias/semana)';

  @override
  String get activityLevelModerate =>
      'Atividade moderada (exercício 3-5 dias/semana)';

  @override
  String get activityLevelActive => 'Ativo (exercício 6-7 dias/semana)';

  @override
  String get activityLevelVeryActive =>
      'Muito ativo (exercício intenso diário / trabalho físico)';

  @override
  String get goalLose => 'Perder peso';

  @override
  String get goalMaintain => 'Manter';

  @override
  String get goalGain => 'Ganhar massa muscular';

  @override
  String get progressPeriod7Days => '7 dias';

  @override
  String get progressPeriod30Days => '30 dias';

  @override
  String get progressPeriodWholeProgram => 'Programa inteiro';

  @override
  String get nutrientVitaminC => 'Vitamina C';

  @override
  String get nutrientVitaminD => 'Vitamina D';

  @override
  String get nutrientCalcium => 'Cálcio';

  @override
  String get nutrientIron => 'Ferro';

  @override
  String get nutrientMagnesium => 'Magnésio';

  @override
  String get nutrientPotassium => 'Potássio';

  @override
  String get macroProtein => 'Proteína';

  @override
  String get macroCarbs => 'Carboidratos';

  @override
  String get macroFat => 'Gordura';

  @override
  String onboardingAgeTooLow(int age) {
    return 'O aplicativo é para pessoas de $age anos ou mais.';
  }

  @override
  String get onboardingAgeInvalid => 'Valor inválido.';

  @override
  String get onboardingAgeSexTitle => 'Idade e sexo biológico';

  @override
  String get age => 'Idade';

  @override
  String get years => 'anos';

  @override
  String get sexFemale => 'Feminino';

  @override
  String get sexMale => 'Masculino';

  @override
  String get onboardingSexHint =>
      'Usado apenas para calcular a taxa metabólica basal (fórmula Mifflin-St Jeor).';

  @override
  String get onboardingHeightWeightTitle => 'Altura e peso atual';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get onboardingActivityTitle => 'Nível de atividade física';

  @override
  String get onboardingGoalTitle => 'Qual é o seu objetivo?';

  @override
  String get onboardingLossRate => 'Ritmo de perda desejado';

  @override
  String get onboardingGainRate => 'Ritmo de ganho desejado';

  @override
  String get kgPerWeek => 'kg/semana';

  @override
  String get onboardingRateRecommendation =>
      'Recomendado: 0,25-0,75 kg/semana para um ritmo sustentável.';

  @override
  String get programStartDateLabel => 'Data de início da dieta';

  @override
  String get programStartDateHint =>
      'Diferente da data de criação da conta — é o ponto a partir do qual queres medir o progresso.';

  @override
  String get disclaimerTitle => 'Antes de começar';

  @override
  String get disclaimerIntro =>
      'O Calorii Fit estima suas necessidades calóricas e ritmo de perda de peso com base em fórmulas geralmente aceitas (Mifflin-St Jeor), não uma avaliação médica individual.';

  @override
  String get disclaimerMedical =>
      'Não substitui o conselho de um médico ou nutricionista — especialmente se você tem uma condição médica, está grávida ou amamentando.';

  @override
  String get disclaimerAllergens =>
      'A identificação de alimentos a partir de uma foto não detecta alérgenos. Se você tem alergia ou intolerância grave, sempre verifique os ingredientes você mesmo — não confie no aplicativo para isso.';

  @override
  String get disclaimerEatingDisorders =>
      'Se você teve ou tem uma relação difícil com a comida (transtornos alimentares), converse com um médico antes de contar calorias — o aplicativo não substitui esse apoio.';

  @override
  String get disclaimerAcceptLabel =>
      'Eu entendo e concordo em usar o aplicativo levando isso em conta.';

  @override
  String get finish => 'Concluir';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get progress => 'Progresso';

  @override
  String get activityAndSync => 'Atividade e sincronização';

  @override
  String get editProfileGoal => 'Editar perfil/objetivo';

  @override
  String get checkDeviceCapability => 'Verificar capacidade do dispositivo';

  @override
  String get myRecipes => 'Minhas receitas';

  @override
  String get signOut => 'Sair';

  @override
  String get takePhoto => 'Tirar uma foto';

  @override
  String get previousDay => 'Dia anterior';

  @override
  String get nextDay => 'Próximo dia';

  @override
  String get pickDayHelp => 'Escolher um dia';

  @override
  String dateToday(String date) {
    return 'Hoje, $date';
  }

  @override
  String dateYesterday(String date) {
    return 'Ontem, $date';
  }

  @override
  String dateTomorrow(String date) {
    return 'Amanhã, $date';
  }

  @override
  String get setUpYourGoal => 'Configure seu objetivo';

  @override
  String kcalToday(String kcal) {
    return '$kcal kcal hoje';
  }

  @override
  String get setUp => 'Configurar';

  @override
  String dailyTargetLabel(String kcal) {
    return 'Meta: $kcal kcal';
  }

  @override
  String get calorieDeficit => 'Déficit calórico';

  @override
  String get totalBurnedLabel => 'Total queimado';

  @override
  String get totalConsumedLabel => 'Total consumido';

  @override
  String overLimitCaption(String overBy, String limit) {
    return 'Você excedeu o limite em $overBy kcal (acima de $limit kcal).';
  }

  @override
  String limitCaptionLose(String kcal) {
    return 'Não exceda $kcal kcal, para atingir seu ritmo de perda alvo.';
  }

  @override
  String limitCaptionGain(String kcal) {
    return 'Você precisa de pelo menos $kcal kcal para seu ritmo de ganho alvo.';
  }

  @override
  String limitCaptionMaintain(String kcal) {
    return 'Fique em torno de $kcal kcal para manter.';
  }

  @override
  String recommendedRange(String low, String high) {
    return 'Recomendado: $low–$high kcal';
  }

  @override
  String get addFood => 'Adicionar alimento';

  @override
  String get sportActivity => 'Atividade física';

  @override
  String get manualCaloriesEntered => 'Calorias inseridas manualmente';

  @override
  String get addActivity => 'Adicionar atividade';

  @override
  String get caloricIntake => 'Ingestão calórica';

  @override
  String get dailyCaloricDeficit => 'Déficit calórico diário';

  @override
  String get setUpProfileFirst =>
      'Primeiro configure seu perfil e objetivo no menu.';

  @override
  String get totalCaloriesLabel => 'Calorias totais';

  @override
  String get avgPerDay => 'Média/dia';

  @override
  String get estimatedLoss => 'Perda estimada';

  @override
  String get macroBalanceTitle => 'Balanço de macronutrientes';

  @override
  String get macroBalanceNoData =>
      'Nenhum alimento com proteína/carboidratos/gordura conhecidos neste período.';

  @override
  String macroSharePercent(int share, int min, int max) {
    return '$share% (recomendado $min-$max%)';
  }

  @override
  String get micronutrientsTitle => 'Micronutrientes (média/dia)';

  @override
  String get micronutrientsNoData =>
      'Nenhum alimento com dados de vitaminas/minerais neste período — veja a nota abaixo.';

  @override
  String get micronutrientsNoEntries =>
      'Nenhum alimento registrado neste período.';

  @override
  String micronutrientsCoverage(int pct, int withData, int total) {
    return 'Dados de vitaminas/minerais disponíveis para $pct% dos alimentos registrados ($withData/$total) — o restante (comida caseira, produtos sem rótulo) não tem dados conhecidos e não é incluído na média.';
  }

  @override
  String micronutrientShare(String amount, String unit, int percent) {
    return '$amount $unit · $percent% do valor diário';
  }

  @override
  String get chartTargetLabel => 'Meta';

  @override
  String get healthConnectTitle => 'Health Connect / Apple Saúde';

  @override
  String get healthConnectDescription =>
      'Obtém o peso e a atividade física registrados pelo seu relógio, através da plataforma de saúde do seu telefone.';

  @override
  String get bluetoothScaleSubtitle =>
      'Conecte diretamente uma balança inteligente';

  @override
  String get weightHistoryTitle => 'Histórico de peso';

  @override
  String get addLabel => 'Adicionar';

  @override
  String get noEntriesYet => 'Ainda não há registros.';

  @override
  String get syncButton => 'Sincronizar';

  @override
  String get syncAgain => 'Sincronizar novamente';

  @override
  String get stepsToday => 'passos hoje';

  @override
  String get activeKcal => 'kcal ativas';

  @override
  String newWeightFetched(String kg) {
    return 'Novo peso obtido: $kg kg';
  }

  @override
  String newWorkoutsImported(int count) {
    return '$count novos treinos importados do seu relógio.';
  }

  @override
  String get weightSourceManual => 'manual';

  @override
  String get weightSourceHealthConnect => 'Health Connect';

  @override
  String get weightSourceAppleHealth => 'Apple Saúde';

  @override
  String get weightSourceBluetoothScale => 'Balança BT';

  @override
  String get addWeightTitle => 'Adicionar peso';

  @override
  String get editWeightTitle => 'Editar peso';

  @override
  String get weighInDateHelp => 'Data da pesagem';

  @override
  String get weighInTimeHelp => 'Horário da pesagem';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get chooseARecipe => 'Escolher uma receita';

  @override
  String get newRecipe => 'Nova receita';

  @override
  String get editRecipe => 'Editar receita';

  @override
  String get noRecipesYet =>
      'Você ainda não salvou nenhuma receita. Adicione uma usando o botão abaixo.';

  @override
  String recipeServingsSummary(int servings, int kcal) {
    return '$servings porções · $kcal kcal/porção';
  }

  @override
  String recipeAddedToday(String name) {
    return '$name foi adicionado hoje.';
  }

  @override
  String addRecipeTo(String name) {
    return 'Adicionar \"$name\" a:';
  }

  @override
  String get recipeNameLabel => 'Nome da receita';

  @override
  String get recipeNameHint => 'ex.: Minha salada de frango';

  @override
  String get numberOfServings => 'Número de porções';

  @override
  String get ingredients => 'Ingredientes';

  @override
  String get addAtLeastOneIngredient => 'Adicione pelo menos um ingrediente.';

  @override
  String get saveRecipe => 'Salvar receita';

  @override
  String perServing(int grams, int kcal) {
    return 'Por porção ($grams g): $kcal kcal';
  }

  @override
  String macroSummaryLine(String protein, String carbs, String fat) {
    return 'Proteína $protein · Carboidratos $carbs · Gordura $fat';
  }

  @override
  String get addIngredientTitle => 'Adicionar ingrediente';

  @override
  String get productNameLabel => 'Nome do produto';

  @override
  String get noProductFound => 'Nenhum produto encontrado.';

  @override
  String get searchWithAiButton => 'Pesquisar com IA';

  @override
  String get aiSearchNoResult =>
      'A IA não encontrou um produto fiável para esta pesquisa.';

  @override
  String get aiEstimateBadge => 'estimativa IA';

  @override
  String get quantityLabel => 'Quantidade';

  @override
  String get addIngredientButton => 'Adicionar ingrediente';

  @override
  String get editIngredientQuantityTitle => 'Editar quantidade';

  @override
  String get chooseRecipeIconTitle => 'Escolher um ícone';

  @override
  String get recipeIconSuggested => 'Sugerido';

  @override
  String get saveAsRecipeTooltip => 'Salvar como receita';

  @override
  String get saveAsRecipeDialogTitle => 'Salvar como nova receita';

  @override
  String recipeSavedConfirmation(String name) {
    return '\"$name\" foi salvo nas suas receitas.';
  }

  @override
  String addFoodTitle(String meal) {
    return 'Adicionar alimento — $meal';
  }

  @override
  String get productNameHint => 'ex.: Iogurte grego';

  @override
  String get enterProductName => 'Digite o nome do produto';

  @override
  String get frequentlyLogged => 'Registrado frequentemente';

  @override
  String addCount(int count) {
    return 'Adicionar ($count)';
  }

  @override
  String get calorieIndexLabel => 'Índice calórico (kcal / 100g)';

  @override
  String get quantityEatenLabel => 'Quantidade consumida';

  @override
  String get editGramsDialogTitle => 'Editar porção';

  @override
  String get requiredField => 'Campo obrigatório';

  @override
  String get invalidValue => 'Valor inválido';

  @override
  String get searchFailedCheckConnection =>
      'A busca não pôde ser concluída (verifique sua conexão).';

  @override
  String get addProductManually => 'Adicionar produto manualmente';

  @override
  String get macroProteinShort => 'P';

  @override
  String get macroCarbsShort => 'C';

  @override
  String get macroFatShort => 'G';

  @override
  String get macrosUnavailable => 'Macronutrientes indisponíveis';

  @override
  String gramsPreviewLine(int kcal, String protein, String carbs, String fat) {
    return '$kcal kcal · Proteína $protein · Carboidratos $carbs · Gordura $fat';
  }

  @override
  String get languageDialogTitle => 'Idioma';

  @override
  String get languageSystemDefault => 'Idioma do telefone (padrão)';

  @override
  String get languageMenuEntry => 'Idioma';

  @override
  String get guideMenuEntry => 'Guia de uso';

  @override
  String get guideScreenTitle => 'Guia de uso';

  @override
  String get guideIntroTitle => 'O que é o Calorii Fit';

  @override
  String get guideIntroBody =>
      'Um aplicativo de nutrição que estima as calorias diretamente a partir de uma foto do seu prato, usando o sensor de profundidade do telefone, não apenas uma foto comum. Também mantém um diário completo: refeições, exercícios, hidratação, peso e seu progresso rumo ao objetivo.';

  @override
  String get guidePhotoTitle => 'Estimativa por foto';

  @override
  String get guidePhotoBody =>
      'Você fotografa o prato, o telefone mede seu volume usando LiDAR, ARCore Depth ou câmera dupla, e o app identifica os alimentos e calcula a porção. Você confirma ou ajusta o resultado com um controle deslizante ou predefinições — nada é salvo automaticamente. Sem sensor de profundidade, o diâmetro do prato é usado como referência, marcado claramente como estimativa aproximada.';

  @override
  String get guideLogTitle => 'Diário do dia';

  @override
  String get guideLogBody =>
      'Quatro refeições por dia — Café da manhã, Almoço, Jantar, Lanche. Adicione alimentos por foto, busca, leitura de código de barras, manualmente, das suas receitas ou rapidamente por uma lista de alimentos frequentes.';

  @override
  String get guideRecipesTitle => 'Minhas receitas';

  @override
  String get guideRecipesBody =>
      'Salve uma combinação de ingredientes que você come com frequência e registre-a com um único toque. Você pode escolher um ícone para cada receita (ou aceitar a sugestão automática) e editar a quantidade de qualquer ingrediente a qualquer momento. Ao adicionar vários alimentos de uma vez, você pode salvá-los na hora como uma nova receita.';

  @override
  String get guideWorkoutsTitle => 'Atividade física';

  @override
  String get guideWorkoutsBody =>
      'Escolha o tipo de atividade e a duração, e as calorias queimadas são calculadas automaticamente — ou informe-as diretamente, se já as conhece de um smartwatch. As calorias queimadas são subtraídas do orçamento do dia.';

  @override
  String get guideProgressTitle => 'Progresso';

  @override
  String get guideProgressBody =>
      'Gráficos de 7 dias, 30 dias ou todo o programa: evolução do peso (suavizada), GET adaptativo calculado a partir do seu próprio equilíbrio energético, equilíbrio de macronutrientes e cobertura de micronutrientes. Sincroniza com Apple Saúde / Health Connect e uma balança Bluetooth.';

  @override
  String get guideHydrationTitle => 'Hidratação';

  @override
  String get guideHydrationBody =>
      'Um contador diário simples de copos de água — um toque para adicionar, um toque para desfazer o último.';

  @override
  String get guideStreaksTitle => 'Motivação';

  @override
  String get guideStreaksBody =>
      'Um selo de chama mostra quantos dias seguidos você registrou pelo menos uma refeição.';

  @override
  String get guideRemindersTitle => 'Lembrete diário';

  @override
  String get guideRemindersBody =>
      'Uma notificação, no horário escolhido por você, lembrando de registrar suas refeições — desativável a qualquer momento pelo menu.';

  @override
  String get guideProfileTitle => 'Perfil e objetivo';

  @override
  String get guideProfileBody =>
      'Idade, sexo biológico, altura, peso, nível de atividade e objetivo — editáveis a qualquer momento. O app recalcula automaticamente sua meta calórica a cada alteração.';

  @override
  String get guidePrivacyTitle => 'Privacidade';

  @override
  String get guidePrivacyBody =>
      'Seus dados estão vinculados exclusivamente à sua conta e não são visíveis para outros usuários. Você pode excluir sua conta e todos os dados associados a qualquer momento, pelo menu — a exclusão é permanente e imediata.';

  @override
  String get guideLanguagesTitle => 'Idiomas disponíveis';

  @override
  String get guideLanguagesBody =>
      'O app está disponível em 13 idiomas, escolhidos pelo menu — não apenas detectados automaticamente pelo idioma do telefone.';

  @override
  String get guidePremiumTitle => 'Premium e assinaturas';

  @override
  String get guidePremiumDraftNote =>
      'Rascunho, não finalizado — o plano abaixo ainda não está ativo no app. No momento não há pagamento no app nem limitação de recursos.';

  @override
  String get guidePremiumFreeBody =>
      'Grátis, para sempre: diário alimentar completo, 20 análises de fotos por dia, receitas próprias ilimitadas, gráficos de progresso básicos e sincronização com Apple Saúde / Health Connect.';

  @override
  String get guidePremiumPaidBody =>
      'Premium (preço indicativo, não confirmado): análises de fotos ilimitadas, GET adaptativo e micronutrientes detalhados, além de suporte prioritário.';

  @override
  String get themeDialogTitle => 'Tema';

  @override
  String get themeSystemDefault => 'Tema do telefone (padrão)';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeMenuEntry => 'Tema';

  @override
  String get barcodeToggleTorch => 'Alternar flash';

  @override
  String get clearSelection => 'Limpar seleção';
}

library bestapp_package;

// Services
export 'src/services/api_services.dart';
export 'src/services/nav_services.dart';
export 'src/services/middleware/authreq.dart';
export 'src/services/middleware/cookies.dart';
export 'src/services/middleware/api_logs.dart';
export 'src/models/api_response.dart';

// Widget
export 'src/widgets/cards/be-card-selected.dart';
export 'src/widgets/component/be-separate.dart';

export 'src/widgets/loading/be-load-circular.dart';
export 'src/widgets/loading/be-modal-progress-full.dart';
export 'src/widgets/avatars/be-avatar.dart';
export 'src/widgets/avatars/be-image-cached.dart';
export 'src/widgets/loading/shimmer-loading/shimmer.dart';
export 'src/widgets/loading/shimmer-loading/shimmer-loading.dart';
export 'src/widgets/buttons/be-button.dart';
export 'src/widgets/buttons/be-button-outline.dart';
export 'src/widgets/buttons/be-button-outline-icon.dart';
export 'src/widgets/buttons/be-button-icon.dart';
export 'src/widgets/buttons/progress_button/be_button_progress.dart';
export 'src/widgets/loading/builder_state.dart';
export 'src/widgets/loading/be-shimmer-loading.dart';
export 'src/widgets/loading/pulling_loading.dart';
export 'src/widgets/appbar/be-preferred_appbar.dart';
export 'src/widgets/appbar/be-appbar.dart';
export 'src/widgets/appbar/be-appbar-pref.dart';

export 'src/widgets/inputs/be-input-controller.dart';
export 'src/widgets/inputs/be-input-dropdown-controller.dart';
export 'src/widgets/inputs/be-input-autocomplete-controller.dart';

// Border
export 'src/widgets/component/border/be-border.dart';

// Dialog
export 'src/alerts/be-dialog-snack.dart';
export 'src/alerts/be-dialog-toast.dart';
export 'src/alerts/be-dialog-center.dart';
export 'src/alerts/dialog-utils.dart';

export 'src/models/enums.dart';
export 'src/models/auth_model.dart';

// Formatters
export 'src/formatters/br_telefone_input_formatter.dart';
export 'src/formatters/cep_input_formatter.dart';
export 'src/formatters/cnpj_input_formatter.dart';
export 'src/formatters/computable_formatter.dart';
export 'src/formatters/cpf_input_formatter.dart';
export 'src/formatters/credit_card_formatter.dart';
export 'src/formatters/currency_input_formatter.dart';
export 'src/formatters/date_formatter.dart';
export 'src/formatters/mmyy_formatter.dart';
export 'src/formatters/mmyyyy_formatter.dart';
export 'src/formatters/time_formatter.dart';

// Utils
export 'src/utils/bestapp-utils.dart';
export 'src/utils/colors-fromhex.dart';
export 'src/utils/compress-images.dart';
// export 'src/utils/app_directory.dart'; // WASM-incompatível (usa dart:io + path_provider)
export 'src/utils/getbytes-fromasset.dart';
export 'src/utils/helpers/api_helpers.dart';
export 'src/utils/devices_info.dart';

// Validators
export 'src/validators/cnpj_validator.dart';
export 'src/validators/cpf_validator.dart';

//Exports useful packages
export 'package:dio/dio.dart';
export 'package:email_validator/email_validator.dart';
export 'package:pull_to_refresh/pull_to_refresh.dart';
// export 'package:cached_network_image/cached_network_image.dart'; // WASM-incompatível (flutter_cache_manager usa getApplicationDocumentsDirectory)
export 'package:talker_dio_logger/talker_dio_logger.dart';
export 'package:cookie_jar/cookie_jar.dart';
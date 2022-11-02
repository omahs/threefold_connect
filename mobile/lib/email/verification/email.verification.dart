import 'package:threebotlogin/email/helpers/email.helpers.dart';
import 'package:threebotlogin/email/widgets/email.widgets.dart';

import '../../core/storage/core.storage.dart';

Future emailVerification() async {
  Map<String, String?> email = await getEmail();
  if (email['email'] == null) return;

  String? sei = await getSignedEmailIdentifier();
  if (sei == null) return;

  String? verifiedEmail = await verifySignedEmailIdentifier(sei);
  if (verifiedEmail == null) return;

  await setEmail(verifiedEmail, sei);
  showSuccessEmailVerifiedDialog();
}

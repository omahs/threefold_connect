import 'package:threebotlogin/core/storage/core.storage.dart';
import 'package:threebotlogin/phone/helpers/phone.helpers.dart';
import 'package:threebotlogin/phone/widgets/phone.widgets.dart';

Future phoneVerification() async {
  Map<String, String?> phone = await getPhone();
  if (phone['phone'] == null) return;

  String? spi = await getSignedPhoneIdentifier();
  if (spi == null) return;

  String? verifiedPhone = await verifySignedPhoneIdentifier(spi);
  if (verifiedPhone == null) return;

  await setPhone(verifiedPhone, spi);
  showSuccessPhoneVerifiedDialog();
}

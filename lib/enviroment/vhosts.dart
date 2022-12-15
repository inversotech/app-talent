import 'package:lamb_talent/enviroment/models.dart';

class Api {
  VHost apiDev = VHost(
      apiTalent: 'http://app07.adventistas.pe/lamb-api-talent/public/api/',
      apiMessenger:
          'https://app07.adventistas.pe/lamb-school-messenger-api/public/api/',
      apiTalent2: 'http://app07.adventistas.pe/lamb-api-talent-v2/public/api/',
      codeModule: '16120100',
      codeFcmApp: 'lamb-talent',
      appIdOneSignal: '1110e1d3-ffcc-4bd9-8564-46771cbf77d9');
  VHost apiProd = VHost(
      apiTalent: 'https://api-lamb-talent.upeu.edu.pe/api-talent/api/',
      apiMessenger: 'https://api-lamb-school-messenger.upeu.edu.pe/api/',
      apiTalent2: 'https://api-lamb-talent.upeu.edu.pe/api-talent-v2/api/',
      codeModule: '16120100',
      codeFcmApp: 'lamb-talent',
      appIdOneSignal: '1110e1d3-ffcc-4bd9-8564-46771cbf77d9');
}

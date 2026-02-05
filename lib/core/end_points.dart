import 'package:lamb_talent/enviroment/enviroment.dart';

final Map endPoints = {
  'oauth': {
    'login': '${Env.api.apiTalent}oauth/login-mobile',
    'valid-tokens-oauth': '${Env.api.apiTalent}oauth/valid-tokens-oauth',
    'user-info': '${Env.api.apiTalent}user/info',
  },
  'comun': {
    'overtime-year': '${Env.api.apiTalent}comun/assistance/year-overtime',
    'overtime-state': '${Env.api.apiTalent}comun/assistance/estado-sobretiempo',
    'overtime-type': '${Env.api.apiTalent}comun/assistance/tipo-sobretiempo',
    'show-overtime': '${Env.api.apiTalent}comun/assistance/show-overtime',
    'get-process-overtime':
        '${Env.api.apiTalent}comun/assistance/get-process-overtime',
    'my-entities': '${Env.api.apiTalent}comun/my-entities-contract',
    'my-deptos': '${Env.api.apiTalent}comun/my-deptos-contract',
    'total-entities-deptos':
        '${Env.api.apiTalent}comun/total-entities-deptos-contract',
    'years': '${Env.api.apiTalent}comun/years',
    'months': '${Env.api.apiTalent}comun/months',
    'descriptions-marking':
        '${Env.api.apiTalent}comun/assistance/descriptions-marking',
    'justification-status':
        '${Env.api.apiTalent}comun/assistance/justification-status',
    'license-permit-status':
        '${Env.api.apiTalent}comun/benefits/estado-lica-per',
    'type-licen-per': '${Env.api.apiTalent}comun/benefits/tipo-perm-lic',
    'type-concept-licen-per':
        '${Env.api.apiTalent}comun/benefits/type-concept-permlic',
    'my-areas': '${Env.api.apiTalent}comun/search-my-area-access',
    'type-institution': '${Env.api.apiTalent}comun/benefits/type-inst-atention',
    'person-signature': '${Env.api.apiTalent}comun/personal-signature',
    'file-view': '${Env.api.apiTalent}comun/benefits/file-view',
    'actions-by-module': '${Env.api.apiTalent}comun/actions-by-module',
    'acceso-nivel': '${Env.api.apiTalent}comun/acceso-nivel',
    'my-workers': '${Env.api.apiTalent}comun/contract/search-worker-access',
    'change-entity-depto': '${Env.api.apiTalent}comun/change-entity-depto'
  },
  'assistance': {
    'worker-scheduled-hours':
        '${Env.api.apiTalent}comun/assistance/worker-scheduled-hours',
    'overtime-type': '${Env.api.apiTalent}assistance/tipo-sobretiempo',
    'register': '${Env.api.apiTalent}assistance/overtime/register',
    'registerStatus': '${Env.api.apiTalent}assistance/overtime/register-status',
    'process': '${Env.api.apiTalent}assistance/overtime/process',
    'map-coordinates':
        '${Env.api.apiTalent}assistance/assistance/map-coordinates-by-worker',
    'show-button-assistance':
        '${Env.api.apiTalent}assistance/assistance/show-button-assistance',
    'worker-marking':
        '${Env.api.apiTalent}assistance/assistance/worker-marking-mobile',
    'justification-reason':
        '${Env.api.apiTalent}assistance/settings/justification-reason',
    'request-by-worker':
        '${Env.api.apiTalent}assistance/justification/request-by-worker',
    'justification': '${Env.api.apiTalent}assistance/justification/request',
    'schedule-worker-by-date':
        '${Env.api.apiTalent}assistance/justification/schedule-worker-by-date',
    'marking-worker-by-date':
        '${Env.api.apiTalent}assistance/justification/marking-worker-by-date',
    'assist-markings':
        '${Env.api.apiTalent}assistance/assistance/assist-markings',
    'markings-ini': '${Env.api.apiTalent}assistance/assistance/markings-ini',
    'survey-detail':
        '${Env.api.apiTalent}assistance/settings/survey-covid-detail',
    'survey-answer': '${Env.api.apiTalent}assistance/settings/survey-answer',
    'survey-answer-covid':
        '${Env.api.apiTalent}assistance/settings/survey-answer-covid',
    'survey-answer-covid-detail':
        '${Env.api.apiTalent}assistance/settings/survey-answer-covid-detail',
  },
  'account-status': {
    'entity-type': '${Env.api.apiTalent}report/account-status/entity-type/',
    'person-year': '${Env.api.apiTalent}report/account-status/person-year/',
    //account-status
    'account-status':
        '${Env.api.apiTalent}report/account-status/procedure/spc_2_sta_data',
    'account-status-items':
        '${Env.api.apiTalent}report/account-status/account-status-items',
    'account-status-items-incomes':
        '${Env.api.apiTalent}report/account-status/salary-incomes',
    'account-status-items-discounts':
        '${Env.api.apiTalent}report/account-status/salary-discounts',
    'account-status-helps-incomes':
        '${Env.api.apiTalent}report/account-status/salary-incomes-helps',
    'account-status-helps-discounts':
        '${Env.api.apiTalent}report/account-status/salary-discounts-helps',
    'account-status-travels-incomes':
        '${Env.api.apiTalent}report/account-status/salary-incomes-travels',
    'account-status-travels-discounts':
        '${Env.api.apiTalent}report/account-status/salary-discounts-travels',
    'account-status-personal-agreement-detail':
        '${Env.api.apiTalent}report/account-status/account-status-details',
    //deparments
    'deparments-items':
        '${Env.api.apiTalent}report/account-status/departments-items',
    'deparments-items-detail':
        '${Env.api.apiTalent}report/account-status/departments-items-detail',
    //travels
    'travels-data': '${Env.api.apiTalent}report/account-status/travels-data',
    'travels-data-detail':
        '${Env.api.apiTalent}report/account-status/travels-data-detail',
    //graphics
    'account-status-graphics':
        '${Env.api.apiTalent}report/account-status/financial-data-graph-options',
    'account-status-graphics-detail':
        '${Env.api.apiTalent}report/account-status/financial-data-graph',
  },
  'report': {
    'monthly-assistance-summary-chart':
        '${Env.api.apiTalent}report/assistance/monthly-assistance-summary-chart',
    'monthly-assistance-summary':
        '${Env.api.apiTalent}report/assistance/monthly-assistance-summary',
    'info-assistance':
        '${Env.api.apiTalent}report/assistance/info-assistance-mobile'
  },
  'justification': {
    'request': '${Env.api.apiTalent}assistance/justification/request',
    'request-markings':
        '${Env.api.apiTalent}assistance/justification/request/markings',
  },
  'workerportal': {
    'my-overtimes': '${Env.api.apiTalent}workerportal/assistance/my-overtimes',
    'license-permit':
        '${Env.api.apiTalent}workerportal/lisenses/licences-permits',
    'holiday':
        '${Env.api.apiTalent}workerportal/holidays/anho-programing-holidays',
    'payments-ticket-month':
        '${Env.api.apiTalent}workerportal/lambFinancial-payments/payments-ticket-month-pdf',
    'payments-ticket-month-download':
        '${Env.api.apiTalent}workerportal/lambFinancial-payments/payments-ticket-month-download-pdf',
    'payments-ticket':
        '${Env.api.apiTalent}workerportal/lambFinancial-payments/payments-ticket'
  },
  'benefits': {
    'license-permit': '${Env.api.apiTalent}benefits/licenses-permits/licenses',
    'license-permit-detail':
        '${Env.api.apiTalent}benefits/licenses-permits/det-perm-lic',
    'process-license-permit':
        '${Env.api.apiTalent}benefits/licenses-permits/process-licencia-permiso',
    'valid-license-permit':
        '${Env.api.apiTalent}benefits/licenses-permits/valid-perm-lic',
    'holiday': '${Env.api.apiTalent}benefits/holidays',
    'pro-holiday': '${Env.api.apiTalent}benefits/holidays/pro-holidays'
  },
  'messenger': {
    'notification-event-album':
        '${Env.api.apiMessenger}report/show-notification-event-album',
    'notifications': '${Env.api.apiMessenger}notifications/notifications',
    'events': '${Env.api.apiMessenger}events/events',
    'albums': '${Env.api.apiMessenger}albums/albums',
    'groups': '${Env.api.apiMessenger}groups/relacion-groups/to-relacion',
    'relation-person': '${Env.api.apiMessenger}groups/relacion-personas',
    'like': '${Env.api.apiMessenger}red/likes',
    'comment': '${Env.api.apiMessenger}red/comentarios',
    'likes': '${Env.api.apiMessenger}red/likes',
    'total-no-leidos': '${Env.api.apiMessenger}report/total-no-leidos',
    'storage': '${Env.api.apiMessengerShell}storage',
  },
  'procesos': {
    'solicitud-pago':
        '${Env.api.apiTalent}workerportal/procesos/solicitud-pago',
    'solicitud-vale':
        '${Env.api.apiTalent}workerportal/procesos/solicitud-vale',
    'rendir-vale': '${Env.api.apiTalent}workerportal/procesos/rendir-vale',
  }
};

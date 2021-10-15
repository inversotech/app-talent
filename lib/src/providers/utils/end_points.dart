import 'package:upn_financiero_mobil/enviroment/enviroment.dart';

final Map endPoints = {
  'oauth': {
    'login': apiUrl + 'oauth/login-mobile',
    'valid-tokens-oauth': apiUrl + 'oauth/valid-tokens-oauth',
    'user-info': apiUrl + 'user/info',
  },
  'comun': {
    'my-entities': apiUrl + 'comun/my-entity-access',
    'my-deptos': apiUrl + 'comun/my-depto-access',
    'years': apiUrl + 'comun/years',
    'months': apiUrl + 'comun/months',
    'descriptions-marking': apiUrl + 'comun/assistance/descriptions-marking',
    'justification-status': apiUrl + 'comun/assistance/justification-status',
    'license-permit-status': apiUrl + 'comun/benefits/estado-lica-per',
    'type-licen-per': apiUrl + 'comun/benefits/tipo-perm-lic',
    'type-concept-licen-per': apiUrl + 'comun/benefits/type-concept-permlic',
    'my-areas': apiUrl + 'comun/search-my-area-access',
    'type-institution': apiUrl + 'comun/benefits/type-inst-atention',
    'person-signature': apiUrl + 'comun/personal-signature',
    'file-view': apiUrl + 'comun/benefits/file-view',
  },
  'assistance': {
    'map-coordinates':
        apiUrl + 'assistance/assistance/map-coordinates-by-worker',
    'show-button-assistance':
        apiUrl + 'assistance/assistance/show-button-assistance',
    'worker-marking': apiUrl + 'assistance/assistance/worker-marking-mobile',
    'justification-reason': apiUrl + 'assistance/settings/justification-reason',
    'request-by-worker': apiUrl + 'assistance/justification/request-by-worker',
    'justification': apiUrl + 'assistance/justification/request',
    'schedule-worker-by-date':
        apiUrl + 'assistance/justification/schedule-worker-by-date',
    'marking-worker-by-date':
        apiUrl + 'assistance/justification/marking-worker-by-date',
    'assist-markings': apiUrl + 'assistance/assistance/assist-markings',
    'markings-ini': apiUrl + 'assistance/assistance/markings-ini',
    'survey-detail': apiUrl + 'assistance/settings/survey-covid-detail',
    'survey-answer': apiUrl + 'assistance/settings/survey-answer',
    'survey-answer-covid': apiUrl + 'assistance/settings/survey-answer-covid',
    'survey-answer-covid-detail': apiUrl + 'assistance/settings/survey-answer-covid-detail',
    
  },
  'account-status': {
    'entity-type': apiUrl + 'report/account-status/entity-type/',
    'person-year': apiUrl + 'report/account-status/person-year/',
    //account-status
    'account-status': apiUrl + 'report/account-status/procedure/spc_2_sta_data',
    'account-status-items':
        apiUrl + 'report/account-status/account-status-items',
    'account-status-items-incomes':
        apiUrl + 'report/account-status/salary-incomes',
    'account-status-items-discounts':
        apiUrl + 'report/account-status/salary-discounts',
    'account-status-helps-incomes':
        apiUrl + 'report/account-status/salary-incomes-helps',
    'account-status-helps-discounts':
        apiUrl + 'report/account-status/salary-discounts-helps',
    'account-status-travels-incomes':
        apiUrl + 'report/account-status/salary-incomes-travels',
    'account-status-travels-discounts':
        apiUrl + 'report/account-status/salary-discounts-travels',
    'account-status-personal-agreement-detail':
        apiUrl + 'report/account-status/account-status-details',
    //deparments
    'deparments-items': apiUrl + 'report/account-status/departments-items',
    'deparments-items-detail':
        apiUrl + 'report/account-status/departments-items-detail',
    //travels
    'travels-data': apiUrl + 'report/account-status/travels-data',
    'travels-data-detail': apiUrl + 'report/account-status/travels-data-detail',
    //graphics
    'account-status-graphics':
        apiUrl + 'report/account-status/financial-data-graph-options',
    'account-status-graphics-detail':
        apiUrl + 'report/account-status/financial-data-graph',
  },
  'report': {
    'monthly-assistance-summary-chart':
        apiUrl + 'report/assistance/monthly-assistance-summary-chart',
    'monthly-assistance-summary':
        apiUrl + 'report/assistance/monthly-assistance-summary'
  },
  'justification': {
    'request': apiUrl + 'assistance/justification/request',
    'request-markings': apiUrl + 'assistance/justification/request/markings',
  },
  'workerportal': {
    'license-permit': apiUrl + 'workerportal/lisenses/licences-permits',
    'holiday': apiUrl + 'workerportal/holidays/anho-programing-holidays',
    'payments-ticket':
        apiUrl + 'workerportal/lambFinancial-payments/payments-ticket'
  },
  'benefits': {
    'license-permit': apiUrl + 'benefits/licenses-permits/licenses',
    'license-permit-detail': apiUrl + 'benefits/licenses-permits/det-perm-lic',
    'process-license-permit':
        apiUrl + 'benefits/licenses-permits/process-licencia-permiso',
    'valid-license-permit': apiUrl + 'benefits/licenses-permits/valid-perm-lic',
    'holiday': apiUrl + 'benefits/holidays',
  }
};

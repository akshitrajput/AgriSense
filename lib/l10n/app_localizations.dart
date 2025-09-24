import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('or'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome,'**
  String get welcomeMessage;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @welcomeToAgriSense.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AgriSense!'**
  String get welcomeToAgriSense;

  /// No description provided for @letsGetYouStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started with a few details.'**
  String get letsGetYouStarted;

  /// No description provided for @selectYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Your Language'**
  String get selectYourLanguage;

  /// No description provided for @welcomeFarmer.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {farmerName}!'**
  String welcomeFarmer(String farmerName);

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cultivating Your Profile'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s begin your harvest.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingFarmDetails.
  ///
  /// In en, this message translates to:
  /// **'Please provide your farm\'s details to complete your profile.'**
  String get onboardingFarmDetails;

  /// No description provided for @farmDimensions.
  ///
  /// In en, this message translates to:
  /// **'Farm Dimensions'**
  String get farmDimensions;

  /// No description provided for @farmLocation.
  ///
  /// In en, this message translates to:
  /// **'Farm Location'**
  String get farmLocation;

  /// No description provided for @plantationDetails.
  ///
  /// In en, this message translates to:
  /// **'Plantation Details'**
  String get plantationDetails;

  /// No description provided for @chooseLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose Location on Map'**
  String get chooseLocation;

  /// No description provided for @locationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location Selected!'**
  String get locationSelected;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length (m)'**
  String get length;

  /// No description provided for @breadth.
  ///
  /// In en, this message translates to:
  /// **'Breadth (m)'**
  String get breadth;

  /// No description provided for @numberOfRows.
  ///
  /// In en, this message translates to:
  /// **'Number of Rows'**
  String get numberOfRows;

  /// No description provided for @plantsPerRow.
  ///
  /// In en, this message translates to:
  /// **'Plants per Row'**
  String get plantsPerRow;

  /// No description provided for @createFarmProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Farm Profile'**
  String get createFarmProfile;

  /// No description provided for @farmSummary.
  ///
  /// In en, this message translates to:
  /// **'Farm Summary'**
  String get farmSummary;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop:'**
  String get crop;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area:'**
  String get area;

  /// No description provided for @rows.
  ///
  /// In en, this message translates to:
  /// **'Rows:'**
  String get rows;

  /// No description provided for @smartControls.
  ///
  /// In en, this message translates to:
  /// **'Smart Controls'**
  String get smartControls;

  /// No description provided for @autonomousRover.
  ///
  /// In en, this message translates to:
  /// **'Autonomous Rover'**
  String get autonomousRover;

  /// No description provided for @sprinklerSystem.
  ///
  /// In en, this message translates to:
  /// **'Sprinkler System'**
  String get sprinklerSystem;

  /// No description provided for @toolsAndAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Tools & Analytics'**
  String get toolsAndAnalytics;

  /// No description provided for @viewFarmMap.
  ///
  /// In en, this message translates to:
  /// **'View Farm Map'**
  String get viewFarmMap;

  /// No description provided for @viewPreviousReports.
  ///
  /// In en, this message translates to:
  /// **'View Previous Reports'**
  String get viewPreviousReports;

  /// No description provided for @scanNewPlant.
  ///
  /// In en, this message translates to:
  /// **'Scan a New Plant'**
  String get scanNewPlant;

  /// No description provided for @marketAndWeather.
  ///
  /// In en, this message translates to:
  /// **'Market & Weather'**
  String get marketAndWeather;

  /// No description provided for @chennaiWeather.
  ///
  /// In en, this message translates to:
  /// **'Chennai Weather'**
  String get chennaiWeather;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rain;

  /// No description provided for @farmingTips.
  ///
  /// In en, this message translates to:
  /// **'Farming Tips & News'**
  String get farmingTips;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'New organic pesticide shows promising results in early trials.'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Proper soil aeration can increase crop yield by up to 15%.'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Consider drip irrigation to conserve water during dry seasons.'**
  String get tip3;

  /// No description provided for @plantHealthScan.
  ///
  /// In en, this message translates to:
  /// **'Plant Health Scan'**
  String get plantHealthScan;

  /// No description provided for @scanWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan with Camera'**
  String get scanWithCamera;

  /// No description provided for @uploadFromStorage.
  ///
  /// In en, this message translates to:
  /// **'Upload from Storage'**
  String get uploadFromStorage;

  /// No description provided for @plantHealthReport.
  ///
  /// In en, this message translates to:
  /// **'Plant Health Report'**
  String get plantHealthReport;

  /// No description provided for @diseaseDetected.
  ///
  /// In en, this message translates to:
  /// **'Disease Detected'**
  String get diseaseDetected;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'Severity: High'**
  String get severityHigh;

  /// No description provided for @analysisDetails.
  ///
  /// In en, this message translates to:
  /// **'Analysis Details'**
  String get analysisDetails;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @fungalLeafBlight.
  ///
  /// In en, this message translates to:
  /// **'Fungal Leaf Blight'**
  String get fungalLeafBlight;

  /// No description provided for @affectedArea.
  ///
  /// In en, this message translates to:
  /// **'Affected Area'**
  String get affectedArea;

  /// No description provided for @recommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended Action'**
  String get recommendedAction;

  /// No description provided for @applyFungicide.
  ///
  /// In en, this message translates to:
  /// **'Apply Fungicide, Isolate Plant'**
  String get applyFungicide;

  /// No description provided for @farmMapView.
  ///
  /// In en, this message translates to:
  /// **'Farm Map View'**
  String get farmMapView;

  /// No description provided for @healthyPlants.
  ///
  /// In en, this message translates to:
  /// **'Healthy Plants'**
  String get healthyPlants;

  /// No description provided for @affectedPlants.
  ///
  /// In en, this message translates to:
  /// **'Affected Plants'**
  String get affectedPlants;

  /// No description provided for @cropDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Details'**
  String get cropDetailsTitle;

  /// No description provided for @markAffected.
  ///
  /// In en, this message translates to:
  /// **'Mark as Affected'**
  String get markAffected;

  /// No description provided for @markHealthy.
  ///
  /// In en, this message translates to:
  /// **'Mark as Healthy'**
  String get markHealthy;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @farmDetails.
  ///
  /// In en, this message translates to:
  /// **'Farm Details'**
  String get farmDetails;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @saveFarmChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Farm Changes'**
  String get saveFarmChanges;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @detailsUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Details updated successfully!'**
  String get detailsUpdatedMessage;

  /// No description provided for @selectCropType.
  ///
  /// In en, this message translates to:
  /// **'Select Crop Type'**
  String get selectCropType;

  /// No description provided for @cropWheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get cropWheat;

  /// No description provided for @cropMaize.
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get cropMaize;

  /// No description provided for @cropCorn.
  ///
  /// In en, this message translates to:
  /// **'Corn'**
  String get cropCorn;

  /// No description provided for @cropTomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get cropTomato;

  /// No description provided for @cropPotato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get cropPotato;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistory;

  /// No description provided for @noHistoryRecords.
  ///
  /// In en, this message translates to:
  /// **'No history records found.'**
  String get noHistoryRecords;

  /// No description provided for @sevenDayForecast.
  ///
  /// In en, this message translates to:
  /// **'7-Day Forecast'**
  String get sevenDayForecast;

  /// No description provided for @cropHealthStatus.
  ///
  /// In en, this message translates to:
  /// **'Crop Health Status'**
  String get cropHealthStatus;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'or',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

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
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
  ];

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cultivating Your Profile\nLet\'s begin your harvest.'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your farm.'**
  String get onboardingSubtitle;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @selectCropType.
  ///
  /// In en, this message translates to:
  /// **'Select Crop Type'**
  String get selectCropType;

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

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Farm Profile'**
  String get createProfile;

  /// No description provided for @yourFarmOverview.
  ///
  /// In en, this message translates to:
  /// **'Your Farm Overview'**
  String get yourFarmOverview;

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

  /// No description provided for @startPlantHealthScan.
  ///
  /// In en, this message translates to:
  /// **'Start Plant Health Scan'**
  String get startPlantHealthScan;

  /// No description provided for @viewFarmMap.
  ///
  /// In en, this message translates to:
  /// **'View Farm Map'**
  String get viewFarmMap;

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

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

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
  /// **'Diagnosis:'**
  String get diagnosis;

  /// No description provided for @fungalLeafBlight.
  ///
  /// In en, this message translates to:
  /// **'Fungal Leaf Blight'**
  String get fungalLeafBlight;

  /// No description provided for @affectedArea.
  ///
  /// In en, this message translates to:
  /// **'Affected Area:'**
  String get affectedArea;

  /// No description provided for @recommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended Action:'**
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

  /// No description provided for @mapLength.
  ///
  /// In en, this message translates to:
  /// **'Length: 100m'**
  String get mapLength;

  /// No description provided for @mapWidth.
  ///
  /// In en, this message translates to:
  /// **'Width: 50m'**
  String get mapWidth;

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

  /// No description provided for @plantsPerRow.
  ///
  /// In en, this message translates to:
  /// **'Plants per Row'**
  String get plantsPerRow;

  /// No description provided for @toolsAndAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Tools & Analytics'**
  String get toolsAndAnalytics;

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

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome,'**
  String get welcomeMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

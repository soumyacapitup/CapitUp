import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('hi')];

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @appLanguageHelp.
  ///
  /// In en, this message translates to:
  /// **'Buttons, menus and screens. AI answers have their own language setting.'**
  String get appLanguageHelp;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @onb1Title.
  ///
  /// In en, this message translates to:
  /// **'All your cover, one place'**
  String get onb1Title;

  /// No description provided for @onb1Body.
  ///
  /// In en, this message translates to:
  /// **'Health, life and motor policies for the whole family, kept safe and easy to find.'**
  String get onb1Body;

  /// No description provided for @onb2Title.
  ///
  /// In en, this message translates to:
  /// **'Ask in plain words'**
  String get onb2Title;

  /// No description provided for @onb2Body.
  ///
  /// In en, this message translates to:
  /// **'Every answer points to the page it came from, or tells you it isn\'t in your policy.'**
  String get onb2Body;

  /// No description provided for @onb3Title.
  ///
  /// In en, this message translates to:
  /// **'Renewals never sneak up'**
  String get onb3Title;

  /// No description provided for @onb3Body.
  ///
  /// In en, this message translates to:
  /// **'A gentle nudge well before your policy ends, so you are never left uncovered.'**
  String get onb3Body;

  /// No description provided for @onb4Title.
  ///
  /// In en, this message translates to:
  /// **'Family and nominees, sorted'**
  String get onb4Title;

  /// No description provided for @onb4Body.
  ///
  /// In en, this message translates to:
  /// **'See who is covered, who gets what, and what to do if something happens.'**
  String get onb4Body;

  /// No description provided for @loginHeadline.
  ///
  /// In en, this message translates to:
  /// **'All your insurance.\nOne place. Clearly explained.'**
  String get loginHeadline;

  /// No description provided for @loginSubhead.
  ///
  /// In en, this message translates to:
  /// **'Add your policies, understand what you\'re covered for, and never miss a renewal.'**
  String get loginSubhead;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @consentStart.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get consentStart;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @consentAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get consentAnd;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @consentEnd.
  ///
  /// In en, this message translates to:
  /// **', and consent to my policy documents being processed to provide this service.'**
  String get consentEnd;

  /// No description provided for @getOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOtp;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to {identifier}'**
  String otpSentTo(String identifier);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get nameTitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @dobOptional.
  ///
  /// In en, this message translates to:
  /// **'Date of birth (optional)'**
  String get dobOptional;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get navPortfolio;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @addPolicy.
  ///
  /// In en, this message translates to:
  /// **'Add policy'**
  String get addPolicy;

  /// No description provided for @hiName.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}'**
  String hiName(String name);

  /// No description provided for @helloThere.
  ///
  /// In en, this message translates to:
  /// **'Hello there'**
  String get helloThere;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s where your cover stands today.'**
  String get homeSubtitle;

  /// No description provided for @whatToDo.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatToDo;

  /// No description provided for @comingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get comingUp;

  /// No description provided for @coverageReport.
  ///
  /// In en, this message translates to:
  /// **'Coverage report'**
  String get coverageReport;

  /// No description provided for @askAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get askAi;

  /// No description provided for @claimHelp.
  ///
  /// In en, this message translates to:
  /// **'Claim help'**
  String get claimHelp;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @nominees.
  ///
  /// In en, this message translates to:
  /// **'Nominees'**
  String get nominees;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @emergencyCard.
  ///
  /// In en, this message translates to:
  /// **'Emergency card'**
  String get emergencyCard;

  /// No description provided for @seeCoverageReport.
  ///
  /// In en, this message translates to:
  /// **'See your coverage report'**
  String get seeCoverageReport;

  /// No description provided for @addAPolicy.
  ///
  /// In en, this message translates to:
  /// **'Add a policy'**
  String get addAPolicy;

  /// No description provided for @seeSampleReport.
  ///
  /// In en, this message translates to:
  /// **'See a sample report'**
  String get seeSampleReport;

  /// No description provided for @coinsEarned.
  ///
  /// In en, this message translates to:
  /// **'+{coins} coins earned'**
  String coinsEarned(int coins);

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get personalDetails;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @renewalReminders.
  ///
  /// In en, this message translates to:
  /// **'Renewal reminders'**
  String get renewalReminders;

  /// No description provided for @renewalRemindersHelp.
  ///
  /// In en, this message translates to:
  /// **'90, 60, 30, 15, 7 and 1 day before a policy expires'**
  String get renewalRemindersHelp;

  /// No description provided for @policyUpdates.
  ///
  /// In en, this message translates to:
  /// **'Policy updates'**
  String get policyUpdates;

  /// No description provided for @policyUpdatesHelp.
  ///
  /// In en, this message translates to:
  /// **'When a document has been read and is ready to review'**
  String get policyUpdatesHelp;

  /// No description provided for @notificationsPromise.
  ///
  /// In en, this message translates to:
  /// **'We never send promotional notifications, and notifications never show your policy numbers, amounts or health details.'**
  String get notificationsPromise;

  /// No description provided for @faqSafeQ.
  ///
  /// In en, this message translates to:
  /// **'Is my data safe?'**
  String get faqSafeQ;

  /// No description provided for @faqSafeA.
  ///
  /// In en, this message translates to:
  /// **'Your documents are stored encrypted and are only accessible to you. We do not sell your data or share it with insurers or agents.'**
  String get faqSafeA;

  /// No description provided for @faqAiQ.
  ///
  /// In en, this message translates to:
  /// **'How does the AI answer my questions?'**
  String get faqAiQ;

  /// No description provided for @faqAiA.
  ///
  /// In en, this message translates to:
  /// **'It reads only your own policy document and shows the page its answer came from. If the answer is not in your document it will say so instead of guessing.'**
  String get faqAiA;

  /// No description provided for @faqWrongQ.
  ///
  /// In en, this message translates to:
  /// **'The details extracted from my policy are wrong. What do I do?'**
  String get faqWrongQ;

  /// No description provided for @faqWrongA.
  ///
  /// In en, this message translates to:
  /// **'Open the policy, tap the ⋮ menu and choose \"Edit details\". Anything you correct is saved as confirmed by you.'**
  String get faqWrongA;

  /// No description provided for @faqUploadQ.
  ///
  /// In en, this message translates to:
  /// **'Which documents can I upload?'**
  String get faqUploadQ;

  /// No description provided for @faqUploadA.
  ///
  /// In en, this message translates to:
  /// **'PDF policy documents work best. You can also upload a clear photo (JPG/PNG) up to 20 MB. Password-protected PDFs must be unlocked first.'**
  String get faqUploadA;

  /// No description provided for @faqSellQ.
  ///
  /// In en, this message translates to:
  /// **'Do you sell insurance?'**
  String get faqSellQ;

  /// No description provided for @faqSellA.
  ///
  /// In en, this message translates to:
  /// **'No. {app} helps you organise and understand the policies you already have. We do not sell or recommend insurance products.'**
  String faqSellA(String app);

  /// No description provided for @faqDeleteQ.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get faqDeleteQ;

  /// No description provided for @faqDeleteA.
  ///
  /// In en, this message translates to:
  /// **'Profile → Privacy & data → Delete account. Your data is permanently deleted after 7 days.'**
  String get faqDeleteA;

  /// No description provided for @supportThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks — we\'ll get back to you within 2 working days.'**
  String get supportThanks;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get helpSupport;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faqTitle;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topic;

  /// No description provided for @topicQuestion.
  ///
  /// In en, this message translates to:
  /// **'A question'**
  String get topicQuestion;

  /// No description provided for @topicProblem.
  ///
  /// In en, this message translates to:
  /// **'Something isn\'t working'**
  String get topicProblem;

  /// No description provided for @topicFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get topicFeedback;

  /// No description provided for @topicPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy / my data'**
  String get topicPrivacy;

  /// No description provided for @topicGrievance.
  ///
  /// In en, this message translates to:
  /// **'Complaint (grievance)'**
  String get topicGrievance;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @emailUsInstead.
  ///
  /// In en, this message translates to:
  /// **'Email us instead'**
  String get emailUsInstead;

  /// No description provided for @deleteAccountQ.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountQ;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Your account will be disabled now. All your policies, documents and data will be permanently deleted after 7 days. Logging in again within 7 days cancels the deletion.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @privacyData.
  ///
  /// In en, this message translates to:
  /// **'Privacy & data'**
  String get privacyData;

  /// No description provided for @privacyPromise.
  ///
  /// In en, this message translates to:
  /// **'We use your policy documents only to show, explain and remind you about your own insurance. Documents are encrypted, never sold, and never shared with insurers or agents. AI processing uses providers contractually barred from training on your data.'**
  String get privacyPromise;

  /// No description provided for @downloadMyData.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get downloadMyData;

  /// No description provided for @downloadMyDataHelp.
  ///
  /// In en, this message translates to:
  /// **'A copy of your profile, policies and questions'**
  String get downloadMyDataHelp;

  /// No description provided for @privacyPolicyItem.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicyItem;

  /// No description provided for @grievanceOfficer.
  ///
  /// In en, this message translates to:
  /// **'Grievance officer'**
  String get grievanceOfficer;

  /// No description provided for @deleteAccountHelp.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete all your data'**
  String get deleteAccountHelp;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @appLockHelp.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint, face or device PIN to open the app'**
  String get appLockHelp;

  /// No description provided for @setUpScreenLock.
  ///
  /// In en, this message translates to:
  /// **'Set up a screen lock on your phone first.'**
  String get setUpScreenLock;

  /// No description provided for @aiAnswerLanguage.
  ///
  /// In en, this message translates to:
  /// **'AI answer language'**
  String get aiAnswerLanguage;

  /// No description provided for @aiAnswerLanguageHelp.
  ///
  /// In en, this message translates to:
  /// **'Summaries and answers about your policies will be written in this language. You can ask questions in it too.'**
  String get aiAnswerLanguageHelp;

  /// No description provided for @policy.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get policy;

  /// No description provided for @reviewExtracted.
  ///
  /// In en, this message translates to:
  /// **'Please review the extracted details'**
  String get reviewExtracted;

  /// No description provided for @coverageReportHelp.
  ///
  /// In en, this message translates to:
  /// **'What is covered, what has limits and what is not — item by item'**
  String get coverageReportHelp;

  /// No description provided for @noNomineeAddOne.
  ///
  /// In en, this message translates to:
  /// **'No nominee recorded — add one'**
  String get noNomineeAddOne;

  /// No description provided for @notRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get notRecorded;

  /// No description provided for @policyClauses.
  ///
  /// In en, this message translates to:
  /// **'Policy clauses'**
  String get policyClauses;

  /// No description provided for @policyClausesHelp.
  ///
  /// In en, this message translates to:
  /// **'Benefits, exclusions, waiting periods and limits — word for word'**
  String get policyClausesHelp;

  /// No description provided for @whoIsCovered.
  ///
  /// In en, this message translates to:
  /// **'Who is covered'**
  String get whoIsCovered;

  /// No description provided for @understandPolicy.
  ///
  /// In en, this message translates to:
  /// **'Understand your policy'**
  String get understandPolicy;

  /// No description provided for @keyDetails.
  ///
  /// In en, this message translates to:
  /// **'Key details'**
  String get keyDetails;

  /// No description provided for @coverageDetails.
  ///
  /// In en, this message translates to:
  /// **'Coverage details'**
  String get coverageDetails;

  /// No description provided for @typeInsurance.
  ///
  /// In en, this message translates to:
  /// **'{type} insurance'**
  String typeInsurance(String type);

  /// No description provided for @idv.
  ///
  /// In en, this message translates to:
  /// **'Insured declared value'**
  String get idv;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @validRange.
  ///
  /// In en, this message translates to:
  /// **'Valid {start} – {end}'**
  String validRange(String start, String end);

  /// No description provided for @premiumValue.
  ///
  /// In en, this message translates to:
  /// **'Premium {amount}'**
  String premiumValue(String amount);

  /// No description provided for @askAiShort.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get askAiShort;

  /// No description provided for @renewal.
  ///
  /// In en, this message translates to:
  /// **'Renewal'**
  String get renewal;

  /// No description provided for @claimHelpAction.
  ///
  /// In en, this message translates to:
  /// **'Claim help'**
  String get claimHelpAction;

  /// No description provided for @documentsRequired.
  ///
  /// In en, this message translates to:
  /// **'Documents usually required'**
  String get documentsRequired;

  /// No description provided for @followInsurerProcess.
  ///
  /// In en, this message translates to:
  /// **'Always follow the claim process stated in your policy and by your insurer.'**
  String get followInsurerProcess;

  /// No description provided for @readingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Reading your policy…'**
  String get readingPolicy;

  /// No description provided for @watchOutFor.
  ///
  /// In en, this message translates to:
  /// **'Watch out for'**
  String get watchOutFor;

  /// No description provided for @policyNumber.
  ///
  /// In en, this message translates to:
  /// **'Policy number'**
  String get policyNumber;

  /// No description provided for @insurer.
  ///
  /// In en, this message translates to:
  /// **'Insurer'**
  String get insurer;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @coverRow.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get coverRow;

  /// No description provided for @deletePolicyQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this policy?'**
  String get deletePolicyQ;

  /// No description provided for @deletePolicyBody.
  ///
  /// In en, this message translates to:
  /// **'The policy, its document and your questions about it will be permanently deleted.'**
  String get deletePolicyBody;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetails;

  /// No description provided for @viewDocument.
  ///
  /// In en, this message translates to:
  /// **'View document'**
  String get viewDocument;

  /// No description provided for @deletePolicy.
  ///
  /// In en, this message translates to:
  /// **'Delete policy'**
  String get deletePolicy;

  /// No description provided for @policyHealth.
  ///
  /// In en, this message translates to:
  /// **'Policy health'**
  String get policyHealth;

  /// No description provided for @noIssuesFound.
  ///
  /// In en, this message translates to:
  /// **'No issues found in the details we read'**
  String get noIssuesFound;

  /// No description provided for @thingsToKnow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 thing to know about} other{{count} things to know about}}'**
  String thingsToKnow(int count);

  /// No description provided for @markedRenewed.
  ///
  /// In en, this message translates to:
  /// **'Marked as renewed. Add your new policy document to keep things up to date.'**
  String get markedRenewed;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @renewalTitle.
  ///
  /// In en, this message translates to:
  /// **'Renewal'**
  String get renewalTitle;

  /// No description provided for @addEndDate.
  ///
  /// In en, this message translates to:
  /// **'Add the policy end date to track renewal.'**
  String get addEndDate;

  /// No description provided for @expiredOn.
  ///
  /// In en, this message translates to:
  /// **'This policy expired on {date}.'**
  String expiredOn(String date);

  /// No description provided for @renewsOn.
  ///
  /// In en, this message translates to:
  /// **'Renews on {date} — {days, plural, =1{1 day left} other{{days} days left}}.'**
  String renewsOn(String date, int days);

  /// No description provided for @lastPremium.
  ///
  /// In en, this message translates to:
  /// **'Last premium: {amount}'**
  String lastPremium(String amount);

  /// No description provided for @remindSchedule.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you 90, 60, 30, 15, 7 and 1 day before expiry.'**
  String get remindSchedule;

  /// No description provided for @remindersOff.
  ///
  /// In en, this message translates to:
  /// **'Renewal reminders are turned off in settings.'**
  String get remindersOff;

  /// No description provided for @markedAsRenewed.
  ///
  /// In en, this message translates to:
  /// **'✓ Marked as renewed'**
  String get markedAsRenewed;

  /// No description provided for @markedNotRenewing.
  ///
  /// In en, this message translates to:
  /// **'Marked as not renewing'**
  String get markedNotRenewing;

  /// No description provided for @iRenewed.
  ///
  /// In en, this message translates to:
  /// **'I\'ve renewed this policy'**
  String get iRenewed;

  /// No description provided for @notRenewing.
  ///
  /// In en, this message translates to:
  /// **'I\'m not renewing'**
  String get notRenewing;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @claimHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health insurance claim'**
  String get claimHealthTitle;

  /// No description provided for @claimHealthStep1.
  ///
  /// In en, this message translates to:
  /// **'Check that the hospital is in your insurer\'s network (for cashless treatment).'**
  String get claimHealthStep1;

  /// No description provided for @claimHealthStep2.
  ///
  /// In en, this message translates to:
  /// **'Planned admission: request cashless pre-authorisation at the hospital\'s insurance desk at least 48 hours before.'**
  String get claimHealthStep2;

  /// No description provided for @claimHealthStep3.
  ///
  /// In en, this message translates to:
  /// **'Emergency admission: inform your insurer or TPA within 24 hours.'**
  String get claimHealthStep3;

  /// No description provided for @claimHealthStep4.
  ///
  /// In en, this message translates to:
  /// **'Show your health card / policy number and photo ID at the hospital.'**
  String get claimHealthStep4;

  /// No description provided for @claimHealthStep5.
  ///
  /// In en, this message translates to:
  /// **'For reimbursement (non-network hospital), pay the bill and submit the claim within the time stated in your policy.'**
  String get claimHealthStep5;

  /// No description provided for @claimHealthStep6.
  ///
  /// In en, this message translates to:
  /// **'Track your claim with the claim reference number your insurer gives you.'**
  String get claimHealthStep6;

  /// No description provided for @claimHealthDoc1.
  ///
  /// In en, this message translates to:
  /// **'Claim form (signed)'**
  String get claimHealthDoc1;

  /// No description provided for @claimHealthDoc2.
  ///
  /// In en, this message translates to:
  /// **'Policy copy / health card'**
  String get claimHealthDoc2;

  /// No description provided for @claimHealthDoc3.
  ///
  /// In en, this message translates to:
  /// **'Photo ID and address proof'**
  String get claimHealthDoc3;

  /// No description provided for @claimHealthDoc4.
  ///
  /// In en, this message translates to:
  /// **'Discharge summary'**
  String get claimHealthDoc4;

  /// No description provided for @claimHealthDoc5.
  ///
  /// In en, this message translates to:
  /// **'Original hospital bills and payment receipts'**
  String get claimHealthDoc5;

  /// No description provided for @claimHealthDoc6.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s prescriptions and investigation reports'**
  String get claimHealthDoc6;

  /// No description provided for @claimHealthDoc7.
  ///
  /// In en, this message translates to:
  /// **'Cancelled cheque or bank details (for reimbursement)'**
  String get claimHealthDoc7;

  /// No description provided for @claimMotorTitle.
  ///
  /// In en, this message translates to:
  /// **'Motor insurance claim'**
  String get claimMotorTitle;

  /// No description provided for @claimMotorStep1.
  ///
  /// In en, this message translates to:
  /// **'Ensure everyone is safe. For theft or third-party injury, file an FIR with the police.'**
  String get claimMotorStep1;

  /// No description provided for @claimMotorStep2.
  ///
  /// In en, this message translates to:
  /// **'Inform your insurer as soon as possible and get a claim number.'**
  String get claimMotorStep2;

  /// No description provided for @claimMotorStep3.
  ///
  /// In en, this message translates to:
  /// **'Do not repair the vehicle before the insurer\'s surveyor inspects it (unless told otherwise).'**
  String get claimMotorStep3;

  /// No description provided for @claimMotorStep4.
  ///
  /// In en, this message translates to:
  /// **'Take the vehicle to a network garage for cashless repair, or any garage for reimbursement.'**
  String get claimMotorStep4;

  /// No description provided for @claimMotorStep5.
  ///
  /// In en, this message translates to:
  /// **'Pay any compulsory deductible and non-covered items; the insurer settles the rest.'**
  String get claimMotorStep5;

  /// No description provided for @claimMotorDoc1.
  ///
  /// In en, this message translates to:
  /// **'Claim form'**
  String get claimMotorDoc1;

  /// No description provided for @claimMotorDoc2.
  ///
  /// In en, this message translates to:
  /// **'Policy copy'**
  String get claimMotorDoc2;

  /// No description provided for @claimMotorDoc3.
  ///
  /// In en, this message translates to:
  /// **'Registration certificate (RC)'**
  String get claimMotorDoc3;

  /// No description provided for @claimMotorDoc4.
  ///
  /// In en, this message translates to:
  /// **'Driving licence of the driver'**
  String get claimMotorDoc4;

  /// No description provided for @claimMotorDoc5.
  ///
  /// In en, this message translates to:
  /// **'FIR (for theft, major accident or third-party claims)'**
  String get claimMotorDoc5;

  /// No description provided for @claimMotorDoc6.
  ///
  /// In en, this message translates to:
  /// **'Repair estimate and final invoice'**
  String get claimMotorDoc6;

  /// No description provided for @claimLifeTitle.
  ///
  /// In en, this message translates to:
  /// **'Life insurance claim'**
  String get claimLifeTitle;

  /// No description provided for @claimLifeStep1.
  ///
  /// In en, this message translates to:
  /// **'The nominee should inform the insurer as soon as possible.'**
  String get claimLifeStep1;

  /// No description provided for @claimLifeStep2.
  ///
  /// In en, this message translates to:
  /// **'Collect the claim form from the insurer\'s branch or website.'**
  String get claimLifeStep2;

  /// No description provided for @claimLifeStep3.
  ///
  /// In en, this message translates to:
  /// **'Submit the form with the required documents.'**
  String get claimLifeStep3;

  /// No description provided for @claimLifeStep4.
  ///
  /// In en, this message translates to:
  /// **'The insurer may investigate claims made within the first few policy years.'**
  String get claimLifeStep4;

  /// No description provided for @claimLifeStep5.
  ///
  /// In en, this message translates to:
  /// **'Track the claim status with the insurer.'**
  String get claimLifeStep5;

  /// No description provided for @claimLifeDoc1.
  ///
  /// In en, this message translates to:
  /// **'Claim form'**
  String get claimLifeDoc1;

  /// No description provided for @claimLifeDoc2.
  ///
  /// In en, this message translates to:
  /// **'Original policy document'**
  String get claimLifeDoc2;

  /// No description provided for @claimLifeDoc3.
  ///
  /// In en, this message translates to:
  /// **'Death certificate'**
  String get claimLifeDoc3;

  /// No description provided for @claimLifeDoc4.
  ///
  /// In en, this message translates to:
  /// **'Nominee\'s photo ID, address proof and bank details'**
  String get claimLifeDoc4;

  /// No description provided for @claimLifeDoc5.
  ///
  /// In en, this message translates to:
  /// **'Medical records / FIR and post-mortem report (if applicable)'**
  String get claimLifeDoc5;

  /// No description provided for @claimOtherTitle.
  ///
  /// In en, this message translates to:
  /// **'Making a claim'**
  String get claimOtherTitle;

  /// No description provided for @claimOtherStep1.
  ///
  /// In en, this message translates to:
  /// **'Read your policy to confirm the event is covered.'**
  String get claimOtherStep1;

  /// No description provided for @claimOtherStep2.
  ///
  /// In en, this message translates to:
  /// **'Inform your insurer as soon as possible and get a claim number.'**
  String get claimOtherStep2;

  /// No description provided for @claimOtherStep3.
  ///
  /// In en, this message translates to:
  /// **'Submit the claim form and supporting documents.'**
  String get claimOtherStep3;

  /// No description provided for @claimOtherStep4.
  ///
  /// In en, this message translates to:
  /// **'Track your claim with the insurer.'**
  String get claimOtherStep4;

  /// No description provided for @claimOtherDoc1.
  ///
  /// In en, this message translates to:
  /// **'Claim form'**
  String get claimOtherDoc1;

  /// No description provided for @claimOtherDoc2.
  ///
  /// In en, this message translates to:
  /// **'Policy copy'**
  String get claimOtherDoc2;

  /// No description provided for @claimOtherDoc3.
  ///
  /// In en, this message translates to:
  /// **'Photo ID'**
  String get claimOtherDoc3;

  /// No description provided for @claimOtherDoc4.
  ///
  /// In en, this message translates to:
  /// **'Proof of loss / bills'**
  String get claimOtherDoc4;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @claimGuides.
  ///
  /// In en, this message translates to:
  /// **'Claim guides'**
  String get claimGuides;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @gmailImport.
  ///
  /// In en, this message translates to:
  /// **'Gmail import'**
  String get gmailImport;

  /// No description provided for @digiLocker.
  ///
  /// In en, this message translates to:
  /// **'DigiLocker'**
  String get digiLocker;

  /// No description provided for @claimTracking.
  ///
  /// In en, this message translates to:
  /// **'Claim tracking'**
  String get claimTracking;

  /// No description provided for @wellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get wellness;

  /// No description provided for @deathLife1.
  ///
  /// In en, this message translates to:
  /// **'Inform the insurer as soon as possible (call centre, branch or website) and note the claim number.'**
  String get deathLife1;

  /// No description provided for @deathLife2.
  ///
  /// In en, this message translates to:
  /// **'The nominee fills the death claim form and attaches the documents below.'**
  String get deathLife2;

  /// No description provided for @deathLife3.
  ///
  /// In en, this message translates to:
  /// **'For deaths within the first 3 policy years the insurer may investigate before paying — this is normal.'**
  String get deathLife3;

  /// No description provided for @deathLife4.
  ///
  /// In en, this message translates to:
  /// **'The claim amount is paid to the nominee\'s bank account. If the nominee is a minor, the appointee receives it.'**
  String get deathLife4;

  /// No description provided for @deathHealth1.
  ///
  /// In en, this message translates to:
  /// **'A health policy ends for the person who died. If it is a family floater, the other members stay covered until renewal.'**
  String get deathHealth1;

  /// No description provided for @deathHealth2.
  ///
  /// In en, this message translates to:
  /// **'Any pending hospital bills can still be claimed by the nominee — submit them within the claim time limit.'**
  String get deathHealth2;

  /// No description provided for @deathHealth3.
  ///
  /// In en, this message translates to:
  /// **'Inform the insurer to remove the member and update the policy at renewal.'**
  String get deathHealth3;

  /// No description provided for @deathMotor1.
  ///
  /// In en, this message translates to:
  /// **'The vehicle and its insurance must be transferred to the legal heir within the time the insurer specifies.'**
  String get deathMotor1;

  /// No description provided for @deathMotor2.
  ///
  /// In en, this message translates to:
  /// **'Inform the insurer with the death certificate and the new owner\'s documents.'**
  String get deathMotor2;

  /// No description provided for @deathMotor3.
  ///
  /// In en, this message translates to:
  /// **'Until transfer, avoid using the vehicle — claims may be refused if the registered owner has died.'**
  String get deathMotor3;

  /// No description provided for @deathOther1.
  ///
  /// In en, this message translates to:
  /// **'Inform the insurer with the death certificate and ask for their claim or transfer process.'**
  String get deathOther1;

  /// No description provided for @deathDoc1.
  ///
  /// In en, this message translates to:
  /// **'Death certificate (original or attested copy)'**
  String get deathDoc1;

  /// No description provided for @deathDoc2.
  ///
  /// In en, this message translates to:
  /// **'Policy document or policy number'**
  String get deathDoc2;

  /// No description provided for @deathDoc3.
  ///
  /// In en, this message translates to:
  /// **'Nominee\'s photo ID and address proof (Aadhaar / PAN)'**
  String get deathDoc3;

  /// No description provided for @deathDoc4.
  ///
  /// In en, this message translates to:
  /// **'Nominee\'s bank details (cancelled cheque)'**
  String get deathDoc4;

  /// No description provided for @deathDoc5.
  ///
  /// In en, this message translates to:
  /// **'Medical records or hospital discharge summary (if applicable)'**
  String get deathDoc5;

  /// No description provided for @deathDoc6.
  ///
  /// In en, this message translates to:
  /// **'FIR and post-mortem report (for accidental death)'**
  String get deathDoc6;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'My {type} insurance details'**
  String shareSubject(String type);

  /// No description provided for @shareBody.
  ///
  /// In en, this message translates to:
  /// **'Keep this safe.\n\n{name} — {type} insurance\nPolicy number: {number}\nCover: {cover}\nNominees: {nominees}\n\nIf something happens to me:\n{steps}'**
  String shareBody(String name, String type, String number, String cover, String nominees, String steps);

  /// No description provided for @seePolicyDocument.
  ///
  /// In en, this message translates to:
  /// **'see policy document'**
  String get seePolicyDocument;

  /// No description provided for @addNominee.
  ///
  /// In en, this message translates to:
  /// **'Add nominee'**
  String get addNominee;

  /// No description provided for @fullyAssigned.
  ///
  /// In en, this message translates to:
  /// **'100% of the claim amount is assigned'**
  String get fullyAssigned;

  /// No description provided for @noNomineeYet.
  ///
  /// In en, this message translates to:
  /// **'No nominee recorded yet'**
  String get noNomineeYet;

  /// No description provided for @assignedLeft.
  ///
  /// In en, this message translates to:
  /// **'{assigned}% assigned · {left}% left'**
  String assignedLeft(int assigned, int left);

  /// No description provided for @nomineeLegalNote.
  ///
  /// In en, this message translates to:
  /// **'This is your own record. The nominee that counts legally is the one registered with your insurer — keep them the same.'**
  String get nomineeLegalNote;

  /// No description provided for @minorAppointee.
  ///
  /// In en, this message translates to:
  /// **'Minor · appointee: {name}'**
  String minorAppointee(String name);

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'not set'**
  String get notSet;

  /// No description provided for @ifSomethingHappens.
  ///
  /// In en, this message translates to:
  /// **'If something happens to you'**
  String get ifSomethingHappens;

  /// No description provided for @docsFamilyNeeds.
  ///
  /// In en, this message translates to:
  /// **'Documents your family will need'**
  String get docsFamilyNeeds;

  /// No description provided for @shareWithFamily.
  ///
  /// In en, this message translates to:
  /// **'Share these details with family'**
  String get shareWithFamily;

  /// No description provided for @needAppointee.
  ///
  /// In en, this message translates to:
  /// **'Add an appointee — an adult who receives the money for a minor.'**
  String get needAppointee;

  /// No description provided for @editNominee.
  ///
  /// In en, this message translates to:
  /// **'Edit nominee'**
  String get editNominee;

  /// No description provided for @pickFromFamily.
  ///
  /// In en, this message translates to:
  /// **'Pick from family'**
  String get pickFromFamily;

  /// No description provided for @fullNameAsPolicy.
  ///
  /// In en, this message translates to:
  /// **'Full name (as in the policy)'**
  String get fullNameAsPolicy;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @shareOfClaim.
  ///
  /// In en, this message translates to:
  /// **'Share of claim: {percent}%'**
  String shareOfClaim(int percent);

  /// No description provided for @appointeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Appointee (adult who receives money for the minor)'**
  String get appointeeLabel;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @removeNominee.
  ///
  /// In en, this message translates to:
  /// **'Remove nominee'**
  String get removeNominee;

  /// No description provided for @notFoundFillIn.
  ///
  /// In en, this message translates to:
  /// **'Not found in document — please fill in'**
  String get notFoundFillIn;

  /// No description provided for @doubleCheck.
  ///
  /// In en, this message translates to:
  /// **'Please double-check this'**
  String get doubleCheck;

  /// No description provided for @startBeforeEnd.
  ///
  /// In en, this message translates to:
  /// **'Start date must be before end date.'**
  String get startBeforeEnd;

  /// No description provided for @checkPolicyDetails.
  ///
  /// In en, this message translates to:
  /// **'Check your policy details'**
  String get checkPolicyDetails;

  /// No description provided for @enterPolicyDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter policy details'**
  String get enterPolicyDetails;

  /// No description provided for @editPolicyDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit policy details'**
  String get editPolicyDetails;

  /// No description provided for @weReadDetails.
  ///
  /// In en, this message translates to:
  /// **'We read these details from your document. Please check them carefully — fields marked in amber need your attention.'**
  String get weReadDetails;

  /// No description provided for @insuranceType.
  ///
  /// In en, this message translates to:
  /// **'Insurance type'**
  String get insuranceType;

  /// No description provided for @insurerRequired.
  ///
  /// In en, this message translates to:
  /// **'Insurer is required'**
  String get insurerRequired;

  /// No description provided for @planName.
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
  String get planName;

  /// No description provided for @idvRupees.
  ///
  /// In en, this message translates to:
  /// **'IDV (₹)'**
  String get idvRupees;

  /// No description provided for @sumAssuredRupees.
  ///
  /// In en, this message translates to:
  /// **'Sum assured (₹)'**
  String get sumAssuredRupees;

  /// No description provided for @sumInsuredRupees.
  ///
  /// In en, this message translates to:
  /// **'Sum insured (₹)'**
  String get sumInsuredRupees;

  /// No description provided for @premiumRupees.
  ///
  /// In en, this message translates to:
  /// **'Premium (₹)'**
  String get premiumRupees;

  /// No description provided for @premiumFrequency.
  ///
  /// In en, this message translates to:
  /// **'Premium frequency'**
  String get premiumFrequency;

  /// No description provided for @notSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get notSure;

  /// No description provided for @confirmAddPolicy.
  ///
  /// In en, this message translates to:
  /// **'Confirm & add policy'**
  String get confirmAddPolicy;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @whoIsCoveredQ.
  ///
  /// In en, this message translates to:
  /// **'Who is covered?'**
  String get whoIsCoveredQ;

  /// No description provided for @addFamilyMembers.
  ///
  /// In en, this message translates to:
  /// **'Add family members'**
  String get addFamilyMembers;

  /// No description provided for @statusCovered.
  ///
  /// In en, this message translates to:
  /// **'Covered'**
  String get statusCovered;

  /// No description provided for @statusLimited.
  ///
  /// In en, this message translates to:
  /// **'Covered with limits'**
  String get statusLimited;

  /// No description provided for @statusMissing.
  ///
  /// In en, this message translates to:
  /// **'Not covered'**
  String get statusMissing;

  /// No description provided for @statusInfo.
  ///
  /// In en, this message translates to:
  /// **'Policy detail'**
  String get statusInfo;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not found in your document'**
  String get statusUnknown;

  /// No description provided for @ratingStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get ratingStrong;

  /// No description provided for @ratingFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get ratingFair;

  /// No description provided for @ratingWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get ratingWeak;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating: {label}'**
  String ratingLabel(String label);

  /// No description provided for @sampleReport.
  ///
  /// In en, this message translates to:
  /// **'Sample report'**
  String get sampleReport;

  /// No description provided for @reportNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Report not available'**
  String get reportNotAvailable;

  /// No description provided for @reportTypesNote.
  ///
  /// In en, this message translates to:
  /// **'Coverage reports are available for health, life and motor policies.'**
  String get reportTypesNote;

  /// No description provided for @coverAtGlance.
  ///
  /// In en, this message translates to:
  /// **'Your cover at a glance'**
  String get coverAtGlance;

  /// No description provided for @addOnsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 add-on} other{{count} add-ons}}'**
  String addOnsCount(int count);

  /// No description provided for @fromPolicyPage.
  ///
  /// In en, this message translates to:
  /// **'From your policy · page {page}'**
  String fromPolicyPage(int page);

  /// No description provided for @fromPolicyDetails.
  ///
  /// In en, this message translates to:
  /// **'From your policy details'**
  String get fromPolicyDetails;

  /// No description provided for @fromPolicyWording.
  ///
  /// In en, this message translates to:
  /// **'From your policy wording'**
  String get fromPolicyWording;

  /// No description provided for @pageN.
  ///
  /// In en, this message translates to:
  /// **'page {page}'**
  String pageN(int page);

  /// No description provided for @notMentioned.
  ///
  /// In en, this message translates to:
  /// **'Not mentioned in the document we read'**
  String get notMentioned;

  /// No description provided for @whyItMatters.
  ///
  /// In en, this message translates to:
  /// **'Why it matters'**
  String get whyItMatters;

  /// No description provided for @askAboutThisQ.
  ///
  /// In en, this message translates to:
  /// **'What does my policy say about {topic}?'**
  String askAboutThisQ(String topic);

  /// No description provided for @askAboutThis.
  ///
  /// In en, this message translates to:
  /// **'Ask about this'**
  String get askAboutThis;

  /// No description provided for @seeForOwnPolicy.
  ///
  /// In en, this message translates to:
  /// **'See this for your own policy'**
  String get seeForOwnPolicy;

  /// No description provided for @questionsAboutCover.
  ///
  /// In en, this message translates to:
  /// **'Questions about your cover?'**
  String get questionsAboutCover;

  /// No description provided for @addPolicyShort.
  ///
  /// In en, this message translates to:
  /// **'Add policy'**
  String get addPolicyShort;

  /// No description provided for @hero1.
  ///
  /// In en, this message translates to:
  /// **'a maternity bill?'**
  String get hero1;

  /// No description provided for @hero2.
  ///
  /// In en, this message translates to:
  /// **'a knee surgery?'**
  String get hero2;

  /// No description provided for @hero3.
  ///
  /// In en, this message translates to:
  /// **'a flooded car engine?'**
  String get hero3;

  /// No description provided for @hero4.
  ///
  /// In en, this message translates to:
  /// **'a 10-day ICU stay?'**
  String get hero4;

  /// No description provided for @hero5.
  ///
  /// In en, this message translates to:
  /// **'your family\'s future?'**
  String get hero5;

  /// No description provided for @whichPolicy.
  ///
  /// In en, this message translates to:
  /// **'Which policy?'**
  String get whichPolicy;

  /// No description provided for @willPolicyCover.
  ///
  /// In en, this message translates to:
  /// **'Will your policy cover'**
  String get willPolicyCover;

  /// No description provided for @statHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get statHealth;

  /// No description provided for @statLife.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get statLife;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'Per year'**
  String get perYear;

  /// No description provided for @askAboutYourCover.
  ///
  /// In en, this message translates to:
  /// **'Ask about your cover'**
  String get askAboutYourCover;

  /// No description provided for @askWhichPolicy.
  ///
  /// In en, this message translates to:
  /// **'Ask about which policy?'**
  String get askWhichPolicy;

  /// No description provided for @addPolicyFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a policy first, then you can ask questions about it.'**
  String get addPolicyFirst;

  /// No description provided for @askAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about your cover'**
  String get askAnything;

  /// No description provided for @requestReview.
  ///
  /// In en, this message translates to:
  /// **'Request a policy review'**
  String get requestReview;

  /// No description provided for @expertWillCall.
  ///
  /// In en, this message translates to:
  /// **'An insurance expert will call you on your registered number to walk through your policies. We won\'t try to sell you anything.'**
  String get expertWillCall;

  /// No description provided for @helpWithOptional.
  ///
  /// In en, this message translates to:
  /// **'What would you like help with? (optional)'**
  String get helpWithOptional;

  /// No description provided for @requestCall.
  ///
  /// In en, this message translates to:
  /// **'Request call'**
  String get requestCall;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent. Our team will call you on your registered number.'**
  String get requestSent;

  /// No description provided for @talkToExpert.
  ///
  /// In en, this message translates to:
  /// **'Talk to an expert'**
  String get talkToExpert;

  /// No description provided for @expertPitch.
  ///
  /// In en, this message translates to:
  /// **'A 30-minute walk through your cover and what to do next. No selling.'**
  String get expertPitch;

  /// No description provided for @sugMaternity.
  ///
  /// In en, this message translates to:
  /// **'Is maternity covered?'**
  String get sugMaternity;

  /// No description provided for @sugRoomRent.
  ///
  /// In en, this message translates to:
  /// **'What is the room rent limit?'**
  String get sugRoomRent;

  /// No description provided for @sugPed.
  ///
  /// In en, this message translates to:
  /// **'What is the waiting period for pre-existing diseases?'**
  String get sugPed;

  /// No description provided for @sugExcluded.
  ///
  /// In en, this message translates to:
  /// **'What is excluded?'**
  String get sugExcluded;

  /// No description provided for @sugZeroDep.
  ///
  /// In en, this message translates to:
  /// **'Is zero depreciation included?'**
  String get sugZeroDep;

  /// No description provided for @sugIdv.
  ///
  /// In en, this message translates to:
  /// **'What is my IDV?'**
  String get sugIdv;

  /// No description provided for @sugRoadside.
  ///
  /// In en, this message translates to:
  /// **'Is roadside assistance covered?'**
  String get sugRoadside;

  /// No description provided for @sugDeathBenefit.
  ///
  /// In en, this message translates to:
  /// **'What is the death benefit?'**
  String get sugDeathBenefit;

  /// No description provided for @sugNominee.
  ///
  /// In en, this message translates to:
  /// **'Who is the nominee?'**
  String get sugNominee;

  /// No description provided for @sugSurrender.
  ///
  /// In en, this message translates to:
  /// **'Can I surrender this policy?'**
  String get sugSurrender;

  /// No description provided for @sugCover.
  ///
  /// In en, this message translates to:
  /// **'What does this policy cover?'**
  String get sugCover;

  /// No description provided for @askAboutYourPolicy.
  ///
  /// In en, this message translates to:
  /// **'Ask about your policy'**
  String get askAboutYourPolicy;

  /// No description provided for @checkingDocument.
  ///
  /// In en, this message translates to:
  /// **'Checking your policy document…'**
  String get checkingDocument;

  /// No description provided for @askAQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question…'**
  String get askAQuestion;

  /// No description provided for @askAnythingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about this policy'**
  String get askAnythingPolicy;

  /// No description provided for @answersFromDocument.
  ///
  /// In en, this message translates to:
  /// **'Answers come only from your policy document, with the page they were found on.'**
  String get answersFromDocument;

  /// No description provided for @pageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pageLabel(String page);

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String sourceLabel(String source);

  /// No description provided for @policyDocument.
  ///
  /// In en, this message translates to:
  /// **'policy document'**
  String get policyDocument;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {level, select, high{high} medium{medium} low{low} other{{level}}}'**
  String confidenceLabel(String level);

  /// No description provided for @fileTooBig.
  ///
  /// In en, this message translates to:
  /// **'File must be under 20 MB.'**
  String get fileTooBig;

  /// No description provided for @wrongFileType.
  ///
  /// In en, this message translates to:
  /// **'Please choose a PDF, JPG or PNG file.'**
  String get wrongFileType;

  /// No description provided for @addAPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a policy'**
  String get addAPolicyTitle;

  /// No description provided for @uploadIntro.
  ///
  /// In en, this message translates to:
  /// **'Upload your policy document and we\'ll read it for you. Make sure it shows the policy number, start and end dates, premium, cover amount and insurer/plan name.'**
  String get uploadIntro;

  /// No description provided for @uploadingPercent.
  ///
  /// In en, this message translates to:
  /// **'Uploading… {percent}%'**
  String uploadingPercent(int percent);

  /// No description provided for @uploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload policy PDF'**
  String get uploadPdf;

  /// No description provided for @recommendedBest.
  ///
  /// In en, this message translates to:
  /// **'Recommended · Best accuracy'**
  String get recommendedBest;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @photoTip.
  ///
  /// In en, this message translates to:
  /// **'Place the policy on a flat, well-lit surface'**
  String get photoTip;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo of the policy'**
  String get uploadPhoto;

  /// No description provided for @jpgOrPng.
  ///
  /// In en, this message translates to:
  /// **'JPG or PNG'**
  String get jpgOrPng;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter details manually'**
  String get enterManually;

  /// No description provided for @noDocumentNeeded.
  ///
  /// In en, this message translates to:
  /// **'No document needed'**
  String get noDocumentNeeded;

  /// No description provided for @importGmail.
  ///
  /// In en, this message translates to:
  /// **'Import from Gmail'**
  String get importGmail;

  /// No description provided for @docsEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Your documents are encrypted and only visible to you.'**
  String get docsEncrypted;

  /// No description provided for @couldNotDial.
  ///
  /// In en, this message translates to:
  /// **'Could not open the dialler for {number}'**
  String couldNotDial(String number);

  /// No description provided for @callFirst.
  ///
  /// In en, this message translates to:
  /// **'In an emergency, call first.'**
  String get callFirst;

  /// No description provided for @insuranceCanWait.
  ///
  /// In en, this message translates to:
  /// **'Insurance questions can wait. Get help, then use the details below.'**
  String get insuranceCanWait;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get ambulance;

  /// No description provided for @yourPolicyNumbers.
  ///
  /// In en, this message translates to:
  /// **'Your policy numbers'**
  String get yourPolicyNumbers;

  /// No description provided for @addPolicyNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Add a policy and its number will show here, ready to quote at the hospital or to your insurer.'**
  String get addPolicyNumberHint;

  /// No description provided for @goodToKnow.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get goodToKnow;

  /// No description provided for @tipCashless.
  ///
  /// In en, this message translates to:
  /// **'For planned cashless treatment, tell the hospital desk your insurer and policy number first.'**
  String get tipCashless;

  /// No description provided for @tipHelpline.
  ///
  /// In en, this message translates to:
  /// **'Your insurer\'s claims helpline is printed on your policy document and e-card. Keep it handy.'**
  String get tipHelpline;

  /// No description provided for @tipIntimation.
  ///
  /// In en, this message translates to:
  /// **'Many policies want an intimation within 24 hours of an emergency admission. Check the time limit in your wording.'**
  String get tipIntimation;

  /// No description provided for @callLabel.
  ///
  /// In en, this message translates to:
  /// **'Call {label} {number}'**
  String callLabel(String label, String number);

  /// No description provided for @policyNumberNotAdded.
  ///
  /// In en, this message translates to:
  /// **'Policy number not added yet'**
  String get policyNumberNotAdded;

  /// No description provided for @validTill.
  ///
  /// In en, this message translates to:
  /// **'{type} · valid till {date}'**
  String validTill(String type, String date);

  /// No description provided for @copyPolicyNumber.
  ///
  /// In en, this message translates to:
  /// **'Copy policy number'**
  String get copyPolicyNumber;

  /// No description provided for @policyNumberCopied.
  ///
  /// In en, this message translates to:
  /// **'Policy number copied'**
  String get policyNumberCopied;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @earnCoins.
  ///
  /// In en, this message translates to:
  /// **'EARN COINS'**
  String get earnCoins;

  /// No description provided for @useCoins.
  ///
  /// In en, this message translates to:
  /// **'USE COINS'**
  String get useCoins;

  /// No description provided for @yourCoins.
  ///
  /// In en, this message translates to:
  /// **'Your coins'**
  String get yourCoins;

  /// No description provided for @coinsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 coin} other{{count} coins}}'**
  String coinsCount(int count);

  /// No description provided for @earnedForOrganising.
  ///
  /// In en, this message translates to:
  /// **'Earned for organising your insurance'**
  String get earnedForOrganising;

  /// No description provided for @waysToEarn.
  ///
  /// In en, this message translates to:
  /// **'Ways to earn'**
  String get waysToEarn;

  /// No description provided for @progressDone.
  ///
  /// In en, this message translates to:
  /// **'{progress} done'**
  String progressDone(String progress);

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @useYourCoins.
  ///
  /// In en, this message translates to:
  /// **'Use your coins'**
  String get useYourCoins;

  /// No description provided for @perksOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Perks are on the way. Keep earning — your coins will be ready when they launch.'**
  String get perksOnTheWay;

  /// No description provided for @familyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get familyTitle;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// No description provided for @addYourFamily.
  ///
  /// In en, this message translates to:
  /// **'Add your family'**
  String get addYourFamily;

  /// No description provided for @addFamilyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the people covered by your policies to see who is protected and where the gaps are.'**
  String get addFamilyMessage;

  /// No description provided for @notLinked.
  ///
  /// In en, this message translates to:
  /// **'Not linked to any policy'**
  String get notLinked;

  /// No description provided for @addFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Add family member'**
  String get addFamilyMember;

  /// No description provided for @editFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Edit family member'**
  String get editFamilyMember;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMember;

  /// No description provided for @policyTypeName.
  ///
  /// In en, this message translates to:
  /// **'{type, select, health{Health} life{Life} motor{Motor} other{Other}}'**
  String policyTypeName(String type);

  /// No description provided for @enumLabel.
  ///
  /// In en, this message translates to:
  /// **'{value, select, self{Self} spouse{Spouse} child{Child} parent{Parent} sibling{Sibling} otherValue{Other} annual{Annual} half_yearly{Half-yearly} quarterly{Quarterly} monthly{Monthly} single{Single} other{}}'**
  String enumLabel(String value);

  /// No description provided for @clauseType.
  ///
  /// In en, this message translates to:
  /// **'{type, select, benefit{Benefit} exclusion{Exclusion} waiting_period{Waiting period} limit{Limit} condition{Condition} definition{Definition} other{Clause}}'**
  String clauseType(String type);

  /// No description provided for @untitledPolicy.
  ///
  /// In en, this message translates to:
  /// **'Untitled policy'**
  String get untitledPolicy;

  /// No description provided for @errPdfPassword.
  ///
  /// In en, this message translates to:
  /// **'This PDF is password-protected. Please upload an unlocked copy.'**
  String get errPdfPassword;

  /// No description provided for @errPdfTooManyPages.
  ///
  /// In en, this message translates to:
  /// **'This document has too many pages. Please upload only the policy schedule and wording.'**
  String get errPdfTooManyPages;

  /// No description provided for @errPdfUnreadable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open this file. It may be damaged.'**
  String get errPdfUnreadable;

  /// No description provided for @errNoText.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read any text. Try a clearer photo or the original PDF.'**
  String get errNoText;

  /// No description provided for @errOcrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scanned documents can\'t be read right now. Please upload a digital PDF or enter details manually.'**
  String get errOcrUnavailable;

  /// No description provided for @errAiUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Our reading service is busy. Please retry in a minute.'**
  String get errAiUnavailable;

  /// No description provided for @errProcessing.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t process this document.'**
  String get errProcessing;

  /// No description provided for @yourPolicies.
  ///
  /// In en, this message translates to:
  /// **'Your policies'**
  String get yourPolicies;

  /// No description provided for @coinsOpenRewards.
  ///
  /// In en, this message translates to:
  /// **'Coins: {count}. Open rewards'**
  String coinsOpenRewards(int count);

  /// No description provided for @policiesNeedCheck.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 policy needs a quick check from you} other{{count} policies need a quick check from you}}'**
  String policiesNeedCheck(int count);

  /// No description provided for @daysLeftEnds.
  ///
  /// In en, this message translates to:
  /// **'days left · ends {date}'**
  String daysLeftEnds(String date);

  /// No description provided for @earnCoinsOrganised.
  ///
  /// In en, this message translates to:
  /// **'Earn coins for staying organised'**
  String get earnCoinsOrganised;

  /// No description provided for @addPoliciesNominees.
  ///
  /// In en, this message translates to:
  /// **'Add policies, nominees and family members.'**
  String get addPoliciesNominees;

  /// No description provided for @worthALook.
  ///
  /// In en, this message translates to:
  /// **'Worth a look'**
  String get worthALook;

  /// No description provided for @allCount.
  ///
  /// In en, this message translates to:
  /// **'All {count}'**
  String allCount(int count);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @myInsurance.
  ///
  /// In en, this message translates to:
  /// **'My insurance'**
  String get myInsurance;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @addPoliciesHere.
  ///
  /// In en, this message translates to:
  /// **'Add your health, life and motor policies and they will all live here.'**
  String get addPoliciesHere;

  /// No description provided for @allWithCount.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String allWithCount(int count);

  /// No description provided for @noPoliciesOfType.
  ///
  /// In en, this message translates to:
  /// **'No policies of this type.'**
  String get noPoliciesOfType;

  /// No description provided for @takingLonger.
  ///
  /// In en, this message translates to:
  /// **'This is taking longer than usual. We\'ll keep working on it — check back shortly.'**
  String get takingLonger;

  /// No description provided for @readingYourPolicy.
  ///
  /// In en, this message translates to:
  /// **'Reading your policy'**
  String get readingYourPolicy;

  /// No description provided for @underAMinute.
  ///
  /// In en, this message translates to:
  /// **'This usually takes under a minute.'**
  String get underAMinute;

  /// No description provided for @noClausesYet.
  ///
  /// In en, this message translates to:
  /// **'No clauses yet'**
  String get noClausesYet;

  /// No description provided for @clausesNote.
  ///
  /// In en, this message translates to:
  /// **'Clauses are read from your uploaded policy document. Manually added policies have none.'**
  String get clausesNote;

  /// No description provided for @searchWording.
  ///
  /// In en, this message translates to:
  /// **'Search the policy wording'**
  String get searchWording;

  /// No description provided for @nothingMatches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches.'**
  String get nothingMatches;

  /// No description provided for @notEnoughDetails.
  ///
  /// In en, this message translates to:
  /// **'Not enough details yet'**
  String get notEnoughDetails;

  /// No description provided for @healthCounts.
  ///
  /// In en, this message translates to:
  /// **'{strong} strong · {attention} need attention · {missing} not covered'**
  String healthCounts(int strong, int attention, int missing);

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get needsAttention;

  /// No description provided for @notMentionedInDoc.
  ///
  /// In en, this message translates to:
  /// **'Not mentioned in your document'**
  String get notMentionedInDoc;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get allCaughtUp;

  /// No description provided for @notificationsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Renewal reminders and policy updates will appear here.'**
  String get notificationsAppearHere;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @helpLegal.
  ///
  /// In en, this message translates to:
  /// **'Help & legal'**
  String get helpLegal;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & conditions'**
  String get termsConditions;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @comparePolicies.
  ///
  /// In en, this message translates to:
  /// **'Compare policies'**
  String get comparePolicies;

  /// No description provided for @compareN.
  ///
  /// In en, this message translates to:
  /// **'Compare {count} policies'**
  String compareN(int count);

  /// No description provided for @choose2or3.
  ///
  /// In en, this message translates to:
  /// **'Choose 2 or 3 policies'**
  String get choose2or3;

  /// No description provided for @compareIntro.
  ///
  /// In en, this message translates to:
  /// **'Compare policies you already have — for example two health policies — to see differences in cover and features.'**
  String get compareIntro;

  /// No description provided for @typeCover.
  ///
  /// In en, this message translates to:
  /// **'{type} · {amount} cover'**
  String typeCover(String type, String amount);

  /// No description provided for @sideBySide.
  ///
  /// In en, this message translates to:
  /// **'Side by side'**
  String get sideBySide;

  /// No description provided for @reviewNeeded.
  ///
  /// In en, this message translates to:
  /// **'Review needed'**
  String get reviewNeeded;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @endsInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Ends in 1 day} other{Ends in {days} days}}'**
  String endsInDays(int days);

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @datesMissing.
  ///
  /// In en, this message translates to:
  /// **'Dates missing'**
  String get datesMissing;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day left} other{{days} days left}}'**
  String daysLeft(int days);

  /// No description provided for @checkupTitle.
  ///
  /// In en, this message translates to:
  /// **'Your insurance check-up'**
  String get checkupTitle;

  /// No description provided for @lookingGood.
  ///
  /// In en, this message translates to:
  /// **'Looking good'**
  String get lookingGood;

  /// No description provided for @noGapsFound.
  ///
  /// In en, this message translates to:
  /// **'We found no gaps in the policies you have added.'**
  String get noGapsFound;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode · offline AI'**
  String get demoMode;

  /// No description provided for @confirmAppLock.
  ///
  /// In en, this message translates to:
  /// **'Confirm to turn on app lock'**
  String get confirmAppLock;

  /// No description provided for @unlockApp.
  ///
  /// In en, this message translates to:
  /// **'Unlock {app}'**
  String unlockApp(String app);

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @neverMissRenewal.
  ///
  /// In en, this message translates to:
  /// **'Never miss a renewal'**
  String get neverMissRenewal;

  /// No description provided for @pushPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications for renewal reminders, processing updates and important policy alerts. Only things that matter — no marketing.'**
  String get pushPromptBody;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @somethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWrong;

  /// No description provided for @timedOut.
  ///
  /// In en, this message translates to:
  /// **'The connection timed out. Please try again.'**
  String get timedOut;

  /// No description provided for @cantReachServer.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your internet connection.'**
  String get cantReachServer;

  /// No description provided for @somethingWrongRetry.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWrongRetry;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Same as phone'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

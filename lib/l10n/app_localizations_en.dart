// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get appLanguage => 'App language';

  @override
  String get appLanguageHelp => 'Buttons, menus and screens. AI answers have their own language setting.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get started';

  @override
  String get continueAction => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get seeAll => 'See all';

  @override
  String get tryAgain => 'Try again';

  @override
  String get onb1Title => 'All your cover, one place';

  @override
  String get onb1Body => 'Health, life and motor policies for the whole family, kept safe and easy to find.';

  @override
  String get onb2Title => 'Ask in plain words';

  @override
  String get onb2Body => 'Every answer points to the page it came from, or tells you it isn\'t in your policy.';

  @override
  String get onb3Title => 'Renewals never sneak up';

  @override
  String get onb3Body => 'A gentle nudge well before your policy ends, so you are never left uncovered.';

  @override
  String get onb4Title => 'Family and nominees, sorted';

  @override
  String get onb4Body => 'See who is covered, who gets what, and what to do if something happens.';

  @override
  String get loginHeadline => 'All your insurance.\nOne place. Clearly explained.';

  @override
  String get loginSubhead => 'Add your policies, understand what you\'re covered for, and never miss a renewal.';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get consentStart => 'I agree to the ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get consentAnd => ' and ';

  @override
  String get terms => 'Terms';

  @override
  String get consentEnd => ', and consent to my policy documents being processed to provide this service.';

  @override
  String get getOtp => 'Get OTP';

  @override
  String get otpTitle => 'Enter the 6-digit code';

  @override
  String otpSentTo(String identifier) {
    return 'Sent to $identifier';
  }

  @override
  String get verify => 'Verify';

  @override
  String resendIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get resendCode => 'Resend code';

  @override
  String get nameTitle => 'What should we call you?';

  @override
  String get fullName => 'Full name';

  @override
  String get dobOptional => 'Date of birth (optional)';

  @override
  String get navHome => 'Home';

  @override
  String get navPortfolio => 'Portfolio';

  @override
  String get navExplore => 'Explore';

  @override
  String get navProfile => 'Profile';

  @override
  String get addPolicy => 'Add policy';

  @override
  String hiName(String name) {
    return 'Hi $name';
  }

  @override
  String get helloThere => 'Hello there';

  @override
  String get homeSubtitle => 'Here\'s where your cover stands today.';

  @override
  String get whatToDo => 'What would you like to do?';

  @override
  String get comingUp => 'Coming up';

  @override
  String get coverageReport => 'Coverage report';

  @override
  String get askAi => 'Ask AI';

  @override
  String get claimHelp => 'Claim help';

  @override
  String get family => 'Family';

  @override
  String get nominees => 'Nominees';

  @override
  String get compare => 'Compare';

  @override
  String get emergencyCard => 'Emergency card';

  @override
  String get seeCoverageReport => 'See your coverage report';

  @override
  String get addAPolicy => 'Add a policy';

  @override
  String get seeSampleReport => 'See a sample report';

  @override
  String coinsEarned(int coins) {
    return '+$coins coins earned';
  }

  @override
  String get personalDetails => 'Personal details';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get save => 'Save';

  @override
  String get notifications => 'Notifications';

  @override
  String get renewalReminders => 'Renewal reminders';

  @override
  String get renewalRemindersHelp => '90, 60, 30, 15, 7 and 1 day before a policy expires';

  @override
  String get policyUpdates => 'Policy updates';

  @override
  String get policyUpdatesHelp => 'When a document has been read and is ready to review';

  @override
  String get notificationsPromise =>
      'We never send promotional notifications, and notifications never show your policy numbers, amounts or health details.';

  @override
  String get faqSafeQ => 'Is my data safe?';

  @override
  String get faqSafeA =>
      'Your documents are stored encrypted and are only accessible to you. We do not sell your data or share it with insurers or agents.';

  @override
  String get faqAiQ => 'How does the AI answer my questions?';

  @override
  String get faqAiA =>
      'It reads only your own policy document and shows the page its answer came from. If the answer is not in your document it will say so instead of guessing.';

  @override
  String get faqWrongQ => 'The details extracted from my policy are wrong. What do I do?';

  @override
  String get faqWrongA =>
      'Open the policy, tap the ⋮ menu and choose \"Edit details\". Anything you correct is saved as confirmed by you.';

  @override
  String get faqUploadQ => 'Which documents can I upload?';

  @override
  String get faqUploadA =>
      'PDF policy documents work best. You can also upload a clear photo (JPG/PNG) up to 20 MB. Password-protected PDFs must be unlocked first.';

  @override
  String get faqSellQ => 'Do you sell insurance?';

  @override
  String faqSellA(String app) {
    return 'No. $app helps you organise and understand the policies you already have. We do not sell or recommend insurance products.';
  }

  @override
  String get faqDeleteQ => 'How do I delete my account?';

  @override
  String get faqDeleteA => 'Profile → Privacy & data → Delete account. Your data is permanently deleted after 7 days.';

  @override
  String get supportThanks => 'Thanks — we\'ll get back to you within 2 working days.';

  @override
  String get helpSupport => 'Help & support';

  @override
  String get faqTitle => 'Frequently asked questions';

  @override
  String get contactUs => 'Contact us';

  @override
  String get topic => 'Topic';

  @override
  String get topicQuestion => 'A question';

  @override
  String get topicProblem => 'Something isn\'t working';

  @override
  String get topicFeedback => 'Feedback';

  @override
  String get topicPrivacy => 'Privacy / my data';

  @override
  String get topicGrievance => 'Complaint (grievance)';

  @override
  String get howCanWeHelp => 'How can we help?';

  @override
  String get send => 'Send';

  @override
  String get emailUsInstead => 'Email us instead';

  @override
  String get deleteAccountQ => 'Delete your account?';

  @override
  String get deleteAccountBody =>
      'Your account will be disabled now. All your policies, documents and data will be permanently deleted after 7 days. Logging in again within 7 days cancels the deletion.';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get privacyData => 'Privacy & data';

  @override
  String get privacyPromise =>
      'We use your policy documents only to show, explain and remind you about your own insurance. Documents are encrypted, never sold, and never shared with insurers or agents. AI processing uses providers contractually barred from training on your data.';

  @override
  String get downloadMyData => 'Download my data';

  @override
  String get downloadMyDataHelp => 'A copy of your profile, policies and questions';

  @override
  String get privacyPolicyItem => 'Privacy policy';

  @override
  String get grievanceOfficer => 'Grievance officer';

  @override
  String get deleteAccountHelp => 'Permanently delete all your data';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockHelp => 'Use fingerprint, face or device PIN to open the app';

  @override
  String get setUpScreenLock => 'Set up a screen lock on your phone first.';

  @override
  String get aiAnswerLanguage => 'AI answer language';

  @override
  String get aiAnswerLanguageHelp =>
      'Summaries and answers about your policies will be written in this language. You can ask questions in it too.';

  @override
  String get policy => 'Policy';

  @override
  String get reviewExtracted => 'Please review the extracted details';

  @override
  String get coverageReportHelp => 'What is covered, what has limits and what is not — item by item';

  @override
  String get noNomineeAddOne => 'No nominee recorded — add one';

  @override
  String get notRecorded => 'Not recorded';

  @override
  String get policyClauses => 'Policy clauses';

  @override
  String get policyClausesHelp => 'Benefits, exclusions, waiting periods and limits — word for word';

  @override
  String get whoIsCovered => 'Who is covered';

  @override
  String get understandPolicy => 'Understand your policy';

  @override
  String get keyDetails => 'Key details';

  @override
  String get coverageDetails => 'Coverage details';

  @override
  String typeInsurance(String type) {
    return '$type insurance';
  }

  @override
  String get idv => 'Insured declared value';

  @override
  String get cover => 'Cover';

  @override
  String validRange(String start, String end) {
    return 'Valid $start – $end';
  }

  @override
  String premiumValue(String amount) {
    return 'Premium $amount';
  }

  @override
  String get askAiShort => 'Ask AI';

  @override
  String get renewal => 'Renewal';

  @override
  String get claimHelpAction => 'Claim help';

  @override
  String get documentsRequired => 'Documents usually required';

  @override
  String get followInsurerProcess => 'Always follow the claim process stated in your policy and by your insurer.';

  @override
  String get readingPolicy => 'Reading your policy…';

  @override
  String get watchOutFor => 'Watch out for';

  @override
  String get policyNumber => 'Policy number';

  @override
  String get insurer => 'Insurer';

  @override
  String get plan => 'Plan';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get premium => 'Premium';

  @override
  String get coverRow => 'Cover';

  @override
  String get deletePolicyQ => 'Delete this policy?';

  @override
  String get deletePolicyBody => 'The policy, its document and your questions about it will be permanently deleted.';

  @override
  String get delete => 'Delete';

  @override
  String get editDetails => 'Edit details';

  @override
  String get viewDocument => 'View document';

  @override
  String get deletePolicy => 'Delete policy';

  @override
  String get policyHealth => 'Policy health';

  @override
  String get noIssuesFound => 'No issues found in the details we read';

  @override
  String thingsToKnow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things to know about',
      one: '1 thing to know about',
    );
    return '$_temp0';
  }

  @override
  String get markedRenewed => 'Marked as renewed. Add your new policy document to keep things up to date.';

  @override
  String get add => 'Add';

  @override
  String get renewalTitle => 'Renewal';

  @override
  String get addEndDate => 'Add the policy end date to track renewal.';

  @override
  String expiredOn(String date) {
    return 'This policy expired on $date.';
  }

  @override
  String renewsOn(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(days, locale: localeName, other: '$days days left', one: '1 day left');
    return 'Renews on $date — $_temp0.';
  }

  @override
  String lastPremium(String amount) {
    return 'Last premium: $amount';
  }

  @override
  String get remindSchedule => 'We\'ll remind you 90, 60, 30, 15, 7 and 1 day before expiry.';

  @override
  String get remindersOff => 'Renewal reminders are turned off in settings.';

  @override
  String get markedAsRenewed => '✓ Marked as renewed';

  @override
  String get markedNotRenewing => 'Marked as not renewing';

  @override
  String get iRenewed => 'I\'ve renewed this policy';

  @override
  String get notRenewing => 'I\'m not renewing';

  @override
  String get undo => 'Undo';

  @override
  String get claimHealthTitle => 'Health insurance claim';

  @override
  String get claimHealthStep1 => 'Check that the hospital is in your insurer\'s network (for cashless treatment).';

  @override
  String get claimHealthStep2 =>
      'Planned admission: request cashless pre-authorisation at the hospital\'s insurance desk at least 48 hours before.';

  @override
  String get claimHealthStep3 => 'Emergency admission: inform your insurer or TPA within 24 hours.';

  @override
  String get claimHealthStep4 => 'Show your health card / policy number and photo ID at the hospital.';

  @override
  String get claimHealthStep5 =>
      'For reimbursement (non-network hospital), pay the bill and submit the claim within the time stated in your policy.';

  @override
  String get claimHealthStep6 => 'Track your claim with the claim reference number your insurer gives you.';

  @override
  String get claimHealthDoc1 => 'Claim form (signed)';

  @override
  String get claimHealthDoc2 => 'Policy copy / health card';

  @override
  String get claimHealthDoc3 => 'Photo ID and address proof';

  @override
  String get claimHealthDoc4 => 'Discharge summary';

  @override
  String get claimHealthDoc5 => 'Original hospital bills and payment receipts';

  @override
  String get claimHealthDoc6 => 'Doctor\'s prescriptions and investigation reports';

  @override
  String get claimHealthDoc7 => 'Cancelled cheque or bank details (for reimbursement)';

  @override
  String get claimMotorTitle => 'Motor insurance claim';

  @override
  String get claimMotorStep1 =>
      'Ensure everyone is safe. For theft or third-party injury, file an FIR with the police.';

  @override
  String get claimMotorStep2 => 'Inform your insurer as soon as possible and get a claim number.';

  @override
  String get claimMotorStep3 =>
      'Do not repair the vehicle before the insurer\'s surveyor inspects it (unless told otherwise).';

  @override
  String get claimMotorStep4 =>
      'Take the vehicle to a network garage for cashless repair, or any garage for reimbursement.';

  @override
  String get claimMotorStep5 => 'Pay any compulsory deductible and non-covered items; the insurer settles the rest.';

  @override
  String get claimMotorDoc1 => 'Claim form';

  @override
  String get claimMotorDoc2 => 'Policy copy';

  @override
  String get claimMotorDoc3 => 'Registration certificate (RC)';

  @override
  String get claimMotorDoc4 => 'Driving licence of the driver';

  @override
  String get claimMotorDoc5 => 'FIR (for theft, major accident or third-party claims)';

  @override
  String get claimMotorDoc6 => 'Repair estimate and final invoice';

  @override
  String get claimLifeTitle => 'Life insurance claim';

  @override
  String get claimLifeStep1 => 'The nominee should inform the insurer as soon as possible.';

  @override
  String get claimLifeStep2 => 'Collect the claim form from the insurer\'s branch or website.';

  @override
  String get claimLifeStep3 => 'Submit the form with the required documents.';

  @override
  String get claimLifeStep4 => 'The insurer may investigate claims made within the first few policy years.';

  @override
  String get claimLifeStep5 => 'Track the claim status with the insurer.';

  @override
  String get claimLifeDoc1 => 'Claim form';

  @override
  String get claimLifeDoc2 => 'Original policy document';

  @override
  String get claimLifeDoc3 => 'Death certificate';

  @override
  String get claimLifeDoc4 => 'Nominee\'s photo ID, address proof and bank details';

  @override
  String get claimLifeDoc5 => 'Medical records / FIR and post-mortem report (if applicable)';

  @override
  String get claimOtherTitle => 'Making a claim';

  @override
  String get claimOtherStep1 => 'Read your policy to confirm the event is covered.';

  @override
  String get claimOtherStep2 => 'Inform your insurer as soon as possible and get a claim number.';

  @override
  String get claimOtherStep3 => 'Submit the claim form and supporting documents.';

  @override
  String get claimOtherStep4 => 'Track your claim with the insurer.';

  @override
  String get claimOtherDoc1 => 'Claim form';

  @override
  String get claimOtherDoc2 => 'Policy copy';

  @override
  String get claimOtherDoc3 => 'Photo ID';

  @override
  String get claimOtherDoc4 => 'Proof of loss / bills';

  @override
  String get explore => 'Explore';

  @override
  String get claimGuides => 'Claim guides';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get gmailImport => 'Gmail import';

  @override
  String get digiLocker => 'DigiLocker';

  @override
  String get claimTracking => 'Claim tracking';

  @override
  String get wellness => 'Wellness';

  @override
  String get deathLife1 =>
      'Inform the insurer as soon as possible (call centre, branch or website) and note the claim number.';

  @override
  String get deathLife2 => 'The nominee fills the death claim form and attaches the documents below.';

  @override
  String get deathLife3 =>
      'For deaths within the first 3 policy years the insurer may investigate before paying — this is normal.';

  @override
  String get deathLife4 =>
      'The claim amount is paid to the nominee\'s bank account. If the nominee is a minor, the appointee receives it.';

  @override
  String get deathHealth1 =>
      'A health policy ends for the person who died. If it is a family floater, the other members stay covered until renewal.';

  @override
  String get deathHealth2 =>
      'Any pending hospital bills can still be claimed by the nominee — submit them within the claim time limit.';

  @override
  String get deathHealth3 => 'Inform the insurer to remove the member and update the policy at renewal.';

  @override
  String get deathMotor1 =>
      'The vehicle and its insurance must be transferred to the legal heir within the time the insurer specifies.';

  @override
  String get deathMotor2 => 'Inform the insurer with the death certificate and the new owner\'s documents.';

  @override
  String get deathMotor3 =>
      'Until transfer, avoid using the vehicle — claims may be refused if the registered owner has died.';

  @override
  String get deathOther1 =>
      'Inform the insurer with the death certificate and ask for their claim or transfer process.';

  @override
  String get deathDoc1 => 'Death certificate (original or attested copy)';

  @override
  String get deathDoc2 => 'Policy document or policy number';

  @override
  String get deathDoc3 => 'Nominee\'s photo ID and address proof (Aadhaar / PAN)';

  @override
  String get deathDoc4 => 'Nominee\'s bank details (cancelled cheque)';

  @override
  String get deathDoc5 => 'Medical records or hospital discharge summary (if applicable)';

  @override
  String get deathDoc6 => 'FIR and post-mortem report (for accidental death)';

  @override
  String shareSubject(String type) {
    return 'My $type insurance details';
  }

  @override
  String shareBody(String name, String type, String number, String cover, String nominees, String steps) {
    return 'Keep this safe.\n\n$name — $type insurance\nPolicy number: $number\nCover: $cover\nNominees: $nominees\n\nIf something happens to me:\n$steps';
  }

  @override
  String get seePolicyDocument => 'see policy document';

  @override
  String get addNominee => 'Add nominee';

  @override
  String get fullyAssigned => '100% of the claim amount is assigned';

  @override
  String get noNomineeYet => 'No nominee recorded yet';

  @override
  String assignedLeft(int assigned, int left) {
    return '$assigned% assigned · $left% left';
  }

  @override
  String get nomineeLegalNote =>
      'This is your own record. The nominee that counts legally is the one registered with your insurer — keep them the same.';

  @override
  String minorAppointee(String name) {
    return 'Minor · appointee: $name';
  }

  @override
  String get notSet => 'not set';

  @override
  String get ifSomethingHappens => 'If something happens to you';

  @override
  String get docsFamilyNeeds => 'Documents your family will need';

  @override
  String get shareWithFamily => 'Share these details with family';

  @override
  String get needAppointee => 'Add an appointee — an adult who receives the money for a minor.';

  @override
  String get editNominee => 'Edit nominee';

  @override
  String get pickFromFamily => 'Pick from family';

  @override
  String get fullNameAsPolicy => 'Full name (as in the policy)';

  @override
  String get relationship => 'Relationship';

  @override
  String shareOfClaim(int percent) {
    return 'Share of claim: $percent%';
  }

  @override
  String get appointeeLabel => 'Appointee (adult who receives money for the minor)';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get removeNominee => 'Remove nominee';

  @override
  String get notFoundFillIn => 'Not found in document — please fill in';

  @override
  String get doubleCheck => 'Please double-check this';

  @override
  String get startBeforeEnd => 'Start date must be before end date.';

  @override
  String get checkPolicyDetails => 'Check your policy details';

  @override
  String get enterPolicyDetails => 'Enter policy details';

  @override
  String get editPolicyDetails => 'Edit policy details';

  @override
  String get weReadDetails =>
      'We read these details from your document. Please check them carefully — fields marked in amber need your attention.';

  @override
  String get insuranceType => 'Insurance type';

  @override
  String get insurerRequired => 'Insurer is required';

  @override
  String get planName => 'Plan name';

  @override
  String get idvRupees => 'IDV (₹)';

  @override
  String get sumAssuredRupees => 'Sum assured (₹)';

  @override
  String get sumInsuredRupees => 'Sum insured (₹)';

  @override
  String get premiumRupees => 'Premium (₹)';

  @override
  String get premiumFrequency => 'Premium frequency';

  @override
  String get notSure => 'Not sure';

  @override
  String get confirmAddPolicy => 'Confirm & add policy';

  @override
  String get select => 'Select';

  @override
  String get whoIsCoveredQ => 'Who is covered?';

  @override
  String get addFamilyMembers => 'Add family members';

  @override
  String get statusCovered => 'Covered';

  @override
  String get statusLimited => 'Covered with limits';

  @override
  String get statusMissing => 'Not covered';

  @override
  String get statusInfo => 'Policy detail';

  @override
  String get statusUnknown => 'Not found in your document';

  @override
  String get ratingStrong => 'Strong';

  @override
  String get ratingFair => 'Fair';

  @override
  String get ratingWeak => 'Weak';

  @override
  String ratingLabel(String label) {
    return 'Rating: $label';
  }

  @override
  String get sampleReport => 'Sample report';

  @override
  String get reportNotAvailable => 'Report not available';

  @override
  String get reportTypesNote => 'Coverage reports are available for health, life and motor policies.';

  @override
  String get coverAtGlance => 'Your cover at a glance';

  @override
  String addOnsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count add-ons', one: '1 add-on');
    return '$_temp0';
  }

  @override
  String fromPolicyPage(int page) {
    return 'From your policy · page $page';
  }

  @override
  String get fromPolicyDetails => 'From your policy details';

  @override
  String get fromPolicyWording => 'From your policy wording';

  @override
  String pageN(int page) {
    return 'page $page';
  }

  @override
  String get notMentioned => 'Not mentioned in the document we read';

  @override
  String get whyItMatters => 'Why it matters';

  @override
  String askAboutThisQ(String topic) {
    return 'What does my policy say about $topic?';
  }

  @override
  String get askAboutThis => 'Ask about this';

  @override
  String get seeForOwnPolicy => 'See this for your own policy';

  @override
  String get questionsAboutCover => 'Questions about your cover?';

  @override
  String get addPolicyShort => 'Add policy';

  @override
  String get hero1 => 'a maternity bill?';

  @override
  String get hero2 => 'a knee surgery?';

  @override
  String get hero3 => 'a flooded car engine?';

  @override
  String get hero4 => 'a 10-day ICU stay?';

  @override
  String get hero5 => 'your family\'s future?';

  @override
  String get whichPolicy => 'Which policy?';

  @override
  String get willPolicyCover => 'Will your policy cover';

  @override
  String get statHealth => 'Health';

  @override
  String get statLife => 'Life';

  @override
  String get perYear => 'Per year';

  @override
  String get askAboutYourCover => 'Ask about your cover';

  @override
  String get askWhichPolicy => 'Ask about which policy?';

  @override
  String get addPolicyFirst => 'Add a policy first, then you can ask questions about it.';

  @override
  String get askAnything => 'Ask anything about your cover';

  @override
  String get requestReview => 'Request a policy review';

  @override
  String get expertWillCall =>
      'An insurance expert will call you on your registered number to walk through your policies. We won\'t try to sell you anything.';

  @override
  String get helpWithOptional => 'What would you like help with? (optional)';

  @override
  String get requestCall => 'Request call';

  @override
  String get requestSent => 'Request sent. Our team will call you on your registered number.';

  @override
  String get talkToExpert => 'Talk to an expert';

  @override
  String get expertPitch => 'A 30-minute walk through your cover and what to do next. No selling.';

  @override
  String get sugMaternity => 'Is maternity covered?';

  @override
  String get sugRoomRent => 'What is the room rent limit?';

  @override
  String get sugPed => 'What is the waiting period for pre-existing diseases?';

  @override
  String get sugExcluded => 'What is excluded?';

  @override
  String get sugZeroDep => 'Is zero depreciation included?';

  @override
  String get sugIdv => 'What is my IDV?';

  @override
  String get sugRoadside => 'Is roadside assistance covered?';

  @override
  String get sugDeathBenefit => 'What is the death benefit?';

  @override
  String get sugNominee => 'Who is the nominee?';

  @override
  String get sugSurrender => 'Can I surrender this policy?';

  @override
  String get sugCover => 'What does this policy cover?';

  @override
  String get askAboutYourPolicy => 'Ask about your policy';

  @override
  String get checkingDocument => 'Checking your policy document…';

  @override
  String get askAQuestion => 'Ask a question…';

  @override
  String get askAnythingPolicy => 'Ask anything about this policy';

  @override
  String get answersFromDocument => 'Answers come only from your policy document, with the page they were found on.';

  @override
  String pageLabel(String page) {
    return 'Page $page';
  }

  @override
  String sourceLabel(String source) {
    return 'Source: $source';
  }

  @override
  String get policyDocument => 'policy document';

  @override
  String confidenceLabel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {'high': 'high', 'medium': 'medium', 'low': 'low', 'other': '$level'});
    return 'Confidence: $_temp0';
  }

  @override
  String get fileTooBig => 'File must be under 20 MB.';

  @override
  String get wrongFileType => 'Please choose a PDF, JPG or PNG file.';

  @override
  String get addAPolicyTitle => 'Add a policy';

  @override
  String get uploadIntro =>
      'Upload your policy document and we\'ll read it for you. Make sure it shows the policy number, start and end dates, premium, cover amount and insurer/plan name.';

  @override
  String uploadingPercent(int percent) {
    return 'Uploading… $percent%';
  }

  @override
  String get uploadPdf => 'Upload policy PDF';

  @override
  String get recommendedBest => 'Recommended · Best accuracy';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get photoTip => 'Place the policy on a flat, well-lit surface';

  @override
  String get uploadPhoto => 'Upload a photo of the policy';

  @override
  String get jpgOrPng => 'JPG or PNG';

  @override
  String get enterManually => 'Enter details manually';

  @override
  String get noDocumentNeeded => 'No document needed';

  @override
  String get importGmail => 'Import from Gmail';

  @override
  String get docsEncrypted => 'Your documents are encrypted and only visible to you.';

  @override
  String couldNotDial(String number) {
    return 'Could not open the dialler for $number';
  }

  @override
  String get callFirst => 'In an emergency, call first.';

  @override
  String get insuranceCanWait => 'Insurance questions can wait. Get help, then use the details below.';

  @override
  String get emergency => 'Emergency';

  @override
  String get ambulance => 'Ambulance';

  @override
  String get yourPolicyNumbers => 'Your policy numbers';

  @override
  String get addPolicyNumberHint =>
      'Add a policy and its number will show here, ready to quote at the hospital or to your insurer.';

  @override
  String get goodToKnow => 'Good to know';

  @override
  String get tipCashless =>
      'For planned cashless treatment, tell the hospital desk your insurer and policy number first.';

  @override
  String get tipHelpline =>
      'Your insurer\'s claims helpline is printed on your policy document and e-card. Keep it handy.';

  @override
  String get tipIntimation =>
      'Many policies want an intimation within 24 hours of an emergency admission. Check the time limit in your wording.';

  @override
  String callLabel(String label, String number) {
    return 'Call $label $number';
  }

  @override
  String get policyNumberNotAdded => 'Policy number not added yet';

  @override
  String validTill(String type, String date) {
    return '$type · valid till $date';
  }

  @override
  String get copyPolicyNumber => 'Copy policy number';

  @override
  String get policyNumberCopied => 'Policy number copied';

  @override
  String get rewards => 'Rewards';

  @override
  String get earnCoins => 'EARN COINS';

  @override
  String get useCoins => 'USE COINS';

  @override
  String get yourCoins => 'Your coins';

  @override
  String coinsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count coins', one: '1 coin');
    return '$_temp0';
  }

  @override
  String get earnedForOrganising => 'Earned for organising your insurance';

  @override
  String get waysToEarn => 'Ways to earn';

  @override
  String progressDone(String progress) {
    return '$progress done';
  }

  @override
  String get history => 'History';

  @override
  String get useYourCoins => 'Use your coins';

  @override
  String get perksOnTheWay => 'Perks are on the way. Keep earning — your coins will be ready when they launch.';

  @override
  String get familyTitle => 'Family';

  @override
  String get addMember => 'Add member';

  @override
  String get addYourFamily => 'Add your family';

  @override
  String get addFamilyMessage =>
      'Add the people covered by your policies to see who is protected and where the gaps are.';

  @override
  String get notLinked => 'Not linked to any policy';

  @override
  String get addFamilyMember => 'Add family member';

  @override
  String get editFamilyMember => 'Edit family member';

  @override
  String get removeMember => 'Remove member';

  @override
  String policyTypeName(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'health': 'Health',
      'life': 'Life',
      'motor': 'Motor',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String enumLabel(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'self': 'Self',
      'spouse': 'Spouse',
      'child': 'Child',
      'parent': 'Parent',
      'sibling': 'Sibling',
      'otherValue': 'Other',
      'annual': 'Annual',
      'half_yearly': 'Half-yearly',
      'quarterly': 'Quarterly',
      'monthly': 'Monthly',
      'single': 'Single',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String clauseType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'benefit': 'Benefit',
      'exclusion': 'Exclusion',
      'waiting_period': 'Waiting period',
      'limit': 'Limit',
      'condition': 'Condition',
      'definition': 'Definition',
      'other': 'Clause',
    });
    return '$_temp0';
  }

  @override
  String get untitledPolicy => 'Untitled policy';

  @override
  String get errPdfPassword => 'This PDF is password-protected. Please upload an unlocked copy.';

  @override
  String get errPdfTooManyPages =>
      'This document has too many pages. Please upload only the policy schedule and wording.';

  @override
  String get errPdfUnreadable => 'We couldn\'t open this file. It may be damaged.';

  @override
  String get errNoText => 'We couldn\'t read any text. Try a clearer photo or the original PDF.';

  @override
  String get errOcrUnavailable =>
      'Scanned documents can\'t be read right now. Please upload a digital PDF or enter details manually.';

  @override
  String get errAiUnavailable => 'Our reading service is busy. Please retry in a minute.';

  @override
  String get errProcessing => 'We couldn\'t process this document.';

  @override
  String get yourPolicies => 'Your policies';

  @override
  String coinsOpenRewards(int count) {
    return 'Coins: $count. Open rewards';
  }

  @override
  String policiesNeedCheck(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count policies need a quick check from you',
      one: '1 policy needs a quick check from you',
    );
    return '$_temp0';
  }

  @override
  String daysLeftEnds(String date) {
    return 'days left · ends $date';
  }

  @override
  String get earnCoinsOrganised => 'Earn coins for staying organised';

  @override
  String get addPoliciesNominees => 'Add policies, nominees and family members.';

  @override
  String get worthALook => 'Worth a look';

  @override
  String allCount(int count) {
    return 'All $count';
  }

  @override
  String get details => 'Details';

  @override
  String get myInsurance => 'My insurance';

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get addPoliciesHere => 'Add your health, life and motor policies and they will all live here.';

  @override
  String allWithCount(int count) {
    return 'All ($count)';
  }

  @override
  String get noPoliciesOfType => 'No policies of this type.';

  @override
  String get takingLonger => 'This is taking longer than usual. We\'ll keep working on it — check back shortly.';

  @override
  String get readingYourPolicy => 'Reading your policy';

  @override
  String get underAMinute => 'This usually takes under a minute.';

  @override
  String get noClausesYet => 'No clauses yet';

  @override
  String get clausesNote => 'Clauses are read from your uploaded policy document. Manually added policies have none.';

  @override
  String get searchWording => 'Search the policy wording';

  @override
  String get nothingMatches => 'Nothing matches.';

  @override
  String get notEnoughDetails => 'Not enough details yet';

  @override
  String healthCounts(int strong, int attention, int missing) {
    return '$strong strong · $attention need attention · $missing not covered';
  }

  @override
  String get needsAttention => 'Needs attention';

  @override
  String get notMentionedInDoc => 'Not mentioned in your document';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get allCaughtUp => 'You\'re all caught up';

  @override
  String get notificationsAppearHere => 'Renewal reminders and policy updates will appear here.';

  @override
  String get profile => 'Profile';

  @override
  String get account => 'Account';

  @override
  String get helpLegal => 'Help & legal';

  @override
  String get termsConditions => 'Terms & conditions';

  @override
  String get logOut => 'Log out';

  @override
  String get comparePolicies => 'Compare policies';

  @override
  String compareN(int count) {
    return 'Compare $count policies';
  }

  @override
  String get choose2or3 => 'Choose 2 or 3 policies';

  @override
  String get compareIntro =>
      'Compare policies you already have — for example two health policies — to see differences in cover and features.';

  @override
  String typeCover(String type, String amount) {
    return '$type · $amount cover';
  }

  @override
  String get sideBySide => 'Side by side';

  @override
  String get reviewNeeded => 'Review needed';

  @override
  String get statusActive => 'Active';

  @override
  String endsInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(days, locale: localeName, other: 'Ends in $days days', one: 'Ends in 1 day');
    return '$_temp0';
  }

  @override
  String get statusExpired => 'Expired';

  @override
  String get datesMissing => 'Dates missing';

  @override
  String daysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(days, locale: localeName, other: '$days days left', one: '1 day left');
    return '$_temp0';
  }

  @override
  String get checkupTitle => 'Your insurance check-up';

  @override
  String get lookingGood => 'Looking good';

  @override
  String get noGapsFound => 'We found no gaps in the policies you have added.';

  @override
  String get demoMode => 'Demo mode · offline AI';

  @override
  String get confirmAppLock => 'Confirm to turn on app lock';

  @override
  String unlockApp(String app) {
    return 'Unlock $app';
  }

  @override
  String get unlock => 'Unlock';

  @override
  String get loading => 'Loading';

  @override
  String get neverMissRenewal => 'Never miss a renewal';

  @override
  String get pushPromptBody =>
      'Turn on notifications for renewal reminders, processing updates and important policy alerts. Only things that matter — no marketing.';

  @override
  String get notNow => 'Not now';

  @override
  String get allow => 'Allow';

  @override
  String get somethingWrong => 'Something went wrong';

  @override
  String get timedOut => 'The connection timed out. Please try again.';

  @override
  String get cantReachServer => 'Can\'t reach the server. Check your internet connection.';

  @override
  String get somethingWrongRetry => 'Something went wrong. Please try again.';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'Same as phone';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';
}

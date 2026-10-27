// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get languageName => 'हिन्दी';

  @override
  String get appLanguage => 'ऐप की भाषा';

  @override
  String get appLanguageHelp => 'बटन, मेन्यू और स्क्रीन। AI जवाबों की भाषा अलग से चुनी जाती है।';

  @override
  String get skip => 'छोड़ें';

  @override
  String get next => 'आगे';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get continueAction => 'आगे बढ़ें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get onb1Title => 'आपका पूरा बीमा, एक जगह';

  @override
  String get onb1Body => 'पूरे परिवार की हेल्थ, लाइफ और मोटर पॉलिसी, सुरक्षित और ढूँढने में आसान।';

  @override
  String get onb2Title => 'सीधे शब्दों में पूछें';

  @override
  String get onb2Body => 'हर जवाब बताता है कि वह पॉलिसी के किस पेज से है, या कि यह आपकी पॉलिसी में नहीं है।';

  @override
  String get onb3Title => 'रिन्यूअल कभी नहीं छूटेगा';

  @override
  String get onb3Body => 'पॉलिसी खत्म होने से काफ़ी पहले याद दिलाएँगे, ताकि आप कभी बिना कवर के न रहें।';

  @override
  String get onb4Title => 'परिवार और नॉमिनी, सब तय';

  @override
  String get onb4Body => 'देखें कौन कवर है, किसे क्या मिलेगा, और कुछ होने पर क्या करना है।';

  @override
  String get loginHeadline => 'आपका पूरा बीमा।\nएक जगह। साफ़ समझ में।';

  @override
  String get loginSubhead => 'अपनी पॉलिसी जोड़ें, समझें कि आपको किस चीज़ का कवर है, और कोई रिन्यूअल न चूकें।';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get consentStart => 'मैं ';

  @override
  String get privacyPolicy => 'प्राइवेसी पॉलिसी';

  @override
  String get consentAnd => ' और ';

  @override
  String get terms => 'शर्तों';

  @override
  String get consentEnd =>
      ' से सहमत हूँ, और इस सेवा के लिए अपने पॉलिसी दस्तावेज़ों की प्रोसेसिंग की अनुमति देता/देती हूँ।';

  @override
  String get getOtp => 'OTP पाएँ';

  @override
  String get otpTitle => '6 अंकों का कोड डालें';

  @override
  String otpSentTo(String identifier) {
    return '$identifier पर भेजा गया';
  }

  @override
  String get verify => 'पुष्टि करें';

  @override
  String resendIn(int seconds) {
    return '$seconds सेकंड में दोबारा भेजें';
  }

  @override
  String get resendCode => 'कोड दोबारा भेजें';

  @override
  String get nameTitle => 'हम आपको किस नाम से बुलाएँ?';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get dobOptional => 'जन्म तिथि (वैकल्पिक)';

  @override
  String get navHome => 'होम';

  @override
  String get navPortfolio => 'पॉलिसी';

  @override
  String get navExplore => 'जानें';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get addPolicy => 'पॉलिसी जोड़ें';

  @override
  String hiName(String name) {
    return 'नमस्ते $name';
  }

  @override
  String get helloThere => 'नमस्ते';

  @override
  String get homeSubtitle => 'आज आपके बीमा कवर की स्थिति।';

  @override
  String get whatToDo => 'आप क्या करना चाहेंगे?';

  @override
  String get comingUp => 'जल्द आने वाले';

  @override
  String get coverageReport => 'कवरेज रिपोर्ट';

  @override
  String get askAi => 'AI से पूछें';

  @override
  String get claimHelp => 'क्लेम में मदद';

  @override
  String get family => 'परिवार';

  @override
  String get nominees => 'नॉमिनी';

  @override
  String get compare => 'तुलना करें';

  @override
  String get emergencyCard => 'इमरजेंसी कार्ड';

  @override
  String get seeCoverageReport => 'अपनी कवरेज रिपोर्ट देखें';

  @override
  String get addAPolicy => 'पॉलिसी जोड़ें';

  @override
  String get seeSampleReport => 'नमूना रिपोर्ट देखें';

  @override
  String coinsEarned(int coins) {
    return '+$coins कॉइन मिले';
  }

  @override
  String get personalDetails => 'निजी जानकारी';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get city => 'शहर';

  @override
  String get state => 'राज्य';

  @override
  String get save => 'सेव करें';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get renewalReminders => 'रिन्यूअल रिमाइंडर';

  @override
  String get renewalRemindersHelp => 'पॉलिसी खत्म होने से 90, 60, 30, 15, 7 और 1 दिन पहले';

  @override
  String get policyUpdates => 'पॉलिसी अपडेट';

  @override
  String get policyUpdatesHelp => 'जब कोई दस्तावेज़ पढ़ लिया गया हो और जाँचने के लिए तैयार हो';

  @override
  String get notificationsPromise =>
      'हम कभी प्रचार वाली सूचनाएँ नहीं भेजते, और सूचनाओं में कभी आपका पॉलिसी नंबर, रकम या सेहत की जानकारी नहीं दिखती।';

  @override
  String get faqSafeQ => 'क्या मेरा डेटा सुरक्षित है?';

  @override
  String get faqSafeA =>
      'आपके दस्तावेज़ एन्क्रिप्ट करके रखे जाते हैं और सिर्फ़ आप उन्हें देख सकते हैं। हम आपका डेटा न बेचते हैं, न बीमा कंपनियों या एजेंटों से साझा करते हैं।';

  @override
  String get faqAiQ => 'AI मेरे सवालों के जवाब कैसे देता है?';

  @override
  String get faqAiA =>
      'यह सिर्फ़ आपका अपना पॉलिसी दस्तावेज़ पढ़ता है और बताता है कि जवाब किस पेज से आया। अगर जवाब आपके दस्तावेज़ में नहीं है, तो अंदाज़ा लगाने की बजाय साफ़ बता देता है।';

  @override
  String get faqWrongQ => 'मेरी पॉलिसी से निकाली गई जानकारी गलत है। मैं क्या करूँ?';

  @override
  String get faqWrongA =>
      'पॉलिसी खोलें, ⋮ मेन्यू दबाएँ और \"जानकारी बदलें\" चुनें। आप जो भी ठीक करेंगे, वह आपके द्वारा पुष्टि किया हुआ माना जाएगा।';

  @override
  String get faqUploadQ => 'मैं कौन-से दस्तावेज़ अपलोड कर सकता/सकती हूँ?';

  @override
  String get faqUploadA =>
      'PDF पॉलिसी दस्तावेज़ सबसे अच्छे रहते हैं। आप 20 MB तक की साफ़ फ़ोटो (JPG/PNG) भी अपलोड कर सकते हैं। पासवर्ड वाली PDF पहले अनलॉक करें।';

  @override
  String get faqSellQ => 'क्या आप बीमा बेचते हैं?';

  @override
  String faqSellA(String app) {
    return 'नहीं। $app आपकी मौजूदा पॉलिसियों को व्यवस्थित करने और समझने में मदद करता है। हम बीमा प्रोडक्ट न बेचते हैं, न उनकी सलाह देते हैं।';
  }

  @override
  String get faqDeleteQ => 'मैं अपना अकाउंट कैसे डिलीट करूँ?';

  @override
  String get faqDeleteA =>
      'प्रोफ़ाइल → प्राइवेसी और डेटा → अकाउंट डिलीट करें। आपका डेटा 7 दिन बाद हमेशा के लिए मिटा दिया जाता है।';

  @override
  String get supportThanks => 'धन्यवाद — हम 2 कामकाजी दिनों में आपसे संपर्क करेंगे।';

  @override
  String get helpSupport => 'मदद और सहायता';

  @override
  String get faqTitle => 'अक्सर पूछे जाने वाले सवाल';

  @override
  String get contactUs => 'हमसे संपर्क करें';

  @override
  String get topic => 'विषय';

  @override
  String get topicQuestion => 'एक सवाल';

  @override
  String get topicProblem => 'कुछ काम नहीं कर रहा';

  @override
  String get topicFeedback => 'सुझाव';

  @override
  String get topicPrivacy => 'प्राइवेसी / मेरा डेटा';

  @override
  String get topicGrievance => 'शिकायत';

  @override
  String get howCanWeHelp => 'हम कैसे मदद करें?';

  @override
  String get send => 'भेजें';

  @override
  String get emailUsInstead => 'इसकी बजाय ईमेल करें';

  @override
  String get deleteAccountQ => 'अपना अकाउंट डिलीट करें?';

  @override
  String get deleteAccountBody =>
      'आपका अकाउंट अभी बंद कर दिया जाएगा। आपकी सभी पॉलिसियाँ, दस्तावेज़ और डेटा 7 दिन बाद हमेशा के लिए मिटा दिए जाएँगे। 7 दिन के अंदर फिर से लॉग इन करने पर डिलीट रद्द हो जाएगा।';

  @override
  String get deleteAccount => 'अकाउंट डिलीट करें';

  @override
  String get privacyData => 'प्राइवेसी और डेटा';

  @override
  String get privacyPromise =>
      'हम आपके पॉलिसी दस्तावेज़ों का इस्तेमाल सिर्फ़ आपका अपना बीमा दिखाने, समझाने और याद दिलाने के लिए करते हैं। दस्तावेज़ एन्क्रिप्टेड रहते हैं, कभी बेचे नहीं जाते, और कभी बीमा कंपनियों या एजेंटों से साझा नहीं होते। AI प्रोसेसिंग ऐसे प्रदाताओं से होती है जिन्हें अनुबंध के तहत आपके डेटा पर ट्रेनिंग की अनुमति नहीं है।';

  @override
  String get downloadMyData => 'मेरा डेटा डाउनलोड करें';

  @override
  String get downloadMyDataHelp => 'आपकी प्रोफ़ाइल, पॉलिसियों और सवालों की एक कॉपी';

  @override
  String get privacyPolicyItem => 'प्राइवेसी पॉलिसी';

  @override
  String get grievanceOfficer => 'शिकायत अधिकारी';

  @override
  String get deleteAccountHelp => 'अपना सारा डेटा हमेशा के लिए मिटाएँ';

  @override
  String get appLock => 'ऐप लॉक';

  @override
  String get appLockHelp => 'ऐप खोलने के लिए फ़िंगरप्रिंट, चेहरा या फ़ोन का PIN इस्तेमाल करें';

  @override
  String get setUpScreenLock => 'पहले अपने फ़ोन पर स्क्रीन लॉक लगाएँ।';

  @override
  String get aiAnswerLanguage => 'AI जवाबों की भाषा';

  @override
  String get aiAnswerLanguageHelp =>
      'आपकी पॉलिसियों के सारांश और जवाब इसी भाषा में लिखे जाएँगे। आप इसमें सवाल भी पूछ सकते हैं।';

  @override
  String get policy => 'पॉलिसी';

  @override
  String get reviewExtracted => 'कृपया निकाली गई जानकारी जाँच लें';

  @override
  String get coverageReportHelp => 'क्या कवर है, किस पर सीमा है और क्या कवर नहीं है — एक-एक करके';

  @override
  String get noNomineeAddOne => 'कोई नॉमिनी दर्ज नहीं — एक जोड़ें';

  @override
  String get notRecorded => 'दर्ज नहीं';

  @override
  String get policyClauses => 'पॉलिसी की शर्तें';

  @override
  String get policyClausesHelp => 'लाभ, बहिष्करण (exclusions), वेटिंग पीरियड और सीमाएँ — शब्दशः';

  @override
  String get whoIsCovered => 'किसे कवर मिलता है';

  @override
  String get understandPolicy => 'अपनी पॉलिसी समझें';

  @override
  String get keyDetails => 'मुख्य जानकारी';

  @override
  String get coverageDetails => 'कवरेज की जानकारी';

  @override
  String typeInsurance(String type) {
    return '$type बीमा';
  }

  @override
  String get idv => 'इंश्योर्ड डिक्लेयर्ड वैल्यू (IDV)';

  @override
  String get cover => 'कवर';

  @override
  String validRange(String start, String end) {
    return 'वैध: $start – $end';
  }

  @override
  String premiumValue(String amount) {
    return 'प्रीमियम $amount';
  }

  @override
  String get askAiShort => 'AI से पूछें';

  @override
  String get renewal => 'रिन्यूअल';

  @override
  String get claimHelpAction => 'क्लेम में मदद';

  @override
  String get documentsRequired => 'आम तौर पर ज़रूरी दस्तावेज़';

  @override
  String get followInsurerProcess => 'हमेशा वही क्लेम प्रक्रिया अपनाएँ जो आपकी पॉलिसी और बीमा कंपनी बताती है।';

  @override
  String get readingPolicy => 'आपकी पॉलिसी पढ़ी जा रही है…';

  @override
  String get watchOutFor => 'इन बातों का ध्यान रखें';

  @override
  String get policyNumber => 'पॉलिसी नंबर';

  @override
  String get insurer => 'बीमा कंपनी';

  @override
  String get plan => 'प्लान';

  @override
  String get startDate => 'शुरू होने की तारीख';

  @override
  String get endDate => 'खत्म होने की तारीख';

  @override
  String get premium => 'प्रीमियम';

  @override
  String get coverRow => 'कवर';

  @override
  String get deletePolicyQ => 'यह पॉलिसी डिलीट करें?';

  @override
  String get deletePolicyBody => 'पॉलिसी, उसका दस्तावेज़ और उसके बारे में आपके सवाल हमेशा के लिए मिटा दिए जाएँगे।';

  @override
  String get delete => 'डिलीट करें';

  @override
  String get editDetails => 'जानकारी बदलें';

  @override
  String get viewDocument => 'दस्तावेज़ देखें';

  @override
  String get deletePolicy => 'पॉलिसी डिलीट करें';

  @override
  String get policyHealth => 'पॉलिसी हेल्थ';

  @override
  String get noIssuesFound => 'हमने जो जानकारी पढ़ी, उसमें कोई समस्या नहीं मिली';

  @override
  String thingsToKnow(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count बातें जानने लायक');
    return '$_temp0';
  }

  @override
  String get markedRenewed => 'रिन्यू के रूप में दर्ज किया। सब अपडेट रखने के लिए अपनी नई पॉलिसी का दस्तावेज़ जोड़ें।';

  @override
  String get add => 'जोड़ें';

  @override
  String get renewalTitle => 'रिन्यूअल';

  @override
  String get addEndDate => 'रिन्यूअल ट्रैक करने के लिए पॉलिसी खत्म होने की तारीख जोड़ें।';

  @override
  String expiredOn(String date) {
    return 'यह पॉलिसी $date को खत्म हो गई।';
  }

  @override
  String renewsOn(String date, int days) {
    return '$date को रिन्यू होगी — $days दिन बाकी।';
  }

  @override
  String lastPremium(String amount) {
    return 'पिछला प्रीमियम: $amount';
  }

  @override
  String get remindSchedule => 'हम खत्म होने से 90, 60, 30, 15, 7 और 1 दिन पहले याद दिलाएँगे।';

  @override
  String get remindersOff => 'सेटिंग्स में रिन्यूअल रिमाइंडर बंद हैं।';

  @override
  String get markedAsRenewed => '✓ रिन्यू के रूप में दर्ज';

  @override
  String get markedNotRenewing => 'रिन्यू न करने के रूप में दर्ज';

  @override
  String get iRenewed => 'मैंने यह पॉलिसी रिन्यू कर ली है';

  @override
  String get notRenewing => 'मैं रिन्यू नहीं करूँगा/करूँगी';

  @override
  String get undo => 'वापस लें';

  @override
  String get claimHealthTitle => 'हेल्थ इंश्योरेंस क्लेम';

  @override
  String get claimHealthStep1 => 'जाँच लें कि अस्पताल आपकी बीमा कंपनी के नेटवर्क में है (कैशलेस इलाज के लिए)।';

  @override
  String get claimHealthStep2 =>
      'पहले से तय भर्ती: कम से कम 48 घंटे पहले अस्पताल के इंश्योरेंस डेस्क पर कैशलेस प्री-ऑथराइज़ेशन माँगें।';

  @override
  String get claimHealthStep3 => 'इमरजेंसी में भर्ती: 24 घंटे के अंदर अपनी बीमा कंपनी या TPA को सूचना दें।';

  @override
  String get claimHealthStep4 => 'अस्पताल में अपना हेल्थ कार्ड / पॉलिसी नंबर और फ़ोटो ID दिखाएँ।';

  @override
  String get claimHealthStep5 =>
      'रीइम्बर्समेंट के लिए (नेटवर्क से बाहर का अस्पताल), बिल चुकाएँ और पॉलिसी में लिखी समय-सीमा के अंदर क्लेम जमा करें।';

  @override
  String get claimHealthStep6 => 'बीमा कंपनी से मिले क्लेम रेफ़रेंस नंबर से अपना क्लेम ट्रैक करें।';

  @override
  String get claimHealthDoc1 => 'क्लेम फ़ॉर्म (हस्ताक्षर सहित)';

  @override
  String get claimHealthDoc2 => 'पॉलिसी की कॉपी / हेल्थ कार्ड';

  @override
  String get claimHealthDoc3 => 'फ़ोटो ID और पते का प्रमाण';

  @override
  String get claimHealthDoc4 => 'डिस्चार्ज समरी';

  @override
  String get claimHealthDoc5 => 'अस्पताल के मूल बिल और भुगतान की रसीदें';

  @override
  String get claimHealthDoc6 => 'डॉक्टर के पर्चे और जाँच रिपोर्टें';

  @override
  String get claimHealthDoc7 => 'कैंसल चेक या बैंक की जानकारी (रीइम्बर्समेंट के लिए)';

  @override
  String get claimMotorTitle => 'मोटर इंश्योरेंस क्लेम';

  @override
  String get claimMotorStep1 =>
      'पहले सबकी सुरक्षा पक्की करें। चोरी या थर्ड-पार्टी को चोट लगने पर पुलिस में FIR दर्ज कराएँ।';

  @override
  String get claimMotorStep2 => 'जल्द से जल्द बीमा कंपनी को सूचना दें और क्लेम नंबर लें।';

  @override
  String get claimMotorStep3 =>
      'बीमा कंपनी के सर्वेयर की जाँच से पहले गाड़ी की मरम्मत न कराएँ (जब तक अलग से न कहा जाए)।';

  @override
  String get claimMotorStep4 =>
      'कैशलेस मरम्मत के लिए गाड़ी नेटवर्क गैराज ले जाएँ, या रीइम्बर्समेंट के लिए किसी भी गैराज में।';

  @override
  String get claimMotorStep5 =>
      'अनिवार्य डिडक्टिबल और जो चीज़ें कवर नहीं हैं उनका भुगतान आप करें; बाकी बीमा कंपनी चुकाती है।';

  @override
  String get claimMotorDoc1 => 'क्लेम फ़ॉर्म';

  @override
  String get claimMotorDoc2 => 'पॉलिसी की कॉपी';

  @override
  String get claimMotorDoc3 => 'रजिस्ट्रेशन सर्टिफ़िकेट (RC)';

  @override
  String get claimMotorDoc4 => 'ड्राइवर का ड्राइविंग लाइसेंस';

  @override
  String get claimMotorDoc5 => 'FIR (चोरी, बड़ी दुर्घटना या थर्ड-पार्टी क्लेम के लिए)';

  @override
  String get claimMotorDoc6 => 'मरम्मत का अनुमान और अंतिम बिल';

  @override
  String get claimLifeTitle => 'लाइफ़ इंश्योरेंस क्लेम';

  @override
  String get claimLifeStep1 => 'नॉमिनी जल्द से जल्द बीमा कंपनी को सूचना दें।';

  @override
  String get claimLifeStep2 => 'बीमा कंपनी की शाखा या वेबसाइट से क्लेम फ़ॉर्म लें।';

  @override
  String get claimLifeStep3 => 'ज़रूरी दस्तावेज़ों के साथ फ़ॉर्म जमा करें।';

  @override
  String get claimLifeStep4 => 'पॉलिसी के शुरुआती कुछ सालों में किए गए क्लेम की बीमा कंपनी जाँच कर सकती है।';

  @override
  String get claimLifeStep5 => 'बीमा कंपनी से क्लेम की स्थिति ट्रैक करें।';

  @override
  String get claimLifeDoc1 => 'क्लेम फ़ॉर्म';

  @override
  String get claimLifeDoc2 => 'पॉलिसी का मूल दस्तावेज़';

  @override
  String get claimLifeDoc3 => 'मृत्यु प्रमाण पत्र';

  @override
  String get claimLifeDoc4 => 'नॉमिनी की फ़ोटो ID, पते का प्रमाण और बैंक की जानकारी';

  @override
  String get claimLifeDoc5 => 'मेडिकल रिकॉर्ड / FIR और पोस्टमॉर्टम रिपोर्ट (अगर लागू हो)';

  @override
  String get claimOtherTitle => 'क्लेम कैसे करें';

  @override
  String get claimOtherStep1 => 'पॉलिसी पढ़कर पक्का करें कि यह घटना कवर है।';

  @override
  String get claimOtherStep2 => 'जल्द से जल्द बीमा कंपनी को सूचना दें और क्लेम नंबर लें।';

  @override
  String get claimOtherStep3 => 'क्लेम फ़ॉर्म और सहायक दस्तावेज़ जमा करें।';

  @override
  String get claimOtherStep4 => 'बीमा कंपनी से अपना क्लेम ट्रैक करें।';

  @override
  String get claimOtherDoc1 => 'क्लेम फ़ॉर्म';

  @override
  String get claimOtherDoc2 => 'पॉलिसी की कॉपी';

  @override
  String get claimOtherDoc3 => 'फ़ोटो ID';

  @override
  String get claimOtherDoc4 => 'नुकसान का प्रमाण / बिल';

  @override
  String get explore => 'एक्सप्लोर';

  @override
  String get claimGuides => 'क्लेम गाइड';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get gmailImport => 'Gmail से इम्पोर्ट';

  @override
  String get digiLocker => 'डिजीलॉकर';

  @override
  String get claimTracking => 'क्लेम ट्रैकिंग';

  @override
  String get wellness => 'वेलनेस';

  @override
  String get deathLife1 =>
      'जल्द से जल्द बीमा कंपनी को सूचना दें (कॉल सेंटर, शाखा या वेबसाइट) और क्लेम नंबर नोट कर लें।';

  @override
  String get deathLife2 => 'नॉमिनी डेथ क्लेम फ़ॉर्म भरें और नीचे दिए दस्तावेज़ लगाएँ।';

  @override
  String get deathLife3 =>
      'पॉलिसी के पहले 3 सालों में मृत्यु होने पर बीमा कंपनी भुगतान से पहले जाँच कर सकती है — यह सामान्य है।';

  @override
  String get deathLife4 =>
      'क्लेम की रकम नॉमिनी के बैंक खाते में आती है। अगर नॉमिनी नाबालिग है, तो अपॉइंटी को मिलती है।';

  @override
  String get deathHealth1 =>
      'जिस व्यक्ति की मृत्यु हुई, उसके लिए हेल्थ पॉलिसी खत्म हो जाती है। फ़ैमिली फ़्लोटर में बाकी सदस्य रिन्यूअल तक कवर रहते हैं।';

  @override
  String get deathHealth2 =>
      'अस्पताल के बकाया बिलों का क्लेम नॉमिनी फिर भी कर सकते हैं — क्लेम की समय-सीमा के अंदर जमा करें।';

  @override
  String get deathHealth3 => 'सदस्य को हटाने के लिए बीमा कंपनी को सूचना दें और रिन्यूअल पर पॉलिसी अपडेट कराएँ।';

  @override
  String get deathMotor1 =>
      'गाड़ी और उसका बीमा, बीमा कंपनी की बताई समय-सीमा में कानूनी वारिस के नाम ट्रांसफ़र होना चाहिए।';

  @override
  String get deathMotor2 => 'मृत्यु प्रमाण पत्र और नए मालिक के दस्तावेज़ों के साथ बीमा कंपनी को सूचना दें।';

  @override
  String get deathMotor3 =>
      'ट्रांसफ़र होने तक गाड़ी न चलाएँ — रजिस्टर्ड मालिक की मृत्यु के बाद क्लेम खारिज हो सकते हैं।';

  @override
  String get deathOther1 =>
      'मृत्यु प्रमाण पत्र के साथ बीमा कंपनी को सूचना दें और उनकी क्लेम या ट्रांसफ़र प्रक्रिया पूछें।';

  @override
  String get deathDoc1 => 'मृत्यु प्रमाण पत्र (मूल या सत्यापित कॉपी)';

  @override
  String get deathDoc2 => 'पॉलिसी दस्तावेज़ या पॉलिसी नंबर';

  @override
  String get deathDoc3 => 'नॉमिनी की फ़ोटो ID और पते का प्रमाण (आधार / PAN)';

  @override
  String get deathDoc4 => 'नॉमिनी के बैंक की जानकारी (कैंसल चेक)';

  @override
  String get deathDoc5 => 'मेडिकल रिकॉर्ड या अस्पताल की डिस्चार्ज समरी (अगर लागू हो)';

  @override
  String get deathDoc6 => 'FIR और पोस्टमॉर्टम रिपोर्ट (दुर्घटना में मृत्यु पर)';

  @override
  String shareSubject(String type) {
    return 'मेरे $type बीमा की जानकारी';
  }

  @override
  String shareBody(String name, String type, String number, String cover, String nominees, String steps) {
    return 'इसे संभाल कर रखें।\n\n$name — $type बीमा\nपॉलिसी नंबर: $number\nकवर: $cover\nनॉमिनी: $nominees\n\nअगर मुझे कुछ हो जाए:\n$steps';
  }

  @override
  String get seePolicyDocument => 'पॉलिसी दस्तावेज़ देखें';

  @override
  String get addNominee => 'नॉमिनी जोड़ें';

  @override
  String get fullyAssigned => 'क्लेम की 100% रकम बाँट दी गई है';

  @override
  String get noNomineeYet => 'अभी कोई नॉमिनी दर्ज नहीं';

  @override
  String assignedLeft(int assigned, int left) {
    return '$assigned% बाँटा गया · $left% बाकी';
  }

  @override
  String get nomineeLegalNote =>
      'यह आपका अपना रिकॉर्ड है। कानूनी तौर पर वही नॉमिनी माना जाता है जो बीमा कंपनी में दर्ज है — दोनों एक जैसे रखें।';

  @override
  String minorAppointee(String name) {
    return 'नाबालिग · अपॉइंटी: $name';
  }

  @override
  String get notSet => 'तय नहीं';

  @override
  String get ifSomethingHappens => 'अगर आपको कुछ हो जाए';

  @override
  String get docsFamilyNeeds => 'आपके परिवार को ज़रूरी दस्तावेज़';

  @override
  String get shareWithFamily => 'यह जानकारी परिवार के साथ साझा करें';

  @override
  String get needAppointee => 'एक अपॉइंटी जोड़ें — कोई वयस्क जो नाबालिग की ओर से रकम लेगा।';

  @override
  String get editNominee => 'नॉमिनी बदलें';

  @override
  String get pickFromFamily => 'परिवार में से चुनें';

  @override
  String get fullNameAsPolicy => 'पूरा नाम (पॉलिसी के अनुसार)';

  @override
  String get relationship => 'रिश्ता';

  @override
  String shareOfClaim(int percent) {
    return 'क्लेम में हिस्सा: $percent%';
  }

  @override
  String get appointeeLabel => 'अपॉइंटी (वयस्क जो नाबालिग की ओर से रकम लेगा)';

  @override
  String get phoneOptional => 'फ़ोन (वैकल्पिक)';

  @override
  String get removeNominee => 'नॉमिनी हटाएँ';

  @override
  String get notFoundFillIn => 'दस्तावेज़ में नहीं मिला — कृपया भरें';

  @override
  String get doubleCheck => 'कृपया इसे दोबारा जाँचें';

  @override
  String get startBeforeEnd => 'शुरू होने की तारीख, खत्म होने की तारीख से पहले होनी चाहिए।';

  @override
  String get checkPolicyDetails => 'अपनी पॉलिसी की जानकारी जाँचें';

  @override
  String get enterPolicyDetails => 'पॉलिसी की जानकारी भरें';

  @override
  String get editPolicyDetails => 'पॉलिसी की जानकारी बदलें';

  @override
  String get weReadDetails =>
      'हमने यह जानकारी आपके दस्तावेज़ से पढ़ी है। कृपया ध्यान से जाँचें — पीले रंग से चिह्नित फ़ील्ड पर ध्यान देना ज़रूरी है।';

  @override
  String get insuranceType => 'बीमा का प्रकार';

  @override
  String get insurerRequired => 'बीमा कंपनी का नाम ज़रूरी है';

  @override
  String get planName => 'प्लान का नाम';

  @override
  String get idvRupees => 'IDV (₹)';

  @override
  String get sumAssuredRupees => 'सम एश्योर्ड (₹)';

  @override
  String get sumInsuredRupees => 'सम इंश्योर्ड (₹)';

  @override
  String get premiumRupees => 'प्रीमियम (₹)';

  @override
  String get premiumFrequency => 'प्रीमियम कितनी बार';

  @override
  String get notSure => 'पता नहीं';

  @override
  String get confirmAddPolicy => 'पुष्टि करें और पॉलिसी जोड़ें';

  @override
  String get select => 'चुनें';

  @override
  String get whoIsCoveredQ => 'किसे कवर मिलता है?';

  @override
  String get addFamilyMembers => 'परिवार के सदस्य जोड़ें';

  @override
  String get statusCovered => 'कवर है';

  @override
  String get statusLimited => 'सीमा के साथ कवर';

  @override
  String get statusMissing => 'कवर नहीं';

  @override
  String get statusInfo => 'पॉलिसी की जानकारी';

  @override
  String get statusUnknown => 'आपके दस्तावेज़ में नहीं मिला';

  @override
  String get ratingStrong => 'मज़बूत';

  @override
  String get ratingFair => 'ठीक-ठाक';

  @override
  String get ratingWeak => 'कमज़ोर';

  @override
  String ratingLabel(String label) {
    return 'रेटिंग: $label';
  }

  @override
  String get sampleReport => 'सैंपल रिपोर्ट';

  @override
  String get reportNotAvailable => 'रिपोर्ट उपलब्ध नहीं';

  @override
  String get reportTypesNote => 'कवरेज रिपोर्ट हेल्थ, लाइफ़ और मोटर पॉलिसियों के लिए उपलब्ध है।';

  @override
  String get coverAtGlance => 'एक नज़र में आपका कवर';

  @override
  String addOnsCount(int count) {
    return '$count ऐड-ऑन';
  }

  @override
  String fromPolicyPage(int page) {
    return 'आपकी पॉलिसी से · पेज $page';
  }

  @override
  String get fromPolicyDetails => 'आपकी पॉलिसी की जानकारी से';

  @override
  String get fromPolicyWording => 'आपकी पॉलिसी के शब्दों से';

  @override
  String pageN(int page) {
    return 'पेज $page';
  }

  @override
  String get notMentioned => 'हमने जो दस्तावेज़ पढ़ा, उसमें इसका ज़िक्र नहीं है';

  @override
  String get whyItMatters => 'यह क्यों ज़रूरी है';

  @override
  String askAboutThisQ(String topic) {
    return 'मेरी पॉलिसी $topic के बारे में क्या कहती है?';
  }

  @override
  String get askAboutThis => 'इसके बारे में पूछें';

  @override
  String get seeForOwnPolicy => 'इसे अपनी पॉलिसी के लिए देखें';

  @override
  String get questionsAboutCover => 'अपने कवर के बारे में सवाल?';

  @override
  String get addPolicyShort => 'पॉलिसी जोड़ें';

  @override
  String get hero1 => 'डिलीवरी (मैटरनिटी) का बिल?';

  @override
  String get hero2 => 'घुटने की सर्जरी?';

  @override
  String get hero3 => 'बाढ़ में डूबा कार इंजन?';

  @override
  String get hero4 => '10 दिन ICU में भर्ती?';

  @override
  String get hero5 => 'आपके परिवार का भविष्य?';

  @override
  String get whichPolicy => 'कौन-सी पॉलिसी?';

  @override
  String get willPolicyCover => 'क्या आपकी पॉलिसी कवर करेगी';

  @override
  String get statHealth => 'हेल्थ';

  @override
  String get statLife => 'लाइफ़';

  @override
  String get perYear => 'हर साल';

  @override
  String get askAboutYourCover => 'अपने कवर के बारे में पूछें';

  @override
  String get askWhichPolicy => 'किस पॉलिसी के बारे में पूछना है?';

  @override
  String get addPolicyFirst => 'पहले एक पॉलिसी जोड़ें, फिर आप उसके बारे में सवाल पूछ सकते हैं।';

  @override
  String get askAnything => 'अपने कवर के बारे में कुछ भी पूछें';

  @override
  String get requestReview => 'पॉलिसी रिव्यू की माँग करें';

  @override
  String get expertWillCall =>
      'एक बीमा विशेषज्ञ आपके रजिस्टर्ड नंबर पर कॉल करके आपकी पॉलिसियाँ समझाएँगे। हम आपको कुछ भी बेचने की कोशिश नहीं करेंगे।';

  @override
  String get helpWithOptional => 'आपको किस बारे में मदद चाहिए? (वैकल्पिक)';

  @override
  String get requestCall => 'कॉल की माँग करें';

  @override
  String get requestSent => 'माँग भेज दी गई। हमारी टीम आपके रजिस्टर्ड नंबर पर कॉल करेगी।';

  @override
  String get talkToExpert => 'विशेषज्ञ से बात करें';

  @override
  String get expertPitch => 'आपके कवर और आगे क्या करना है, इस पर 30 मिनट की बातचीत। कोई बिक्री नहीं।';

  @override
  String get sugMaternity => 'क्या मैटरनिटी (डिलीवरी) कवर है?';

  @override
  String get sugRoomRent => 'रूम रेंट की सीमा क्या है?';

  @override
  String get sugPed => 'पहले से मौजूद बीमारियों (PED) के लिए वेटिंग पीरियड कितना है?';

  @override
  String get sugExcluded => 'क्या-क्या कवर नहीं है?';

  @override
  String get sugZeroDep => 'क्या ज़ीरो डेप्रिसिएशन शामिल है?';

  @override
  String get sugIdv => 'मेरी IDV कितनी है?';

  @override
  String get sugRoadside => 'क्या रोडसाइड असिस्टेंस कवर है?';

  @override
  String get sugDeathBenefit => 'डेथ बेनिफ़िट कितना है?';

  @override
  String get sugNominee => 'नॉमिनी कौन है?';

  @override
  String get sugSurrender => 'क्या मैं यह पॉलिसी सरेंडर कर सकता/सकती हूँ?';

  @override
  String get sugCover => 'यह पॉलिसी क्या-क्या कवर करती है?';

  @override
  String get askAboutYourPolicy => 'अपनी पॉलिसी के बारे में पूछें';

  @override
  String get checkingDocument => 'आपका पॉलिसी दस्तावेज़ देखा जा रहा है…';

  @override
  String get askAQuestion => 'एक सवाल पूछें…';

  @override
  String get askAnythingPolicy => 'इस पॉलिसी के बारे में कुछ भी पूछें';

  @override
  String get answersFromDocument => 'जवाब सिर्फ़ आपके पॉलिसी दस्तावेज़ से आते हैं, साथ में वह पेज भी जहाँ वे मिले।';

  @override
  String pageLabel(String page) {
    return 'पेज $page';
  }

  @override
  String sourceLabel(String source) {
    return 'स्रोत: $source';
  }

  @override
  String get policyDocument => 'पॉलिसी दस्तावेज़';

  @override
  String confidenceLabel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'high': 'ज़्यादा',
      'medium': 'मध्यम',
      'low': 'कम',
      'other': '$level',
    });
    return 'भरोसा: $_temp0';
  }

  @override
  String get fileTooBig => 'फ़ाइल 20 MB से छोटी होनी चाहिए।';

  @override
  String get wrongFileType => 'कृपया PDF, JPG या PNG फ़ाइल चुनें।';

  @override
  String get addAPolicyTitle => 'पॉलिसी जोड़ें';

  @override
  String get uploadIntro =>
      'अपनी पॉलिसी का दस्तावेज़ अपलोड करें, हम उसे आपके लिए पढ़ेंगे। ध्यान रखें कि उसमें पॉलिसी नंबर, शुरू और खत्म होने की तारीख, प्रीमियम, कवर की रकम और बीमा कंपनी/प्लान का नाम दिखे।';

  @override
  String uploadingPercent(int percent) {
    return 'अपलोड हो रहा है… $percent%';
  }

  @override
  String get uploadPdf => 'पॉलिसी की PDF अपलोड करें';

  @override
  String get recommendedBest => 'सुझाया गया · सबसे सटीक';

  @override
  String get takePhoto => 'फ़ोटो खींचें';

  @override
  String get photoTip => 'पॉलिसी को समतल और अच्छी रोशनी वाली जगह पर रखें';

  @override
  String get uploadPhoto => 'पॉलिसी की फ़ोटो अपलोड करें';

  @override
  String get jpgOrPng => 'JPG या PNG';

  @override
  String get enterManually => 'जानकारी खुद भरें';

  @override
  String get noDocumentNeeded => 'दस्तावेज़ की ज़रूरत नहीं';

  @override
  String get importGmail => 'Gmail से इम्पोर्ट करें';

  @override
  String get docsEncrypted => 'आपके दस्तावेज़ एन्क्रिप्टेड हैं और सिर्फ़ आपको दिखते हैं।';

  @override
  String couldNotDial(String number) {
    return '$number के लिए डायलर नहीं खुल सका';
  }

  @override
  String get callFirst => 'इमरजेंसी में पहले कॉल करें।';

  @override
  String get insuranceCanWait => 'बीमा के सवाल बाद में। पहले मदद लें, फिर नीचे की जानकारी का इस्तेमाल करें।';

  @override
  String get emergency => 'इमरजेंसी';

  @override
  String get ambulance => 'एम्बुलेंस';

  @override
  String get yourPolicyNumbers => 'आपके पॉलिसी नंबर';

  @override
  String get addPolicyNumberHint =>
      'पॉलिसी जोड़ें, उसका नंबर यहाँ दिखेगा — अस्पताल या बीमा कंपनी को बताने के लिए तैयार।';

  @override
  String get goodToKnow => 'जानने लायक';

  @override
  String get tipCashless =>
      'पहले से तय कैशलेस इलाज के लिए, सबसे पहले अस्पताल डेस्क को अपनी बीमा कंपनी और पॉलिसी नंबर बताएँ।';

  @override
  String get tipHelpline =>
      'बीमा कंपनी की क्लेम हेल्पलाइन आपके पॉलिसी दस्तावेज़ और ई-कार्ड पर छपी होती है। उसे पास रखें।';

  @override
  String get tipIntimation =>
      'कई पॉलिसियों में इमरजेंसी भर्ती के 24 घंटे के अंदर सूचना देनी होती है। अपनी पॉलिसी में समय-सीमा देखें।';

  @override
  String callLabel(String label, String number) {
    return '$label $number पर कॉल करें';
  }

  @override
  String get policyNumberNotAdded => 'पॉलिसी नंबर अभी जोड़ा नहीं गया';

  @override
  String validTill(String type, String date) {
    return '$type · $date तक वैध';
  }

  @override
  String get copyPolicyNumber => 'पॉलिसी नंबर कॉपी करें';

  @override
  String get policyNumberCopied => 'पॉलिसी नंबर कॉपी हो गया';

  @override
  String get rewards => 'रिवॉर्ड';

  @override
  String get earnCoins => 'कॉइन कमाएँ';

  @override
  String get useCoins => 'कॉइन इस्तेमाल करें';

  @override
  String get yourCoins => 'आपके कॉइन';

  @override
  String coinsCount(int count) {
    return '$count कॉइन';
  }

  @override
  String get earnedForOrganising => 'अपना बीमा व्यवस्थित करने के लिए मिले';

  @override
  String get waysToEarn => 'कमाने के तरीके';

  @override
  String progressDone(String progress) {
    return '$progress पूरा';
  }

  @override
  String get history => 'इतिहास';

  @override
  String get useYourCoins => 'अपने कॉइन इस्तेमाल करें';

  @override
  String get perksOnTheWay => 'फ़ायदे जल्द आ रहे हैं। कमाते रहिए — लॉन्च होने पर आपके कॉइन तैयार रहेंगे।';

  @override
  String get familyTitle => 'परिवार';

  @override
  String get addMember => 'सदस्य जोड़ें';

  @override
  String get addYourFamily => 'अपना परिवार जोड़ें';

  @override
  String get addFamilyMessage => 'अपनी पॉलिसियों में कवर लोगों को जोड़ें, ताकि दिखे कि कौन सुरक्षित है और कहाँ कमी है।';

  @override
  String get notLinked => 'किसी पॉलिसी से जुड़ा नहीं';

  @override
  String get addFamilyMember => 'परिवार का सदस्य जोड़ें';

  @override
  String get editFamilyMember => 'परिवार के सदस्य की जानकारी बदलें';

  @override
  String get removeMember => 'सदस्य हटाएँ';

  @override
  String policyTypeName(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {'health': 'हेल्थ', 'life': 'लाइफ़', 'motor': 'मोटर', 'other': 'अन्य'});
    return '$_temp0';
  }

  @override
  String enumLabel(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'self': 'स्वयं',
      'spouse': 'पति/पत्नी',
      'child': 'बच्चा',
      'parent': 'माता/पिता',
      'sibling': 'भाई/बहन',
      'otherValue': 'अन्य',
      'annual': 'सालाना',
      'half_yearly': 'छमाही',
      'quarterly': 'तिमाही',
      'monthly': 'मासिक',
      'single': 'एकमुश्त',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String clauseType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'benefit': 'लाभ',
      'exclusion': 'बहिष्करण',
      'waiting_period': 'वेटिंग पीरियड',
      'limit': 'सीमा',
      'condition': 'शर्त',
      'definition': 'परिभाषा',
      'other': 'क्लॉज़',
    });
    return '$_temp0';
  }

  @override
  String get untitledPolicy => 'बिना नाम की पॉलिसी';

  @override
  String get errPdfPassword => 'यह PDF पासवर्ड से सुरक्षित है। कृपया बिना पासवर्ड वाली कॉपी अपलोड करें।';

  @override
  String get errPdfTooManyPages =>
      'इस दस्तावेज़ में बहुत ज़्यादा पेज हैं। कृपया सिर्फ़ पॉलिसी शेड्यूल और वर्डिंग अपलोड करें।';

  @override
  String get errPdfUnreadable => 'हम यह फ़ाइल नहीं खोल सके। शायद यह खराब है।';

  @override
  String get errNoText => 'हम कोई टेक्स्ट नहीं पढ़ सके। साफ़ फ़ोटो या असली PDF आज़माएँ।';

  @override
  String get errOcrUnavailable =>
      'स्कैन किए दस्तावेज़ अभी नहीं पढ़े जा सकते। कृपया डिजिटल PDF अपलोड करें या जानकारी खुद भरें।';

  @override
  String get errAiUnavailable => 'हमारी रीडिंग सेवा अभी व्यस्त है। कृपया एक मिनट बाद फिर कोशिश करें।';

  @override
  String get errProcessing => 'हम इस दस्तावेज़ को प्रोसेस नहीं कर सके।';

  @override
  String get yourPolicies => 'आपकी पॉलिसियाँ';

  @override
  String coinsOpenRewards(int count) {
    return 'कॉइन: $count। रिवॉर्ड खोलें';
  }

  @override
  String policiesNeedCheck(int count) {
    return '$count पॉलिसी को आपकी एक छोटी-सी जाँच चाहिए';
  }

  @override
  String daysLeftEnds(String date) {
    return 'दिन बाकी · $date को खत्म';
  }

  @override
  String get earnCoinsOrganised => 'व्यवस्थित रहने पर कॉइन कमाएँ';

  @override
  String get addPoliciesNominees => 'पॉलिसियाँ, नॉमिनी और परिवार के सदस्य जोड़ें।';

  @override
  String get worthALook => 'एक नज़र डालें';

  @override
  String allCount(int count) {
    return 'सभी $count';
  }

  @override
  String get details => 'विवरण';

  @override
  String get myInsurance => 'मेरा बीमा';

  @override
  String get nothingHereYet => 'अभी यहाँ कुछ नहीं है';

  @override
  String get addPoliciesHere => 'अपनी हेल्थ, लाइफ़ और मोटर पॉलिसियाँ जोड़ें, सब यहीं रहेंगी।';

  @override
  String allWithCount(int count) {
    return 'सभी ($count)';
  }

  @override
  String get noPoliciesOfType => 'इस प्रकार की कोई पॉलिसी नहीं।';

  @override
  String get takingLonger => 'इसमें सामान्य से ज़्यादा समय लग रहा है। हम काम जारी रखेंगे — थोड़ी देर में फिर देखें।';

  @override
  String get readingYourPolicy => 'आपकी पॉलिसी पढ़ी जा रही है';

  @override
  String get underAMinute => 'इसमें आम तौर पर एक मिनट से कम लगता है।';

  @override
  String get noClausesYet => 'अभी कोई शर्त नहीं';

  @override
  String get clausesNote =>
      'शर्तें आपके अपलोड किए पॉलिसी दस्तावेज़ से पढ़ी जाती हैं। खुद जोड़ी गई पॉलिसियों में ये नहीं होतीं।';

  @override
  String get searchWording => 'पॉलिसी के शब्दों में खोजें';

  @override
  String get nothingMatches => 'कुछ नहीं मिला।';

  @override
  String get notEnoughDetails => 'अभी पर्याप्त जानकारी नहीं';

  @override
  String healthCounts(int strong, int attention, int missing) {
    return '$strong मज़बूत · $attention पर ध्यान ज़रूरी · $missing कवर नहीं';
  }

  @override
  String get needsAttention => 'ध्यान ज़रूरी';

  @override
  String get notMentionedInDoc => 'आपके दस्तावेज़ में इसका ज़िक्र नहीं';

  @override
  String get markAllRead => 'सभी को पढ़ा हुआ मानें';

  @override
  String get allCaughtUp => 'सब देख लिया';

  @override
  String get notificationsAppearHere => 'रिन्यूअल रिमाइंडर और पॉलिसी अपडेट यहाँ दिखेंगे।';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get account => 'अकाउंट';

  @override
  String get helpLegal => 'मदद और कानूनी जानकारी';

  @override
  String get termsConditions => 'नियम और शर्तें';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get comparePolicies => 'पॉलिसियों की तुलना करें';

  @override
  String compareN(int count) {
    return '$count पॉलिसियों की तुलना करें';
  }

  @override
  String get choose2or3 => '2 या 3 पॉलिसियाँ चुनें';

  @override
  String get compareIntro =>
      'अपनी मौजूदा पॉलिसियों की तुलना करें — जैसे दो हेल्थ पॉलिसियाँ — ताकि कवर और सुविधाओं में फ़र्क दिखे।';

  @override
  String typeCover(String type, String amount) {
    return '$type · $amount कवर';
  }

  @override
  String get sideBySide => 'साथ-साथ तुलना';

  @override
  String get reviewNeeded => 'जाँच ज़रूरी';

  @override
  String get statusActive => 'चालू';

  @override
  String endsInDays(int days) {
    return '$days दिन में खत्म';
  }

  @override
  String get statusExpired => 'खत्म हो गई';

  @override
  String get datesMissing => 'तारीखें नहीं हैं';

  @override
  String daysLeft(int days) {
    return '$days दिन बाकी';
  }

  @override
  String get checkupTitle => 'आपके बीमा की जाँच';

  @override
  String get lookingGood => 'सब ठीक है';

  @override
  String get noGapsFound => 'आपकी जोड़ी गई पॉलिसियों में हमें कोई कमी नहीं मिली।';

  @override
  String get demoMode => 'डेमो मोड · ऑफ़लाइन AI';

  @override
  String get confirmAppLock => 'ऐप लॉक चालू करने के लिए पुष्टि करें';

  @override
  String unlockApp(String app) {
    return '$app अनलॉक करें';
  }

  @override
  String get unlock => 'अनलॉक करें';

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get neverMissRenewal => 'कोई रिन्यूअल न छूटे';

  @override
  String get pushPromptBody =>
      'रिन्यूअल रिमाइंडर, प्रोसेसिंग अपडेट और ज़रूरी पॉलिसी अलर्ट के लिए सूचनाएँ चालू करें। सिर्फ़ काम की बातें — कोई मार्केटिंग नहीं।';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get somethingWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get timedOut => 'कनेक्शन का समय खत्म हो गया। कृपया फिर कोशिश करें।';

  @override
  String get cantReachServer => 'सर्वर तक नहीं पहुँच पा रहे। अपना इंटरनेट कनेक्शन जाँचें।';

  @override
  String get somethingWrongRetry => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get appearance => 'रंग-रूप';

  @override
  String get themeSystem => 'फ़ोन के अनुसार';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';
}

// Static, reviewed claim guidance (V1 is content, not AI), in the app's language.
// TODO(Week 8): have this content reviewed by an insurance domain expert before launch.
import '../../../l10n/app_localizations.dart';

class ClaimGuide {
  const ClaimGuide(this.title, this.steps, this.documents);
  final String title;
  final List<String> steps;
  final List<String> documents;
}

Map<String, ClaimGuide> claimGuidesFor(AppLocalizations t) => {
  'health': ClaimGuide(
    t.claimHealthTitle,
    [
      t.claimHealthStep1,
      t.claimHealthStep2,
      t.claimHealthStep3,
      t.claimHealthStep4,
      t.claimHealthStep5,
      t.claimHealthStep6,
    ],
    [
      t.claimHealthDoc1,
      t.claimHealthDoc2,
      t.claimHealthDoc3,
      t.claimHealthDoc4,
      t.claimHealthDoc5,
      t.claimHealthDoc6,
      t.claimHealthDoc7,
    ],
  ),
  'motor': ClaimGuide(
    t.claimMotorTitle,
    [t.claimMotorStep1, t.claimMotorStep2, t.claimMotorStep3, t.claimMotorStep4, t.claimMotorStep5],
    [t.claimMotorDoc1, t.claimMotorDoc2, t.claimMotorDoc3, t.claimMotorDoc4, t.claimMotorDoc5, t.claimMotorDoc6],
  ),
  'life': ClaimGuide(
    t.claimLifeTitle,
    [t.claimLifeStep1, t.claimLifeStep2, t.claimLifeStep3, t.claimLifeStep4, t.claimLifeStep5],
    [t.claimLifeDoc1, t.claimLifeDoc2, t.claimLifeDoc3, t.claimLifeDoc4, t.claimLifeDoc5],
  ),
  'other': ClaimGuide(
    t.claimOtherTitle,
    [t.claimOtherStep1, t.claimOtherStep2, t.claimOtherStep3, t.claimOtherStep4],
    [t.claimOtherDoc1, t.claimOtherDoc2, t.claimOtherDoc3, t.claimOtherDoc4],
  ),
};

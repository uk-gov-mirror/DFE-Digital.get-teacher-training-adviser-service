require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::UkTelephone do
  include_context "wizard step"
  it_behaves_like "a wizard step"
  include_context "sanitize fields", %i[telephone]

  it { is_expected.to be_contains_personal_details }
  it { is_expected.to be_optional }

  context "attributes" do
    it { is_expected.to respond_to :telephone }
  end

  describe "telephone" do
    it { is_expected.to_not allow_values("abc12345", "12", "1" * 21).for :telephone }
    it { is_expected.to allow_values(nil, "123456789").for :telephone }
  end

  describe "#skipped?" do
    it "returns false if UkAddress step was shown and degree_options is not equivalent" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?) { false }
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject).to_not be_skipped
    end

    it "returns true if UkAddress was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?) { true }
      expect(subject).to be_skipped
    end

    it "returns true if degree_options is equivalent" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).to be_skipped
    end

    it "returns true when pre-filled with crm data" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      wizardstore.persist_crm({ "telephone" => "123456789" })
      expect(subject).to be_skipped
    end
  end
end

require "rails_helper"

RSpec.describe SignUp::Steps::SubjectLikeToTeach do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  context "attributes" do
    it { is_expected.to respond_to :preferred_teaching_subject_id }
  end

  describe "#preferred_teaching_subject_id" do
    it "allows a valid preferred_teaching_subject_id" do
      subject_type = GetIntoTeachingApiClient::TypeEntity.new(id: "abc-123")
      allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
        receive(:get_teaching_subjects) { [subject_type] }
      expect(subject).to allow_value(subject_type.id).for :preferred_teaching_subject_id
    end

    it { is_expected.to_not allow_value("").for :preferred_teaching_subject_id }
    it { is_expected.to_not allow_value(nil).for :preferred_teaching_subject_id }
  end

  describe "#self.options" do
    it "is a pending example"
  end
end

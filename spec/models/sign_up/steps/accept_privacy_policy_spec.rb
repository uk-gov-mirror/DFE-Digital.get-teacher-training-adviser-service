require "rails_helper"

RSpec.describe SignUp::Steps::AcceptPrivacyPolicy do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :accepted_policy_id }

  context "accepted_policy_id" do
    it "allows a valid privacy policy id" do
      policy = GetIntoTeachingApiClient::PrivacyPolicy.new(id: "abc-123")
      allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
        receive(:get_privacy_policy).with(policy.id) { policy }
      expect(subject).to allow_value(policy.id).for :accepted_policy_id
    end
    it { is_expected.to_not allow_value("def-456").for :accepted_policy_id }
  end
end

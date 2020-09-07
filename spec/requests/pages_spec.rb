require "rails_helper"

RSpec.describe PagesController, type: :request do
  let(:policy_id) { SecureRandom.uuid }
  let(:policy) { GetIntoTeachingApiClient::PrivacyPolicy.new(id: policy_id, text: "Latest privacy policy") }

  describe "get /privacy_policy" do
    context "viewing the latest privacy policy" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to receive(:get_latest_privacy_policy).and_return(policy)
      end

      subject do
        get privacy_policy_path
        response
      end

      include_examples "policy_views"
    end

    context "viewing a specific privacy policy" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to receive(:get_privacy_policy).and_return(policy)
      end

      subject do
        get privacy_policy_path(id: policy_id)
        response
      end

      include_examples "policy_views"
    end
  end

  describe "get /session-expired" do
    it "returns a success response" do
      get session_expired_path
      expect(response).to have_http_status(200)
    end
  end

  context "#show" do
    subject { response }

    context "for known page" do
      before { get "/home" }
      it { is_expected.to have_http_status :success }
      it { expect(response.body).to match "Sign up to get an adviser" }
    end

    context "for unknown page" do
      before { get "/unknown" }
      it { is_expected.to have_http_status :not_found }
      it { expect(response.body).to match "The page you were looking for doesn't exist" }
    end
  end
end

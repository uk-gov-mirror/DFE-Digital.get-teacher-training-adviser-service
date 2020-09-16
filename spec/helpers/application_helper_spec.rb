require "rails_helper"

RSpec.describe ApplicationHelper do
  include TextFormatHelper
  describe "#analytics_body_tag" do
    let(:gtm_id) { "1234" }
    let(:hotjar_id) { "5678" }
    let(:snapchat_id) { "3456" }
    let(:pinterest_id) { "6543" }
    let(:facebook_id) { "4321" }
    let(:twitter_id) { "1289" }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_TAG_MANAGER_ID").and_return gtm_id
      allow(ENV).to receive(:[]).with("HOTJAR_ID").and_return hotjar_id
      allow(ENV).to receive(:[]).with("SNAPCHAT_ID").and_return snapchat_id
      allow(ENV).to receive(:[]).with("PINTEREST_ID").and_return pinterest_id
      allow(ENV).to receive(:[]).with("FACEBOOK_ID").and_return facebook_id
      allow(ENV).to receive(:[]).with("TWITTER_ID").and_return twitter_id
    end

    subject { analytics_body_tag { "<h1>TEST</h1>".html_safe } }

    it { is_expected.to have_css "body h1" }

    context "includes stimulus controllers" do
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-controller~=hotjar]" }
      it { is_expected.to have_css "body[data-controller~=snapchat]" }
      it { is_expected.to have_css "body[data-controller~=pinterest]" }
      it { is_expected.to have_css "body[data-controller~=facebook]" }
      it { is_expected.to have_css "body[data-controller~=twitter]" }
    end

    context "assigns service ids" do
      it { is_expected.to have_css "body[data-analytics-gtm-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-hotjar-id=5678]" }
      it { is_expected.to have_css "body[data-analytics-snapchat-id=3456]" }
      it { is_expected.to have_css "body[data-analytics-pinterest-id=6543]" }
      it { is_expected.to have_css "body[data-analytics-facebook-id=4321]" }
      it { is_expected.to have_css "body[data-analytics-twitter-id=1289]" }
    end

    context "with blank service ids" do
      let(:gtm_id) { "" }
      let(:twitter_id) { "" }
      it { is_expected.to have_css "body[data-analytics-gtm-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-twitter-id=\"\"]" }
    end

    context "with no service ids" do
      let(:gtm_id) { nil }
      let(:twitter_id) { nil }
      it { is_expected.not_to have_css "body[data-analytics-gtm-id]" }
      it { is_expected.not_to have_css "body[data-analytics-twitter-id]" }
    end

    context "default events" do
      it { is_expected.to have_css "body[data-snapchat-action=track]" }
      it { is_expected.to have_css "body[data-snapchat-event=PAGE_VIEW]" }
      it { is_expected.to have_css "body[data-facebook-action=track]" }
      it { is_expected.to have_css "body[data-facebook-event=PageView]" }
      it { is_expected.to have_css "body[data-twitter-action=track]" }
      it { is_expected.to have_css "body[data-twitter-event=PageView]" }
    end

    context "with additional stimulus controller" do
      subject { analytics_body_tag(data: { controller: "atest" }) { tag.hr } }
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-controller~=twitter]" }
      it { is_expected.to have_css "body[data-controller~=atest]" }
    end

    context "with other data attributes" do
      subject { analytics_body_tag(data: { timefmt: "24" }) { tag.hr } }
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-analytics-gtm-id=1234]" }
      it { is_expected.to have_css "body[data-timefmt=24]" }
    end

    context "with other attributes" do
      subject { analytics_body_tag(class: "homepage") { tag.hr } }
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body.homepage" }
    end
  end

  describe "#govuk_form_for" do
    it "renders a form with GOV.UK form builder" do
      expect(govuk_form_for(StubModel.new, url: "http://test.com") {}).to eq(
        "<form class=\"new_stub_model\" id=\"new_stub_model\" novalidate=\"novalidate\" "\
        "action=\"http://test.com\" accept-charset=\"UTF-8\" method=\"post\"></form>",
      )
    end
  end

  describe "#back_link" do
    it "renders a back link with GOV.UK class names" do
      expect(back_link).to eq("<a class=\"govuk-back-link\" href=\"javascript:history.back()\">Back</a>")
    end
  end

  describe "#link_to_change_answer" do
    it "returns a link to the sign up step" do
      expect(link_to_change_answer(TeacherTrainingAdviser::Steps::Identity)).to eq(
        "<a class=\"govuk-link\" href=\"/teacher_training_adviser/sign_up/identity\">Change <span class=\"visually-hidden\"> identity</span></a>",
      )
    end
  end

  class StubModel
    include ActiveModel::Model
  end
end

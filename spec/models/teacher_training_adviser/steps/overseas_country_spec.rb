require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::OverseasCountry do
  include_context "wizard step"
  it_behaves_like "a wizard step"
  it_behaves_like "a wizard step that exposes API lookup items as options",
                  :get_countries, described_class::OMIT_COUNTRY_IDS

  context "attributes" do
    it { is_expected.to respond_to :country_id }
  end

  describe "country_id" do
    it "allows a valid country id" do
      country = GetIntoTeachingApiClient::LookupItem.new(id: "abc-123")
      allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
        receive(:get_countries) { [country] }
      expect(subject).to allow_value(country.id).for :country_id
    end
    it { is_expected.to_not allow_values(nil, "", "def-123").for :country_id }
  end

  describe "#skipped?" do
    it "returns false if uk_or_overseas is Overseas" do
      wizardstore["uk_or_overseas"] = TeacherTrainingAdviser::Steps::UkOrOverseas::OPTIONS[:overseas]
      expect(subject).to_not be_skipped
    end

    it "returns true if uk_or_overseas is UK" do
      wizardstore["uk_or_overseas"] = TeacherTrainingAdviser::Steps::UkOrOverseas::OPTIONS[:uk]
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }
    let(:lookup_item) { GetIntoTeachingApiClient::LookupItem.new(id: "123", value: "Value") }
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
        receive(:get_countries) { [lookup_item] }
      instance.country_id = lookup_item.id
    end

    it { is_expected.to eq({ "country_id" => "Value" }) }
  end
end

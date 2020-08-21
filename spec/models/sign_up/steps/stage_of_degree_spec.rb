require "rails_helper"

RSpec.describe SignUp::Steps::StageOfDegree do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  context "attributes" do
    it { is_expected.to respond_to :degree_status_id }
  end

  describe "#degree_status_id" do
    it "allows a valid degree status id" do
      status = GetIntoTeachingApiClient::TypeEntity.new(id: 123)
      allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
        receive(:get_qualification_degree_status) { [status] }
      expect(subject).to allow_value(status.id).for :degree_status_id
    end

    it { is_expected.to_not allow_value("").for :degree_status_id }
    it { is_expected.to_not allow_value(nil).for :degree_status_id }
  end

  describe "#self.options" do
    it "is a pending example"
  end
end

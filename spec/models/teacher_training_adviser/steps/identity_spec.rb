require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::Identity do
  include_context "wizard step"
  it_behaves_like "a wizard step"
  it_behaves_like "an issue verification code wizard step"
  include_context "sanitize fields", %i[first_name last_name email]

  it { is_expected.to be_contains_personal_details }

  context "attributes" do
    it { is_expected.to respond_to :first_name }
    it { is_expected.to respond_to :last_name }
    it { is_expected.to respond_to :email }
  end

  describe "first_name" do
    it { is_expected.to_not allow_values(nil, "", "a" * 257).for :first_name }
    it { is_expected.to allow_values("John").for :first_name }
  end

  describe "last_name" do
    it { is_expected.to_not allow_values(nil, "", "a" * 257).for :last_name }
    it { is_expected.to allow_values("John").for :last_name }
  end

  describe "email" do
    it { is_expected.to_not allow_values(nil, "", "a@#{'a' * 101}.com").for :email }
    it { is_expected.to allow_values("test@test.com", "test%.mctest@domain.co.uk").for :email }
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }
    before do
      instance.first_name = "John"
      instance.last_name = "Doe"
      instance.email = "john@doe.com"
    end

    it { is_expected.to eq({ "name" => "John Doe", "email" => "john@doe.com" }) }
  end
end

require "rails_helper"

RSpec.describe RetakeScience do
  subject { build(:retake_science) }

  describe "validation" do
    context "with valid subject option" do
      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "with invalid subject option" do
      it "is not valid" do
        subject.planning_to_retake_gcse_science_id = "invalid_id"
        expect(subject).to_not be_valid
      end
    end
  end
end
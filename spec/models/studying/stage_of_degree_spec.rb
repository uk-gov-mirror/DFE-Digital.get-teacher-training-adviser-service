require "rails_helper"

RSpec.describe Studying::StageOfDegree, :vcr do
  subject { build(:stage_of_degree) }

  describe "validation" do
    context "with valid answer" do
      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "with invalid answer" do
      it "is invalid" do
        subject.degree_stage = "invalid_id"
        expect(subject).not_to be_valid
      end
    end
  end

  describe "#next_step" do
    it "returns the correct option" do
      expect(subject.next_step).to eq("studying/what_subject_degree")
    end
  end
end
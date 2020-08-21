require "rails_helper"

RSpec.describe SignUp::Steps::GcseScience do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  context "attributes" do
    it { is_expected.to respond_to :has_gcse_science_id }
  end

  describe "has_gcse_science_id" do
    it { is_expected.to_not allow_value(nil).for :has_gcse_science_id }
    it { is_expected.to allow_value(Crm::OPTIONS[:yes]).for :has_gcse_science_id }
    it { is_expected.to allow_value(Crm::OPTIONS[:no]).for :has_gcse_science_id }
  end
end

require "rails_helper"
require "basic_auth"

RSpec.describe BasicAuth do
  let(:http_auth) { "" }
  let(:instance) { described_class }

  before do
    allow(Rails.application.credentials.config).to receive(:[]).and_call_original
    allow(Rails.application.credentials.config).to receive(:[]).with(:http_auth) { http_auth }
    described_class.class_variable_set(:@@credentials, nil)
  end

  describe ".credentials" do
    subject { instance.credentials }

    it { is_expected.to eq([]) }

    context "when http_auth is present" do
      let(:http_auth) { "username1=password1,username2=password2" }

      it do
        is_expected.to contain_exactly(
          { username: "username1", password: "password1" },
          { username: "username2", password: "password2" },
        )
      end
    end
  end

  describe ".authenticate" do
    let(:username) { "" }
    let(:password) { "" }

    subject { instance.authenticate(username, password) }

    it { is_expected.to be_falsy }

    context "when http_auth has an empty credential" do
      let(:http_auth) { "=" }

      it { is_expected.to be_falsy }
    end

    context "when http_auth is present" do
      let(:http_auth) { "username1=password1,username2=password2,username2=password3" }

      context "when the username/password are incorrect" do
        let(:username) { "username1" }
        let(:password) { "password2" }

        it { is_expected.to be_falsy }
      end

      context "when the username/password are correct" do
        let(:username) { "username1" }
        let(:password) { "password1" }

        it { is_expected.to be_truthy }
      end

      context "when the username/password are correct (duplicate username, different password)" do
        let(:username) { "username2" }
        let(:password) { "password3" }

        it { is_expected.to be_truthy }
      end
    end
  end
end

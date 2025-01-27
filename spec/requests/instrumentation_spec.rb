require "rails_helper"

RSpec.describe "Instrumentation" do
  let(:registry) { Prometheus::Client.registry }

  describe "process_action.action_controller" do
    after { get cookies_path(query: "param") }

    it "increments the :tta_requests_total metric" do
      metric = registry.get(:tta_requests_total)
      expect(metric).to receive(:increment).with(labels: { path: "/cookies", method: "GET", status: 200 }).once
    end

    it "observes the :tta_request_duration_ms metric" do
      metric = registry.get(:tta_request_duration_ms)
      expect(metric).to receive(:observe).with(instance_of(Float), labels: { path: "/cookies", method: "GET", status: 200 }).once
    end

    it "observes the :tta_request_view_runtime_ms metric" do
      metric = registry.get(:tta_request_view_runtime_ms)
      expect(metric).to receive(:observe).with(instance_of(Float), labels: { path: "/cookies", method: "GET", status: 200 }).once
    end
  end

  describe "render_template.action_view" do
    after { get cookie_preference_path }

    it "observes the :tta_render_view_ms metric" do
      metric = registry.get(:tta_render_view_ms)
      expect(metric).to receive(:observe).with(instance_of(Float), labels: {
        identifier: "cookie_preferences/show.html.erb",
      }).once
    end
  end

  describe "render_partial.action_view" do
    after { get root_path }

    it "observes the :tta_render_view_ms metric" do
      metric = registry.get(:tta_render_partial_ms)
      allow(metric).to receive(:observe)
      expect(metric).to receive(:observe).with(instance_of(Float), labels: {
        identifier: "layouts/_footer.html.erb",
      }).once
    end
  end

  describe "cache_read.active_support" do
    after { get privacy_policy_path }

    it "observes the :tta_cache_read_total metric" do
      metric = registry.get(:tta_cache_read_total)
      expect(metric).to receive(:increment).with(labels: {
        key: instance_of(String),
        hit: false,
      }).twice
    end
  end

  describe "tta.csp_violation" do
    let(:params) do
      {
        "csp-report" =>
        {
          "blocked-uri" => "http://document-uri.com/script.js?param=test",
          "document-uri" => "http://document-uri.com/path?param=test",
          "violated-directive": "violated-directive extra-info",
        },
      }
    end

    after { post csp_reports_path, params: params.to_json }

    it "increments the :tta_csp_violations_total metric" do
      metric = registry.get(:tta_csp_violations_total)
      expect(metric).to receive(:increment).with(labels:
        {
          blocked_uri: "http://document-uri.com/script.js",
          document_uri: "/path",
          violated_directive: "violated-directive",
        }).once
    end
  end

  describe "tta.feedback" do
    let(:params) do
      {
        teacher_training_adviser_feedback: attributes_for(:feedback),
      }
    end

    after { post teacher_training_adviser_feedbacks_path, params: params }

    it "increments the :tta_feedback_visit_total metric" do
      metric = registry.get(:tta_feedback_visit_total)
      expect(metric).to receive(:increment).with(labels: { successful: "true" }).once
    end

    it "increments the :tta_feedback_rating_total metric" do
      metric = registry.get(:tta_feedback_rating_total)
      expect(metric).to receive(:increment).with(labels: { rating: "satisfied" }).once
    end
  end
end

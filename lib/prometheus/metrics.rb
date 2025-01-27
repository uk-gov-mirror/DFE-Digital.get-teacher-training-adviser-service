module Prometheus
  module Metrics
    prometheus = Prometheus::Client.registry

    prometheus.counter(
      :tta_requests_total,
      docstring: "A counter of requests",
      labels: %i[path method status],
    )

    prometheus.histogram(
      :tta_request_duration_ms,
      docstring: "A histogram of request durations",
      labels: %i[path method status],
    )

    prometheus.histogram(
      :tta_request_view_runtime_ms,
      docstring: "A histogram of request view runtimes",
      labels: %i[path method status],
    )

    prometheus.histogram(
      :tta_render_view_ms,
      docstring: "A histogram of view rendering times",
      labels: %i[identifier],
    )

    prometheus.histogram(
      :tta_render_partial_ms,
      docstring: "A histogram of partial rendering times",
      labels: %i[identifier],
    )

    prometheus.counter(
      :tta_cache_read_total,
      docstring: "A counter of cache reads",
      labels: %i[key hit],
    )

    prometheus.counter(
      :tta_csp_violations_total,
      docstring: "A counter of CSP violations",
      labels: %i[blocked_uri document_uri violated_directive],
    )

    prometheus.counter(
      :tta_feedback_visit_total,
      docstring: "A counter of feedback visit responses",
      labels: %i[successful],
    )

    prometheus.counter(
      :tta_feedback_rating_total,
      docstring: "A counter of feedback rating responses",
      labels: %i[rating],
    )
  end
end

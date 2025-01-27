module ApplicationHelper
  def analytics_body_tag(attributes = {}, &block)
    attributes = attributes.symbolize_keys

    analytics = {
      "analytics-gtm-id" => ENV["GOOGLE_TAG_MANAGER_ID"],
      "analytics-adwords-id" => ENV["GOOGLE_AD_WORDS_ID"],
      "analytics-snapchat-id" => ENV["SNAPCHAT_ID"],
      "analytics-pinterest-id" => ENV["PINTEREST_ID"],
      "analytics-facebook-id" => ENV["FACEBOOK_ID"],
      "analytics-twitter-id" => ENV["TWITTER_ID"],
      "analytics-lid-id" => ENV["LID_ID"],
      "pinterest-action-value" => "page",
      "snapchat-action-value" => "track",
      "snapchat-event-value" => "PAGE_VIEW",
      "facebook-action-value" => "track",
      "facebook-event-value" => "PageView",
      "twitter-action-value" => "track",
      "twitter-event-value" => "PageView",
    }.symbolize_keys

    attributes[:data] ||= {}
    attributes[:data] = attributes[:data].merge(analytics)

    attributes[:data][:controller] =
      "gtm pinterest snapchat facebook twitter #{attributes[:data][:controller]}"

    tag.body attributes, &block
  end

  def prefix_title(title)
    if title
      "Get an adviser: #{title}"
    else
      "Get an adviser"
    end
  end

  def govuk_form_for(*args, **options, &block)
    merged = options.dup
    merged[:builder] = GOVUKDesignSystemFormBuilder::FormBuilder
    merged[:html] ||= {}
    merged[:html][:novalidate] = true

    form_for(*args, **merged, &block)
  end

  def back_link(path = :back, text: "Back", **options)
    options[:class] = "govuk-back-link #{options[:class]}".strip

    link_to text, path, **options
  end

  def link_to_change_answer(step)
    link_to(teacher_training_adviser_step_path(step.key), { class: "govuk-link" }) do
      safe_html_format("Change <span class='visually-hidden'> #{step.key.humanize(capitalize: false)}</span>")
    end
  end

  def link_to_git_site(text = "Get into Teaching", path = "", attributes = {})
    link_to text, git_url(path), attributes
  end

  def link_to_git_mailing_list(text, attributes = {})
    link_to text, git_url("mailinglist/signup"), attributes
  end

  def link_to_git_events(text, events_path: nil, **attributes)
    link_to text, git_url(["events", events_path].compact.join("/")), **attributes
  end

  def internal_referer
    referer = request.referer
    internal = referer.to_s.include?(root_url)
    return nil unless internal

    referer
  end

  def human_boolean(boolean)
    boolean ? "Yes" : "No"
  end

private

  def git_url(path = "")
    url = ENV["GIT_URL"].presence
    return "/url-not-set/#{path}" unless url

    "#{url.chomp('/')}/#{path}"
  end
end

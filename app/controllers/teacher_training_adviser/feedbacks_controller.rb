require "teacher_training_adviser/feedback_exporter"

module TeacherTrainingAdviser
  class FeedbacksController < ApplicationController
    RECENT_AMOUNT = 10
    RESTRICTED_ACTIONS = %w[index export].freeze

    invisible_captcha only: [:create], timestamp_threshold: 1.second
    before_action :load_recent_feedback, only: %i[index export]
    before_action :restrict_access, if: :authenticate?

    def new
      @page_title = "Give feedback on this service"
      @feedback = Feedback.new
    end

    def create
      @feedback = Feedback.new(feedback_params)

      if @feedback.save
        ActiveSupport::Notifications.instrument("tta.feedback", @feedback)
        redirect_to(thank_you_teacher_training_adviser_feedbacks_path)
      else
        render :new
      end
    end

    def thank_you
      @page_title = "Thank you for your feedback"
    end

    def index
      @page_title = "Service feedback"
      @search = FeedbackSearch.new
    end

    def export
      @page_title = "Export feedback"
      @search = FeedbackSearch.new(feedback_search_params)

      if @search.valid?
        filename = "feedback-#{@search.range.join('--')}"
        exporter = FeedbackExporter.new(@search.results)

        respond_to do |format|
          format.csv { send_data exporter.to_csv, filename: "#{filename}.csv" }
        end
      else
        render :index, formats: %i[html]
      end
    end

    def restrict_access
      raise_forbidden if RESTRICTED_ACTIONS.include?(action_name) &&
        session[:username] != "feedback"
    end

  protected

    def authenticate?
      return false if Rails.env.test? || Rails.env.development?

      Rails.env.production? ? RESTRICTED_ACTIONS.include?(action_name) : true
    end

  private

    def load_recent_feedback
      @recent_feedback = Feedback.recent.limit(RECENT_AMOUNT)
    end

    def feedback_params
      params.require(:teacher_training_adviser_feedback).permit(
        :rating,
        :improvements,
        :successful_visit,
        :unsuccessful_visit_explanation,
      )
    end

    def feedback_search_params
      params.require(:teacher_training_adviser_feedback_search).permit(
        :created_on_or_after,
        :created_on_or_before,
      )
    end
  end
end

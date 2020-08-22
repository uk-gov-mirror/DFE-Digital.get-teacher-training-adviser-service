module TeacherTrainingAdviser::Steps
  class WhatDegreeClass < Wizard::Step
    extend ApiOptions

    attribute :uk_degree_grade_id, :integer

    validates :uk_degree_grade_id, types: { method: :get_qualification_uk_degree_grades, message: "You must select an option" }

    def skipped?
      [
        TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying],
        TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:degree],
      ].none?(@store["degree_options"])
    end

    def studying?
      @store["degree_options"] == TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying]
    end

    def self.options
      generate_api_options(GetIntoTeachingApiClient::TypesApi.new.get_qualification_uk_degree_grades)
    end
  end
end
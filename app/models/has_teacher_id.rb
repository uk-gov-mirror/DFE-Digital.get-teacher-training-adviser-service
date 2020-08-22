class HasTeacherId < Base
  attribute :has_id, :boolean

  validates :has_id, inclusion: { in: [true, false], message: "You must select either yes or no" }

  def next_step
    if has_id == true
      "previous_id"
    else
      "previous_subject"
    end
  end
end
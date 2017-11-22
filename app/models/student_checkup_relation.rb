class StudentCheckupRelation < ActiveRecord::Base
    belongs_to :student
    belongs_to :user
    belongs_to :checkup, polymorphic: true

    after_create :update_student

    private

    def update_student
        self.checkup.update_student
    end
end

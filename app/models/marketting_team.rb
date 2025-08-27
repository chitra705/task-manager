class MarkettingTeam < ApplicationRecord
	def self.find_by_emp_id(emp_id)
    find_by(emp_id: emp_id)
  end
end

class TeamList < ApplicationRecord
	belongs_to :team, polymorphic: true

	enum name:{
  	management: 0,
  	administration: 1,
  	development: 2,
  	marketing: 3
  }

  def self.add_team(incoming_values)
  	tl = TeamList.new
  	tl.name = incoming_values['name']
  	tl.team = incoming_values
  	tl.save!
  end

  def self.filter_by_category
    team_lists = TeamList.all.pluck(:team_type).uniq
    tasks_by_category = {}

    team_lists.each do |team_name|
      tasks = ProjectTask.where(team_type: team_name)
      tasks_by_category[team_name] =tasks
    end

    tasks_by_category
  end


end

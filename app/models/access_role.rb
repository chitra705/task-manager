class AccessRole < ApplicationRecord

	enum name:{
  	admin: 0,
  	manager: 1,
  	team_lead: 2 
  	team_member: 3
  }
end

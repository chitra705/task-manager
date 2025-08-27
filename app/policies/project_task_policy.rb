class ProjectTaskPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

 class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(created_by_id: user.id)  # Non-admin sees only tasks they created
      end
    end
  end

  def index?
    user.admin? || user.manager? || user.team_lead? || user.team_member?
  end

  def show?
    user.admin? || user.manager? || user.team_lead? || user.team_member?
  end

  def create?
    user.admin? || user.manager? || user.team_lead?
  end

  def update?
    user.admin? || user.manager? || user.team_lead?
  end

  def destroy?
    user.admin? || user.manager? || user.team_lead?
  end

  def assign?
    user.manager? || user.admin? || user.team_lead?
  end

  def move?
    user.manager? || user.admin? || user.team_lead?
  end

  def upload_file?
    user.admin? || user.manager? || user.team_lead?
  end

  def task_delete?
    user.admin? || user.manager? || user.team_lead?
  end

  def update_status?
    user.admin? || user.manager? || user.team_lead? || user.team_member?
  end

  def update_task_log_status?
    user.admin? || user.manager? || user.team_lead? || user.team_member?
  end

  def download_csv
    user.admin? || user.manager? || user.team_lead?
  end

end

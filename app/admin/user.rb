ActiveAdmin.register User do
  permit_params :name, :email, :role, :approved, :dob, :address, :location, :blood_group

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :role
    column :approved
    column :created_at
    actions defaults: true do |user|
      if !user.approved
        item 'Approve', approve_user_path(user), method: :put, class: 'member_link'
        item 'Reject', reject_user_path(user), method: :put, class: 'member_link'
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :role
      f.input :approved
      f.input :dob
      f.input :address
      f.input :location
      f.input :blood_group
    end
    f.actions
  end

  member_action :approve, method: :put do
    user = User.find(params[:id])
    user.update(approved: true)
    UserMailer.user_approved(user).deliver_now
    redirect_to users_path, notice: "User #{user.email} has been approved."
  end

  member_action :reject, method: :put do
    user = User.find(params[:id])
    UserMailer.user_rejected(user).deliver_now
    user.destroy
    redirect_to users_path, notice: "User #{user.email} has been rejected."
  end
end

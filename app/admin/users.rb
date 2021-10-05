ActiveAdmin.register User do
  scope :not_activated
  scope :activated

  filter :name
  filter :email
  filter :following
  filter :followers
  filter :created_at
  filter :updated_at
  filter :activated_at
  filter :admin

  index do
    column :id
    column :name
    column :email
    actions
  end

end

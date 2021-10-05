ActiveAdmin.register Micropost do

  filter :user
  filter :content
  filter :created_at
  filter :updated_at

  index do
    column :id
    column :user_id
    column :content
    actions
  end

end

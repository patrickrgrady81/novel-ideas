ActiveAdmin.register Book do
  index do 
    column :title 
    column :author
    actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :author, :title, :description, :isbn, :price, :img
  #
  # or
  #
  # permit_params do
  #   permitted = [:author, :title, :description, :isbn, :price, :img]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

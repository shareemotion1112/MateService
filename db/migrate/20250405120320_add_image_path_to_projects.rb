class AddImagePathToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :image_path, :string
  end
end

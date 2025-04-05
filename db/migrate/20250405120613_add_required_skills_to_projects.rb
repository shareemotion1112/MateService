class AddRequiredSkillsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :required_skills, :string
  end
end

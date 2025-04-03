class CreateJoinTableProjectsSkills < ActiveRecord::Migration[8.0]
  def change
    create_join_table :projects, :skills do |t|
      t.index [:project_id, :skill_id]
      t.index [:skill_id, :project_id]
    end
  end
end

class AddYearsOfExperienceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :years_of_experience, :integer
  end
end

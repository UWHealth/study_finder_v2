class CreateGroups < ActiveRecord::Migration
  def change
    create_table :study_finder_groups do |t|
      t.string :group_name
      t.timestamps
    end
  end
end

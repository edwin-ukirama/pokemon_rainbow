class CreateSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :skills do |t|
      t.string :name, index: { unique: true, name: 'unique_skill_names'}, limit: 45
      t.integer :power
      t.integer :max_pp
      t.string :element_type
      t.timestamps
    end
  end
end

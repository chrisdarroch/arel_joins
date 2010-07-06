class CreateClassrooms < ActiveRecord::Migration
  def self.up
    create_table :classrooms do |t|
      t.references :school
      t.string :name
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :classrooms
  end
end

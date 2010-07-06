class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.references :student
      t.references :exam
      t.integer :mark

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end

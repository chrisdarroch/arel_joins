class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.string :title
      t.integer :marks
      t.float :weight
      t.date :announced_on
      t.datetime :starts_at

      t.timestamps
    end
  end

  def self.down
    drop_table :exams
  end
end

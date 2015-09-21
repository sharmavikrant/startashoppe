class CreateHighScores < ActiveRecord::Migration
  def change
    create_table :high_scores do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end

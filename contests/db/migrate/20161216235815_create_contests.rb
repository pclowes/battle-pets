class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :category

      t.timestamps
    end
  end
end

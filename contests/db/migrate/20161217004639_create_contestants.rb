class CreateContestants < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
      t.integer :pet_id
      t.string  :name
      t.integer :strength
      t.integer :agility
      t.integer :wit
      t.integer :senses
      t.integer :experience
      t.integer :contest_id
      t.boolean :winner

      t.timestamps
    end
  end
end

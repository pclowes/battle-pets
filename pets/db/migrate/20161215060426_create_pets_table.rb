class CreatePetsTable < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.string :name
      t.integer :strength
      t.integer :agility
      t.integer :wit
      t.integer :senses
      t.integer :experience

      t.timestamps
    end
  end
end

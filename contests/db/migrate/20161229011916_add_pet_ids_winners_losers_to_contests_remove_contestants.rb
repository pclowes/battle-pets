class AddPetIdsWinnersLosersToContestsRemoveContestants < ActiveRecord::Migration
  def change
    drop_table :contestants

    add_column :contests, :pet_ids, :integer, array: true, default: []
  end
end

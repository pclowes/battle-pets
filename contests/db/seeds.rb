Contest.destroy_all
Contestant.destroy_all

contest1 = Contest.create!(category: :strength)
Contestant.create!([
                       {
                           pet_id: 1,
                           name: "Pet 1",
                           strength: 11,
                           agility: 22,
                           wit: 33,
                           senses: 44,
                           experience: 100,
                           contest_id: contest1.id,
                           winner: false

                       },
                       {
                           pet_id: 2,
                           name: "Pet 2",
                           strength: 44,
                           agility: 33,
                           wit: 22,
                           senses: 11,
                           experience: 100,
                           contest_id: contest1.id,
                           winner: true
                       }
                   ])

contest1 = Contest.create!(category: :senses)
Contestant.create!([
                       {
                           pet_id: 1,
                           name: "Contestant 1",
                           strength: 11,
                           agility: 22,
                           wit: 33,
                           senses: 44,
                           experience: 100,
                           contest_id: contest1.id,
                           winner: true

                       },
                       {
                           pet_id: 2,
                           name: "Contestant 2",
                           strength: 44,
                           agility: 33,
                           wit: 22,
                           senses: 11,
                           experience: 100,
                           contest_id: contest1.id,
                           winner: false
                       }
                   ])

p "Created #{Contest.count} contests"
p "Created #{Contestant.count} contestants"
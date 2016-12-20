Pet.destroy_all

Pet.create!([
                {
                    name: "Pet 1",
                    strength: 11,
                    agility: 55,
                    wit: 33,
                    senses: 44,
                    experience: 115
                },
                {
                    name: "Pet 2",
                    strength: 49,
                    agility: 33,
                    wit: 33,
                    senses: 44,
                    experience: 135
                },
                {
                    name: "Pet 3",
                    strength: 11,
                    agility: 22,
                    wit: 33,
                    senses: 23,
                    experience: 100
                }
            ])

p "Created #{Pet.count} pets"
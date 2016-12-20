class ResultService
  def update(result)
    winning_pets = Pet.where("id IN (?)", result[:winners])
    losing_pets = Pet.where("id IN (?)", result[:losers])

    winning_pets.map do |w|
      w.experience += 15
      w.save!
    end

    losing_pets.map do |l|
      l.experience += 5
      l.save!
    end
  end
end
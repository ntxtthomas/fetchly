class BreedCsvExporter
  require "csv"

  def self.export
    breeds_data = DogApiService.new.fetch_all_breeds

    csv_str = CSV.generate(headers: true) do |csv|
      csv << ["Name", "Bred For", "Origin", "Breed Group", "Life Span", "Size Category", "Temperament"]

      breeds_data.each do |breed|
        csv << [
          breed["name"],
          breed["bred_for"],
          breed["origin"],
          breed["breed_group"],
          breed["life_span"],
          breed["size_category"],
          breed["temperament"]
        ]
      end
    end
    csv_str
  end
end

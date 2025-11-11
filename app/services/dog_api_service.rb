class DogApiService
  include HTTParty

  base_uri "https://api.thedogapi.com/v1"

  def initialize(api_key = nil)
    @api_key = api_key || ENV["DOG_API_KEY"]
  end

  def fetch_breeds
    response = make_request("/breeds")
    parsed_data = parse_response(response)
    enhance_with_size_data(parsed_data)
  end

  def fetch_breed(breed_id)
    response = make_request("/breeds/#{breed_id}")
    parsed_data = parse_response(response)
    return nil unless parsed_data

    enhance_with_size_data([parsed_data]).first
  end

  def fetch_breed_images(breed_id, limit = 5)
    response = make_request("/images/search?breed_id=#{breed_id}&limit=#{limit}")
    parse_response(response)
  end

  private

  def make_request(endpoint)
    options = {
      headers: {
        "x-api-key" => @api_key
      }
    }
    self.class.get(endpoint, options)
  end

  def parse_response(response)
    return response.parsed_response if response.success?
    nil
  end

  def enhance_with_size_data(breeds)
    breeds.map do |breed|
      weight_string = breed["weight"]["imperial"]
      weight_numbers = weight_string.scan(/\d+/).map(&:to_i)

      case weight_numbers.size
      when 1 then average_weight = weight_numbers.first
      when 2 then average_weight = (weight_numbers.sum / 2.0).round
      else average_weight = nil
      end
      size =  case average_weight
      when 0...30 then "Small"
      when 30...65 then "Medium"
      when 65...80 then "Large"
      else "Extra Large"
      end
      breed.merge("size_category" => size)
    end
  end
end

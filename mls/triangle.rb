require "#{Rails.root}/lib/rets"

class TriangleMLS < RetsDataProcessor

  def jsession(response)
    regex = /\=(.*?);/
    jsession = response['set-cookie'][0]

    jsession.slice(regex, 1)
  end

  def parse(data)
    columns = data["RETS"]["COLUMNS"].split(/\t/)
    data = data["RETS"]["DATA"]

    data_hash = {}
    data_array = []

    data.each_with_index do |item, index|
      columns.each_with_index do |column, column_index|
        data_hash[column] = data[index].split(/\t/)[column_index]
      end

      data_array << data_hash
      data_hash = {}
    end

    data_array
  end

  # Loop through all data 2500 records at a time
  def pull_data(params, jesession_id, counter = 0)
    data = []
    while true
      params = params.sub! "offset=#{(counter * 2500) - 2500}", "offset=#{counter * 2500}" if counter > 0
      pull_data = self.search(jesession_id, params)
      data << self.parse(pull_data)
      count = data[counter].count
      counter += 1
      puts "Pulled #{count} items..."
      break if count < 2500
    end

    data
  end

  # Gets an array of listings, medias, etc with hashes inside the array
  # and updates or creates each fields in the database
  def create_or_update_items(data_array, db_params, model, unique_id, check_listing = false)
    data_array.each do |array|
      array.each do |hash|
        if check_listing
          listing = Listing.exists?(listing_id: hash['L_ListingID'])
          create_update(model, db_params, hash, unique_id) if listing
        else
          create_update(model, db_params, hash, unique_id)
        end
      end
    end
  end
  
  
  def create_update(model, db_params, hash, unique_id)
    create_or_update = model.find_or_create_by(unique_id.first[0] => hash[unique_id.first[1]])
    hash.each do |key, value|
      if !value.blank? && db_params[key.to_sym]
        create_or_update[db_params[key.to_sym]] = value
      end
    end
    create_or_update.save!
  end

end
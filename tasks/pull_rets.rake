require "#{Rails.root}/lib/mls/triangle"

# Credentials
URL = 'http://triangle.apps.retsiq.com/rets/'
USERNAME = 'Keenidx'
PASSWORD = 'iSTv14Gq'

namespace :pull_rets do

  task :triangle_data => :environment do

    residential_db_params = {
        L_ListOffice1: 'office_id',
        LO1_OrganizationName: 'office_name',
        L_ListingID: 'listing_id',
        L_DOM: 'days_on_market',
        LO1_PhoneNumber1: 'office_phone',
        L_ListAgent1: 'agent_id',
        LA1_UserFirstName: 'agent_first_name',
        LA1_UserLastName: 'agent_last_name',
        L_AddressNumber: 'street_number',
        L_AddressDirection: 'street_dir_prefix',
        L_AddressStreet: 'street_name',
        L_Address2: 'unit_number',
        L_City: 'city',
        L_State: 'state',
        L_Zip: 'postal_code',
        LMD_MP_Latitude: 'latitude',
        LMD_MP_Longitude: 'longitude',
        LM_Char10_9: 'county_area',
        LM_Char10_10: 'sub_area',
        L_Area: 'county',
        LM_char255_1: 'directions',
        L_DisplayId: 'mls_id',
        L_ListingDate: 'list_date',
        L_AskingPrice: 'list_price',
        LFD_Style_3: 'style',
        L_Remarks: 'public_remarks',
        LM_Char10_22: 'zoning',
        L_UpdateDate: 'modification_timestamp',
        L_Status: 'listing_status',
        LM_Int1_1: 'bedrooms',
        LM_Char25_10: 'master_bedroom_dimensions',
        LM_Char25_11: 'bedroom_2_dimensions',
        LM_Char25_12: 'bedroom_3_dimensions',
        LM_Char25_13: 'bedroom_4_dimensions',
        LM_Char25_14: 'bedroom_5_dimensions',
        LM_Char1_12: 'master_bed_1st_floor',
        LM_Int1_14: 'total_baths',
        LM_Int1_2: 'baths_full',
        LM_Int1_3: 'baths_half',
        LFD_BathFeatures_26: 'bath_features',
        LM_Char25_8: 'kitchen_room_dimensions',
        LM_Char25_5: 'dining_room_dimensions',
        LM_Char25_9: 'breakfast_room_dimensions',
        LM_Char25_4: 'living_room_dimensions',
        LM_Char25_6: 'family_room_dimensions',
        LM_Char25_16: 'bonus_room_dimensions',
        LM_Char10_27: 'office_room_dimensions',
        LM_Char25_3: 'entrance_hall_dimensions',
        LM_Char25_15: 'utility_room_dimensions',
        LM_Char10_7: 'subdivision',
        LM_Char10_8: 'neighborhood',
        LM_Int2_10: 'year_built',
        LFD_Heating_10: 'heating',
        LFD_FuelHeat_11: 'fuel_heat',
        LFD_WaterHeater_12: 'water_heater',
        LFD_AC_9: 'ac',
        LFD_InteriorFeatures_25: 'interior_features',
        LFD_ExteriorFeatures_28: 'exterior_features',
        LFD_ExteriorFinish_4: 'exterior_finish',
        LM_char10_56: 'waterfront_type',
        LFD_Roof_7: 'roof',
        L_PricePerSQFT: 'price_per_sqft',
        LM_Int2_5: 'sqft_living',
        LM_Int2_9: 'sqft_other_area',
        LM_Dec_1: 'approx_lot_sqft',
        LM_Char10_21: 'acres',
        L_Type_: 'list_type',
        LFD_Pool_29: 'private_pool',
        LM_Int1_7: 'garage',
        LM_Char25_20: 'garage_dimensions',
        LM_char10_42: 'garage_floor',
        LM_Char50_3: 'builder_name',
        LFD_Parking_16: 'parking',
        LM_Char10_14: 'elementary_school',
        LM_Char10_16: 'middle_school',
        LM_Char10_18: 'high_school',
        LM_Char1_17: 'hoa_required',
        LM_Dec_6: 'hoa_dues',
        LM_Char25_28: 'hoa_management',
        LFD_Flooring_8: 'flooring',
        LM_Char1_14: 'basement',
        LFD_Accessibility_31: 'accessibility',
        LFD_LotDescription_15: 'lot_description',
        LFD_FireplaceDescription_13: 'fireplace_description',
        LFD_WaterSewer_14: 'water_sewer',
        LFD_EquipmentAppliances_24: 'equipment_appliances',
        VT_VTourURL: 'virtual_tour_url',
    }

    media_db_params = {
        L_ListingID: 'listing_id',
        L_Status: 'status',
        MED_caption: 'caption',
        MED_description: 'description',
        MED_file_size: 'file_size',
        MED_listing_media_id: 'listing_media_id',
        MED_listing_media_type_id: 'listing_media_type_id',
        MED_media_url: 'media_url',
    }


    #example JSESSIONID=D9452B24C3B1DD3C1502E36A8582043B
    #sample call: curl --digest --user "Keenidx:iSTv14Gq" --header "RETS-Version: RETS/1.7.2" --cookie "JSESSIONID=641C5628A2C71910E2D6E9747AC51DF7" 'http://triangle.apps.retsiq.com/rets/Search?SearchType=Property&QueryType=DMQL2&Class=RE_1&Query=(L_Status="1_0"),(LM_Char10_9=001,003,004)&Count=0&Limit=5&Format=COMPACT-DECODED&Select=L_ListOffice1,LO1_OrganizationName,L_ListingID,L_DOM,LO1_PhoneNumber1,L_ListAgent1,LA1_UserFirstName,LA1_UserLastName,L_AddressNumber,L_AddressDirection,L_AddressStreet,L_Address2,L_City,L_State,L_Zip,LMD_MP_Latitude,LMD_MP_Longitude,LM_Char10_9,LM_Char10_10,L_Area,LM_char255_1,L_DisplayId,L_ListingDate,L_AskingPrice,LFD_Style_3,L_Remarks,LM_Char10_22,L_UpdateDate,L_Status,LM_Int1_1,LM_Char25_10,LM_Char25_11,LM_Char25_12,LM_Char25_13,LM_Char25_14,LM_Char1_12,LM_Int1_14,LM_Int1_2,LM_Int1_3,LFD_BathFeatures_26,LM_Char25_8,LM_Char25_5,LM_Char25_9,LM_Char25_4,LM_Char25_6,LM_Char25_16,LM_Char10_27,LM_Char25_3,LM_Char25_15,LM_Char10_7,LM_Char10_8,LM_Int2_10,LFD_Heating_10,LFD_FuelHeat_11,LFD_WaterHeater_12,LFD_AC_9,LFD_InteriorFeatures_25,LFD_ExteriorFeatures_28,LFD_ExteriorFinish_4,LM_char10_56,LFD_Roof_7,L_PricePerSQFT,LM_Int2_5,LM_Int2_9,LM_Dec_1,LM_Char10_21,L_Type_,LFD_Pool_29,LM_Int1_7,LM_Char25_20,LM_char10_42,LM_Char50_3,LFD_Parking_16,LM_Char10_14,LM_Char10_16,LM_Char10_18,LM_Char1_17,LM_Dec_6,LM_Char25_28,LFD_Flooring_8,LM_Char1_14,LFD_Accessibility_31,LFD_Parking_16,LFD_LotDescription_15,LFD_FireplaceDescription_13,LFD_WaterSewer_14,LFD_EquipmentAppliances_24,VT_VTourURL'

    # http://triangle.apps.retsiq.com/rets/Search?SearchType=Property&QueryType=DMQL2&Class=RE_1&Query=#{params}
    # search_params =  "Search?SearchType=Property&QueryType=DMQL2&Class=RE_1&Query=#{params}"
    residential_params = 'Search?SearchType=Property&QueryType=DMQL2&Class=RE_1&Query=(L_Status="1_0"),(LM_Char10_9=001,003,004)&Count=0&Limit=2500&offset=0&Format=COMPACT-DECODED&Select=L_ListOffice1,LO1_OrganizationName,L_ListingID,L_DOM,LO1_PhoneNumber1,L_ListAgent1,LA1_UserFirstName,LA1_UserLastName,L_AddressNumber,L_AddressDirection,L_AddressStreet,L_Address2,L_City,L_State,L_Zip,LMD_MP_Latitude,LMD_MP_Longitude,LM_Char10_9,LM_Char10_10,L_Area,LM_char255_1,L_DisplayId,L_ListingDate,L_AskingPrice,LFD_Style_3,L_Remarks,LM_Char10_22,L_UpdateDate,L_Status,LM_Int1_1,LM_Char25_10,LM_Char25_11,LM_Char25_12,LM_Char25_13,LM_Char25_14,LM_Char1_12,LM_Int1_14,LM_Int1_2,LM_Int1_3,LFD_BathFeatures_26,LM_Char25_8,LM_Char25_5,LM_Char25_9,LM_Char25_4,LM_Char25_6,LM_Char25_16,LM_Char10_27,LM_Char25_3,LM_Char25_15,LM_Char10_7,LM_Char10_8,LM_Int2_10,LFD_Heating_10,LFD_FuelHeat_11,LFD_WaterHeater_12,LFD_AC_9,LFD_InteriorFeatures_25,LFD_ExteriorFeatures_28,LFD_ExteriorFinish_4,LM_char10_56,LFD_Roof_7,L_PricePerSQFT,LM_Int2_5,LM_Int2_9,LM_Dec_1,LM_Char10_21,L_Type_,LFD_Pool_29,LM_Int1_7,LM_Char25_20,LM_char10_42,LM_Char50_3,LFD_Parking_16,LM_Char10_14,LM_Char10_16,LM_Char10_18,LM_Char1_17,LM_Dec_6,LM_Char25_28,LFD_Flooring_8,LM_Char1_14,LFD_Accessibility_31,LFD_Parking_16,LFD_LotDescription_15,LFD_FireplaceDescription_13,LFD_WaterSewer_14,LFD_EquipmentAppliances_24,VT_VTourURL'
    rental_params = 'Search?SearchType=Property&QueryType=DMQL2&Class=RT_6&Query=(L_Status="1_0"),(LM_Char10_9=001,003,004)&Count=0&Limit=2500&offset=0&Format=COMPACT-DECODED&Select=L_ListOffice1,LO1_OrganizationName,L_ListingID,L_DOM,LO1_PhoneNumber1,L_ListAgent1,LA1_UserFirstName,LA1_UserLastName,L_AddressNumber,L_AddressDirection,L_AddressStreet,L_Address2,L_City,L_State,L_Zip,LMD_MP_Latitude,LMD_MP_Longitude,LM_Char10_9,LM_Char10_10,L_Area,LM_char255_1,L_DisplayId,L_ListingDate,L_AskingPrice,LFD_Style_3,L_Remarks,LM_Char10_22,L_UpdateDate,L_Status,LM_Int1_1,LM_Char25_10,LM_Char25_11,LM_Char25_12,LM_Char25_13,LM_Char25_14,LM_Char1_12,LM_Int1_14,LM_Int1_2,LM_Int1_3,LFD_BathFeatures_26,LM_Char25_8,LM_Char25_5,LM_Char25_9,LM_Char25_4,LM_Char25_6,LM_Char25_16,LM_Char10_27,LM_Char25_3,LM_Char25_15,LM_Char10_7,LM_Char10_8,LM_Int2_10,LFD_Heating_10,LFD_FuelHeat_11,LFD_WaterHeater_12,LFD_AC_9,LFD_InteriorFeatures_25,LFD_ExteriorFeatures_28,LFD_ExteriorFinish_4,LM_char10_56,LFD_Roof_7,L_PricePerSQFT,LM_Int2_5,LM_Int2_9,LM_Dec_1,LM_Char10_21,L_Type_,LFD_Pool_29,LM_Int1_7,LM_Char25_20,LM_char10_42,LM_Char50_3,LFD_Parking_16,LM_Char10_14,LM_Char10_16,LM_Char10_18,LM_Char1_17,LM_Dec_6,LM_Char25_28,LFD_Flooring_8,LM_Char1_14,LFD_Accessibility_31,LFD_Parking_16,LFD_LotDescription_15,LFD_FireplaceDescription_13,LFD_WaterSewer_14,LFD_EquipmentAppliances_24,VT_VTourURL'
    media_residential_params = 'Search?SearchType=Media&QueryType=DMQL2&Class=RE_1&Query=(L_Status="1_0")&Count=0&Limit=2500&offset=0&Format=COMPACT-DECODED'
    media_rental_params = 'Search?SearchType=Media&QueryType=DMQL2&Class=RT_6&Query=(L_Status="1_0")&Count=0&Limit=2500&offset=0&Format=COMPACT-DECODED'

    ############
    # I don't know how to exclude the areas we dont want for media urls
    ############

    # Login and get jsession id
    triangle = TriangleMLS.new(URL, USERNAME, PASSWORD)
    login_response = triangle.login
    jesession_id = triangle.jsession(login_response)
    
    puts "Pulling residential listings"

    #RESIDENTIAL
    residential_listings_array = triangle.pull_data(residential_params, jesession_id)

    puts "Creating or updating local db"
    triangle.create_or_update_items(residential_listings_array,
                                    residential_db_params,
                                    Listing,
                                    listing_id: 'L_ListingID')
    puts "Pulling rental listings"
    
    # RENTAL
    rental_listings_array = triangle.pull_data(rental_params, jesession_id)

    puts "Creating or updating local db"
    triangle.create_or_update_items(rental_listings_array,
                                    residential_db_params,
                                    Listing,
                                    listing_id: 'L_ListingID')

    puts "Pulling media for residential"
    
    #MEDIA RESIDENTIAL
    media_residential_array = triangle.pull_data(media_residential_params, jesession_id)

    puts "Creating or updating local db"
    triangle.create_or_update_items(media_residential_array,
                                    media_db_params,
                                    Media,
                                    { listing_media_id: 'MED_listing_media_id' },
                                    true)

    puts "Pulling media for rentals"

    #MEDIA RENTAL
    media_rental_array = triangle.pull_data(media_rental_params, jesession_id)
    
    puts "Creating or updating local db"
    triangle.create_or_update_items(media_residential_array,
                                    media_db_params,
                                    Media,
                                    { listing_media_id: 'MED_listing_media_id' },
                                    true)




    # binding.pry Create a rails console to help with debugging
    # binding.pry
  end
end
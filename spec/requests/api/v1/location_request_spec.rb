require 'rails_helper'

describe 'Location' do
  it 'returns the user location' do
    record = create(:location, location: '80110')

    get "/api/v1/location/#{record.user_id}"

    expect(response).to be_successful
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed[:data]).to have_key(:id)
    expect(parsed[:data]).to have_key(:type)
    expect(parsed[:data]).to have_key(:attributes)

    expect(parsed[:data][:id]).to be_a String

    expect(parsed[:data][:type]).to be_a String
    expect(parsed[:data][:type]).to eq('location')

    expect(parsed[:data][:attributes]).to have_key(:user_id)
    expect(parsed[:data][:attributes]).to have_key(:location)

    expect(parsed[:data][:attributes][:user_id]).to be_an Integer
    expect(parsed[:data][:attributes][:user_id]).to eq(record.user_id)

    expect(parsed[:data][:attributes][:location]).to be_a String
    expect(parsed[:data][:attributes][:location]).to eq(record.location)
  end

  it 'if a user location is searched for but record does not exist' do
    get '/api/v1/location/13'

    expect(response).to be_successful
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed).to have_key(:data)
    expect(parsed[:data]).to eq(nil)
  end

  it 'creates a location entry' do
    user_id = 23
    location = '80110'

    post "/api/v1/#{location}/#{user_id}"
    created_location = Location.last

    expect(response).to be_successful
    new_record = JSON.parse(response.body, symbolize_names: true)

    expect(new_record[:data]).to have_key(:id)
    expect(new_record[:data][:id]).to be_a String
    expect(new_record[:data][:id]).to eq(created_location.id.to_s)

    expect(new_record[:data]).to have_key(:type)
    expect(new_record[:data][:type]).to be_a String
    expect(new_record[:data][:type]).to eq('location')

    expect(new_record[:data]).to have_key(:attributes)
    expect(new_record[:data][:attributes]).to be_a Hash

    expect(new_record[:data][:attributes]).to have_key(:user_id)
    expect(new_record[:data][:attributes][:user_id]).to be_an Integer
    expect(new_record[:data][:attributes][:user_id]).to eq(user_id)

    expect(new_record[:data][:attributes]).to have_key(:location)
    expect(new_record[:data][:attributes][:location]).to be_a String
    expect(new_record[:data][:attributes][:location]).to eq(location)
  end

  it 'updates a location entry' do
    record = create(:location, location: '80110', user_id: 13)

    patch "/api/v1/90210/#{record.user_id}"

    expect(response).to be_successful
    updated_record = JSON.parse(response.body, symbolize_names: true)

    expect(updated_record[:data]).to have_key(:id)
    expect(updated_record[:data][:id]).to be_a String
    expect(updated_record[:data][:id]).to eq(record.id.to_s)

    expect(updated_record[:data]).to have_key(:type)
    expect(updated_record[:data][:type]).to be_a String
    expect(updated_record[:data][:type]).to eq('location')

    expect(updated_record[:data]).to have_key(:attributes)
    expect(updated_record[:data][:attributes]).to be_a Hash

    expect(updated_record[:data][:attributes]).to have_key(:user_id)
    expect(updated_record[:data][:attributes][:user_id]).to be_an Integer
    expect(updated_record[:data][:attributes][:user_id]).to eq(record.user_id)

    expect(updated_record[:data][:attributes]).to have_key(:location)
    expect(updated_record[:data][:attributes][:location]).to be_a String
    expect(updated_record[:data][:attributes][:location]).to eq('90210')

    expect(Location.where(user_id: record.user_id).count).to eq(1)
    expect(Location.where(user_id: record.user_id).first.location).to eq('90210')
    expect(Location.where(user_id: record.user_id).first.location).to_not eq('80110')
  end

  it 'can delete location' do
    location = '76953'
    user_id = 5
    post "/api/v1/#{location}/#{user_id}"

    last_location = Location.last
    last_location_id = last_location.id

    expect(Location.find_by(id: last_location_id)).to be_truthy

    delete "/api/v1/location/#{user_id}"
    expect(Location.find_by(id: last_location_id)).to be(nil)
  end
end

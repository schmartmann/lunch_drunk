require 'rails_helper'

RSpec.describe TimePeriodsController do
  let( :time_period ) { FactoryBot.create( :time_period ) }

  describe 'GET #index' do
    context 'with valid attributes' do
      it 'renders 200' do
        get :index
        expect( response.response_code ).to eq 200
      end
    end
  end
end

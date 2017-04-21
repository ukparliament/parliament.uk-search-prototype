require 'spec_helper'

RSpec.describe Search, vcr: true do
  describe 'GET /' do
    before(:each) do
      get '/'
    end

    it 'should have a response with http status ok (200)' do
      expect(last_response).to be_ok
    end
  end

  describe 'GET /search' do
    before(:each) do
      get '/search'
    end

    it 'should redirect to /search/' do
      expect(last_response).to be_redirect   # This works, but I want it to be more specific
      follow_redirect!
      expect(last_request.url).to eq('http://example.org/search/')
    end
  end

  describe 'GET /results' do
    context 'a valid search' do
      before(:each) do
        get '/results', { q: 'banana' }
      end

      it 'should have a response with http status ok (200)' do
        expect(last_response).to be_ok
      end

      it 'should contain the query parameter in the response body' do
        expect(last_response.body).to include('banana')
      end

      it 'should return the number of results' do
        expect(last_response.body).to include('About 18600 results')
      end

      it 'should return title, link and summary for each entry' do
        expect(last_response.body).to include('Trade dispute between the EU and the US over <b>bananas</b>')
        expect(last_response.body).to include('http://researchbriefings.files.parliament.uk/documents/RP99-28/RP99-28.pdf')
        expect(last_response.body).to include('Mar 12, 1999 <b>...</b> describes why the EU import regime for <b>bananas</b> arose, ...')
      end
    end

    context 'an invalid search' do
      before(:each) do
        get '/results', { q: 'fdsfsd' }
      end

      it 'should have a response with http status ok (200)' do
        expect(last_response).to be_ok
      end

      it 'should contain no results' do
        expect(last_response.body).to include("There were no results for 'fdsfsd'.")
      end
    end

    context 'search for a non-ascii character' do
      it 'should have a response with http status ok (200)' do
        get '/results', { q: 'Ü' }
        expect(last_response).to be_ok
      end
    end
  end
end

require 'spec_helper'

RSpec.describe PaginationHelper do
  subject do
    Class.new { include PaginationHelper  #set instance vars here }
  end

  context '#current_page' do
    it 'calculates the current page' do
      expect(subject.current_page).to eq(4)
    end
  end
end
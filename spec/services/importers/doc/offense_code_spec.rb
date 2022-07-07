require 'rails_helper'

RSpec.describe Importers::Doc::OffenseCode do
  describe '#perform' do
    it 'imports the data' do
      
     offense= create(:doc_offense_code, statute_code:300,description:'TEST',is_violent:true)

     

     data = allow(Importers::Doc::OffenseCode).to receive(:perform).and_return(offense)
     binding.pry
      
      expect()
      
    end
  end
end

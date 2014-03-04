require 'spec_helper'

describe Flatrack::AssetExtensions do

  subject(:instance){ double.extend described_class }

  describe '#asset_path' do
    it 'should be a path to the asset' do
      expect(instance.asset_path :foo).to eq '/assets/foo'
    end
  end

end
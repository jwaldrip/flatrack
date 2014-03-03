require 'spec_helper'

describe Flatrack::CLI do
  extend FileUtils
  include SiteHelper

  it 'should function properly' do
    in_temp_sites do
      sha = SecureRandom.hex
      Flatrack::CLI.start(['new', sha, '--verbose', 'false'])
      cleanup(sha)
    end
  end

end
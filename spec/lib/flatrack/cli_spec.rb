require 'spec_helper'

describe Flatrack::CLI do
  extend FileUtils
  include SiteHelper

  describe '#new' do
    it 'should create a new site' do
      in_temp_sites do
        sha = SecureRandom.hex
        Flatrack::CLI.start(['new', sha, '--verbose', 'false'])
        expect(File.directory? sha).to be true
        cleanup(sha)
      end
    end
  end

  describe '#start' do
    it 'should start the rack server' do
      expect do
        site do
          thread  = Thread.new do
            Flatrack::CLI.start(['start', '--verbose', 'false'])
          end
          retries = 0
          begin
            Net::HTTP.get URI.parse 'http://localhost:5959'
            thread.kill
          rescue Errno::ECONNREFUSED => error
            retries += 1
            sleep 0.1 and retry unless retries > 100
            raise error
          end
        end
      end.to_not raise_error
    end

    it 'should start a server on a custom port' do
      expect do
        site do
          thread  = Thread.new do
            Flatrack::CLI.start(['start', '--port', '8282', '--verbose', 'false'])
          end
          retries = 0
          begin
            Net::HTTP.get URI.parse 'http://localhost:8282'
            thread.kill
          rescue Errno::ECONNREFUSED => error
            retries += 1
            sleep 0.1 and retry unless retries > 100
            raise error
          end
        end
      end.to_not raise_error
    end
  end

end
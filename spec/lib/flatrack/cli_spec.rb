require 'spec_helper'

describe Flatrack::CLI do
  extend FileUtils
  include Flatrack::SiteHelper

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
            Flatrack::CLI.start(%w(start --verbose false))
          end
          retries = 0
          begin
            Net::HTTP.get URI.parse 'http://localhost:5959'
            thread.kill
          rescue Errno::ECONNREFUSED => error
            retries += 1
            sleep 0.1
            retry unless retries > 100
            raise error
          end
        end
      end.to_not raise_error
    end

    it 'should start a server on a custom port' do
      expect do
        site do
          thread  = Thread.new do
            Flatrack::CLI.start(%w(start --port 8282 --verbose false))
          end
          retries = 0
          begin
            Net::HTTP.get URI.parse 'http://localhost:8282'
            thread.kill
          rescue Errno::ECONNREFUSED => error
            retries += 1
            sleep 0.1
            retry unless retries > 100
            raise error
          end
        end
      end.to_not raise_error
    end

    context 'without a boot.rb' do
      it 'should start the rack server' do
        expect do
          site do
            FileUtils.rm 'boot.rb'
            thread  = Thread.new do
              Flatrack::CLI.start(%w(start --verbose false))
            end
            retries = 0
            begin
              Net::HTTP.get URI.parse 'http://localhost:5959'
              thread.kill
            rescue Errno::ECONNREFUSED => error
              retries += 1
              sleep 0.1
              retry unless retries > 100
              raise error
            end
          end
        end.to_not raise_error
      end

      it 'should start a server on a custom port' do
        expect do
          site do
            FileUtils.rm 'boot.rb'
            thread  = Thread.new do
              Flatrack::CLI.start(%w(start --port 8282 --verbose false))
            end
            retries = 0
            begin
              Net::HTTP.get URI.parse 'http://localhost:8282'
              thread.kill
            rescue Errno::ECONNREFUSED => error
              retries += 1
              sleep 0.1
              retry unless retries > 100
              raise error
            end
          end
        end.to_not raise_error
      end
    end
  end

  describe '--version' do
    it 'should display the flatrack version' do
      expect(STDOUT).to receive(:puts).with 'Flatrack ' + Flatrack::VERSION
      Flatrack::CLI.start(%w(--version))
    end
  end

end

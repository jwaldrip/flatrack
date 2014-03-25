require 'spec_helper'

describe Flatrack::Site do
  let(:mock_app) { ->(env) { [200, {}, ['ok']] } }
  let(:mock_env) { Rack::MockRequest.env_for('example.org', {}) }

  it 'should be a rack app' do
    expect(described_class).to respond_to :call
  end

  it 'should include all the proper middleware' do
    allow(described_class).to receive(:site).and_return mock_app

    middlewares = 2.times.map do
      Class.new do
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        end
      end
    end

    Flatrack.config do |site|
      middlewares.each do |middleware|
        expect_any_instance_of(middleware)
        .to receive(:call)
            .with(mock_env)
            .and_call_original
        site.use middleware
      end
    end

    Flatrack::Site.call(mock_env)
  end

  it 'should formulate a proper response' do
    expect(Flatrack::Request).to receive(:new).and_call_original
    expect_any_instance_of(Flatrack::Request).to receive(:response)
    Flatrack::Site.call(mock_env)
  end
end

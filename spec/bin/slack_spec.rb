# frozen_string_literal: true
describe 'Slack CLI' do
  let(:slack) { File.expand_path(File.join(__FILE__, '../../../bin/slack')) }

  before do
    @token = ENV.delete('SLACK_API_TOKEN')
  end

  after do
    ENV['SLACK_API_TOKEN'] = @token if @token
  end

  describe '#help' do
    it 'displays help' do
      help = `"#{slack}" help`
      expect(help).to include 'slack - Slack client.'
    end
  end
end

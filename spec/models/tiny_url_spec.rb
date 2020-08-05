require 'rails_helper'

RSpec.describe TinyUrl, type: :model do
  describe 'constants and validations' do
    it { expect(subject).to validate_presence_of(:original_url) }
    it { expect(subject).to_not validate_presence_of(:shortened_url) }
    it { expect(TinyUrl::TINY_URL_LENGTH).to eq(8) }
  end

  describe 'creation' do
    let(:new_shortened_url) { TinyUrl.new(original_url: my_url) }

    context 'invalid url' do
      describe 'random string' do
        let(:my_url) { 'adsfasdf;ads' }

        it 'should return an error' do
          new_shortened_url.save
          expect(new_shortened_url.errors.messages[:original_url]).to eq(["Invalid url"])
        end
      end

      describe 'email' do
        let(:my_url) { 'www.myexamplesite@mydomain.com' }

        it 'should return an error' do
          new_shortened_url.save
          expect(new_shortened_url.errors.messages[:original_url]).to eq(["Invalid url"])
        end
      end

      describe 'capital letters' do
        let(:my_url) { 'www.myexamplesite@mydomain.com'.upcase }

        it 'should return an error' do
          new_shortened_url.save
          expect(new_shortened_url.errors.messages[:original_url]).to eq(["Invalid url"])
        end
      end
    end

    context 'valid url' do
      let(:my_url) { 'www.myexamplesite.mydomain.com' }

      it 'should return an error' do
        new_shortened_url.save
        expect(new_shortened_url.errors.messages.empty?).to eq(true)
      end
    end
  end
end

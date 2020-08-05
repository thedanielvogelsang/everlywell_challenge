require 'rails_helper'

RSpec.describe TinyUrl, type: :model do
  describe 'constants and validations' do
    it { expect(subject).to validate_presence_of(:original_url) }
    it { expect(subject).to_not validate_presence_of(:shortened_url) }
    it { expect(TinyUrl::TINY_URL_LENGTH).to eq(8) }
  end

  describe 'creation' do
    let(:new_shortened_url) { TinyUrl.new(original_url: my_url) }
    let(:new_url_record) { TinyUrl.create(original_url: my_url) }

    describe 'url validations' do
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

    describe 'callbacks' do
      let(:my_url) { supa_hot_fire }

      context 'before create callbacks' do
        let(:supa_hot_fire) { 'https://www.youtube.com/watch?v=Iu90z9Akxgk&t=201s'}

        it 'creates a shortened_url from the original_url' do
          expect(new_url_record.shortened_url.blank?).to eq(false)
        end

        it 'creates a sanitized_url from the original_url' do
          expect(new_url_record.sanitized_url.blank?).to eq(false)
        end
      end
    end
  end
end

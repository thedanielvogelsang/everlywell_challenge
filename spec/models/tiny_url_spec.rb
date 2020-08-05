require 'rails_helper'

RSpec.describe TinyUrl, type: :model do
  describe 'constants and validations' do
    it { expect(subject).to validate_presence_of(:original_url) }
    it { expect(subject).to_not validate_presence_of(:shortened_url) }
    it { expect(TinyUrl::TINY_URL_LENGTH).to eq(7) }
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

    describe 'shortened_url' do
      let!(:new_url_record) { TinyUrl.create(original_url: not_my_url) }
      let!(:other_shortened_url) { TinyUrl.new(original_url: prince_gently_weeps, shortened_url: new_url_record.shortened_url)}

      let(:my_url) { prince_gently_weeps }
      let(:not_my_url) { prince_gently_weeps + 'ABCDEF'}
      let(:prince_gently_weeps) { 'https://www.youtube.com/watch?v=6SFNW5F8K9Y' }

      context 'upon creation' do
        let(:shortened_url_length) { 'http://'.length + TinyUrl::TINY_URL_LENGTH }

        it 'creates a shortened_url to the given constant length' do
          expect(new_url_record.shortened_url.length).to eq(shortened_url_length)
        end
      end
    end

    describe 'sanitized_url' do
      let(:my_url) { prince_gently_weeps }
      context 'upon creation' do
        let(:prince_gently_weeps) { 'https://www.youtube.com/watch?v=6SFNW5F8K9Y' }
        let(:sanitized_url_format) { Regexp.new(/^(http\:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/) }

        it 'creates a sanitized_url that matches desired format' do
          expect(sanitized_url_format.match(new_url_record.sanitized_url)).to be_truthy
        end
      end
    end
  end
end

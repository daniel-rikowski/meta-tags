require 'spec_helper'

describe MetaTags::ViewHelper do
  subject { ActionView::Base.new }

  context 'returning values' do
    it 'should return title' do
      expect(subject.title('some-title')).to eq('some-title')
    end

    it 'should return headline if specified' do
      expect(subject.title('some-title', 'some-headline')).to eq('some-headline')
    end

    it 'should return title' do
      expect(subject.title('some-title')).to eq('some-title')
      expect(subject.title).to eq('some-title')
    end

    it 'should return description' do
      expect(subject.description('some-description')).to eq('some-description')
    end

    it 'should return keywords' do
      expect(subject.keywords('some-keywords')).to eq('some-keywords')
    end

    it 'should return noindex' do
      expect(subject.noindex('some-noindex')).to eq('some-noindex')
    end

    it 'should return nofollow' do
      expect(subject.noindex('some-nofollow')).to eq('some-nofollow')
    end
  end

  context 'while handling string meta tag names' do
    it 'should work with common parameters' do
      subject.display_meta_tags('site' => 'someSite', 'title' => 'someTitle').tap do |meta|
        expect(meta).to eq('<title>someSite | someTitle</title>')
      end
    end

    it 'should work with open graph parameters' do
      subject.set_meta_tags('og' => {
        'title'       => 'facebook title',
        'description' => 'facebook description'
      })
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "facebook title", property: "og:title" })
        expect(meta).to have_tag('meta', with: { content: "facebook description", property: "og:description" })
      end
    end

    it 'should work with app links parameters' do
      subject.set_meta_tags('al' => {
        'ios' => {
          'url' => 'applinks://docs',
          'app_store_id' => 12345,
          'app_name' => 'App Links'
        }
      })
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "applinks://docs", property: "al:ios:url" })
        expect(meta).to have_tag('meta', with: { content: "12345", property: "al:ios:app_store_id" })
        expect(meta).to have_tag('meta', with: { content: "App Links", property: "al:ios:app_name" })
      end
    end

    it 'should work with facebook parameters' do
      subject.set_meta_tags('fb' => {
        app_id: 12345,
        admins: "12345,23456"
      })
      subject.display_meta_tags(site: 'someSite').tap do |meta|
        expect(meta).to have_tag('meta', with: { content: "12345", property: "fb:app_id" })
        expect(meta).to have_tag('meta', with: { content: "12345,23456", property: "fb:admins" })
      end
    end
  end

  it_behaves_like '.set_meta_tags'
end

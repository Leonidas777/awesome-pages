require 'rails_helper'

RSpec.describe Page, type: :model do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

  it { should allow_value('Cool_page').for(:name) }
  it { should_not allow_value('Cool page!').for(:name) }

  describe 'uniqueness' do
    subject { build :page }

    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:slug) }
  end

  describe 'generate_slug' do
    let(:page) { build :page, name: 'New_page' }
    
    subject { page.save }

    it 'creates a new page' do
      subject

      expect(page.reload.valid?).to be_truthy
      expect(page.reload.slug).to eq 'new_page'
    end

    context 'when name is invalid' do
      let(:page) { build :page, name: 'new_page!' }

      it 'fails while creating a new page' do
        subject
        expect(page.valid?).to be_falsy
      end
    end
  end
end

require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe '#index' do
    subject { get :index }

    context 'when the root page exists' do
      let!(:root_page) { create :page }

      it 'returs the root page' do
        subject
        expect(assigns :page).to eq root_page
      end
    end

    it { is_expected.to redirect_to add_root_page_path }
  end

  describe '#new' do
    subject { get :new, id: 'root' }

    context 'when the root page exists' do
      let!(:root_page) { create :page, name: 'root' }

      it 'returns a new Page object with parent' do
        subject
        expect(assigns :page).to be_a_new Page
        expect(assigns(:page).parent).to eq root_page
      end
    end

    it 'returns a new Page object without parent' do
      subject

      expect(assigns :page).to be_a_new Page
      expect(assigns(:page).parent).to eq nil
    end
  end

  describe '#create' do    
    let(:params) { { page: { parent_slug: nil,
                             name:        'happiness',
                             title:       'What is happiness for?',
                             description: 'Some text.' } } }

    subject { post :create, params }

    it 'creates the parent page' do
      expect { subject }.to change { Page.count }.by(1)
      expect(flash[:notice]).to eq 'Page has been successfully created.'
    end

    it { is_expected.to redirect_to nested_page_path(Page.first) }

    context 'when the root page exists' do
      let!(:root_page) { create :page, name: 'root' }

      let(:params) { { page: { parent_slug: 'root',
                               name:        'happiness',
                               title:       'What is happiness for?',
                               description: 'Some text.' } } }

      it 'creates a new page' do
        expect { subject }.to change { Page.count }.by(1)
        expect(Page.last.parent_id).to eq root_page.id
        expect(flash[:notice]).to eq 'Page has been successfully created.'
      end

      it { is_expected.to redirect_to nested_page_path(Page.last) }

      context 'when parent has not been received' do
        let(:params) { { page: { parent_slug: nil,
                                 name:        'happiness',
                                 title:       'What is happiness for?',
                                 description: 'Some text.' } } }

        it { is_expected.to redirect_to root_path }

        it 'fails creating a new page' do
          expect { subject }.to change { Page.count }.by(0)
          expect(flash[:error]).to eq 'Parent for page has not been received.'
        end
      end
    end
  end

  describe '#edit' do
    let!(:root_page) { create :page_with_children, name: 'root' }
    let(:child_page) { create :page, name: 'new_cool_page' }

    before do
      child_page.parent_id = root_page.id
      child_page.save!
    end

    subject { get :edit, id: 'root/new_cool_page' }

    it 'returns a page object' do
      subject
      expect(assigns(:page)).to eq child_page
    end
    
    context 'when slug received is not correct' do
      subject { get :edit, id: 'root/fake_page' }

      it 'fails due to cannot find a page' do
        subject
        expect(flash[:error]).to eq 'Page has not been found.'
      end

      it { is_expected.to redirect_to root_path }
    end
  end

  describe '#update' do
    let!(:page) { create :page, name:        'luck', 
                                title:       'Good luck', 
                                description: 'Good luck goes after you.' }

    let(:params) { { id: 'luck', page: { name:        'new_name',
                                         title:       'New title',
                                         description: 'New discription.' } } }

    subject { put :update, params }

    it 'updates the page' do
      subject

      expect(flash[:notice]).to eq 'Page has been updated.'
      expect(page.reload).to have_attributes({ name:        'new_name',
                                               title:       'New title',
                                               description: 'New discription.' })
    end

    it { is_expected.to redirect_to nested_page_path(page.reload) }
  end

  describe '#destroy' do
    let!(:root_page) { create :page_with_children, name: 'root' }
    let(:child_page) { root_page.children.first }

    subject { delete :destroy, id: "root/#{child_page.slug}" }

    it 'deletes the page' do
      expect { subject }.to change { Page.count }.by(-1)
      expect(flash[:notice]).to  eq 'Page has been deleted.'
    end

    it { is_expected.to redirect_to root_path }
  end
end

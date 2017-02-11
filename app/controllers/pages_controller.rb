class PagesController < ApplicationController
  before_filter :ensure_root_page_exists, only: [:index]
  before_filter :load_root_page, only: [:index]
  before_filter :load_resource, except: [:index, :create]
  before_filter :load_parent, only: [:create]

  def index
  end

  def show
  end

  def new
    parent = @page
    @page = Page.new
    @page.parent = parent
  end

  def create
    @page = Page.new(params[:page])
    @page.parent = @parent

    if @page.save
      redirect_to @page, notice: 'Page has been successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if page.update(params[:page])
      redirect_to @page, notice: 'Page has been successfully updated.'
    else
      render :edit
    end
  end  

  def destroy
    @page.destroy
    redirect_to pages_path
  end

  private

  def ensure_root_page_exists
    redirect_to new_page_path unless first_page.present?
  end

  def load_resource
    @page = page_by_slug!(params[:id])
  end

  def load_parent
    @parent = page_by_slug!(params[:page][:parent_id])
  end

  def page_by_slug!(slug)
    Page.find_by_slug!(slug_out_of(slug))
  end

  def load_root_page
    @page ||= first_page.present? ? first_page.root : nil
  end

  def first_page
    @first_page ||= Page.first
  end  

  def slug_out_of(url)    
    sliced_url = url.split('/') - ['add', 'edit']
    sliced_url.last
  end
end

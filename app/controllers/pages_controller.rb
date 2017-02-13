class PagesController < ApplicationController
  include PagesHelper

  before_filter :ensure_root_page_exists, only:   [:index]
  before_filter :ensure_to_add_root_page, only:   [:new]
  before_filter :load_root_page,          only:   [:index]
  before_filter :load_resource,           except: [:index, :create]
  before_filter :load_parent,             only:   [:create], if: ->{ first_page.present? }

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
    @page.parent_id = @parent.present? ? @parent.id : nil

    if @page.save
      redirect_to nested_page_path(@page), notice: I18n.t('pages.create')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update_attributes(params[:page])
      redirect_to nested_page_path(@page), notice: I18n.t('pages.update')
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to root_path, notice: I18n.t('pages.delete')
  end

  private

  def ensure_root_page_exists
    redirect_to add_root_page_path unless first_page.present?
  end

  def ensure_to_add_root_page
    if params[:id].nil? && first_page.present?
      redirect_to root_path
    end
  end

  def load_resource
    return unless first_page.present?

    @page = page_by_slug(params[:id])
    return @page if @page.present?

    redirect_to root_path, flash: { error: I18n.t('errors.pages.not_found') }
  end

  def load_parent
    @parent = page_by_slug(params[:page][:parent_slug])

    return @parent if @parent.present?

    redirect_to root_path, flash: { error: I18n.t('errors.pages.without_parent') }
  end

  def load_root_page
    @page ||= first_page.present? ? first_page.root : nil
  end

  def first_page
    @first_page ||= Page.first
  end

  def page_by_slug(slug)
    Page.find_by_slug(slug_out_of(slug))
  end

  def slug_out_of(url)
    return nil if url.nil?

    sliced_url = url.split('/') - ['add', 'edit']
    sliced_url.last
  end
end

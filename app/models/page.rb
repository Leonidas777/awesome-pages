class Page < ActiveRecord::Base
  has_ancestry orphan_strategy: :destroy

  attr_accessible :name, :title, :description

  RUSSIAN_SYMBOLS = 'А-яЁё'

  validates :name, :slug, uniqueness: true, presence: true  
  validates_format_of :name, with: /\A[a-zA-Z0-9_#{RUSSIAN_SYMBOLS}]+\z/

  before_validation :generate_slug

  def to_param
    slug
  end

  def generate_slug
    self.slug ||= name.parameterize
  end  
end


class Page < ActiveRecord::Base
  include Russian

  attr_accessible :name, :title, :description

  has_ancestry orphan_strategy: :destroy

  RUSSIAN_SYMBOLS = 'А-яЁё'

  before_validation :generate_slug

  validates :name, :slug, uniqueness: true, presence: true
  validates_format_of :name, with: /\A[a-zA-Z0-9_#{RUSSIAN_SYMBOLS}]+\z/

  def to_param
    slug
  end

  def generate_slug
    return if name.blank?

    translited_name = Russian::transliterate(name)
    self.slug = translited_name.parameterize
  end
end

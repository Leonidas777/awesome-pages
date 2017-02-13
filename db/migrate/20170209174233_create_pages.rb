class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :name, null: false, uniq: true
      t.string  :title
      t.string  :description
      t.string  :ancestry
      t.string  :slug, null: false, uniq: true

      t.timestamps
    end

    add_index :pages, :ancestry
    add_index :pages, :slug
  end
end

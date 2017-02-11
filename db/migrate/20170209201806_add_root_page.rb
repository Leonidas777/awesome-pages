class AddRootPage < ActiveRecord::Migration
  def up
    Page.create!(name: 'root')
  end

  def down
    Page.find_by_name('root').destroy
  end
end

class CreateTiks < ActiveRecord::Migration
  def change
    create_table :tiks do |t|
      t.integer :num
      t.string :name
    end
  end
end

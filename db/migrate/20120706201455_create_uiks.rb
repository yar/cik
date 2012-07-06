class CreateUiks < ActiveRecord::Migration
  def change
    create_table :uiks do |t|
      t.integer :num
      t.integer :tik_id

      t.timestamps
    end
  end
end

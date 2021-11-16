class CreateFoobars < ActiveRecord::Migration[7.0]
  def change
    create_table :foobars do |t|
      t.text :my_redux

      t.timestamps
    end
  end
end

class CreateAnotherFooBars < ActiveRecord::Migration[7.0]
  def change
    create_table :another_foo_bars do |t|
      t.text :another_redux_store

      t.timestamps
    end
  end
end

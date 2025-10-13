class CreateDogs < ActiveRecord::Migration[8.0]
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :breed
      t.integer :age
      t.string :weight
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

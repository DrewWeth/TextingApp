class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sid
      t.string :body
      t.string :to
      t.string :from
      t.datetime :created
      t.boolean :response
      t.string :res_text

      t.timestamps
    end
  end
end

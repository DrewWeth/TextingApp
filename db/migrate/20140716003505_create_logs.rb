class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :last_serve

      t.timestamps
    end
  end
end

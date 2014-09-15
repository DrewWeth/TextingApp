class CreateUtilities < ActiveRecord::Migration
  def change
    create_table :utilities do |t|
      t.integer :general_counts, :default => 0
      t.integer :specific_a_counts, :default => 0
      t.integer :specific_b_counts, :default => 0

      t.timestamps
    end
  end
end

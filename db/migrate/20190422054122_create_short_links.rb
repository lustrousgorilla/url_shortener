# frozen_string_literal: true

class CreateShortLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :short_links do |t|
      t.string :long_url, null: false
      t.string :short_url, null: false
      t.bigint :user_id, null: false

      t.timestamps

      t.index :short_url, unique: true
      t.index %i[user_id long_url], unique: true
    end
  end
end

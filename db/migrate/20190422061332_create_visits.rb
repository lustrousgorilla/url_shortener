# frozen_string_literal: true

class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.belongs_to :short_link, foreign_key: { on_delete: :cascade }, null: false
      t.string :referrer, null: false
      t.string :user_agent, null: false

      t.timestamps
    end

    change_table :short_links do |t|
      t.integer :visits_count, default: 0, null: false
    end
  end
end

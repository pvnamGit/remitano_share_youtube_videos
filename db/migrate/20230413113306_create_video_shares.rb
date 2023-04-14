class CreateVideoShares < ActiveRecord::Migration[6.0]
  def change
    create_table :video_shares do |t|
      t.string :title
      t.text :description
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

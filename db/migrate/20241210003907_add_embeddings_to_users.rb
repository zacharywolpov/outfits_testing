class AddEmbeddingsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :closet_embedding, :json
    add_column :users, :outfits_history_embedding, :json
  end
end

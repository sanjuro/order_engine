class AddImages < ActiveRecord::Migration

  def self.up
    create_table :assets do |t|
      t.references :viewable,               :polymorphic => true
      t.integer    :attachment_width
      t.integer    :attachment_height
      t.integer    :attachment_file_size
      t.integer    :position
      t.string     :attachment_content_type
      t.string     :attachment_file_name
      t.string     :type,                   :limit => 75
      t.datetime   :attachment_updated_at
      t.text       :alt
    end

    add_index :assets, [:viewable_id],          :name => 'index_assets_on_viewable_id'
    add_index :assets, [:viewable_type, :type], :name => 'index_assets_on_viewable_type_and_type'
  end

  def self.down
      
    end
end

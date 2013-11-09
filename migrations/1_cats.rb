Sequel.migration do
  change do
    create_table :cats do
      primary_key :id
      column :name, String
      column :chip_id, String, null: false, unique: true
      column :owner_name, String
    end
  end
end

Sequel.migration do
  change do
    create_table :people do
      primary_key :id
      column :name, String
    end
  end
end

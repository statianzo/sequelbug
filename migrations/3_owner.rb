Sequel.migration do
  change do
    alter_table :cats do
      add_foreign_key [:owner_name], :people, :key => :name
    end
  end
end

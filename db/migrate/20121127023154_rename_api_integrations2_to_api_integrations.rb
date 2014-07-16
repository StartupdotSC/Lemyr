class RenameApiIntegrations2ToApiIntegrations < ActiveRecord::Migration
  def up
    rename_table :api_integrations2, :api_integrations if self.table_exists? :api_integrations2
  end

  def down
  end
end

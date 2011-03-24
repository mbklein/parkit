Class.new(Sequel::Migration) do
  def up
    create_table(:urls) do
      primary_key :id
      String :user_id
      String :url 
    end
  end
  
  def down
    drop_table(:urls)
  end
end
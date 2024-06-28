class AddNameToUsers < ActiveRecord::Migration[7.1]
  def change
    # name 컬럼 추가
    add_column :users, :name, :string
    # name 컬럼이 email 컬럼 옆으로 이동하게
    change_column :users, :email, :string, after: :name
  end
end

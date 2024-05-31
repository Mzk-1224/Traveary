class AddPrefectureIdToBoards < ActiveRecord::Migration[6.0]
  def change
    add_column :boards, :prefecture_id, :integer
    add_index :boards, :prefecture_id
  end
end

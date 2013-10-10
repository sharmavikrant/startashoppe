class AddSlide2ToMasterusers < ActiveRecord::Migration
  def change
    add_column :masterusers, :slide_2, :string
  end
end

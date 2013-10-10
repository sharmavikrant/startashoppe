class AddSlide1ToMasterusers < ActiveRecord::Migration
  def change
    add_column :masterusers, :slide_1, :string
  end
end

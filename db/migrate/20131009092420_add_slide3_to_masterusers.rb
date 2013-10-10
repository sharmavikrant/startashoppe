class AddSlide3ToMasterusers < ActiveRecord::Migration
  def change
    add_column :masterusers, :slide_3, :string
  end
end

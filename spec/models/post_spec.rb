require 'rails_helper'

RSpec.describe Post, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "validations" do
    it "validate presence of email" do
      should validate_presence_of(:title)
    end 
  end 
end

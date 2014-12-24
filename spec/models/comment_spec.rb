describe Comment do
  it "has a valid factory" do
    expect(FactoryGirl.create(:comment)).to be_valid
  end
  it "is invalid without text" do
    expect(FactoryGirl.build(:comment, text: nil)).to be_invalid
  end
end
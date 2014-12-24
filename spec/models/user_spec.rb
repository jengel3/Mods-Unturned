describe User do
  it "has a valid factory" do
    expect(FactoryGirl.create(:user)).to be_valid
  end
  it "is invalid without a username" do
    expect(FactoryGirl.build(:user, username: nil)).to be_invalid
  end
  it "is invalid without an email" do
    expect(FactoryGirl.build(:user, email: nil)).to be_invalid
  end
  it "is invalid with a username longer than 16 characters" do
    expect(FactoryGirl.build(:user, username: "LongAndInvalidUsername")).to be_invalid
  end
  it "has 0 total downloads when created" do
    user = FactoryGirl.create(:user)
    expect(user.total_downloads).to eq(0)
  end
end
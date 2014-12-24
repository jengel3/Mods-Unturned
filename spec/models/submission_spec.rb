describe Submission do
  it "has a valid factory" do
    expect(FactoryGirl.create(:submission)).to be_valid
  end
  it "is invalid without a name" do
    expect(FactoryGirl.build(:submission, name: nil)).to be_invalid
  end
  it "is invalid without a body" do
    expect(FactoryGirl.build(:submission, body: nil)).to be_invalid
  end
  it "is invalid without a type" do
    expect(FactoryGirl.build(:submission, type: nil)).to be_invalid
  end
  it "has an invalid type" do
    expect(FactoryGirl.build(:submission, type: "Invalid Type")).to be_invalid
  end
  it "returns a truncated description as a string" do
    submission = FactoryGirl.build(:submission, body: "This is a very long description that should be more than 75 characters in total. It will be truncated.")
    expect(submission.desc).to eq("This is a very long description that should be more than 75 characters in to...")
  end
  it "is new if newer than 24 hours" do
    submission = FactoryGirl.create(:submission)
    expect(submission.is_new?).to eq(true)
  end
  it "is not ready when approved_at is nil" do
    submission = FactoryGirl.build(:submission)
    expect(submission.ready?).to eq(false)
  end
  it "is ready when approved at is present" do
    submission = FactoryGirl.build(:submission, approved_at: Time.now)
    expect(submission.ready?).to eq(true)
  end
  it "has 0 downloads when created" do
    submission = FactoryGirl.build(:submission)
    expect(submission.total_downloads).to eq(0)
  end
end
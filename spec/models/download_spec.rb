describe Download do
  it "has a valid factory" do
    expect(FactoryGirl.create(:download)).to be_valid
  end
  it "is invalid without an ip" do
    expect(FactoryGirl.build(:download, ip: nil)).to be_invalid
  end
  it "should have the same creator as submission creator" do
    download = FactoryGirl.build(:download)
    expect(download.creator).to eq(download.submission.user)
  end
  it "should increase downloads" do
    download = FactoryGirl.create(:download)
    expect(download.submission.total_downloads).to eq(1)
  end
end
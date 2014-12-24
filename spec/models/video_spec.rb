describe Video do
  it "has a valid factory" do
    expect(FactoryGirl.create(:video)).to be_valid
  end
  it "is invalid without a url" do
    expect(FactoryGirl.build(:video, url: nil)).to be_invalid
  end
  it "has a valid thumbnail" do
    id = "ePNCIz7x6IM"
    video = FactoryGirl.create(:video, url: "https://www.youtube.com/watch?v=#{id}")
    expect(video.get_thumbnail).to eq("https://img.youtube.com/vi/#{id}/0.jpg")
  end
  it "has no thumbnail" do
    video = FactoryGirl.create(:video, url: "http://www.reddit.com/")
    expect(video.get_thumbnail).to eq(nil)
  end
end
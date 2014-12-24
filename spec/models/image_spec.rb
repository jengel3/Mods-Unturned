describe Image do
  it "has a valid factory" do
    expect(FactoryGirl.create(:image)).to be_valid
  end
  it "is invalid without a location" do
    expect(FactoryGirl.build(:image, location: nil)).to be_invalid
  end
  it "has a valid location" do
    expect(FactoryGirl.build(:image, location: "Thumbnail 1")).to be_valid
  end
  it "has an invalid location" do
    expect(FactoryGirl.build(:image, location: "Bad Location")).to be_invalid
  end
  it "is invalid without an uploaded image" do
    expect(FactoryGirl.build(:image, image: nil)).to be_invalid
  end
  it "has the correct file name" do
    image = FactoryGirl.build(:image)
    expect(image.image.file.filename).to eq("Bridge.jpg")
  end
end
describe Upload do
  it "has a valid factory" do
    expect(FactoryGirl.create(:upload)).to be_valid
  end
  it "is invalid without a name" do
    expect(FactoryGirl.build(:upload, name: nil)).to be_invalid
  end
  it "is invalid without a version" do
    expect(FactoryGirl.build(:upload, version: nil)).to be_invalid
  end
  it "is not approved when created" do
    upload = FactoryGirl.build(:upload)
    expect(upload.approved).to eq(false)
  end
  it "is not denied when created" do
    upload = FactoryGirl.build(:upload)
    expect(upload.denied).to eq(false)
  end
  it "is invalid without an uploaded file" do
    expect(FactoryGirl.build(:upload, upload: nil)).to be_invalid
  end
  it "has the correct file name" do
    upload = FactoryGirl.build(:upload)
    expect(upload.upload.file.filename).to eq("Matchbox_Isle.zip")
  end
  it "has the correct download size unit" do
    upload = FactoryGirl.build(:upload)
    expect(upload.upload.download_size[1]).to eq("mb")
  end
  it "has the correct download size" do
    upload = FactoryGirl.build(:upload)
    expect(upload.upload.download_size[0]).to eq(10)
  end
end
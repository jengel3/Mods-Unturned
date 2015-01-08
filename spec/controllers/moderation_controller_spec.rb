RSpec.describe ModerationController do
  describe "GET home" do
    it "shows unapproved files" do
      upload = create(:upload)

      user = create(:user, admin: true)
      sign_in user
      get :home
      expect(assigns(:uploads)).to eq([upload])
    end

    it "does not show approved files" do
      upload = create(:upload, approved: true)
      user = create(:user, admin: true)
      sign_in user
      get :home
      expect(assigns(:uploads)).to eq([])
    end

    it "renders the home template" do
      user = create(:user, admin: true)
      sign_in user
      get :home
      expect(response).to render_template("home")
    end
  end
end

RSpec.describe SubmissionsController do
  describe "GET index" do
    it "shows nothing in index" do
      submission = create(:submission)
      get :index
      expect(assigns(:submissions)).to eq([])
    end

    it "does not show non-user uploads" do
      user = create(:user, username: 'ExampleUser')
      submission = create(:submission, user: user, :approved_at => Time.now)
      get :index, user: 'NotExampleUser'
      expect(assigns(:submissions)).to eq(nil)
    end

    it "shows user uploads" do
      user = create(:user, username: 'ExampleUser')
      submission = create(:submission, user: user, :approved_at => Time.now)
      get :index, user: 'ExampleUser'
      expect(assigns(:submissions)).to eq([submission])
    end

    it "shows correct title for users" do
      user = create(:user)
      get :index, user: user.username
      expect(assigns(:title)).to eq(user.username + "'s" + " Creations")
    end

    it "has correct type" do
      get :index, type: 'levels'
      expect(assigns(:type)).to eq('levels')
      get :index, type: 'models'
      expect(assigns(:type)).to eq('models')
      get :index
      expect(assigns(:type)).to eq('All')
    end

    it "displays approved submissions" do
      submission = create(:submission, :approved_at => Time.now)
      get :index
      expect(assigns(:submissions)).to eq([submission])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
  describe "GET show" do
    it "should render show template" do
      submission = create(:submission)
      get :show, id: submission.id
      expect(response).to render_template("show")
    end
  end
end

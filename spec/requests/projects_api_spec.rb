require 'rails_helper'

RSpec.describe "Projects API", type: :request do
  it "1件のプロジェクトを読み出すこと" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project,
      name: "New Project",
      owner: user
    )
    FactoryBot.create(:project,
      name: "Second Project"
    )

    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }
    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1

    project_id = json[0]["id"]
    get api_project_path(project_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }
    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json["name"]).to eq "New Project"
  end

  it "プロジェクトを作成出来ること" do
    user = FactoryBot.create(:user)
    project_params = FactoryBot.attributes_for(:project)

    expect {
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_params
      }
    }.to change(user.projects, :count).by(1)
    expect(response).to have_http_status(:success)
  end
end
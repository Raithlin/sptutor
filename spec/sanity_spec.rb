require 'rails_helper'

RSpec.describe "RSpec Integration", type: :request do
  it "can access Rails environment" do
    expect(Rails.env).to eq("test")
  end

  it "can make a health check request" do
    get rails_health_check_path
    expect(response).to have_http_status(:ok)
  end
end

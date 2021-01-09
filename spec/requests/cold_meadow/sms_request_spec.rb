require "rails_helper"

RSpec.describe "ColdMeadow::Sms", type: :request do
  describe "posting a message" do
    it "handles valid params" do
      headers = { "content_type" => "application/json" }

      message_params = {
        uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
        recipients: [
          { phone_number: "+15141234567" },
          { phone_number: "+15141238950" }
        ],
        sender: { personal_name: "Jane Smith" },
        body: "Hello world!"
      }

      post "/cold_meadow/sms",
           params: { message: message_params },
           headers: headers

      expect(response).to have_http_status(:accepted)
      expect(JSON.parse(response.body)).to include("status" => "accepted")
    end

    it "handles invalid params" do
      headers = { "content_type" => "application/json" }

      message_params = {
        uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
        recipients: [
          { phone_number: "+123" },
          { phone_number: "+15141238950" }
        ],
        sender: { personal_name: nil },
        body: nil
      }

      post "/cold_meadow/sms",
           params: { message: message_params },
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)

      json_body = JSON.parse(response.body)
      expect(json_body).to include("status" => "error")
      expect(json_body["data"]).to include(
        "uuid" => "bafb6c01-1171-4f75-b488-c538c5aacd5a"
      )
      expect(json_body["data"]).to have_key("errors")
    end
  end
end

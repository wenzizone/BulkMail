get "/api/:uid" do
    content_type :json
    res = Api::GetImport.getimportjobs(params[:uid])
    res.to_json
end
get "/api/importjobs/:uid" do
    content_type :json
    res = Api::GetImport.getimportjobs(params[:uid])
    res.to_json
end

get "/api/gettablename/:uid" do
    content_type :json
    res = Api::GetSend.gettable(params[:uid])
    res.to_json
end
shared_examples 'API Attachable' do
  context 'attachments' do
    it "included in attachable object" do
      expect(response.body).to have_json_size(2).at_path("#{parent_path}/attachments")
    end

    it "contains id" do
      expect(response.body).to be_json_eql(attachment.id.to_json).at_path("#{parent_path}/attachments/0/id")
    end

    it "contains name" do
      expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("#{parent_path}/attachments/0/name")
    end

    it "contains url" do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{parent_path}/attachments/0/url")
    end
  end
end

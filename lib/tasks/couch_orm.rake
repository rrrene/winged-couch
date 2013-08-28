namespace :couch_orm do
  desc "upload receiver.html to couchdb"
  task :upload_receiver_html => :environment do

    design_doc = "/_design/couch-orm"

    database = CouchORM::Database.new("couch-orm")
    database.create unless database.exist?

    begin
      rev = database.get(design_doc)["_rev"]
      database.delete("#{design_doc}?rev=#{rev}")
    rescue
      nil
    end

    receiver_html = File.read(File.expand_path("../receiver.html", __FILE__))

    data = {
      _attachments: {
        "receiver.html" => {
          content_type: "text/html",
          data: Base64.encode64(receiver_html)
        }
      }
    }.to_json

    database.put(design_doc, data)

  end
end
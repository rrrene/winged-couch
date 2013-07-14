module CouchHelper
  def self.included(base)
    base.instance_eval do

      let(:couch_db_server) { "http://localhost:5984" }
      let(:success_response) { { "ok" => true } }

    end
  end
end
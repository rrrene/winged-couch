module CouchHelper
  def self.included(base)
    base.instance_eval do

      let(:couch_db_server) { "/" }
      let(:success_response) { { "ok" => true } }

    end
  end
end
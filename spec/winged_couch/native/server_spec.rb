require 'spec_helper'

module WingedCouch
  module Native
    describe Server do

      subject(:server) { Server }

      its(:info)         { should have_key("couchdb") }
      its(:all_dbs)      { should include("_users") }
      its(:active_tasks) { should be_a(Array) }
      its(:uuids)        { should have_key("uuids") }
      its(:stats)        { should be_a(Hash) }
      its(:log)          { should be_a(String) }

    end
  end
end
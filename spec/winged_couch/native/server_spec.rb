require 'spec_helper'

describe WingedCouch::Native::Server do

  subject(:server) { WingedCouch::Native::Server }

  its(:info)         { should have_key("couchdb") }
  its(:all_dbs)      { should include("_users") }
  its(:active_tasks) { should be_a(Array) }
  its(:uuids)        { should have_key("uuids") }
  its(:stats)        { should be_a(Hash) }
  its(:log)          { should be_a(String) }

end
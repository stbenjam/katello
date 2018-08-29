attributes :id, :uuid, :last_checkin, :service_level, :release_version, :autoheal, :registered_at, :registered_through

node :role do |facet|
  facet.purpose_role
end

node :usage do |facet|
  facet.purpose_usage
end

node :add_ons do |facet|
  facet.purpose_addons&.map(&:name)
end

child :user => :user do
  attributes :id, :login
end

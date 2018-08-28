module Katello
  class PurposeRole < Katello::Model
    self.table_name = 'katello_purpose_roles'

    has_many :subscription_facets, :class_name => "Katello::Host::SubscriptionFacet"
  end
end

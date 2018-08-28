module Katello
  class PurposeUsage < Katello::Model
    self.table_name = 'katello_purpose_usages'

    has_many :subscription_facets, :class_name => "Katello::Host::SubscriptionFacet"
  end
end

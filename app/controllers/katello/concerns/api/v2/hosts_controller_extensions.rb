module Katello
  module Concerns
    module Api::V2::HostsControllerExtensions
      extend ActiveSupport::Concern
      include ForemanTasks::Triggers

      module Overrides
        def action_permission
          case params[:action]
          when 'host_collections'
            'edit'
          else
            super
          end
        end

        def update
          role = params.dig('host', 'subscription_facet_attributes', 'role')
          @host.subscription_facet&.update_role(role) if role && role != @host.purpose_role&.to_s

          usage = params.dig('host', 'subscription_facet_attributes', 'usage')
          @host.subscription_facet&.update_usage(usage) if usage && usage != @host.purpose_usage&.to_s

          add_ons = params.dig('host', 'subscription_facet_attributes', 'add_ons')
          @host.subscription_facet&.update_addons(add_ons) if add_ons

          super
        end
      end

      included do
        prepend Overrides
        def destroy
          Katello::RegistrationManager.unregister_host(@host, :unregistering => false)
          process_response(:object => @host)
        end

        api :PUT, "/hosts/:host_id/host_collections", N_("Alter a hosts host collections")
        param :host_id, :number, :required => true, :desc => N_("The id of the host to alter")
        param :host_collection_ids, Array, :required => true, :desc => N_("List of host collection ids to update")
        def host_collections
          @host.host_collection_ids = params[:host_collection_ids]
          @host.save!
          render(:locals => { :resource => @host }, :template => 'katello/api/v2/hosts/show', :status => 200)
        end
      end
    end
  end
end

require 'rest-client'
class BlogAdminInviteJob < Struct.new(:listing_id, :community_id)
  include DelayedAirbrakeNotification

  # This before hook should be included in all Jobs to make sure that the service_name is
  # correct as it's stored in the thread and the same thread handles many different communities
  # if the job doesn't have host parameter, should call the method with nil, to set the default service_name
  def before(job)
    # Set the correct service name to thread for I18n to pick it
    ApplicationHelper.store_community_service_name_to_thread_from_community_id(community_id)
  end

  def perform
    session_email = 'hola@example.com'
    session_password = 'password'
    session_role_id = '1234567890'

    listing = Listing.find(listing_id)
    author = listing.author
    author_email = author.primary_email&.address

    if author.listings.count == 1 && author_email
      begin
        # Get the ghost-admin-api-session
        response = RestClient.post "https://blog.level1.cl/ghost/api/admin/session/", {'username' => "#{session_email}", 'password' => "#{session_password}"}.to_json, {content_type: :json, accept: :json}

        cookies = response.cookies
        admin_session_cookies = cookies['ghost-admin-api-session'] rescue ''

        # Call the admin invites api
        if admin_session_cookies.present?
          invite_response = RestClient.post "https://blog.level1.cl/ghost/api/admin/invites/", {'invites' => [{'email' => "#{author_email}", 'role_id' => "#{session_role_id}"}]}.to_json, {'Cookie' => "ghost-admin-api-session=#{admin_session_cookies}", 'Content-Type' => 'application/json'}

          result = JSON.parse(invite_response)
          invite_results = result['invites'] rescue {}
          if invite_results && invite_results.first['status'] == 'sent'
            puts "===== SUCCESS ====="
          end
        end
      rescue Exception => e
        puts e.message
        puts "===== SOMETHING WENT WRONG ====="
      end  
    end
  end
end

# frozen_string_literal: true

class UnfavouriteService < BaseService
  include Payloadable

  def call(account, status)
    favourite = Favourite.find_by!(account: account, status: status)
    favourite.destroy!
    create_notification(favourite)
    favourite
  end

  private

  def create_notification(favourite)
    status = favourite.status

    if status.direct_visibility?
      ActivityPub::DeliveryWorker.perform_async(build_json(favourite), favourite.account_id, status.account.inbox_url)
    else
      ActivityPub::InteractionDistributionWorker.perform_async(build_json(favourite), favourite.account_id, status.id) unless status.local_only?
    end
  end

  def build_json(favourite)
    serialize_payload(favourite, ActivityPub::UndoLikeSerializer).to_json
  end
end

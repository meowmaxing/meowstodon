# frozen_string_literal: true

module Admin
  class CollectionsController < BaseController
    before_action :set_account
    before_action :set_collection, only: :show

    def show
      authorize @collection, :show?
    end

    private

    def set_account
      @account = Account.find(params[:account_id])
    end

    def set_collection
      @collection = @account.collections.includes(accepted_collection_items: :account).find(params[:id])
    end

    def set_collections
      @collections = @account.collections.includes(accepted_collection_items: :account).page(params[:page]).per(PER_PAGE)
    end

    def action_from_button
      if params[:report]
        'report'
      elsif params[:remove_from_report]
        'remove_from_report'
      end
    end
>>>>>>> refs/remotes/origin/main
  end
end

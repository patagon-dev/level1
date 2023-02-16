class ChileanBankAccountsController < ApplicationController
  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_settings")
  end

  before_action :set_chilean_bank_account, except: [:create]

  def new
    @selected_left_navi_link = "payments"

    unless @chilean_bank_account.present?
      @chilean_bank_account = ChileanBankAccount.new(
        first_name: @current_user.given_name,
        last_name: @current_user.family_name,
        payment_notification_email: @current_user.primary_email.address
      )
    end
  end

  def create
    @selected_left_navi_link = "payments"
    new_bank_account = @current_user.build_chilean_bank_account(chilean_bank_account_params)

    if new_bank_account.save
      flash[:warning] = t("chilean_bank_accounts.payment_information_saved_successfully")
      redirect_to edit_chilean_bank_account_path(new_bank_account)
    else
      flash[:error] = new_bank_account.errors.full_messages.to_sentence
      redirect_to new_chilean_bank_account_path
    end
  end

  def edit
    @selected_left_navi_link = "payments"
  end

  def update
    @selected_left_navi_link = "payments"

    if @chilean_bank_account.update(chilean_bank_account_params)
      flash[:warning] = t("chilean_bank_accounts.payment_information_saved_successfully")
    else
      flash[:error] = @chilean_bank_account.errors.full_messages.to_sentence
    end

    redirect_to edit_chilean_bank_account_path(@chilean_bank_account)
  end

  private
  def chilean_bank_account_params
    params.require(:chilean_bank_account).slice(
      :first_name,
      :last_name,
      :bank_rut,
      :bank_account,
      :bank_name,
      :payment_notification_email
    ).permit!
  end

  def set_chilean_bank_account
    @chilean_bank_account = @current_user.chilean_bank_account
  end
end

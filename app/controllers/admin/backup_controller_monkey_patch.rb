

Admin::BackupsController.class_eval do

  before_action :check_developer

  def email
    if backup = Backup[params.fetch(:id)] && is_developer?(current_user.email)
      token = EmailBackupToken.set(current_user.id)
      download_url = "#{url_for(controller: 'backups', action: 'show')}?token=#{token}"
      Jobs.enqueue(:download_backup_email, to_address: current_user.email, backup_file_path: download_url)
      render nothing: true
    else
      render nothing: true, status: 404
    end
  end


  def destroy
    if backup = Backup[params.fetch(:id)]  && is_developer?(current_user.email)
      StaffActionLogger.new(current_user).log_backup_destroy(backup)
      backup.remove
      render nothing: true
    else
      render nothing: true, status: 404
    end
  end

  def restore
    opts = {
      filename: params.fetch(:id),
      client_id: params.fetch(:client_id),
      publish_to_message_bus: true,
    }
    if is_developer?(current_user.email)
        SiteSetting.set_and_log(:disable_emails, true, current_user)
        BackupRestore.restore!(current_user.id, opts)  
       
    else
        render json: failed_json.merge(message: "Restore not permitted by plugin!")
    end
  rescue BackupRestore::OperationRunningError
    render json: failed_json.merge(message: I18n.t("backup.operation_already_running"))
  else
    render json: success_json
  end

  def rollback
    if is_developer?(current_user.email)
        BackupRestore.rollback!
    else
        render json: failed_json.merge(message: "Rollback not permitted by plugin!")
    end
  rescue BackupRestore::OperationRunningError
    render json: failed_json.merge(message: I18n.t("backup.operation_already_running"))
  else
    render json: success_json
  end


 
  private
  
  def is_developer?(value)
    if SiteSetting.enable_limit_backups_to_developers?
      Rails.configuration.respond_to?(:developer_emails) && Rails.configuration.developer_emails.include?(value)
    else 
      true
    end
  end

  def check_developer
      @is_developer = false
      if is_developer?(current_user.email)
        @is_developer = true
      end
  end
 
end
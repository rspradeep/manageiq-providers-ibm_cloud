module ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::Provision::StateMachine
  def create_destination
    signal :prepare_provision
  end

  def start_clone_task
    update_and_notify_parent(:message => "Starting Clone of #{clone_direction}")
    log_clone_options(phase_context[:clone_options])
    phase_context[:clone_task_ref] = start_clone(phase_context[:clone_options])
    phase_context.delete(:clone_options)
    signal :poll_clone_complete
  end

  def poll_clone_complete
    _clone_status, _status_message = do_clone_task_check(phase_context[:clone_task_ref])
    clone_status = true

    if clone_status
      signal :poll_destination_in_vmdb
    else
      requeue_phase
    end
  end

  def poll_destination_in_vmdb
    # TODO: implement
  end
end

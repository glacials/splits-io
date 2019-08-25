module ApplicationsHelper
  def scope_to_sentence(scope)
    case scope
    when 'upload_run'
      'Upload runs on your behalf'
    when 'delete_run'
      'Delete and/or disown your runs'
    when 'manage_race'
      'Manage your participation in races'
    end
  end
end

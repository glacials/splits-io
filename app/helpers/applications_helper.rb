module ApplicationsHelper
  def scope_to_sentence(scope)
    case scope
    when 'upload_run'
      "Upload runs on your behalf"
    end
  end
end

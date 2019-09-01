class SpeedrunDotComUser < ApplicationRecord
  belongs_to :user

  def self.from_api_key!(api_key, user:)
    srdc_user = find_by(api_key: api_key)
    return srdc_user if srdc_user.present?

    result = SpeedrunDotCom::User.from_api_key(api_key)
    return if result.nil?

    new(srdc_id: result['id'], api_key: api_key, user: user).from_result!(result)
  end

  def sync!
    from_result!(SpeedrunDotCom::User.from_id(srdc_id))
  end

  def from_result!(result)
    update(
      name: result['names']['international'],
      url:  result['weblink']
    ) && self
  end
end

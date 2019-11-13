class AddCaptchaToStudyFinderSystemInfos < ActiveRecord::Migration[4.2]
  def change
    add_column :study_finder_system_infos, :captcha, :boolean, null: false, default: false
  end
end

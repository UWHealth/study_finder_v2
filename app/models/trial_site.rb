class TrialSite < ApplicationRecord
  self.table_name = 'study_finder_trial_sites'

  belongs_to :trial
  belongs_to :site
end
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# ============================================
# System info
# ============================================

system = {
  initials: 'UW (Development Server)',
  school_name: 'University of Wisconsin School of Medicine and Public Health',
  system_name: 'StudyFinder',
  system_header: '(Development Server) Do you want to have an impact on future health? You can!',
  system_description: "<p>When you join a clinical research study, you contribute to new health discoveries. Your participation helps doctors and other researchers understand how to diagnose, treat and prevent diseases.  As more people participate, we can change lives for the better..</p><p> Use this website to quickly and easily find clinical studies that are open and seeking participants.</p><p>Thank you!</p>",
  researcher_description: "<h2>Information for researchers about StudyFinder</h2><p>Studyfinder is a recruitment tool for clinical trials conducted at UW Health and the UW School of Medicine and Public Health. This site includes both oncology and non-oncology clinical trials.</p><p>Studyfinder displays data in a way that is intuitive and user-friendly for the public. Currently, in order to post a study on Study Finder the study must be listed in OnCore and have a ClinicalTrials.gov number. <p>The study will not display until listed on ClinicalTrials.gov and a status of <span style=\"text-decoration: underline;\">Open to Accrual</span> in OnCore.</p><br><p>For information about how to post studies on StudyFinder, please see: <a href=\"https://kb.wisc.edu/ictr/96376\">OnCore Knowledgebase</a></p><p>For more general questions about Studyfinder, please email <a href=\"mailto:studyinfo@ictr.wisc.edu\">studyinfo@ictr.wisc.edu</a></p>",
  search_term: 'madison AND (wisconsin OR wi)',
  default_url: 'https://clinicaltrials.uwhealth.org',
  default_email: 'studyinfo@ictr.wisc.edu',
  display_all_locations: false,
  secret_key: 'test',
  contact_email_suffix: ''
}

system_info = SystemInfo.find_or_initialize_by(initials: system[:initials])
system_info.school_name = system[:school_name]
system_info.system_name = system[:system_name]
system_info.system_header = system[:system_header]
system_info.system_description = system[:system_description]
system_info.researcher_description = system[:researcher_description]
system_info.search_term = system[:search_term]
system_info.default_url = system[:default_url]
system_info.default_email = system[:default_email]
system_info.display_all_locations = system[:display_all_locations]
system_info.secret_key = system[:secret_key]
system_info.contact_email_suffix = system[:contact_email_suffix]

system_info.save!

# ============================================
# API Key
# ============================================

k = ApiKey.new(name: 'test_api_key')
k.save
puts "API Key: #{k.token}"

# ============================================
# Parsers
# ============================================

[
  {
    name: 'clinicaltrials.gov',
    klass: 'Parsers::Ctgov'
  }
].each do |p|
  parser = Parser.find_or_initialize_by(name: p[:name])
  parser.klass = p[:klass]
  parser.save!
end

# ============================================
# Users
# ============================================

[
  {
    internet_id: ENV['USER'],
    first_name: 'Admin',
    last_name: 'User',
    email: "fake@example.edu"
  }
].each do |u|
  user = User.find_or_initialize_by(internet_id: u[:internet_id])
  user.first_name = u[:first_name]
  user.last_name = u[:last_name]
  user.email = u[:email]
  user.save!
end

# ============================================
# Groups and conditions
# ============================================

CSV.foreach(Rails.root.join("db/seeds/condition_groups.csv")) do |group_name, condition_name|
  group = Group.find_or_create_by(group_name: group_name)
  condition = Condition.find_or_create_by(condition: condition_name)
  ConditionGroup.find_or_create_by(group: group, condition: condition)
end

# ============================================
# Trials
# ============================================

Rake::Task['studyfinder:ctgov:load'].invoke

# ============================================
# Trial attribute settings
# ============================================
attribute_setting_data = JSON.parse(IO.read(Rails.root.join("db/seeds/trial_attribute_settings.json")))
system_info = SystemInfo.first
system_info.trial_attribute_settings.delete_all
system_info.trial_attribute_settings.create(attribute_setting_data)

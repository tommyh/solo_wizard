require File.expand_path("config/environment.rb")

class SoloWizardTasks < Thor

  desc "create_first_soloist_script", "Create the first soloist script"
  def create_first_soloist_script
    SoloistScript.create(:recipes => Recipe.with_checked_by_default)
  end

  desc "clean_all_tables", "Empty out all of the tables"
  def clean_all_tables
    SoloistScript.destroy_all
    Recipe.destroy_all
    RecipeGroup.destroy_all
  end

  desc "create_pivotal_workstation_recipes", "Create the initial set of recipes from pivotal workstation"
  def create_pivotal_workstation_recipes
    group01 = RecipeGroup.create :name => "Development Stack", :position => 1
    group02 = RecipeGroup.create :name => "Databases", :position => 2
    group03 = RecipeGroup.create :name => "General Software", :position => 6
    group04 = RecipeGroup.create :name => "OS-X Settings", :position => 7, :description => "Configuring your OS-X with some helpful settings"
    group05 = RecipeGroup.create :name => ".bash_profile", :position => 8
    group06 = RecipeGroup.create :name => "Command Line Tools", :position => 3
    group07 = RecipeGroup.create :name => "Source Control", :position => 4
    group08 = RecipeGroup.create :name => "Text Editors", :position => 5
    group09 = RecipeGroup.create :name => "Etc", :position => 9
    group10 = RecipeGroup.create :name => "Pivotal Workstation Meta", :position => 10, :description => "Each 'Meta' recipe is a collection of other recipes"

    group06.recipes.create :name => "ack", :checked_by_default => true
    group04.recipes.create :name => "active_corners", :checked_by_default => false
    group01.recipes.create :name => "activemq", :checked_by_default => false
    group09.recipes.create :name => "add_ops_user", :checked_by_default => false
    group06.recipes.create :name => "ag", :checked_by_default => false
    group03.recipes.create :name => "alfred", :checked_by_default => false
    group05.recipes.create :name => "bash_path_order", :checked_by_default => true
    group05.recipes.create :name => "bash_profile-aliases", :checked_by_default => true
    group05.recipes.create :name => "bash_profile-arch_flags", :checked_by_default => false
    group05.recipes.create :name => "bash_profile-better_history", :checked_by_default => true
    group05.recipes.create :name => "bash_profile-ctrl-o", :checked_by_default => true
    group05.recipes.create :name => "bash_profile-ctrl-s", :checked_by_default => false
    group05.recipes.create :name => "bash_profile-git_completion", :checked_by_default => true
    group05.recipes.create :name => "bash_profile-lang_en", :checked_by_default => false
    group05.recipes.create :name => "bash_profile-no_sudo_gem_install", :checked_by_default => true
    group05.recipes.create :name => "bash_profile-ps1", :checked_by_default => true
    group05.recipes.create :name => "bash_profile-ree_settings", :checked_by_default => false
    group09.recipes.create :name => "ca_certs_to_match_heroku", :checked_by_default => false
    group03.recipes.create :name => "ccmenu", :checked_by_default => true
    group03.recipes.create :name => "chrome", :checked_by_default => true
    group09.recipes.create :name => "create_var_chef_cache", :checked_by_default => true
    group09.recipes.create :name => "default_editor", :checked_by_default => true
    group04.recipes.create :name => "defaults_fast_key_repeat_rate", :checked_by_default => true
    group04.recipes.create :name => "disable_front_row", :checked_by_default => false
    group04.recipes.create :name => "dock_preferences", :checked_by_default => false
    group03.recipes.create :name => "dropbox", :checked_by_default => true
    group06.recipes.create :name => "ec2_api_tools", :checked_by_default => false
    group04.recipes.create :name => "enable_assistive_devices", :checked_by_default => true
    group01.recipes.create :name => "erlang", :checked_by_default => false
    group03.recipes.create :name => "evernote", :checked_by_default => false
    group04.recipes.create :name => "finder_display_full_path", :checked_by_default => false
    group03.recipes.create :name => "firefox", :checked_by_default => true
    group03.recipes.create :name => "flycut", :checked_by_default => true
    group03.recipes.create :name => "freeruler", :checked_by_default => false
    group04.recipes.create :name => "function_keys", :checked_by_default => true
    group09.recipes.create :name => "gem_no_rdoc_no_ri", :checked_by_default => true
    group07.recipes.create :name => "git", :checked_by_default => true
    group07.recipes.create :name => "git_config_global_defaults", :checked_by_default => true
    group07.recipes.create :name => "git_projects", :checked_by_default => false
    group07.recipes.create :name => "git_scripts", :checked_by_default => true
    group07.recipes.create :name => "github_for_mac", :checked_by_default => true
    group07.recipes.create :name => "github_ssh_keys", :checked_by_default => false
    group07.recipes.create :name => "gitx", :checked_by_default => true
    group09.recipes.create :name => "global_environment_variables", :checked_by_default => true
    group09.recipes.create :name => "google_chrome_prevent_updates", :checked_by_default => false
    group03.recipes.create :name => "grid", :checked_by_default => false
    group06.recipes.create :name => "homebrew", :checked_by_default => true
    group01.recipes.create :name => "imagemagick", :checked_by_default => true
    group09.recipes.create :name => "increase_shared_memory", :checked_by_default => true
    group04.recipes.create :name => "input_on_login", :checked_by_default => false
    group09.recipes.create :name => "inputrc", :checked_by_default => true
    group08.recipes.create :name => "intellij_community_edition", :checked_by_default => false
    group08.recipes.create :name => "intellij_ultimate_edition", :checked_by_default => false
    group06.recipes.create :name => "iterm2", :checked_by_default => true
    group01.recipes.create :name => "java", :checked_by_default => true
    group08.recipes.create :name => "joe", :checked_by_default => false
    group06.recipes.create :name => "jumpcut", :checked_by_default => false
    group04.recipes.create :name => "keyboard_preferences", :checked_by_default => true
    group03.recipes.create :name => "keycastr", :checked_by_default => true
    group03.recipes.create :name => "libreoffice", :checked_by_default => false
    group09.recipes.create :name => "lion_basedev", :checked_by_default => false
    group09.recipes.create :name => "locate_on", :checked_by_default => true
    group01.recipes.create :name => "memcached", :checked_by_default => false
    group04.recipes.create :name => "menubar_preferences", :checked_by_default => true
    group03.recipes.create :name => "menumeters", :checked_by_default => true
    group10.recipes.create :name => "meta_osx_base", :checked_by_default => false
    group10.recipes.create :name => "meta_osx_development", :checked_by_default => false
    group10.recipes.create :name => "meta_pivotal_lion_image", :checked_by_default => false
    group10.recipes.create :name => "meta_pivotal_specifics", :checked_by_default => false
    group10.recipes.create :name => "meta_ruby_development", :checked_by_default => false
    group02.recipes.create :name => "mongodb", :checked_by_default => false
    group03.recipes.create :name => "mouse_locator", :checked_by_default => true
    group02.recipes.create :name => "mysql", :checked_by_default => true
    group01.recipes.create :name => "nginx", :checked_by_default => false
    group01.recipes.create :name => "node_js", :checked_by_default => true
    group06.recipes.create :name => "oh_my_zsh", :checked_by_default => false
    group09.recipes.create :name => "osx_updates", :checked_by_default => false
    group03.recipes.create :name => "pg_admin", :checked_by_default => false
    group09.recipes.create :name => "pivotal_logos", :checked_by_default => false
    group02.recipes.create :name => "postgres", :checked_by_default => true
    group03.recipes.create :name => "propane", :checked_by_default => false
    group01.recipes.create :name => "qt", :checked_by_default => true
    group01.recipes.create :name => "rabbitmq", :checked_by_default => false
    group06.recipes.create :name => "rbenv", :checked_by_default => false
    group01.recipes.create :name => "redis", :checked_by_default => false
    group04.recipes.create :name => "remove_expose_keyboard_shortcuts", :checked_by_default => false
    group04.recipes.create :name => "remove_garageband", :checked_by_default => false
    group09.recipes.create :name => "rename_machine", :checked_by_default => false
    group08.recipes.create :name => "rubymine", :checked_by_default => true
    group08.recipes.create :name => "rubymine_preferences_pivotal", :checked_by_default => true
    group06.recipes.create :name => "rvm", :checked_by_default => true
    group04.recipes.create :name => "safari_preferences", :checked_by_default => false
    group03.recipes.create :name => "screen_sharing_app", :checked_by_default => true
    group04.recipes.create :name => "screen_sharing_on", :checked_by_default => false
    group01.recipes.create :name => "selenium_webdriver", :checked_by_default => false
    group04.recipes.create :name => "set_finder_show_all_hd_on_desktop", :checked_by_default => false
    group04.recipes.create :name => "set_finder_show_hd_on_desktop", :checked_by_default => false
    group04.recipes.create :name => "set_finder_show_user_home_in_sidebar", :checked_by_default => false
    group04.recipes.create :name => "set_multitouch_preferences", :checked_by_default => false
    group04.recipes.create :name => "set_screensaver_preferences", :checked_by_default => false
    group03.recipes.create :name => "sizeup", :checked_by_default => true
    group03.recipes.create :name => "skype", :checked_by_default => true
    group01.recipes.create :name => "snmpd", :checked_by_default => false
    group01.recipes.create :name => "solr", :checked_by_default => false
    group09.recipes.create :name => "ssh_copy_id", :checked_by_default => false
    group06.recipes.create :name => "sshd_on", :checked_by_default => true
    group09.recipes.create :name => "ssl_certificate", :checked_by_default => false
    group08.recipes.create :name => "sublime_text", :checked_by_default => false
    group07.recipes.create :name => "svn", :checked_by_default => false
    group04.recipes.create :name => "terminal_focus", :checked_by_default => false
    group04.recipes.create :name => "terminal_preferences", :checked_by_default => false
    group08.recipes.create :name => "textmate", :checked_by_default => true
    group08.recipes.create :name => "textmate_bundles", :checked_by_default => true
    group08.recipes.create :name => "textmate_plugins", :checked_by_default => false
    group08.recipes.create :name => "textmate_preferences", :checked_by_default => true
    group04.recipes.create :name => "timemachine_preferences", :checked_by_default => false
    group06.recipes.create :name => "tmux", :checked_by_default => true
    group06.recipes.create :name => "unix_essentials", :checked_by_default => true
    group09.recipes.create :name => "user_owns_usr_local", :checked_by_default => true
    group08.recipes.create :name => "vim", :checked_by_default => true
    group03.recipes.create :name => "virtualbox", :checked_by_default => true
    group04.recipes.create :name => "window_focus", :checked_by_default => false
    group09.recipes.create :name => "workspace_directory", :checked_by_default => true
    group03.recipes.create :name => "xquartz", :checked_by_default => true
    group06.recipes.create :name => "zsh", :checked_by_default => false
  end

end
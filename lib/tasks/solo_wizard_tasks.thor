require File.expand_path("config/environment.rb")

class SoloWizardTasks < Thor

  desc "create_recipes", "Create recipes from github and delete old recipes"
  def create_and_update_recipes_from_github
    invoke :create_recipe_groups

    # find all recipes from pivotal_workstation cookbook (via github)
    github_recipe_names = GithubApiClient.pivotal_workstation_recipes

    # if there are no recipes from github, something probably went wrong (possibly a logical error where
    #  they moved all of the recipes), so just bail early
    return if github_recipe_names.blank?

    # we will want to put them in the "Uncategorized" RecipeGroup because who knows what they are
    uncategorized_group = RecipeGroup.find_by_name(RecipeGroup::NAMES[:uncategorized])

    # create all new recipes we found
    github_recipe_names.each do |recipe_name|
      Recipe.find_or_create_by_name!(recipe_name, :recipe_group => uncategorized_group)
    end

    # delete all recipes which aren't in the pivotal_workstation cookbook anymore (via github)
    (Recipe.all.map(&:name) - github_recipe_names).each do |recipe_name|
      Recipe.find_by_name!(recipe_name).destroy
    end

    # delete all empty recipe groups
    RecipeGroup.all.each do |recipe_group|
      recipe_group.destroy if recipe_group.recipes.blank?
    end
  end

  desc "create_recipe_groups", "Create Recipe Groups"
  def create_recipe_groups
    create_pivotal_workstation_recipe_group(:development_stack, 1)
    create_pivotal_workstation_recipe_group(:databases, 2)
    create_pivotal_workstation_recipe_group(:general_software, 6)
    create_pivotal_workstation_recipe_group(:osx_settings, 7, "Configuring your OS-X with some helpful settings.")
    create_pivotal_workstation_recipe_group(:bash_profile, 8)
    create_pivotal_workstation_recipe_group(:command_line_tools, 3)
    create_pivotal_workstation_recipe_group(:source_control, 4)
    create_pivotal_workstation_recipe_group(:text_editors, 5)
    create_pivotal_workstation_recipe_group(:etc, 9)
    create_pivotal_workstation_recipe_group(:pivotal_labs, 10, "These recipes have something which makes them only useful to people who work at the Pivotal Labs consultancy, ie Renaming your machine to a standard convention, installing Pivotal Logos, etc.")
    create_pivotal_workstation_recipe_group(:uncategorized, 11, "These recipes have been added in the pivotal_workstation cookbook, but have not been categorized by SoloWizard yet.")
  end

  desc "update_optional_metadata", "Update optional metadata for the recipes"
  def update_optional_metadata
    update_pivotal_workstation_recipe("ack", :command_line_tools, true, "Ack is a powerful alternative to grep(regular expression search) for programmers. It is faster than grep.")
    update_pivotal_workstation_recipe("active_corners", :osx_settings, false, "This recipe relaunches dock with corner values with either one of desktop,dashboard,mission control,application windows,launchpad,start screen saver, disable screen saver, put display to sleep.")
    update_pivotal_workstation_recipe("activemq", :development_stack, false, "Apache ActiveMQ is the most popular and powerful open source messaging and Integration Patterns server. It supports many Cross Language Clients and Protocols and many advanced features while fully supporting JMS 1.1 and J2EE 1.4.")
    update_pivotal_workstation_recipe("add_ops_user", :etc, false, "This recipe adds a new 'ops' user and adds it to kernal and creates a home directory for the same user and adds it a admin user.")
    update_pivotal_workstation_recipe("ag", :command_line_tools, false, "Ag is similar to Ack,searches through code, but faster than Ack, which in turn is faster than grep.")
    update_pivotal_workstation_recipe("alfred", :general_software, false)
    update_pivotal_workstation_recipe("bash_path_order", :bash_profile, true, "It appends '/usr/local/bin:' before ENV['PATH']. It also opens every file in '/etc/paths/' location and updates the first line with '/usr/local/bin\\n' and removes any occurrences of '/usr/local/bin\\n' thereafter.")
    update_pivotal_workstation_recipe("bash_profile-aliases", :bash_profile, true, "Adds some helpful bash aliases: 'll' for the 'ls -lhA' command.  And adds color=auto to grep command")
    update_pivotal_workstation_recipe("bash_profile-arch_flags", :bash_profile, false, "This recipe creates an environment variable ARCHFLAGS and sets value '-arch x86_64' for it.")
    update_pivotal_workstation_recipe("bash_profile-better_history", :bash_profile, true, "This recipe sets history control for bash and sets to ignore duplicates, sets size for history as 10000 and also enables to append data to the history file rather than overwriting.")
    update_pivotal_workstation_recipe("bash_profile-ctrl-o", :bash_profile, true, "Go back to a command in history and press CTRL-O instead of RETURN. This will execute the command and bring up the next command in the history file. Press CTRL-O again to enter this command and bring up the next one. This recipe enables CTRL-O.")
    update_pivotal_workstation_recipe("bash_profile-ctrl-s", :bash_profile, false, "This recipe disables start/stop  output control and frees up CTRL-S for bash history forward searches.")
    update_pivotal_workstation_recipe("bash_profile-git_completion", :bash_profile, true, "This recipe installs git-core and bash-completion.  bash-completion extends bash's standard completion behavior to achieve complex lines with just a few keystrokes. This recipe adds completion for git commands.")
    update_pivotal_workstation_recipe("bash_profile-lang_en", :bash_profile, false, "This recipe sets the language and locale to US English and encoding to UTF-8.")
    update_pivotal_workstation_recipe("bash_profile-no_sudo_gem_install", :bash_profile, true, "This recipe raises error whenever 'sudo gem' command is used to install the gem.")
    update_pivotal_workstation_recipe("bash_profile-ps1", :bash_profile, true, "The appearance of the prompt in a shell is governed by the shell variable PS1. This recipe can change the default value for PS1.")
    update_pivotal_workstation_recipe("bash_profile-ree_settings", :bash_profile, false, "Tuning settings for REE (Ruby Enterprise Edition) concerning memory and heap slots")
    update_pivotal_workstation_recipe("ca_certs_to_match_heroku", :etc, false, "Iterates through every file in '/usr/lib/ssl', ''/usr/lib/ssl/certs/' and sets the current user as owner. This recipe also copies the '/usr/lib/ssl/certs/ca-certificates.crt' file from cookbook as 'cacert.pem' in read-only mode.")
    update_pivotal_workstation_recipe("ccmenu", :general_software, true, "CCMenu displays the project status of CruiseControl continuous integration servers as an item in the Mac OS X menu bar.")
    update_pivotal_workstation_recipe("chrome", :general_software, true, "Google Chrome is a browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier.")
    update_pivotal_workstation_recipe("create_var_chef_cache", :etc, true, "This recipe creates a file cache path directory and makes 'root' as its owner.")
    update_pivotal_workstation_recipe("default_editor", :etc, true, "This recipe sets TextMate to be the default editor for .xml, .rb, .erb, .plain-text, .yml, .yaml")
    update_pivotal_workstation_recipe("defaults_fast_key_repeat_rate", :osx_settings, true, "This recipe sets KeyRepeat to 2 and InitialKeyRepeat to 15 in global preferences for the user")
    update_pivotal_workstation_recipe("disable_front_row", :osx_settings, false, "Front Row was a media center software application for Apple's Macintosh computers and Apple TV for navigating and viewing video, photos, podcasts, and music from a computer, optical disc, or the Internet through a 10-foot user interface (similar to Windows Media Center and Boxee). This recipe disables Front Row software.")
    update_pivotal_workstation_recipe("dock_preferences", :osx_settings, false, "This recipe sets the dock preferences as left orientated and auto hide option to true as default.")
    update_pivotal_workstation_recipe("dropbox", :general_software, true, "Dropbox is a free service that lets you bring your photos, docs, and videos anywhere and share them easily.")
    update_pivotal_workstation_recipe("ec2_api_tools", :command_line_tools, false, "The EC2 API tools serve as the client interface to the Amazon EC2 web service. This recipe installs EC2 API tools on Mac OS X and includes the 'ec2_tools' action from the bash profile.")
    update_pivotal_workstation_recipe("enable_assistive_devices", :osx_settings, true, "This recipe turns on 'Assistive devices' from the system preferences.")
    update_pivotal_workstation_recipe("erlang", :development_stack, false)
    update_pivotal_workstation_recipe("evernote", :general_software, false)
    update_pivotal_workstation_recipe("finder_display_full_path", :osx_settings, false, "The Finder in OS X Lion provides access to files and folders. This recipe sets finder to show full path in title bar.")
    update_pivotal_workstation_recipe("firefox", :general_software, true, "Mozilla Firefox is a free and open source web browser developed for Microsoft Windows, Mac OS X, and Linux coordinated by Mozilla Corporation and Mozilla Foundation.")
    update_pivotal_workstation_recipe("flycut", :general_software, true, "Flycut is a clipboard manager for Mac systems.")
    update_pivotal_workstation_recipe("freeruler", :general_software, false, "Free Ruler is a free screen ruler for Mac OS X.")
    update_pivotal_workstation_recipe("function_keys", :osx_settings, true, "This recipe maps the function key action to default function key actions to the OS.")
    update_pivotal_workstation_recipe("gem_no_rdoc_no_ri", :etc, true, "This recipe sets the preference for installing a gem package without rdoc and ri.")
    update_pivotal_workstation_recipe("git", :source_control, true, "Git is a distributed revision control and source code management system with an emphasis on speed.")
    update_pivotal_workstation_recipe("git_config_global_defaults", :source_control, true, "This recipe sets a global git ignore, aliases (st for status, di for diff, co for checkout, ci for commit, br for branch, sta for stash, llog for log --date=local), no warning for whitespace, colors, and also branch auto setup merge as true.")
    update_pivotal_workstation_recipe("git_projects", :source_control, false, "This recipe clones all the git projects to workspace of the current user.")
    update_pivotal_workstation_recipe("git_scripts", :source_control, true, "This recipe downloads git_scripts to '/usr/local/bin' of current user.")
    update_pivotal_workstation_recipe("github_for_mac", :source_control, true, "Github for Mac is a software to make code sharing easy with github.")
    update_pivotal_workstation_recipe("github_ssh_keys", :pivotal_labs, false, "This recipe creates SSH keys and adds 'github.com' to the list of known hosts if not added already. It also tries to add the created SSH keys to the github.com of possible.")
    update_pivotal_workstation_recipe("gitx", :source_control, true, "GitX is a git GUI made for Mac OS X. It currently features a history viewer much like gitk and a commit GUI like git gui.")
    update_pivotal_workstation_recipe("global_environment_variables", :etc, true, "This recipe sets global environment path to include /usr/local/bin, /usr/bin, /bin, /usr/sbin, /sbin, and /usr/X11/bin")
    update_pivotal_workstation_recipe("google_chrome_prevent_updates", :etc, false, "This recipe prevent Chrome from updating by preventing writability of update directory.")
    update_pivotal_workstation_recipe("grid", :general_software, false, "Grid is a software which allows networked computers to contribute to a single task.")
    update_pivotal_workstation_recipe("homebrew", :command_line_tools, true, "Homebrew is a package management system that simplifies the installation of software on the Mac OS X operating system.")
    update_pivotal_workstation_recipe("imagemagick", :development_stack, true, "ImageMagick is an open source software suite for displaying, converting, and editing image files. It can read and write over 100 image file formats.")
    update_pivotal_workstation_recipe("increase_shared_memory", :etc, true, "SHMMAX and SHMALL are two key shared memory parameters that directly impact's the way by which an SGA(Systm Global Area) is created. This recipe sets shmall to 65536 bytes and shmmax to 16777216 bytes")
    update_pivotal_workstation_recipe("input_on_login", :osx_settings, false, "This recipe sets preferences to show input menu on the login screen.")
    update_pivotal_workstation_recipe("inputrc", :etc, true, "This recipe enables to edit the default keybindings by editing inputrc file.")
    update_pivotal_workstation_recipe("intellij_community_edition", :text_editors, false, "IntelliJ IDEA is a commercial Java IDE by JetBrains.")
    update_pivotal_workstation_recipe("intellij_ultimate_edition", :text_editors, false, "IntelliJ IDEA is a commercial Java IDE by JetBrains.")
    update_pivotal_workstation_recipe("iterm2", :command_line_tools, true, "iTerm2 is a replacement for Terminal and the successor to iTerm.")
    update_pivotal_workstation_recipe("java", :development_stack, true, "Java is a programming language which derives much of its syntax from C and C++ but has a simpler object model and fewer low-level facilities than either C or C++.")
    update_pivotal_workstation_recipe("joe", :text_editors, false, "Joe is an easy to use command line editor for Mac OS X.")
    update_pivotal_workstation_recipe("jumpcut", :command_line_tools, false, "Jumpcut is an application that provides 'clipboard buffering' that is, access to text that you've cut or copied, even if you've subsequently cut or copied something else. The goal of Jumpcut's interface is to provide quick, natural, intuitive access to your clipboard's history.")
    update_pivotal_workstation_recipe("keyboard_preferences", :osx_settings, true, "This recipe enables full keyboard access for all controls, so you can navigate through the UI using keyboard")
    update_pivotal_workstation_recipe("keycastr", :general_software, true, "KeyCastr, an open-source keystroke visualizer for Mac OS X.")
    update_pivotal_workstation_recipe("libreoffice", :general_software, false, "LibreOffice is the power-packed free, libre and open source personal productivity suite for Windows, Macintosh and GNU/Linux, that gives six feature-rich applications for all document production and data processing needs: Writer, Calc, Impress, Draw, Math and Base.")
    update_pivotal_workstation_recipe("lion_basedev", :pivotal_labs, false, "This recipe includes all base recipes for Mac OS X 10.8 referred to as 'Mountain Lion'.")
    update_pivotal_workstation_recipe("locate_on", :etc, true, "This recipe checks and loads locate, which indexes the filesystem")
    update_pivotal_workstation_recipe("memcached", :development_stack, false, "Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.")
    update_pivotal_workstation_recipe("menubar_preferences", :osx_settings, true, "This recipe disables the default Apple Menubar transparency (ref:  http://knoopx.net/2011/10/28/os-x-lion-tweaks )")
    update_pivotal_workstation_recipe("menumeters", :general_software, true, "MenuMeters is a set of CPU, memory, disk, and network monitoring tools for Mac OS X. This recipe installs MenuMeter and adds that to the preferences panes next to the clock.")
    update_pivotal_workstation_recipe("meta_osx_base", :pivotal_labs, false)
    update_pivotal_workstation_recipe("meta_osx_development", :pivotal_labs, false)
    update_pivotal_workstation_recipe("meta_pivotal_lion_image", :pivotal_labs, false)
    update_pivotal_workstation_recipe("meta_pivotal_specifics", :pivotal_labs, false)
    update_pivotal_workstation_recipe("meta_ruby_development", :pivotal_labs, false)
    update_pivotal_workstation_recipe("mongodb", :databases, false, "MongoDB is part of the NoSQL family of database systems. Instead of storing data in tables as is done in a 'classical' relational database, MongoDB stores structured data as JSON-like documents with dynamic schemas (MongoDB calls the format BSON), making the integration of data in certain types of applications easier and faster.This recipe installs mongodb, add it to the preference pane and adds it to the startup")
    update_pivotal_workstation_recipe("mouse_locator", :general_software, true, "Mouse Locator is a simple preference add-on that can be either triggered by a keystroke or always enabled, it creates a green crosshair of sorts around the cursor making it easy to identify on screen. This recipe installs & activates MouseLocator and adds it to preference pane")
    update_pivotal_workstation_recipe("mysql", :databases, true, "MySQL is an open source database management system and is used in some of the most frequently visited websites on the Internet.This recipe installs mysql db and sets up the timezone info in db if not set.")
    update_pivotal_workstation_recipe("nginx", :development_stack, false, "Nginx is an open source Web server and a reverse proxy server for HTTP, SMTP, POP3 and IMAP protocols, with a strong focus on high concurrency, performance and low memory usage.Many ruby web frameworks runs on this.This recipe brew installs nginx and copies the nginx.config template to the nginx configuration path")
    update_pivotal_workstation_recipe("node_js", :development_stack, true, "Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices.This recipe installs node.js through npm, which is downloaded from git and compiled")
    update_pivotal_workstation_recipe("oh_my_zsh", :command_line_tools, false)
    update_pivotal_workstation_recipe("osx_updates", :etc, false, "This recipe checks and installs all available osx update from apple")
    update_pivotal_workstation_recipe("pg_admin", :general_software, false, "pgAdmin is the leading graphical Open Source management, development and administration tool for PostgreSQL.")
    update_pivotal_workstation_recipe("pivotal_logos", :pivotal_labs, false, "This recipe changes the pivotal backgrounds, logos and colors to make the application logos less intrusive to the user")
    update_pivotal_workstation_recipe("postgres", :databases, true, " PostgreSQL, often simply Postgres, is an object-relational database management system (ORDBMS) available for many platforms including Linux, FreeBSD, Solaris, Microsoft Windows and Mac OS X.  This recipe installs postgres and add it to startup. creates the default db with user 'postgres'")
    update_pivotal_workstation_recipe("propane", :general_software, false)
    update_pivotal_workstation_recipe("qt", :development_stack, true, "Qt is a cross-platform application framework that is widely used for developing application software with a graphical user interface (GUI) (in which cases Qt is classified as a widget toolkit), and also used for developing non-GUI programs such as command-line tools and consoles for servers.")
    update_pivotal_workstation_recipe("rabbitmq", :development_stack, false, "RabbitMQ is open source message broker software (message-oriented middleware) that implements the Advanced Message Queuing Protocol standard. It is written in Erlang.")
    update_pivotal_workstation_recipe("rbenv", :command_line_tools, false, "rbenv lets you easily switch between multiple versions of Ruby. It's simple, unobtrusive, and follows the UNIX tradition of single-purpose tools that do one thing well. This recipe packages rbenv and configures all the existing versions with options and sets the default version of ruby to be used.")
    update_pivotal_workstation_recipe("redis", :development_stack, false, "Redis is an open-source, networked, in-memory, key-value data store with optional durability. This recipe installs redis and adds it to the startup.")
    update_pivotal_workstation_recipe("remove_expose_keyboard_shortcuts", :osx_settings, false, "This recipe removes the expose keyboard shortcuts in the system preference.")
    update_pivotal_workstation_recipe("remove_garageband", :osx_settings, false, "GarageBand is a multitrack recording application using which you can record real audio pieces, play with software instruments, create parts using Apple Loops, add effects, mix your music and play it all back with iTunes or include in your iMovies.. This recipe removes the garageband app.")
    update_pivotal_workstation_recipe("rename_machine", :pivotal_labs, false, "This recipe rename the machine with set of hostnames given in the preference.")
    update_pivotal_workstation_recipe("rubymine", :text_editors, true, "RubyMine is an IDE which provides intelligent code completion for Ruby and Ruby on Rails code, on-the-fly code analysis and refactoring support for both plain Ruby projects and web applications built with Ruby on Rails.")
    update_pivotal_workstation_recipe("rubymine_preferences_pivotal", :text_editors, true, "This recipe configures the rubymine with the keymaps and templates included.")
    update_pivotal_workstation_recipe("rvm", :command_line_tools, true, "Ruby Version Manager known as RVM is a Unix software platform that can be used to manage multiple installations of Ruby on the same device.This recipe installs rvm and the ruby version specified. It also sets the default ruby version to be used")
    update_pivotal_workstation_recipe("safari_preferences", :osx_settings, false, "This recipe sets a preference in safari browser to show the status bar.")
    update_pivotal_workstation_recipe("screen_sharing_app", :general_software, true, "ScreenSharing app lets you to share your Desktop screen with the remote machines.")
    update_pivotal_workstation_recipe("screen_sharing_on", :osx_settings, false, "This recipe configures the vnc port for screen sharing and checks for screen sharing enabled.")
    update_pivotal_workstation_recipe("selenium_webdriver", :development_stack, false, "Selenium is a portable software testing framework for web applications. Selenium provides a record/playback tool for authoring tests without learning a test scripting language (Selenium IDE).  This recipe installs seleium webdriver and configure it with chromium web browser.")
    update_pivotal_workstation_recipe("set_finder_show_all_hd_on_desktop", :osx_settings, false, "This recipe sets the preference to show the internal and external harddrives, removable media on desktop")
    update_pivotal_workstation_recipe("set_finder_show_hd_on_desktop", :osx_settings, false, "This recipe sets the preference to show the internal  hard drives on desktop")
    update_pivotal_workstation_recipe("set_finder_show_user_home_in_sidebar", :osx_settings, false, "This recipe sets the preference to show user home in the sidebar")
    update_pivotal_workstation_recipe("set_multitouch_preferences", :osx_settings, false, "This recipe sets the preference for multitouch, allowing  clicking and dragging by touch")
    update_pivotal_workstation_recipe("set_screensaver_preferences", :osx_settings, false, "This recipe sets preferences for screensaver like displaying screensaver, locking screen, asking password if the screen is locked and timeout for display, disk and computer sleep times.")
    update_pivotal_workstation_recipe("shiftit", :general_software, false, "ShiftIt is an application for OSX that allows you to quickly manipulate window position and size using keyboard shortcuts. This recipe installs ShiftIt on the system and adds it to Auto Launch Application directory.")
    update_pivotal_workstation_recipe("sizeup", :general_software, true, "Size up is a window management software for Mac OS X. This recipe installs Size up and enables assistive services by default.")
    update_pivotal_workstation_recipe("skype", :general_software, true, "Skype is a proprietary voice-over-Internet Protocol service and software application. The service allows users to communicate with peers by voice, video, and instant messaging over the Internet and Phone calls may be placed to recipients on the traditional telephone networks.")
    update_pivotal_workstation_recipe("snmpd", :development_stack, false, "snmpd is an SNMP(Simple Network Management Protocol) agent which binds to a port and awaits requests from SNMP management software. This recipe launches snmpd daemon.")
    update_pivotal_workstation_recipe("solr", :development_stack, false, "Solr is an open source enterprise search platform from the Apache.  Its major features include powerful full-text search, hit highlighting, faceted search, dynamic clustering, database integration, and rich document handling. Providing distributed search and index replication, Solr is highly scalable.")
    update_pivotal_workstation_recipe("ssh_copy_id", :etc, false, "ssh-copy-id is a script that uses ssh to log into a remote machine presumably using a login password, so password authentication should be enabled.  This recipe installs ssh-copy-id")
    update_pivotal_workstation_recipe("sshd_on", :command_line_tools, true, "sshd is the daemon program for ssh.Together these programs replace rlogin and rsh, and provide secure encrypted communications between two untrusted hosts over an insecure network. This recipe turns on sshd daemon.")
    update_pivotal_workstation_recipe("ssl_certificate", :etc, false, "This recipe creates ssl certificates and adds it to the list of trusted certificates.")
    update_pivotal_workstation_recipe("sublime_text", :text_editors, false)
    update_pivotal_workstation_recipe("svn", :source_control, false, "Apache Subversion (SVN) is a software versioning and revision control system distributed under an open source license.")
    update_pivotal_workstation_recipe("terminal_focus", :osx_settings, false, "FocusFollowsMouse is where the focus automatically follows the current placement of the pointer. This recipe enables FocusFollowsMouse for terminal.")
    update_pivotal_workstation_recipe("terminal_preferences", :osx_settings, false, "This recipe sets preferences for terminal color scheme and startup terminal color scheme.")
    update_pivotal_workstation_recipe("textmate", :text_editors, true, "TextMate is a general-purpose GUI text editor for Mac OS X created by Allan Odgaard. Notable features include declarative customizations, tabs for open documents, recordable macros, folding sections and snippets, shell integration, and an extensible bundle system.")
    update_pivotal_workstation_recipe("textmate_bundles", :text_editors, true, "This recipe downloads textmate bundles from http://cheffiles.pivotallabs.com/Pivotal.tmbundle.tar.gz and installs from the source")
    update_pivotal_workstation_recipe("textmate_plugins", :text_editors, false, "ProjectPlus is a plug-in for TextMate which extends the functionality of project-related features. This recipe adds ProjectPlus plug-in to textmate.")
    update_pivotal_workstation_recipe("textmate_preferences", :text_editors, true, "This recipe set textmate preference like show linenumbers, tabspace, save on losing focus, soft tabs")
    update_pivotal_workstation_recipe("timemachine_preferences", :osx_settings, false, "This recipe removes the timemachine from system tray and stops it from asking new disk space for backup")
    update_pivotal_workstation_recipe("tmux", :command_line_tools, true, "tmux is a software application that can be used to multiplex several virtual consoles, allowing a user to access multiple separate terminal sessions inside a single terminal window or remote terminal session. This recipe installs tmux and adds the tmux config file.")
    update_pivotal_workstation_recipe("unix_essentials", :command_line_tools, true, "This recipe installs the basic unix essentials like wget, pstree, tree, watch, ssh-copy-id")
    update_pivotal_workstation_recipe("user_owns_usr_local", :etc, true, "This recipe changes the owner of the '/usr/local' to WS_User")
    update_pivotal_workstation_recipe("vagrant", :general_software, false, "Vagrant enables a user to create and configure lightweight, reproducible, and portable virtualized development environments. This recipe installs Vagrant on the system.")
    update_pivotal_workstation_recipe("vim", :text_editors, true, "Based on the vi editor common to Unix-like systems, Vim is designed for use both from a command line interface and as a standalone application in a graphical user interface. This recipe installs vim and macvim.")
    update_pivotal_workstation_recipe("virtualbox", :general_software, true, "VirtualBox is installed on an existing host operating system as an application; this host application allows additional guest operating systems, each known as a Guest OS, to be loaded and run, each with its own virtual environment.")
    update_pivotal_workstation_recipe("window_focus", :osx_settings, false, "FocusFollowsMouse is where the focus automatically follows the current placement of the pointer. This recipe enables FocusFollowsMouse for X11 windows.")
    update_pivotal_workstation_recipe("workspace_directory", :etc, true, "This recipe creates workspace directory inside current user's home directory.")
    update_pivotal_workstation_recipe("xquartz", :general_software, true, "The XQuartz project is an open-source effort to develop a version of the X.Org X Window System that runs on OS X.")
    update_pivotal_workstation_recipe("zsh", :command_line_tools, false, "The Z shell (zsh) is a Unix shell that can be used as an interactive login shell and as a powerful command interpreter for shell scripting.")
  end

  desc "clean_all_tables", "Empty out all of the tables"
  def clean_all_tables
    SoloistScript.destroy_all
    Recipe.destroy_all
    RecipeGroup.destroy_all
  end


  # "no_tasks" denotes a ruby method which isn't a thor task
  #   ie, they can't be called from the command line, but they can be tested independently
  no_tasks do
    def create_pivotal_workstation_recipe_group(name_code, position, description = nil)
      recipe_group = RecipeGroup.find_or_initialize_by_name(RecipeGroup::NAMES[name_code])
      recipe_group.update_attributes! :position => position, :description => description
      recipe_group
    end

    def update_pivotal_workstation_recipe(name, recipe_group_name_code, checked_by_default, description = nil)
      recipe = Recipe.find_by_name(name)
      recipe_group = RecipeGroup.find_by_name(RecipeGroup::NAMES[recipe_group_name_code])

      if recipe.present? && recipe_group.present?
        recipe.update_attributes! :recipe_group => recipe_group, :checked_by_default => checked_by_default, :description => description
      end
    end
  end

end
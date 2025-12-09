  Complete MCP Tools Reference

  filesystem - File operations

  | Tool                      | Description                  |
  |---------------------------|------------------------------|
  | read_file                 | Read file contents           |
  | read_text_file            | Read text file with encoding |
  | read_media_file           | Read image/audio as base64   |
  | read_multiple_files       | Batch read files             |
  | write_file                | Create/overwrite file        |
  | edit_file                 | Line-based text edits        |
  | create_directory          | Create nested directories    |
  | list_directory            | List dir with [FILE]/[DIR]   |
  | list_directory_with_sizes | List dir + sizes             |
  | directory_tree            | Recursive JSON tree          |
  | move_file                 | Move/rename files            |
  | search_files              | Glob pattern search          |
  | get_file_info             | File metadata                |
  | list_allowed_directories  | Show accessible dirs         |

  memory - Knowledge graph

  | Tool                | Description            |
  |---------------------|------------------------|
  | create_entities     | Add entities to graph  |
  | create_relations    | Link entities together |
  | add_observations    | Add facts to entities  |
  | delete_entities     | Remove entities        |
  | delete_observations | Remove facts           |
  | delete_relations    | Remove links           |
  | read_graph          | Get full graph         |
  | search_nodes        | Query entities         |
  | open_nodes          | Get entities by name   |

  git - Version control

  | Tool              | Description           |
  |-------------------|-----------------------|
  | git_status        | Working tree status   |
  | git_diff_unstaged | Unstaged changes      |
  | git_diff_staged   | Staged changes        |
  | git_diff          | Diff branches/commits |
  | git_commit        | Create commit         |
  | git_add           | Stage files           |
  | git_reset         | Unstage all           |
  | git_log           | Show commit history   |
  | git_create_branch | New branch            |
  | git_checkout      | Switch branch         |
  | git_show          | Show commit contents  |
  | git_branch        | List branches         |

  time - Time utilities

  | Tool             | Description               |
  |------------------|---------------------------|
  | get_current_time | Time in timezone          |
  | convert_time     | Convert between timezones |

  fetch - Web fetching

  | Tool  | Description           |
  |-------|-----------------------|
  | fetch | Fetch URL as markdown |

  sequential-thinking - Reasoning

  | Tool               | Description                        |
  |--------------------|------------------------------------|
  | sequentialthinking | Multi-step reasoning with revision |

  repomix - Codebase analysis

  | Tool                       | Description               |
  |----------------------------|---------------------------|
  | pack_codebase              | Package local code to XML |
  | pack_remote_repository     | Clone+pack GitHub repo    |
  | attach_packed_output       | Load existing pack        |
  | read_repomix_output        | Read pack by lines        |
  | grep_repomix_output        | Search in packed code     |
  | file_system_read_file      | Read file (secure)        |
  | file_system_read_directory | List dir contents         |

  playwright - Browser automation

  | Tool                     | Description                      |
  |--------------------------|----------------------------------|
  | browser_navigate         | Go to URL                        |
  | browser_click            | Click element                    |
  | browser_type             | Type text                        |
  | browser_snapshot         | Accessibility tree (prefer this) |
  | browser_take_screenshot  | Visual screenshot                |
  | browser_fill_form        | Fill multiple fields             |
  | browser_select_option    | Dropdown selection               |
  | browser_hover            | Hover element                    |
  | browser_drag             | Drag and drop                    |
  | browser_press_key        | Keyboard input                   |
  | browser_evaluate         | Run JS on page                   |
  | browser_tabs             | Manage tabs                      |
  | browser_wait_for         | Wait for text/time               |
  | browser_console_messages | Get console logs                 |
  | browser_network_requests | Get network traffic              |
  | browser_handle_dialog    | Accept/dismiss dialogs           |
  | browser_file_upload      | Upload files                     |
  | browser_resize           | Resize window                    |
  | browser_navigate_back    | Go back                          |
  | browser_run_code         | Run Playwright code              |
  | browser_install          | Install browser                  |
  | browser_close            | Close page                       |

  chrome-devtools - DevTools control

  | Tool                        | Description              |
  |-----------------------------|--------------------------|
  | take_snapshot               | A11y tree snapshot       |
  | take_screenshot             | Visual capture           |
  | click                       | Click by uid             |
  | fill                        | Input text               |
  | fill_form                   | Fill multiple inputs     |
  | hover                       | Hover element            |
  | drag                        | Drag element             |
  | press_key                   | Keyboard combo           |
  | navigate_page               | URL/back/forward/reload  |
  | new_page                    | Open new tab             |
  | close_page                  | Close tab                |
  | select_page                 | Switch tab focus         |
  | list_pages                  | Show all tabs            |
  | resize_page                 | Set dimensions           |
  | wait_for                    | Wait for text            |
  | handle_dialog               | Accept/dismiss popup     |
  | upload_file                 | File input               |
  | evaluate_script             | Run JS                   |
  | emulate                     | Network/CPU/geo throttle |
  | list_console_messages       | Console logs             |
  | get_console_message         | Get log by ID            |
  | list_network_requests       | Network traffic          |
  | get_network_request         | Request details          |
  | performance_start_trace     | Start perf trace         |
  | performance_stop_trace      | Stop trace               |
  | performance_analyze_insight | Get CWV insights         |

  context7 - Library docs

  | Tool               | Description        |
  |--------------------|--------------------|
  | resolve-library-id | Find library ID    |
  | get-library-docs   | Fetch current docs |

  exa - AI web search

  | Tool                 | Description             |
  |----------------------|-------------------------|
  | web_search_exa       | Real-time web search    |
  | get_code_context_exa | Code/SDK context search |

  voicemode - Voice I/O

  | Tool     | Description                   |
  |----------|-------------------------------|
  | converse | Speak + listen                |
  | service  | Manage whisper/kokoro/livekit |

  use-latest-version - Package versions

  | Tool                    | Description              |
  |-------------------------|--------------------------|
  | get_latest_version      | Get latest pkg version   |
  | get_package_info        | Full pkg metadata        |
  | get_install_command     | Install cmd with version |
  | compare_versions        | Check if update needed   |
  | check_multiple_packages | Batch version check      |

  docker-compose - Container management (~66 tools)

  | Category       | Tools                                                 |
  |----------------|-------------------------------------------------------|
  | Lifecycle (7)  | up, down, start, stop, restart, pause, unpause        |
  | Build (5)      | build, pull, push, images, create                     |
  | Exec (6)       | exec, run, attach, copy, top, wait                    |
  | Logs (5)       | logs, follow, tail, grep, export                      |
  | Config (6)     | config, validate, convert, env, version, ps           |
  | Network (8)    | network create/rm/ls/inspect/connect/disconnect/prune |
  | Volume (8)     | volume create/rm/ls/inspect/prune/backup/restore      |
  | Health (6)     | healthcheck, status, events, port, dependencies       |
  | Monitoring (7) | stats, resources, alerts, metrics, dashboard          |
  | Validation (2) | lint, security-scan                                   |
  | Generation (1) | generate-compose                                      |
  | Debugging (5)  | debug, shell, inspect, diff, rollback                 |

  indentation - Code formatting fix

  | Tool                    | Description                 |
  |-------------------------|-----------------------------|
  | rescue_indentation      | Auto-fix broken indentation |
  | diagnose_indentation    | Analyze indent problems     |
  | fix_project_indentation | Batch fix directory         |
  | smart_analyze           | AI indent analysis          |
  | validate_file           | Check indent validity       |

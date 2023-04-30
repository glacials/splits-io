# coding: utf-8
require 'ffi'

module LiveSplitCore
    module Native
        extend FFI::Library
        ffi_lib File.expand_path('../liblivesplit_core.so', __FILE__)
    
        attach_function :Analysis_calculate_sum_of_best, [:pointer, :bool, :bool, :uint8], :pointer
        attach_function :Analysis_calculate_total_playtime_for_run, [:pointer], :pointer
        attach_function :Analysis_calculate_total_playtime_for_timer, [:pointer], :pointer
        attach_function :AtomicDateTime_drop, [:pointer], :void
        attach_function :AtomicDateTime_is_synchronized, [:pointer], :bool
        attach_function :AtomicDateTime_to_rfc3339, [:pointer], :string
        attach_function :Attempt_index, [:pointer], :int32
        attach_function :Attempt_time, [:pointer], :pointer
        attach_function :Attempt_pause_time, [:pointer], :pointer
        attach_function :Attempt_started, [:pointer], :pointer
        attach_function :Attempt_ended, [:pointer], :pointer
        attach_function :AutoSplittingRuntime_new, [:pointer], :pointer
        attach_function :AutoSplittingRuntime_drop, [:pointer], :void
        attach_function :AutoSplittingRuntime_load_script, [:pointer, :string], :bool
        attach_function :AutoSplittingRuntime_unload_script, [:pointer], :bool
        attach_function :BlankSpaceComponent_new, [], :pointer
        attach_function :BlankSpaceComponent_drop, [:pointer], :void
        attach_function :BlankSpaceComponent_into_generic, [:pointer], :pointer
        attach_function :BlankSpaceComponent_state_as_json, [:pointer], :string
        attach_function :BlankSpaceComponent_state, [:pointer], :pointer
        attach_function :BlankSpaceComponentState_drop, [:pointer], :void
        attach_function :BlankSpaceComponentState_size, [:pointer], :uint32
        attach_function :Component_drop, [:pointer], :void
        attach_function :CurrentComparisonComponent_new, [], :pointer
        attach_function :CurrentComparisonComponent_drop, [:pointer], :void
        attach_function :CurrentComparisonComponent_into_generic, [:pointer], :pointer
        attach_function :CurrentComparisonComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :CurrentComparisonComponent_state, [:pointer, :pointer], :pointer
        attach_function :CurrentPaceComponent_new, [], :pointer
        attach_function :CurrentPaceComponent_drop, [:pointer], :void
        attach_function :CurrentPaceComponent_into_generic, [:pointer], :pointer
        attach_function :CurrentPaceComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :CurrentPaceComponent_state, [:pointer, :pointer], :pointer
        attach_function :DeltaComponent_new, [], :pointer
        attach_function :DeltaComponent_drop, [:pointer], :void
        attach_function :DeltaComponent_into_generic, [:pointer], :pointer
        attach_function :DeltaComponent_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :DeltaComponent_state, [:pointer, :pointer, :pointer], :pointer
        attach_function :DetailedTimerComponent_new, [], :pointer
        attach_function :DetailedTimerComponent_drop, [:pointer], :void
        attach_function :DetailedTimerComponent_into_generic, [:pointer], :pointer
        attach_function :DetailedTimerComponent_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :DetailedTimerComponent_state, [:pointer, :pointer, :pointer], :pointer
        attach_function :DetailedTimerComponentState_drop, [:pointer], :void
        attach_function :DetailedTimerComponentState_timer_time, [:pointer], :string
        attach_function :DetailedTimerComponentState_timer_fraction, [:pointer], :string
        attach_function :DetailedTimerComponentState_timer_semantic_color, [:pointer], :string
        attach_function :DetailedTimerComponentState_segment_timer_time, [:pointer], :string
        attach_function :DetailedTimerComponentState_segment_timer_fraction, [:pointer], :string
        attach_function :DetailedTimerComponentState_comparison1_visible, [:pointer], :bool
        attach_function :DetailedTimerComponentState_comparison1_name, [:pointer], :string
        attach_function :DetailedTimerComponentState_comparison1_time, [:pointer], :string
        attach_function :DetailedTimerComponentState_comparison2_visible, [:pointer], :bool
        attach_function :DetailedTimerComponentState_comparison2_name, [:pointer], :string
        attach_function :DetailedTimerComponentState_comparison2_time, [:pointer], :string
        attach_function :DetailedTimerComponentState_icon_change_ptr, [:pointer], :pointer
        attach_function :DetailedTimerComponentState_icon_change_len, [:pointer], :size_t
        attach_function :DetailedTimerComponentState_segment_name, [:pointer], :string
        attach_function :FuzzyList_new, [], :pointer
        attach_function :FuzzyList_drop, [:pointer], :void
        attach_function :FuzzyList_search, [:pointer, :string, :size_t], :string
        attach_function :FuzzyList_push, [:pointer, :string], :void
        attach_function :GeneralLayoutSettings_default, [], :pointer
        attach_function :GeneralLayoutSettings_drop, [:pointer], :void
        attach_function :GraphComponent_new, [], :pointer
        attach_function :GraphComponent_drop, [:pointer], :void
        attach_function :GraphComponent_into_generic, [:pointer], :pointer
        attach_function :GraphComponent_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :GraphComponent_state, [:pointer, :pointer, :pointer], :pointer
        attach_function :GraphComponentState_drop, [:pointer], :void
        attach_function :GraphComponentState_points_len, [:pointer], :size_t
        attach_function :GraphComponentState_point_x, [:pointer, :size_t], :float
        attach_function :GraphComponentState_point_y, [:pointer, :size_t], :float
        attach_function :GraphComponentState_point_is_best_segment, [:pointer, :size_t], :bool
        attach_function :GraphComponentState_horizontal_grid_lines_len, [:pointer], :size_t
        attach_function :GraphComponentState_horizontal_grid_line, [:pointer, :size_t], :float
        attach_function :GraphComponentState_vertical_grid_lines_len, [:pointer], :size_t
        attach_function :GraphComponentState_vertical_grid_line, [:pointer, :size_t], :float
        attach_function :GraphComponentState_middle, [:pointer], :float
        attach_function :GraphComponentState_is_live_delta_active, [:pointer], :bool
        attach_function :GraphComponentState_is_flipped, [:pointer], :bool
        attach_function :HotkeyConfig_new, [], :pointer
        attach_function :HotkeyConfig_parse_json, [:string], :pointer
        attach_function :HotkeyConfig_parse_file_handle, [:int64], :pointer
        attach_function :HotkeyConfig_drop, [:pointer], :void
        attach_function :HotkeyConfig_settings_description_as_json, [:pointer], :string
        attach_function :HotkeyConfig_as_json, [:pointer], :string
        attach_function :HotkeyConfig_set_value, [:pointer, :size_t, :pointer], :bool
        attach_function :HotkeySystem_new, [:pointer], :pointer
        attach_function :HotkeySystem_with_config, [:pointer, :pointer], :pointer
        attach_function :HotkeySystem_drop, [:pointer], :void
        attach_function :HotkeySystem_config, [:pointer], :pointer
        attach_function :HotkeySystem_resolve, [:pointer, :string], :string
        attach_function :HotkeySystem_deactivate, [:pointer], :bool
        attach_function :HotkeySystem_activate, [:pointer], :bool
        attach_function :HotkeySystem_set_config, [:pointer, :pointer], :bool
        attach_function :KeyValueComponentState_drop, [:pointer], :void
        attach_function :KeyValueComponentState_key, [:pointer], :string
        attach_function :KeyValueComponentState_value, [:pointer], :string
        attach_function :KeyValueComponentState_semantic_color, [:pointer], :string
        attach_function :Layout_new, [], :pointer
        attach_function :Layout_default_layout, [], :pointer
        attach_function :Layout_parse_json, [:string], :pointer
        attach_function :Layout_parse_file_handle, [:int64], :pointer
        attach_function :Layout_parse_original_livesplit, [:pointer, :size_t], :pointer
        attach_function :Layout_drop, [:pointer], :void
        attach_function :Layout_clone, [:pointer], :pointer
        attach_function :Layout_settings_as_json, [:pointer], :string
        attach_function :Layout_state, [:pointer, :pointer], :pointer
        attach_function :Layout_update_state, [:pointer, :pointer, :pointer], :void
        attach_function :Layout_update_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :Layout_state_as_json, [:pointer, :pointer], :string
        attach_function :Layout_push, [:pointer, :pointer], :void
        attach_function :Layout_scroll_up, [:pointer], :void
        attach_function :Layout_scroll_down, [:pointer], :void
        attach_function :Layout_remount, [:pointer], :void
        attach_function :LayoutEditor_new, [:pointer], :pointer
        attach_function :LayoutEditor_close, [:pointer], :pointer
        attach_function :LayoutEditor_state_as_json, [:pointer], :string
        attach_function :LayoutEditor_state, [:pointer], :pointer
        attach_function :LayoutEditor_layout_state_as_json, [:pointer, :pointer], :string
        attach_function :LayoutEditor_update_layout_state, [:pointer, :pointer, :pointer], :void
        attach_function :LayoutEditor_update_layout_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :LayoutEditor_select, [:pointer, :size_t], :void
        attach_function :LayoutEditor_add_component, [:pointer, :pointer], :void
        attach_function :LayoutEditor_remove_component, [:pointer], :void
        attach_function :LayoutEditor_move_component_up, [:pointer], :void
        attach_function :LayoutEditor_move_component_down, [:pointer], :void
        attach_function :LayoutEditor_move_component, [:pointer, :size_t], :void
        attach_function :LayoutEditor_duplicate_component, [:pointer], :void
        attach_function :LayoutEditor_set_component_settings_value, [:pointer, :size_t, :pointer], :void
        attach_function :LayoutEditor_set_general_settings_value, [:pointer, :size_t, :pointer], :void
        attach_function :LayoutEditorState_drop, [:pointer], :void
        attach_function :LayoutEditorState_component_len, [:pointer], :size_t
        attach_function :LayoutEditorState_component_text, [:pointer, :size_t], :string
        attach_function :LayoutEditorState_buttons, [:pointer], :uint8
        attach_function :LayoutEditorState_selected_component, [:pointer], :uint32
        attach_function :LayoutEditorState_field_len, [:pointer, :bool], :size_t
        attach_function :LayoutEditorState_field_text, [:pointer, :bool, :size_t], :string
        attach_function :LayoutEditorState_field_value, [:pointer, :bool, :size_t], :pointer
        attach_function :LayoutState_new, [], :pointer
        attach_function :LayoutState_drop, [:pointer], :void
        attach_function :LayoutState_as_json, [:pointer], :string
        attach_function :LayoutState_len, [:pointer], :size_t
        attach_function :LayoutState_component_type, [:pointer, :size_t], :string
        attach_function :LayoutState_component_as_blank_space, [:pointer, :size_t], :pointer
        attach_function :LayoutState_component_as_detailed_timer, [:pointer, :size_t], :pointer
        attach_function :LayoutState_component_as_graph, [:pointer, :size_t], :pointer
        attach_function :LayoutState_component_as_key_value, [:pointer, :size_t], :pointer
        attach_function :LayoutState_component_as_separator, [:pointer, :size_t], :pointer
        attach_function :LayoutState_component_as_splits, [:pointer, :size_t], :pointer
        attach_function :LayoutState_component_as_text, [:pointer, :size_t], :pointer
        attach_function :LayoutState_component_as_timer, [:pointer, :size_t], :pointer
        attach_function :LayoutState_component_as_title, [:pointer, :size_t], :pointer
        attach_function :ParseRunResult_drop, [:pointer], :void
        attach_function :ParseRunResult_unwrap, [:pointer], :pointer
        attach_function :ParseRunResult_parsed_successfully, [:pointer], :bool
        attach_function :ParseRunResult_timer_kind, [:pointer], :string
        attach_function :ParseRunResult_is_generic_timer, [:pointer], :bool
        attach_function :PbChanceComponent_new, [], :pointer
        attach_function :PbChanceComponent_drop, [:pointer], :void
        attach_function :PbChanceComponent_into_generic, [:pointer], :pointer
        attach_function :PbChanceComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :PbChanceComponent_state, [:pointer, :pointer], :pointer
        attach_function :PossibleTimeSaveComponent_new, [], :pointer
        attach_function :PossibleTimeSaveComponent_drop, [:pointer], :void
        attach_function :PossibleTimeSaveComponent_into_generic, [:pointer], :pointer
        attach_function :PossibleTimeSaveComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :PossibleTimeSaveComponent_state, [:pointer, :pointer], :pointer
        attach_function :PotentialCleanUp_drop, [:pointer], :void
        attach_function :PotentialCleanUp_message, [:pointer], :string
        attach_function :PreviousSegmentComponent_new, [], :pointer
        attach_function :PreviousSegmentComponent_drop, [:pointer], :void
        attach_function :PreviousSegmentComponent_into_generic, [:pointer], :pointer
        attach_function :PreviousSegmentComponent_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :PreviousSegmentComponent_state, [:pointer, :pointer, :pointer], :pointer
        attach_function :Run_new, [], :pointer
        attach_function :Run_parse, [:pointer, :size_t, :string], :pointer
        attach_function :Run_parse_file_handle, [:int64, :string], :pointer
        attach_function :Run_drop, [:pointer], :void
        attach_function :Run_clone, [:pointer], :pointer
        attach_function :Run_game_name, [:pointer], :string
        attach_function :Run_game_icon_ptr, [:pointer], :pointer
        attach_function :Run_game_icon_len, [:pointer], :size_t
        attach_function :Run_category_name, [:pointer], :string
        attach_function :Run_extended_file_name, [:pointer, :bool], :string
        attach_function :Run_extended_name, [:pointer, :bool], :string
        attach_function :Run_extended_category_name, [:pointer, :bool, :bool, :bool], :string
        attach_function :Run_attempt_count, [:pointer], :uint32
        attach_function :Run_metadata, [:pointer], :pointer
        attach_function :Run_offset, [:pointer], :pointer
        attach_function :Run_len, [:pointer], :size_t
        attach_function :Run_has_been_modified, [:pointer], :bool
        attach_function :Run_segment, [:pointer, :size_t], :pointer
        attach_function :Run_attempt_history_len, [:pointer], :size_t
        attach_function :Run_attempt_history_index, [:pointer, :size_t], :pointer
        attach_function :Run_save_as_lss, [:pointer], :string
        attach_function :Run_custom_comparisons_len, [:pointer], :size_t
        attach_function :Run_custom_comparison, [:pointer, :size_t], :string
        attach_function :Run_auto_splitter_settings, [:pointer], :string
        attach_function :Run_push_segment, [:pointer, :pointer], :void
        attach_function :Run_set_game_name, [:pointer, :string], :void
        attach_function :Run_set_category_name, [:pointer, :string], :void
        attach_function :Run_mark_as_modified, [:pointer], :void
        attach_function :RunEditor_new, [:pointer], :pointer
        attach_function :RunEditor_close, [:pointer], :pointer
        attach_function :RunEditor_state_as_json, [:pointer], :string
        attach_function :RunEditor_select_timing_method, [:pointer, :uint8], :void
        attach_function :RunEditor_unselect, [:pointer, :size_t], :void
        attach_function :RunEditor_select_additionally, [:pointer, :size_t], :void
        attach_function :RunEditor_select_only, [:pointer, :size_t], :void
        attach_function :RunEditor_set_game_name, [:pointer, :string], :void
        attach_function :RunEditor_set_category_name, [:pointer, :string], :void
        attach_function :RunEditor_parse_and_set_offset, [:pointer, :string], :bool
        attach_function :RunEditor_parse_and_set_attempt_count, [:pointer, :string], :bool
        attach_function :RunEditor_set_game_icon, [:pointer, :pointer, :size_t], :void
        attach_function :RunEditor_remove_game_icon, [:pointer], :void
        attach_function :RunEditor_set_run_id, [:pointer, :string], :void
        attach_function :RunEditor_set_region_name, [:pointer, :string], :void
        attach_function :RunEditor_set_platform_name, [:pointer, :string], :void
        attach_function :RunEditor_set_emulator_usage, [:pointer, :bool], :void
        attach_function :RunEditor_set_speedrun_com_variable, [:pointer, :string, :string], :void
        attach_function :RunEditor_remove_speedrun_com_variable, [:pointer, :string], :void
        attach_function :RunEditor_add_custom_variable, [:pointer, :string], :void
        attach_function :RunEditor_set_custom_variable, [:pointer, :string, :string], :void
        attach_function :RunEditor_remove_custom_variable, [:pointer, :string], :void
        attach_function :RunEditor_clear_metadata, [:pointer], :void
        attach_function :RunEditor_insert_segment_above, [:pointer], :void
        attach_function :RunEditor_insert_segment_below, [:pointer], :void
        attach_function :RunEditor_remove_segments, [:pointer], :void
        attach_function :RunEditor_move_segments_up, [:pointer], :void
        attach_function :RunEditor_move_segments_down, [:pointer], :void
        attach_function :RunEditor_active_set_icon, [:pointer, :pointer, :size_t], :void
        attach_function :RunEditor_active_remove_icon, [:pointer], :void
        attach_function :RunEditor_active_set_name, [:pointer, :string], :void
        attach_function :RunEditor_active_parse_and_set_split_time, [:pointer, :string], :bool
        attach_function :RunEditor_active_parse_and_set_segment_time, [:pointer, :string], :bool
        attach_function :RunEditor_active_parse_and_set_best_segment_time, [:pointer, :string], :bool
        attach_function :RunEditor_active_parse_and_set_comparison_time, [:pointer, :string, :string], :bool
        attach_function :RunEditor_add_comparison, [:pointer, :string], :bool
        attach_function :RunEditor_import_comparison, [:pointer, :pointer, :string], :bool
        attach_function :RunEditor_remove_comparison, [:pointer, :string], :void
        attach_function :RunEditor_rename_comparison, [:pointer, :string, :string], :bool
        attach_function :RunEditor_move_comparison, [:pointer, :size_t, :size_t], :bool
        attach_function :RunEditor_parse_and_generate_goal_comparison, [:pointer, :string], :bool
        attach_function :RunEditor_clear_history, [:pointer], :void
        attach_function :RunEditor_clear_times, [:pointer], :void
        attach_function :RunEditor_clean_sum_of_best, [:pointer], :pointer
        attach_function :RunMetadata_run_id, [:pointer], :string
        attach_function :RunMetadata_platform_name, [:pointer], :string
        attach_function :RunMetadata_uses_emulator, [:pointer], :bool
        attach_function :RunMetadata_region_name, [:pointer], :string
        attach_function :RunMetadata_speedrun_com_variables, [:pointer], :pointer
        attach_function :RunMetadata_custom_variables, [:pointer], :pointer
        attach_function :RunMetadataCustomVariable_drop, [:pointer], :void
        attach_function :RunMetadataCustomVariable_name, [:pointer], :string
        attach_function :RunMetadataCustomVariable_value, [:pointer], :string
        attach_function :RunMetadataCustomVariable_is_permanent, [:pointer], :bool
        attach_function :RunMetadataCustomVariablesIter_drop, [:pointer], :void
        attach_function :RunMetadataCustomVariablesIter_next, [:pointer], :pointer
        attach_function :RunMetadataSpeedrunComVariable_drop, [:pointer], :void
        attach_function :RunMetadataSpeedrunComVariable_name, [:pointer], :string
        attach_function :RunMetadataSpeedrunComVariable_value, [:pointer], :string
        attach_function :RunMetadataSpeedrunComVariablesIter_drop, [:pointer], :void
        attach_function :RunMetadataSpeedrunComVariablesIter_next, [:pointer], :pointer
        attach_function :Segment_new, [:string], :pointer
        attach_function :Segment_drop, [:pointer], :void
        attach_function :Segment_name, [:pointer], :string
        attach_function :Segment_icon_ptr, [:pointer], :pointer
        attach_function :Segment_icon_len, [:pointer], :size_t
        attach_function :Segment_comparison, [:pointer, :string], :pointer
        attach_function :Segment_personal_best_split_time, [:pointer], :pointer
        attach_function :Segment_best_segment_time, [:pointer], :pointer
        attach_function :Segment_segment_history, [:pointer], :pointer
        attach_function :SegmentHistory_iter, [:pointer], :pointer
        attach_function :SegmentHistoryElement_index, [:pointer], :int32
        attach_function :SegmentHistoryElement_time, [:pointer], :pointer
        attach_function :SegmentHistoryIter_drop, [:pointer], :void
        attach_function :SegmentHistoryIter_next, [:pointer], :pointer
        attach_function :SegmentTimeComponent_new, [], :pointer
        attach_function :SegmentTimeComponent_drop, [:pointer], :void
        attach_function :SegmentTimeComponent_into_generic, [:pointer], :pointer
        attach_function :SegmentTimeComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :SegmentTimeComponent_state, [:pointer, :pointer], :pointer
        attach_function :SeparatorComponent_new, [], :pointer
        attach_function :SeparatorComponent_drop, [:pointer], :void
        attach_function :SeparatorComponent_into_generic, [:pointer], :pointer
        attach_function :SeparatorComponent_state, [:pointer], :pointer
        attach_function :SeparatorComponentState_drop, [:pointer], :void
        attach_function :SettingValue_from_bool, [:bool], :pointer
        attach_function :SettingValue_from_uint, [:uint32], :pointer
        attach_function :SettingValue_from_int, [:int32], :pointer
        attach_function :SettingValue_from_string, [:string], :pointer
        attach_function :SettingValue_from_optional_string, [:string], :pointer
        attach_function :SettingValue_from_optional_empty_string, [], :pointer
        attach_function :SettingValue_from_accuracy, [:string], :pointer
        attach_function :SettingValue_from_digits_format, [:string], :pointer
        attach_function :SettingValue_from_optional_timing_method, [:string], :pointer
        attach_function :SettingValue_from_optional_empty_timing_method, [], :pointer
        attach_function :SettingValue_from_color, [:float, :float, :float, :float], :pointer
        attach_function :SettingValue_from_optional_color, [:float, :float, :float, :float], :pointer
        attach_function :SettingValue_from_optional_empty_color, [], :pointer
        attach_function :SettingValue_from_transparent_gradient, [], :pointer
        attach_function :SettingValue_from_vertical_gradient, [:float, :float, :float, :float, :float, :float, :float, :float], :pointer
        attach_function :SettingValue_from_horizontal_gradient, [:float, :float, :float, :float, :float, :float, :float, :float], :pointer
        attach_function :SettingValue_from_alternating_gradient, [:float, :float, :float, :float, :float, :float, :float, :float], :pointer
        attach_function :SettingValue_from_alignment, [:string], :pointer
        attach_function :SettingValue_from_column_kind, [:string], :pointer
        attach_function :SettingValue_from_column_start_with, [:string], :pointer
        attach_function :SettingValue_from_column_update_with, [:string], :pointer
        attach_function :SettingValue_from_column_update_trigger, [:string], :pointer
        attach_function :SettingValue_from_layout_direction, [:string], :pointer
        attach_function :SettingValue_from_font, [:string, :string, :string, :string], :pointer
        attach_function :SettingValue_from_empty_font, [], :pointer
        attach_function :SettingValue_from_delta_gradient, [:string], :pointer
        attach_function :SettingValue_drop, [:pointer], :void
        attach_function :SettingValue_as_json, [:pointer], :string
        attach_function :SharedTimer_drop, [:pointer], :void
        attach_function :SharedTimer_share, [:pointer], :pointer
        attach_function :SharedTimer_read, [:pointer], :pointer
        attach_function :SharedTimer_write, [:pointer], :pointer
        attach_function :SharedTimer_replace_inner, [:pointer, :pointer], :void
        attach_function :SoftwareRenderer_new, [], :pointer
        attach_function :SoftwareRenderer_drop, [:pointer], :void
        attach_function :SoftwareRenderer_render, [:pointer, :pointer, :pointer, :uint32, :uint32, :uint32, :bool], :void
        attach_function :SplitsComponent_new, [], :pointer
        attach_function :SplitsComponent_drop, [:pointer], :void
        attach_function :SplitsComponent_into_generic, [:pointer], :pointer
        attach_function :SplitsComponent_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :SplitsComponent_state, [:pointer, :pointer, :pointer], :pointer
        attach_function :SplitsComponent_scroll_up, [:pointer], :void
        attach_function :SplitsComponent_scroll_down, [:pointer], :void
        attach_function :SplitsComponent_set_visual_split_count, [:pointer, :size_t], :void
        attach_function :SplitsComponent_set_split_preview_count, [:pointer, :size_t], :void
        attach_function :SplitsComponent_set_always_show_last_split, [:pointer, :bool], :void
        attach_function :SplitsComponent_set_separator_last_split, [:pointer, :bool], :void
        attach_function :SplitsComponentState_drop, [:pointer], :void
        attach_function :SplitsComponentState_final_separator_shown, [:pointer], :bool
        attach_function :SplitsComponentState_len, [:pointer], :size_t
        attach_function :SplitsComponentState_icon_change_count, [:pointer], :size_t
        attach_function :SplitsComponentState_icon_change_segment_index, [:pointer, :size_t], :size_t
        attach_function :SplitsComponentState_icon_change_icon_ptr, [:pointer, :size_t], :pointer
        attach_function :SplitsComponentState_icon_change_icon_len, [:pointer, :size_t], :size_t
        attach_function :SplitsComponentState_name, [:pointer, :size_t], :string
        attach_function :SplitsComponentState_columns_len, [:pointer, :size_t], :size_t
        attach_function :SplitsComponentState_column_value, [:pointer, :size_t, :size_t], :string
        attach_function :SplitsComponentState_column_semantic_color, [:pointer, :size_t, :size_t], :string
        attach_function :SplitsComponentState_is_current_split, [:pointer, :size_t], :bool
        attach_function :SplitsComponentState_has_column_labels, [:pointer], :bool
        attach_function :SplitsComponentState_column_label, [:pointer, :size_t], :string
        attach_function :SumOfBestCleaner_drop, [:pointer], :void
        attach_function :SumOfBestCleaner_next_potential_clean_up, [:pointer], :pointer
        attach_function :SumOfBestCleaner_apply, [:pointer, :pointer], :void
        attach_function :SumOfBestComponent_new, [], :pointer
        attach_function :SumOfBestComponent_drop, [:pointer], :void
        attach_function :SumOfBestComponent_into_generic, [:pointer], :pointer
        attach_function :SumOfBestComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :SumOfBestComponent_state, [:pointer, :pointer], :pointer
        attach_function :TextComponent_new, [], :pointer
        attach_function :TextComponent_drop, [:pointer], :void
        attach_function :TextComponent_into_generic, [:pointer], :pointer
        attach_function :TextComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :TextComponent_state, [:pointer, :pointer], :pointer
        attach_function :TextComponent_set_center, [:pointer, :string], :void
        attach_function :TextComponent_set_left, [:pointer, :string], :void
        attach_function :TextComponent_set_right, [:pointer, :string], :void
        attach_function :TextComponentState_drop, [:pointer], :void
        attach_function :TextComponentState_left, [:pointer], :string
        attach_function :TextComponentState_right, [:pointer], :string
        attach_function :TextComponentState_center, [:pointer], :string
        attach_function :TextComponentState_is_split, [:pointer], :bool
        attach_function :Time_drop, [:pointer], :void
        attach_function :Time_clone, [:pointer], :pointer
        attach_function :Time_real_time, [:pointer], :pointer
        attach_function :Time_game_time, [:pointer], :pointer
        attach_function :Time_index, [:pointer, :uint8], :pointer
        attach_function :TimeSpan_from_seconds, [:double], :pointer
        attach_function :TimeSpan_parse, [:string], :pointer
        attach_function :TimeSpan_drop, [:pointer], :void
        attach_function :TimeSpan_clone, [:pointer], :pointer
        attach_function :TimeSpan_total_seconds, [:pointer], :double
        attach_function :Timer_new, [:pointer], :pointer
        attach_function :Timer_into_shared, [:pointer], :pointer
        attach_function :Timer_into_run, [:pointer, :bool], :pointer
        attach_function :Timer_drop, [:pointer], :void
        attach_function :Timer_current_split_index, [:pointer], :ssize_t
        attach_function :Timer_current_timing_method, [:pointer], :uint8
        attach_function :Timer_current_comparison, [:pointer], :string
        attach_function :Timer_is_game_time_initialized, [:pointer], :bool
        attach_function :Timer_is_game_time_paused, [:pointer], :bool
        attach_function :Timer_loading_times, [:pointer], :pointer
        attach_function :Timer_current_phase, [:pointer], :uint8
        attach_function :Timer_get_run, [:pointer], :pointer
        attach_function :Timer_save_as_lss, [:pointer], :string
        attach_function :Timer_print_debug, [:pointer], :void
        attach_function :Timer_current_time, [:pointer], :pointer
        attach_function :Timer_replace_run, [:pointer, :pointer, :bool], :bool
        attach_function :Timer_set_run, [:pointer, :pointer], :pointer
        attach_function :Timer_start, [:pointer], :void
        attach_function :Timer_split, [:pointer], :void
        attach_function :Timer_split_or_start, [:pointer], :void
        attach_function :Timer_skip_split, [:pointer], :void
        attach_function :Timer_undo_split, [:pointer], :void
        attach_function :Timer_reset, [:pointer, :bool], :void
        attach_function :Timer_reset_and_set_attempt_as_pb, [:pointer], :void
        attach_function :Timer_pause, [:pointer], :void
        attach_function :Timer_resume, [:pointer], :void
        attach_function :Timer_toggle_pause, [:pointer], :void
        attach_function :Timer_toggle_pause_or_start, [:pointer], :void
        attach_function :Timer_undo_all_pauses, [:pointer], :void
        attach_function :Timer_set_current_timing_method, [:pointer, :uint8], :void
        attach_function :Timer_switch_to_next_comparison, [:pointer], :void
        attach_function :Timer_switch_to_previous_comparison, [:pointer], :void
        attach_function :Timer_initialize_game_time, [:pointer], :void
        attach_function :Timer_deinitialize_game_time, [:pointer], :void
        attach_function :Timer_pause_game_time, [:pointer], :void
        attach_function :Timer_resume_game_time, [:pointer], :void
        attach_function :Timer_set_game_time, [:pointer, :pointer], :void
        attach_function :Timer_set_loading_times, [:pointer, :pointer], :void
        attach_function :Timer_mark_as_unmodified, [:pointer], :void
        attach_function :TimerComponent_new, [], :pointer
        attach_function :TimerComponent_drop, [:pointer], :void
        attach_function :TimerComponent_into_generic, [:pointer], :pointer
        attach_function :TimerComponent_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :TimerComponent_state, [:pointer, :pointer, :pointer], :pointer
        attach_function :TimerComponentState_drop, [:pointer], :void
        attach_function :TimerComponentState_time, [:pointer], :string
        attach_function :TimerComponentState_fraction, [:pointer], :string
        attach_function :TimerComponentState_semantic_color, [:pointer], :string
        attach_function :TimerReadLock_drop, [:pointer], :void
        attach_function :TimerReadLock_timer, [:pointer], :pointer
        attach_function :TimerWriteLock_drop, [:pointer], :void
        attach_function :TimerWriteLock_timer, [:pointer], :pointer
        attach_function :TitleComponent_new, [], :pointer
        attach_function :TitleComponent_drop, [:pointer], :void
        attach_function :TitleComponent_into_generic, [:pointer], :pointer
        attach_function :TitleComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :TitleComponent_state, [:pointer, :pointer], :pointer
        attach_function :TitleComponentState_drop, [:pointer], :void
        attach_function :TitleComponentState_icon_change_ptr, [:pointer], :pointer
        attach_function :TitleComponentState_icon_change_len, [:pointer], :size_t
        attach_function :TitleComponentState_line1, [:pointer], :string
        attach_function :TitleComponentState_line2, [:pointer], :string
        attach_function :TitleComponentState_is_centered, [:pointer], :bool
        attach_function :TitleComponentState_shows_finished_runs, [:pointer], :bool
        attach_function :TitleComponentState_finished_runs, [:pointer], :uint32
        attach_function :TitleComponentState_shows_attempts, [:pointer], :bool
        attach_function :TitleComponentState_attempts, [:pointer], :uint32
        attach_function :TotalPlaytimeComponent_new, [], :pointer
        attach_function :TotalPlaytimeComponent_drop, [:pointer], :void
        attach_function :TotalPlaytimeComponent_into_generic, [:pointer], :pointer
        attach_function :TotalPlaytimeComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :TotalPlaytimeComponent_state, [:pointer, :pointer], :pointer
    end

    class LSCHandle
        attr_accessor :ptr
        def initialize(ptr)
            @ptr = ptr
        end
    end

    # The analysis module provides a variety of functions for calculating
    # information about runs.
    class AnalysisRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The analysis module provides a variety of functions for calculating
    # information about runs.
    class AnalysisRefMut < AnalysisRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The analysis module provides a variety of functions for calculating
    # information about runs.
    class Analysis < AnalysisRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = Analysis.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Calculates the Sum of Best Segments for the timing method provided. This is
        # the fastest time possible to complete a run of a category, based on
        # information collected from all the previous attempts. This often matches up
        # with the sum of the best segment times of all the segments, but that may not
        # always be the case, as skipped segments may introduce combined segments that
        # may be faster than the actual sum of their best segment times. The name is
        # therefore a bit misleading, but sticks around for historical reasons. You
        # can choose to do a simple calculation instead, which excludes the Segment
        # History from the calculation process. If there's an active attempt, you can
        # choose to take it into account as well. Can return nil.
        # @param [RunRef] run
        # @param [Boolean] simple_calculation
        # @param [Boolean] use_current_run
        # @param [Integer] method
        # @return [TimeSpan, nil]
        def self.calculate_sum_of_best(run, simple_calculation, use_current_run, method)
            if run.handle.ptr == nil
                raise "run is disposed"
            end
            result = TimeSpan.new(Native.Analysis_calculate_sum_of_best(run.handle.ptr, simple_calculation, use_current_run, method))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Calculates the total playtime of the passed Run.
        # @param [RunRef] run
        # @return [TimeSpan]
        def self.calculate_total_playtime_for_run(run)
            if run.handle.ptr == nil
                raise "run is disposed"
            end
            result = TimeSpan.new(Native.Analysis_calculate_total_playtime_for_run(run.handle.ptr))
            result
        end
        # Calculates the total playtime of the passed Timer.
        # @param [TimerRef] timer
        # @return [TimeSpan]
        def self.calculate_total_playtime_for_timer(timer)
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = TimeSpan.new(Native.Analysis_calculate_total_playtime_for_timer(timer.handle.ptr))
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # An Atomic Date Time represents a UTC Date Time that tries to be as close to
    # an atomic clock as possible.
    class AtomicDateTimeRef
        attr_accessor :handle
        # Represents whether the date time is actually properly derived from an
        # atomic clock. If the synchronization with the atomic clock didn't happen
        # yet or failed, this is set to false.
        # @return [Boolean]
        def is_synchronized()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.AtomicDateTime_is_synchronized(@handle.ptr)
            result
        end
        # Converts this atomic date time into a RFC 3339 formatted date time.
        # @return [String]
        def to_rfc3339()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.AtomicDateTime_to_rfc3339(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # An Atomic Date Time represents a UTC Date Time that tries to be as close to
    # an atomic clock as possible.
    class AtomicDateTimeRefMut < AtomicDateTimeRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # An Atomic Date Time represents a UTC Date Time that tries to be as close to
    # an atomic clock as possible.
    class AtomicDateTime < AtomicDateTimeRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.AtomicDateTime_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = AtomicDateTime.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # An Attempt describes information about an attempt to run a specific category
    # by a specific runner in the past. Every time a new attempt is started and
    # then reset, an Attempt describing general information about it is created.
    class AttemptRef
        attr_accessor :handle
        # Accesses the unique index of the attempt. This index is unique for the
        # Run, not for all of them.
        # @return [Integer]
        def index()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Attempt_index(@handle.ptr)
            result
        end
        # Accesses the split time of the last segment. If the attempt got reset
        # early and didn't finish, this may be empty.
        # @return [TimeRef]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Attempt_time(@handle.ptr))
            result
        end
        # Accesses the amount of time the attempt has been paused for. If it is not
        # known, this returns nil. This means that it may not necessarily be
        # possible to differentiate whether a Run has not been paused or it simply
        # wasn't stored.
        # @return [TimeSpanRef, nil]
        def pause_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpanRef.new(Native.Attempt_pause_time(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Accesses the point in time the attempt was started at. This returns nil
        # if this information is not known.
        # @return [AtomicDateTime, nil]
        def started()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = AtomicDateTime.new(Native.Attempt_started(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Accesses the point in time the attempt was ended at. This returns nil if
        # this information is not known.
        # @return [AtomicDateTime, nil]
        def ended()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = AtomicDateTime.new(Native.Attempt_ended(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # An Attempt describes information about an attempt to run a specific category
    # by a specific runner in the past. Every time a new attempt is started and
    # then reset, an Attempt describing general information about it is created.
    class AttemptRefMut < AttemptRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # An Attempt describes information about an attempt to run a specific category
    # by a specific runner in the past. Every time a new attempt is started and
    # then reset, an Attempt describing general information about it is created.
    class Attempt < AttemptRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = Attempt.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # With an Auto Splitting Runtime, the runner can use an Auto Splitter to
    # automatically control the timer on systems that are supported.
    class AutoSplittingRuntimeRef
        attr_accessor :handle
        # Attempts to load an auto splitter. Returns true if successful.
        # @param [String] path
        # @return [Boolean]
        def load_script(path)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.AutoSplittingRuntime_load_script(@handle.ptr, path)
            result
        end
        # Attempts to unload the auto splitter. Returns true if successful.
        # @return [Boolean]
        def unload_script()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.AutoSplittingRuntime_unload_script(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # With an Auto Splitting Runtime, the runner can use an Auto Splitter to
    # automatically control the timer on systems that are supported.
    class AutoSplittingRuntimeRefMut < AutoSplittingRuntimeRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # With an Auto Splitting Runtime, the runner can use an Auto Splitter to
    # automatically control the timer on systems that are supported.
    class AutoSplittingRuntime < AutoSplittingRuntimeRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.AutoSplittingRuntime_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = AutoSplittingRuntime.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Auto Splitting Runtime for a Timer.
        # @param [SharedTimer] shared_timer
        # @return [AutoSplittingRuntime]
        def self.create(shared_timer)
            if shared_timer.handle.ptr == nil
                raise "shared_timer is disposed"
            end
            result = AutoSplittingRuntime.new(Native.AutoSplittingRuntime_new(shared_timer.handle.ptr))
            shared_timer.handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Blank Space Component is simply an empty component that doesn't show
    # anything other than a background. It mostly serves as padding between other
    # components.
    class BlankSpaceComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Blank Space Component is simply an empty component that doesn't show
    # anything other than a background. It mostly serves as padding between other
    # components.
    class BlankSpaceComponentRefMut < BlankSpaceComponentRef
        # Encodes the component's state information as JSON.
        # @return [String]
        def state_as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.BlankSpaceComponent_state_as_json(@handle.ptr)
            result
        end
        # Calculates the component's state.
        # @return [BlankSpaceComponentState]
        def state()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = BlankSpaceComponentState.new(Native.BlankSpaceComponent_state(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Blank Space Component is simply an empty component that doesn't show
    # anything other than a background. It mostly serves as padding between other
    # components.
    class BlankSpaceComponent < BlankSpaceComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.BlankSpaceComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = BlankSpaceComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Blank Space Component.
        # @return [BlankSpaceComponent]
        def self.create()
            result = BlankSpaceComponent.new(Native.BlankSpaceComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.BlankSpaceComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for this component.
    class BlankSpaceComponentStateRef
        attr_accessor :handle
        # The size of the component.
        # @return [Integer]
        def size()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.BlankSpaceComponentState_size(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class BlankSpaceComponentStateRefMut < BlankSpaceComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class BlankSpaceComponentState < BlankSpaceComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.BlankSpaceComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = BlankSpaceComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Component provides information about a run in a way that is easy to
    # visualize. This type can store any of the components provided by this crate.
    class ComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Component provides information about a run in a way that is easy to
    # visualize. This type can store any of the components provided by this crate.
    class ComponentRefMut < ComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Component provides information about a run in a way that is easy to
    # visualize. This type can store any of the components provided by this crate.
    class Component < ComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.Component_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = Component.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Current Comparison Component is a component that shows the name of the
    # comparison that is currently selected to be compared against.
    class CurrentComparisonComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Current Comparison Component is a component that shows the name of the
    # comparison that is currently selected to be compared against.
    class CurrentComparisonComponentRefMut < CurrentComparisonComponentRef
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.CurrentComparisonComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [KeyValueComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = KeyValueComponentState.new(Native.CurrentComparisonComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Current Comparison Component is a component that shows the name of the
    # comparison that is currently selected to be compared against.
    class CurrentComparisonComponent < CurrentComparisonComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.CurrentComparisonComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = CurrentComparisonComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Current Comparison Component.
        # @return [CurrentComparisonComponent]
        def self.create()
            result = CurrentComparisonComponent.new(Native.CurrentComparisonComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.CurrentComparisonComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Current Pace Component is a component that shows a prediction of the
    # current attempt's final time, if the current attempt's pace matches the
    # chosen comparison for the remainder of the run.
    class CurrentPaceComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Current Pace Component is a component that shows a prediction of the
    # current attempt's final time, if the current attempt's pace matches the
    # chosen comparison for the remainder of the run.
    class CurrentPaceComponentRefMut < CurrentPaceComponentRef
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.CurrentPaceComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [KeyValueComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = KeyValueComponentState.new(Native.CurrentPaceComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Current Pace Component is a component that shows a prediction of the
    # current attempt's final time, if the current attempt's pace matches the
    # chosen comparison for the remainder of the run.
    class CurrentPaceComponent < CurrentPaceComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.CurrentPaceComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = CurrentPaceComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Current Pace Component.
        # @return [CurrentPaceComponent]
        def self.create()
            result = CurrentPaceComponent.new(Native.CurrentPaceComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.CurrentPaceComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Delta Component is a component that shows the how far ahead or behind
    # the current attempt is compared to the chosen comparison.
    class DeltaComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Delta Component is a component that shows the how far ahead or behind
    # the current attempt is compared to the chosen comparison.
    class DeltaComponentRefMut < DeltaComponentRef
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [String]
        def state_as_json(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = Native.DeltaComponent_state_as_json(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer and the layout
        # settings provided.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [KeyValueComponentState]
        def state(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = KeyValueComponentState.new(Native.DeltaComponent_state(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Delta Component is a component that shows the how far ahead or behind
    # the current attempt is compared to the chosen comparison.
    class DeltaComponent < DeltaComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.DeltaComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = DeltaComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Delta Component.
        # @return [DeltaComponent]
        def self.create()
            result = DeltaComponent.new(Native.DeltaComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.DeltaComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Detailed Timer Component is a component that shows two timers, one for
    # the total time of the current attempt and one showing the time of just the
    # current segment. Other information, like segment times of up to two
    # comparisons, the segment icon, and the segment's name, can also be shown.
    class DetailedTimerComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Detailed Timer Component is a component that shows two timers, one for
    # the total time of the current attempt and one showing the time of just the
    # current segment. Other information, like segment times of up to two
    # comparisons, the segment icon, and the segment's name, can also be shown.
    class DetailedTimerComponentRefMut < DetailedTimerComponentRef
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [String]
        def state_as_json(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = Native.DetailedTimerComponent_state_as_json(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer and layout settings
        # provided.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [DetailedTimerComponentState]
        def state(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = DetailedTimerComponentState.new(Native.DetailedTimerComponent_state(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Detailed Timer Component is a component that shows two timers, one for
    # the total time of the current attempt and one showing the time of just the
    # current segment. Other information, like segment times of up to two
    # comparisons, the segment icon, and the segment's name, can also be shown.
    class DetailedTimerComponent < DetailedTimerComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.DetailedTimerComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = DetailedTimerComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Detailed Timer Component.
        # @return [DetailedTimerComponent]
        def self.create()
            result = DetailedTimerComponent.new(Native.DetailedTimerComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.DetailedTimerComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for this component.
    class DetailedTimerComponentStateRef
        attr_accessor :handle
        # The time shown by the component's main timer without the fractional part.
        # @return [String]
        def timer_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_timer_time(@handle.ptr)
            result
        end
        # The fractional part of the time shown by the main timer (including the dot).
        # @return [String]
        def timer_fraction()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_timer_fraction(@handle.ptr)
            result
        end
        # The semantic coloring information the main timer's time carries.
        # @return [String]
        def timer_semantic_color()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_timer_semantic_color(@handle.ptr)
            result
        end
        # The time shown by the component's segment timer without the fractional part.
        # @return [String]
        def segment_timer_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_segment_timer_time(@handle.ptr)
            result
        end
        # The fractional part of the time shown by the segment timer (including the
        # dot).
        # @return [String]
        def segment_timer_fraction()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_segment_timer_fraction(@handle.ptr)
            result
        end
        # Returns whether the first comparison is visible.
        # @return [Boolean]
        def comparison1_visible()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison1_visible(@handle.ptr)
            result
        end
        # Returns the name of the first comparison. You may not call this if the first
        # comparison is not visible.
        # @return [String]
        def comparison1_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison1_name(@handle.ptr)
            result
        end
        # Returns the time of the first comparison. You may not call this if the first
        # comparison is not visible.
        # @return [String]
        def comparison1_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison1_time(@handle.ptr)
            result
        end
        # Returns whether the second comparison is visible.
        # @return [Boolean]
        def comparison2_visible()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison2_visible(@handle.ptr)
            result
        end
        # Returns the name of the second comparison. You may not call this if the
        # second comparison is not visible.
        # @return [String]
        def comparison2_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison2_name(@handle.ptr)
            result
        end
        # Returns the time of the second comparison. You may not call this if the
        # second comparison is not visible.
        # @return [String]
        def comparison2_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison2_time(@handle.ptr)
            result
        end
        # The data of the segment's icon. This value is only specified whenever the
        # icon changes. If you explicitly want to query this value, remount the
        # component. The buffer itself may be empty. This indicates that there is no
        # icon.
        # @return [Integer]
        def icon_change_ptr()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_icon_change_ptr(@handle.ptr)
            result
        end
        # The length of the data of the segment's icon.
        # @return [Integer]
        def icon_change_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_icon_change_len(@handle.ptr)
            result
        end
        # The name of the segment. This may be nil if it's not supposed to be
        # visualized.
        # @return [String, nil]
        def segment_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_segment_name(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class DetailedTimerComponentStateRefMut < DetailedTimerComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class DetailedTimerComponentState < DetailedTimerComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.DetailedTimerComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = DetailedTimerComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # With a Fuzzy List, you can implement a fuzzy searching algorithm. The list
    # stores all the items that can be searched for. With the `search` method you
    # can then execute the actual fuzzy search which returns a list of all the
    # elements found. This can be used to implement searching in a list of games.
    class FuzzyListRef
        attr_accessor :handle
        # Searches for the pattern provided in the list. A list of all the
        # matching elements is returned. The returned list has a maximum amount of
        # elements provided to this method.
        # @param [String] pattern
        # @param [Integer] max
        # @return [String]
        def search(pattern, max)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.FuzzyList_search(@handle.ptr, pattern, max)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # With a Fuzzy List, you can implement a fuzzy searching algorithm. The list
    # stores all the items that can be searched for. With the `search` method you
    # can then execute the actual fuzzy search which returns a list of all the
    # elements found. This can be used to implement searching in a list of games.
    class FuzzyListRefMut < FuzzyListRef
        # Adds a new element to the list.
        # @param [String] text
        def push(text)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.FuzzyList_push(@handle.ptr, text)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # With a Fuzzy List, you can implement a fuzzy searching algorithm. The list
    # stores all the items that can be searched for. With the `search` method you
    # can then execute the actual fuzzy search which returns a list of all the
    # elements found. This can be used to implement searching in a list of games.
    class FuzzyList < FuzzyListRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.FuzzyList_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = FuzzyList.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Fuzzy List.
        # @return [FuzzyList]
        def self.create()
            result = FuzzyList.new(Native.FuzzyList_new())
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The general settings of the layout that apply to all components.
    class GeneralLayoutSettingsRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The general settings of the layout that apply to all components.
    class GeneralLayoutSettingsRefMut < GeneralLayoutSettingsRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The general settings of the layout that apply to all components.
    class GeneralLayoutSettings < GeneralLayoutSettingsRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.GeneralLayoutSettings_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = GeneralLayoutSettings.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a default general layout settings configuration.
        # @return [GeneralLayoutSettings]
        def self.default()
            result = GeneralLayoutSettings.new(Native.GeneralLayoutSettings_default())
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Graph Component visualizes how far the current attempt has been ahead or
    # behind the chosen comparison throughout the whole attempt. All the
    # individual deltas are shown as points in a graph.
    class GraphComponentRef
        attr_accessor :handle
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [String]
        def state_as_json(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = Native.GraphComponent_state_as_json(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer and layout settings
        # provided.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [GraphComponentState]
        def state(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = GraphComponentState.new(Native.GraphComponent_state(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Graph Component visualizes how far the current attempt has been ahead or
    # behind the chosen comparison throughout the whole attempt. All the
    # individual deltas are shown as points in a graph.
    class GraphComponentRefMut < GraphComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Graph Component visualizes how far the current attempt has been ahead or
    # behind the chosen comparison throughout the whole attempt. All the
    # individual deltas are shown as points in a graph.
    class GraphComponent < GraphComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.GraphComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = GraphComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Graph Component.
        # @return [GraphComponent]
        def self.create()
            result = GraphComponent.new(Native.GraphComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.GraphComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for this component.
    # All the coordinates are in the range 0..1.
    class GraphComponentStateRef
        attr_accessor :handle
        # Returns the amount of points to visualize. Connect all of them to visualize
        # the graph. If the live delta is active, the last point is to be interpreted
        # as a preview of the next split that is about to happen. Use the partial fill
        # color to visualize the region beneath that graph segment.
        # @return [Integer]
        def points_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_points_len(@handle.ptr)
            result
        end
        # Returns the x coordinate of the point specified. You may not provide an out
        # of bounds index.
        # @param [Integer] index
        # @return [Float]
        def point_x(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_point_x(@handle.ptr, index)
            result
        end
        # Returns the y coordinate of the point specified. You may not provide an out
        # of bounds index.
        # @param [Integer] index
        # @return [Float]
        def point_y(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_point_y(@handle.ptr, index)
            result
        end
        # Describes whether the segment the point specified is visualizing achieved a
        # new best segment time. Use the best segment color for it, in that case. You
        # may not provide an out of bounds index.
        # @param [Integer] index
        # @return [Boolean]
        def point_is_best_segment(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_point_is_best_segment(@handle.ptr, index)
            result
        end
        # Describes how many horizontal grid lines to visualize.
        # @return [Integer]
        def horizontal_grid_lines_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_horizontal_grid_lines_len(@handle.ptr)
            result
        end
        # Accesses the y coordinate of the horizontal grid line specified. You may not
        # provide an out of bounds index.
        # @param [Integer] index
        # @return [Float]
        def horizontal_grid_line(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_horizontal_grid_line(@handle.ptr, index)
            result
        end
        # Describes how many vertical grid lines to visualize.
        # @return [Integer]
        def vertical_grid_lines_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_vertical_grid_lines_len(@handle.ptr)
            result
        end
        # Accesses the x coordinate of the vertical grid line specified. You may not
        # provide an out of bounds index.
        # @param [Integer] index
        # @return [Float]
        def vertical_grid_line(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_vertical_grid_line(@handle.ptr, index)
            result
        end
        # The y coordinate that separates the region that shows the times that are
        # ahead of the comparison and those that are behind.
        # @return [Float]
        def middle()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_middle(@handle.ptr)
            result
        end
        # If the live delta is active, the last point is to be interpreted as a
        # preview of the next split that is about to happen. Use the partial fill
        # color to visualize the region beneath that graph segment.
        # @return [Boolean]
        def is_live_delta_active()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_is_live_delta_active(@handle.ptr)
            result
        end
        # Describes whether the graph is flipped vertically. For visualizing the
        # graph, this usually doesn't need to be interpreted, as this information is
        # entirely encoded into the other variables.
        # @return [Boolean]
        def is_flipped()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_is_flipped(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    # All the coordinates are in the range 0..1.
    class GraphComponentStateRefMut < GraphComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    # All the coordinates are in the range 0..1.
    class GraphComponentState < GraphComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.GraphComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = GraphComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The configuration to use for a Hotkey System. It describes with keys to use
    # as hotkeys for the different actions.
    class HotkeyConfigRef
        attr_accessor :handle
        # Encodes generic description of the settings available for the hotkey
        # configuration and their current values as JSON.
        # @return [String]
        def settings_description_as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.HotkeyConfig_settings_description_as_json(@handle.ptr)
            result
        end
        # Encodes the hotkey configuration as JSON.
        # @return [String]
        def as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.HotkeyConfig_as_json(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The configuration to use for a Hotkey System. It describes with keys to use
    # as hotkeys for the different actions.
    class HotkeyConfigRefMut < HotkeyConfigRef
        # Sets a setting's value by its index to the given value.
        # 
        # false is returned if a hotkey is already in use by a different action.
        # 
        # This panics if the type of the value to be set is not compatible with the
        # type of the setting's value. A panic can also occur if the index of the
        # setting provided is out of bounds.
        # @param [Integer] index
        # @param [SettingValue] value
        # @return [Boolean]
        def set_value(index, value)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if value.handle.ptr == nil
                raise "value is disposed"
            end
            result = Native.HotkeyConfig_set_value(@handle.ptr, index, value.handle.ptr)
            value.handle.ptr = nil
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The configuration to use for a Hotkey System. It describes with keys to use
    # as hotkeys for the different actions.
    class HotkeyConfig < HotkeyConfigRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.HotkeyConfig_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = HotkeyConfig.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Hotkey Configuration with default settings.
        # @return [HotkeyConfig]
        def self.create()
            result = HotkeyConfig.new(Native.HotkeyConfig_new())
            result
        end
        # Parses a hotkey configuration from the given JSON description. nil is
        # returned if it couldn't be parsed.
        # @param [String] settings
        # @return [HotkeyConfig, nil]
        def self.parse_json(settings)
            result = HotkeyConfig.new(Native.HotkeyConfig_parse_json(settings))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Attempts to parse a hotkey configuration from a given file. nil is
        # returned it couldn't be parsed. This will not close the file descriptor /
        # handle.
        # @param [Integer] handle
        # @return [HotkeyConfig, nil]
        def self.parse_file_handle(handle)
            result = HotkeyConfig.new(Native.HotkeyConfig_parse_file_handle(handle))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # With a Hotkey System the runner can use hotkeys on their keyboard to control
    # the Timer. The hotkeys are global, so the application doesn't need to be in
    # focus. The behavior of the hotkeys depends on the platform and is stubbed
    # out on platforms that don't support hotkeys. You can turn off a Hotkey
    # System temporarily. By default the Hotkey System is activated.
    class HotkeySystemRef
        attr_accessor :handle
        # Returns the hotkey configuration currently in use by the Hotkey System.
        # @return [HotkeyConfig]
        def config()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = HotkeyConfig.new(Native.HotkeySystem_config(@handle.ptr))
            result
        end
        # Resolves the key according to the current keyboard layout.
        # @param [String] key_code
        # @return [String]
        def resolve(key_code)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.HotkeySystem_resolve(@handle.ptr, key_code)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # With a Hotkey System the runner can use hotkeys on their keyboard to control
    # the Timer. The hotkeys are global, so the application doesn't need to be in
    # focus. The behavior of the hotkeys depends on the platform and is stubbed
    # out on platforms that don't support hotkeys. You can turn off a Hotkey
    # System temporarily. By default the Hotkey System is activated.
    class HotkeySystemRefMut < HotkeySystemRef
        # Deactivates the Hotkey System. No hotkeys will go through until it gets
        # activated again. If it's already deactivated, nothing happens.
        # @return [Boolean]
        def deactivate()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.HotkeySystem_deactivate(@handle.ptr)
            result
        end
        # Activates a previously deactivated Hotkey System. If it's already
        # active, nothing happens.
        # @return [Boolean]
        def activate()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.HotkeySystem_activate(@handle.ptr)
            result
        end
        # Applies a new hotkey configuration to the Hotkey System. Each hotkey is
        # changed to the one specified in the configuration. This operation may fail
        # if you provide a hotkey configuration where a hotkey is used for multiple
        # operations. Returns false if the operation failed.
        # @param [HotkeyConfig] config
        # @return [Boolean]
        def set_config(config)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if config.handle.ptr == nil
                raise "config is disposed"
            end
            result = Native.HotkeySystem_set_config(@handle.ptr, config.handle.ptr)
            config.handle.ptr = nil
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # With a Hotkey System the runner can use hotkeys on their keyboard to control
    # the Timer. The hotkeys are global, so the application doesn't need to be in
    # focus. The behavior of the hotkeys depends on the platform and is stubbed
    # out on platforms that don't support hotkeys. You can turn off a Hotkey
    # System temporarily. By default the Hotkey System is activated.
    class HotkeySystem < HotkeySystemRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.HotkeySystem_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = HotkeySystem.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Hotkey System for a Timer with the default hotkeys.
        # @param [SharedTimer] shared_timer
        # @return [HotkeySystem, nil]
        def self.create(shared_timer)
            if shared_timer.handle.ptr == nil
                raise "shared_timer is disposed"
            end
            result = HotkeySystem.new(Native.HotkeySystem_new(shared_timer.handle.ptr))
            shared_timer.handle.ptr = nil
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new Hotkey System for a Timer with a custom configuration for the
        # hotkeys.
        # @param [SharedTimer] shared_timer
        # @param [HotkeyConfig] config
        # @return [HotkeySystem, nil]
        def self.with_config(shared_timer, config)
            if shared_timer.handle.ptr == nil
                raise "shared_timer is disposed"
            end
            if config.handle.ptr == nil
                raise "config is disposed"
            end
            result = HotkeySystem.new(Native.HotkeySystem_with_config(shared_timer.handle.ptr, config.handle.ptr))
            shared_timer.handle.ptr = nil
            config.handle.ptr = nil
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for a key value based component.
    class KeyValueComponentStateRef
        attr_accessor :handle
        # The key to visualize.
        # @return [String]
        def key()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.KeyValueComponentState_key(@handle.ptr)
            result
        end
        # The value to visualize.
        # @return [String]
        def value()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.KeyValueComponentState_value(@handle.ptr)
            result
        end
        # The semantic coloring information the value carries.
        # @return [String]
        def semantic_color()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.KeyValueComponentState_semantic_color(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for a key value based component.
    class KeyValueComponentStateRefMut < KeyValueComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for a key value based component.
    class KeyValueComponentState < KeyValueComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.KeyValueComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = KeyValueComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Layout allows you to combine multiple components together to visualize a
    # variety of information the runner is interested in.
    class LayoutRef
        attr_accessor :handle
        # Clones the layout.
        # @return [Layout]
        def clone()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Layout.new(Native.Layout_clone(@handle.ptr))
            result
        end
        # Encodes the settings of the layout as JSON.
        # @return [String]
        def settings_as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Layout_settings_as_json(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Layout allows you to combine multiple components together to visualize a
    # variety of information the runner is interested in.
    class LayoutRefMut < LayoutRef
        # Calculates and returns the layout's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [LayoutState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = LayoutState.new(Native.Layout_state(@handle.ptr, timer.handle.ptr))
            result
        end
        # Updates the layout's state based on the timer provided.
        # @param [LayoutStateRefMut] state
        # @param [TimerRef] timer
        def update_state(state, timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if state.handle.ptr == nil
                raise "state is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            Native.Layout_update_state(@handle.ptr, state.handle.ptr, timer.handle.ptr)
        end
        # Updates the layout's state based on the timer provided and encodes it as
        # JSON.
        # @param [LayoutStateRefMut] state
        # @param [TimerRef] timer
        # @return [String]
        def update_state_as_json(state, timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if state.handle.ptr == nil
                raise "state is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.Layout_update_state_as_json(@handle.ptr, state.handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the layout's state based on the timer provided and encodes it as
        # JSON. You can use this to visualize all of the components of a layout.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.Layout_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Adds a new component to the end of the layout.
        # @param [Component] component
        def push(component)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if component.handle.ptr == nil
                raise "component is disposed"
            end
            Native.Layout_push(@handle.ptr, component.handle.ptr)
            component.handle.ptr = nil
        end
        # Scrolls up all the components in the layout that can be scrolled up.
        def scroll_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Layout_scroll_up(@handle.ptr)
        end
        # Scrolls down all the components in the layout that can be scrolled down.
        def scroll_down()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Layout_scroll_down(@handle.ptr)
        end
        # Remounts all the components as if they were freshly initialized. Some
        # components may only provide some information whenever it changes or when
        # their state is first queried. Remounting returns this information again,
        # whenever the layout's state is queried the next time.
        def remount()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Layout_remount(@handle.ptr)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Layout allows you to combine multiple components together to visualize a
    # variety of information the runner is interested in.
    class Layout < LayoutRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.Layout_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = Layout.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new empty layout with no components.
        # @return [Layout]
        def self.create()
            result = Layout.new(Native.Layout_new())
            result
        end
        # Creates a new default layout that contains a default set of components
        # in order to provide a good default layout for runners. Which components
        # are provided by this and how they are configured may change in the
        # future.
        # @return [Layout]
        def self.default_layout()
            result = Layout.new(Native.Layout_default_layout())
            result
        end
        # Parses a layout from the given JSON description of its settings. nil is
        # returned if it couldn't be parsed.
        # @param [String] settings
        # @return [Layout, nil]
        def self.parse_json(settings)
            result = Layout.new(Native.Layout_parse_json(settings))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Attempts to parse a layout from a given file. nil is returned it couldn't
        # be parsed. This will not close the file descriptor / handle.
        # @param [Integer] handle
        # @return [Layout, nil]
        def self.parse_file_handle(handle)
            result = Layout.new(Native.Layout_parse_file_handle(handle))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Parses a layout saved by the original LiveSplit. This is lossy, as not
        # everything can be converted completely. nil is returned if it couldn't be
        # parsed at all.
        # @param [Integer] data
        # @param [Integer] length
        # @return [Layout, nil]
        def self.parse_original_livesplit(data, length)
            result = Layout.new(Native.Layout_parse_original_livesplit(data, length))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Layout Editor allows modifying Layouts while ensuring all the different
    # invariants of the Layout objects are upheld no matter what kind of
    # operations are being applied. It provides the current state of the editor as
    # state objects that can be visualized by any kind of User Interface.
    class LayoutEditorRef
        attr_accessor :handle
        # Encodes the Layout Editor's state as JSON in order to visualize it.
        # @return [String]
        def state_as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutEditor_state_as_json(@handle.ptr)
            result
        end
        # Returns the state of the Layout Editor.
        # @return [LayoutEditorState]
        def state()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = LayoutEditorState.new(Native.LayoutEditor_state(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Layout Editor allows modifying Layouts while ensuring all the different
    # invariants of the Layout objects are upheld no matter what kind of
    # operations are being applied. It provides the current state of the editor as
    # state objects that can be visualized by any kind of User Interface.
    class LayoutEditorRefMut < LayoutEditorRef
        # Encodes the layout's state as JSON based on the timer provided. You can use
        # this to visualize all of the components of a layout, while it is still being
        # edited by the Layout Editor.
        # @param [TimerRef] timer
        # @return [String]
        def layout_state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.LayoutEditor_layout_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Updates the layout's state based on the timer provided.
        # @param [LayoutStateRefMut] state
        # @param [TimerRef] timer
        def update_layout_state(state, timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if state.handle.ptr == nil
                raise "state is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            Native.LayoutEditor_update_layout_state(@handle.ptr, state.handle.ptr, timer.handle.ptr)
        end
        # Updates the layout's state based on the timer provided and encodes it as
        # JSON.
        # @param [LayoutStateRefMut] state
        # @param [TimerRef] timer
        # @return [String]
        def update_layout_state_as_json(state, timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if state.handle.ptr == nil
                raise "state is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.LayoutEditor_update_layout_state_as_json(@handle.ptr, state.handle.ptr, timer.handle.ptr)
            result
        end
        # Selects the component with the given index in order to modify its
        # settings. Only a single component is selected at any given time. You may
        # not provide an invalid index.
        # @param [Integer] index
        def select(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_select(@handle.ptr, index)
        end
        # Adds the component provided to the end of the layout. The newly added
        # component becomes the selected component.
        # @param [Component] component
        def add_component(component)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if component.handle.ptr == nil
                raise "component is disposed"
            end
            Native.LayoutEditor_add_component(@handle.ptr, component.handle.ptr)
            component.handle.ptr = nil
        end
        # Removes the currently selected component, unless there's only one
        # component in the layout. The next component becomes the selected
        # component. If there's none, the previous component becomes the selected
        # component instead.
        def remove_component()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_remove_component(@handle.ptr)
        end
        # Moves the selected component up, unless the first component is selected.
        def move_component_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_move_component_up(@handle.ptr)
        end
        # Moves the selected component down, unless the last component is
        # selected.
        def move_component_down()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_move_component_down(@handle.ptr)
        end
        # Moves the selected component to the index provided. You may not provide
        # an invalid index.
        # @param [Integer] dst_index
        def move_component(dst_index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_move_component(@handle.ptr, dst_index)
        end
        # Duplicates the currently selected component. The copy gets placed right
        # after the selected component and becomes the newly selected component.
        def duplicate_component()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_duplicate_component(@handle.ptr)
        end
        # Sets a setting's value of the selected component by its setting index
        # to the given value.
        # 
        # This panics if the type of the value to be set is not compatible with
        # the type of the setting's value. A panic can also occur if the index of
        # the setting provided is out of bounds.
        # @param [Integer] index
        # @param [SettingValue] value
        def set_component_settings_value(index, value)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if value.handle.ptr == nil
                raise "value is disposed"
            end
            Native.LayoutEditor_set_component_settings_value(@handle.ptr, index, value.handle.ptr)
            value.handle.ptr = nil
        end
        # Sets a setting's value of the general settings by its setting index to
        # the given value.
        # 
        # This panics if the type of the value to be set is not compatible with
        # the type of the setting's value. A panic can also occur if the index of
        # the setting provided is out of bounds.
        # @param [Integer] index
        # @param [SettingValue] value
        def set_general_settings_value(index, value)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if value.handle.ptr == nil
                raise "value is disposed"
            end
            Native.LayoutEditor_set_general_settings_value(@handle.ptr, index, value.handle.ptr)
            value.handle.ptr = nil
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Layout Editor allows modifying Layouts while ensuring all the different
    # invariants of the Layout objects are upheld no matter what kind of
    # operations are being applied. It provides the current state of the editor as
    # state objects that can be visualized by any kind of User Interface.
    class LayoutEditor < LayoutEditorRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = LayoutEditor.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Layout Editor that modifies the Layout provided. Creation of
        # the Layout Editor fails when a Layout with no components is provided. In
        # that case nil is returned instead.
        # @param [Layout] layout
        # @return [LayoutEditor, nil]
        def self.create(layout)
            if layout.handle.ptr == nil
                raise "layout is disposed"
            end
            result = LayoutEditor.new(Native.LayoutEditor_new(layout.handle.ptr))
            layout.handle.ptr = nil
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Closes the Layout Editor and gives back access to the modified Layout. In
        # case you want to implement a Cancel Button, just dispose the Layout object
        # you get here.
        # @return [Layout]
        def close()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Layout.new(Native.LayoutEditor_close(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # Represents the current state of the Layout Editor in order to visualize it properly.
    class LayoutEditorStateRef
        attr_accessor :handle
        # Returns the number of components in the layout.
        # @return [Integer]
        def component_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutEditorState_component_len(@handle.ptr)
            result
        end
        # Returns the name of the component at the specified index.
        # @param [Integer] index
        # @return [String]
        def component_text(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutEditorState_component_text(@handle.ptr, index)
            result
        end
        # Returns a bitfield corresponding to which buttons are active.
        # 
        # The bits are as follows:
        # 
        # * `0x04` - Can remove the current component
        # * `0x02` - Can move the current component up
        # * `0x01` - Can move the current component down
        # @return [Integer]
        def buttons()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutEditorState_buttons(@handle.ptr)
            result
        end
        # Returns the index of the currently selected component.
        # @return [Integer]
        def selected_component()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutEditorState_selected_component(@handle.ptr)
            result
        end
        # Returns the number of fields in the layout's settings.
        # 
        # Set `component_settings` to true to use the selected component's settings instead.
        # @param [Boolean] component_settings
        # @return [Integer]
        def field_len(component_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutEditorState_field_len(@handle.ptr, component_settings)
            result
        end
        # Returns the name of the layout's setting at the specified index.
        # 
        # Set `component_settings` to true to use the selected component's settings instead.
        # @param [Boolean] component_settings
        # @param [Integer] index
        # @return [String]
        def field_text(component_settings, index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutEditorState_field_text(@handle.ptr, component_settings, index)
            result
        end
        # Returns the value of the layout's setting at the specified index.
        # 
        # Set `component_settings` to true to use the selected component's settings instead.
        # @param [Boolean] component_settings
        # @param [Integer] index
        # @return [SettingValueRef]
        def field_value(component_settings, index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SettingValueRef.new(Native.LayoutEditorState_field_value(@handle.ptr, component_settings, index))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Represents the current state of the Layout Editor in order to visualize it properly.
    class LayoutEditorStateRefMut < LayoutEditorStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Represents the current state of the Layout Editor in order to visualize it properly.
    class LayoutEditorState < LayoutEditorStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.LayoutEditorState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = LayoutEditorState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for an entire
    # layout. Use this with care, as invalid usage will result in a panic.
    # 
    # Specifically, you should avoid doing the following:
    # 
    # - Using out of bounds indices.
    # - Using the wrong getter function on the wrong type of component.
    class LayoutStateRef
        attr_accessor :handle
        # Encodes the layout state as JSON. You can use this to visualize all of the
        # components of a layout.
        # @return [String]
        def as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutState_as_json(@handle.ptr)
            result
        end
        # Gets the number of Components in the Layout State.
        # @return [Integer]
        def len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutState_len(@handle.ptr)
            result
        end
        # Returns a string describing the type of the Component at the specified
        # index.
        # @param [Integer] index
        # @return [String]
        def component_type(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutState_component_type(@handle.ptr, index)
            result
        end
        # Gets the Blank Space component state at the specified index.
        # @param [Integer] index
        # @return [BlankSpaceComponentStateRef]
        def component_as_blank_space(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = BlankSpaceComponentStateRef.new(Native.LayoutState_component_as_blank_space(@handle.ptr, index))
            result
        end
        # Gets the Detailed Timer component state at the specified index.
        # @param [Integer] index
        # @return [DetailedTimerComponentStateRef]
        def component_as_detailed_timer(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = DetailedTimerComponentStateRef.new(Native.LayoutState_component_as_detailed_timer(@handle.ptr, index))
            result
        end
        # Gets the Graph component state at the specified index.
        # @param [Integer] index
        # @return [GraphComponentStateRef]
        def component_as_graph(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = GraphComponentStateRef.new(Native.LayoutState_component_as_graph(@handle.ptr, index))
            result
        end
        # Gets the Key Value component state at the specified index.
        # @param [Integer] index
        # @return [KeyValueComponentStateRef]
        def component_as_key_value(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = KeyValueComponentStateRef.new(Native.LayoutState_component_as_key_value(@handle.ptr, index))
            result
        end
        # Gets the Separator component state at the specified index.
        # @param [Integer] index
        # @return [SeparatorComponentStateRef]
        def component_as_separator(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SeparatorComponentStateRef.new(Native.LayoutState_component_as_separator(@handle.ptr, index))
            result
        end
        # Gets the Splits component state at the specified index.
        # @param [Integer] index
        # @return [SplitsComponentStateRef]
        def component_as_splits(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SplitsComponentStateRef.new(Native.LayoutState_component_as_splits(@handle.ptr, index))
            result
        end
        # Gets the Text component state at the specified index.
        # @param [Integer] index
        # @return [TextComponentStateRef]
        def component_as_text(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TextComponentStateRef.new(Native.LayoutState_component_as_text(@handle.ptr, index))
            result
        end
        # Gets the Timer component state at the specified index.
        # @param [Integer] index
        # @return [TimerComponentStateRef]
        def component_as_timer(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimerComponentStateRef.new(Native.LayoutState_component_as_timer(@handle.ptr, index))
            result
        end
        # Gets the Title component state at the specified index.
        # @param [Integer] index
        # @return [TitleComponentStateRef]
        def component_as_title(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TitleComponentStateRef.new(Native.LayoutState_component_as_title(@handle.ptr, index))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for an entire
    # layout. Use this with care, as invalid usage will result in a panic.
    # 
    # Specifically, you should avoid doing the following:
    # 
    # - Using out of bounds indices.
    # - Using the wrong getter function on the wrong type of component.
    class LayoutStateRefMut < LayoutStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for an entire
    # layout. Use this with care, as invalid usage will result in a panic.
    # 
    # Specifically, you should avoid doing the following:
    # 
    # - Using out of bounds indices.
    # - Using the wrong getter function on the wrong type of component.
    class LayoutState < LayoutStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.LayoutState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = LayoutState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new empty Layout State. This is useful for creating an empty
        # layout state that gets updated over time.
        # @return [LayoutState]
        def self.create()
            result = LayoutState.new(Native.LayoutState_new())
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A run parsed by the Composite Parser. This contains the Run itself and
    # information about which parser parsed it.
    class ParseRunResultRef
        attr_accessor :handle
        # Returns true if the Run got parsed successfully. false is returned otherwise.
        # @return [Boolean]
        def parsed_successfully()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.ParseRunResult_parsed_successfully(@handle.ptr)
            result
        end
        # Accesses the name of the Parser that parsed the Run. You may not call this
        # if the Run wasn't parsed successfully.
        # @return [String]
        def timer_kind()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.ParseRunResult_timer_kind(@handle.ptr)
            result
        end
        # Checks whether the Parser parsed a generic timer. Since a generic timer can
        # have any name, it may clash with the specific timer formats that
        # livesplit-core supports. With this function you can determine if a generic
        # timer format was parsed, instead of one of the more specific timer formats.
        # @return [Boolean]
        def is_generic_timer()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.ParseRunResult_is_generic_timer(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A run parsed by the Composite Parser. This contains the Run itself and
    # information about which parser parsed it.
    class ParseRunResultRefMut < ParseRunResultRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A run parsed by the Composite Parser. This contains the Run itself and
    # information about which parser parsed it.
    class ParseRunResult < ParseRunResultRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.ParseRunResult_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = ParseRunResult.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Moves the actual Run object out of the Result. You may not call this if the
        # Run wasn't parsed successfully.
        # @return [Run]
        def unwrap()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Run.new(Native.ParseRunResult_unwrap(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The PB Chance Component is a component that shows how likely it is to beat
    # the Personal Best. If there is no active attempt it shows the general chance
    # of beating the Personal Best. During an attempt it actively changes based on
    # how well the attempt is going.
    class PbChanceComponentRef
        attr_accessor :handle
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.PbChanceComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [KeyValueComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = KeyValueComponentState.new(Native.PbChanceComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The PB Chance Component is a component that shows how likely it is to beat
    # the Personal Best. If there is no active attempt it shows the general chance
    # of beating the Personal Best. During an attempt it actively changes based on
    # how well the attempt is going.
    class PbChanceComponentRefMut < PbChanceComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The PB Chance Component is a component that shows how likely it is to beat
    # the Personal Best. If there is no active attempt it shows the general chance
    # of beating the Personal Best. During an attempt it actively changes based on
    # how well the attempt is going.
    class PbChanceComponent < PbChanceComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.PbChanceComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = PbChanceComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new PB Chance Component.
        # @return [PbChanceComponent]
        def self.create()
            result = PbChanceComponent.new(Native.PbChanceComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.PbChanceComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Possible Time Save Component is a component that shows how much time the
    # chosen comparison could've saved for the current segment, based on the Best
    # Segments. This component also allows showing the Total Possible Time Save
    # for the remainder of the current attempt.
    class PossibleTimeSaveComponentRef
        attr_accessor :handle
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.PossibleTimeSaveComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [KeyValueComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = KeyValueComponentState.new(Native.PossibleTimeSaveComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Possible Time Save Component is a component that shows how much time the
    # chosen comparison could've saved for the current segment, based on the Best
    # Segments. This component also allows showing the Total Possible Time Save
    # for the remainder of the current attempt.
    class PossibleTimeSaveComponentRefMut < PossibleTimeSaveComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Possible Time Save Component is a component that shows how much time the
    # chosen comparison could've saved for the current segment, based on the Best
    # Segments. This component also allows showing the Total Possible Time Save
    # for the remainder of the current attempt.
    class PossibleTimeSaveComponent < PossibleTimeSaveComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.PossibleTimeSaveComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = PossibleTimeSaveComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Possible Time Save Component.
        # @return [PossibleTimeSaveComponent]
        def self.create()
            result = PossibleTimeSaveComponent.new(Native.PossibleTimeSaveComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.PossibleTimeSaveComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # Describes a potential clean up that could be applied. You can query a
    # message describing the details of this potential clean up. A potential clean
    # up can then be turned into an actual clean up in order to apply it to the
    # Run.
    class PotentialCleanUpRef
        attr_accessor :handle
        # Accesses the message describing the potential clean up that can be applied
        # to a Run.
        # @return [String]
        def message()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.PotentialCleanUp_message(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Describes a potential clean up that could be applied. You can query a
    # message describing the details of this potential clean up. A potential clean
    # up can then be turned into an actual clean up in order to apply it to the
    # Run.
    class PotentialCleanUpRefMut < PotentialCleanUpRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Describes a potential clean up that could be applied. You can query a
    # message describing the details of this potential clean up. A potential clean
    # up can then be turned into an actual clean up in order to apply it to the
    # Run.
    class PotentialCleanUp < PotentialCleanUpRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.PotentialCleanUp_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = PotentialCleanUp.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Previous Segment Component is a component that shows how much time was
    # saved or lost during the previous segment based on the chosen comparison.
    # Additionally, the potential time save for the previous segment can be
    # displayed. This component switches to a `Live Segment` view that shows
    # active time loss whenever the runner is losing time on the current segment.
    class PreviousSegmentComponentRef
        attr_accessor :handle
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [String]
        def state_as_json(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = Native.PreviousSegmentComponent_state_as_json(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer and the layout
        # settings provided.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [KeyValueComponentState]
        def state(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = KeyValueComponentState.new(Native.PreviousSegmentComponent_state(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Previous Segment Component is a component that shows how much time was
    # saved or lost during the previous segment based on the chosen comparison.
    # Additionally, the potential time save for the previous segment can be
    # displayed. This component switches to a `Live Segment` view that shows
    # active time loss whenever the runner is losing time on the current segment.
    class PreviousSegmentComponentRefMut < PreviousSegmentComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Previous Segment Component is a component that shows how much time was
    # saved or lost during the previous segment based on the chosen comparison.
    # Additionally, the potential time save for the previous segment can be
    # displayed. This component switches to a `Live Segment` view that shows
    # active time loss whenever the runner is losing time on the current segment.
    class PreviousSegmentComponent < PreviousSegmentComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.PreviousSegmentComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = PreviousSegmentComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Previous Segment Component.
        # @return [PreviousSegmentComponent]
        def self.create()
            result = PreviousSegmentComponent.new(Native.PreviousSegmentComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.PreviousSegmentComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Run stores the split times for a specific game and category of a runner.
    class RunRef
        attr_accessor :handle
        # Clones the Run object.
        # @return [Run]
        def clone()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Run.new(Native.Run_clone(@handle.ptr))
            result
        end
        # Accesses the name of the game this Run is for.
        # @return [String]
        def game_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_game_name(@handle.ptr)
            result
        end
        # Accesses the game icon's data. If there is no game icon, this returns an
        # empty buffer.
        # @return [Integer]
        def game_icon_ptr()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_game_icon_ptr(@handle.ptr)
            result
        end
        # Accesses the amount of bytes the game icon's data takes up.
        # @return [Integer]
        def game_icon_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_game_icon_len(@handle.ptr)
            result
        end
        # Accesses the name of the category this Run is for.
        # @return [String]
        def category_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_category_name(@handle.ptr)
            result
        end
        # Returns a file name (without the extension) suitable for this Run that
        # is built the following way:
        # 
        # Game Name - Category Name
        # 
        # If either is empty, the dash is omitted. Special characters that cause
        # problems in file names are also omitted. If an extended category name is
        # used, the variables of the category are appended in a parenthesis.
        # @param [Boolean] use_extended_category_name
        # @return [String]
        def extended_file_name(use_extended_category_name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_extended_file_name(@handle.ptr, use_extended_category_name)
            result
        end
        # Returns a name suitable for this Run that is built the following way:
        # 
        # Game Name - Category Name
        # 
        # If either is empty, the dash is omitted. If an extended category name is
        # used, the variables of the category are appended in a parenthesis.
        # @param [Boolean] use_extended_category_name
        # @return [String]
        def extended_name(use_extended_category_name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_extended_name(@handle.ptr, use_extended_category_name)
            result
        end
        # Returns an extended category name that possibly includes the region,
        # platform and variables, depending on the arguments provided. An extended
        # category name may look like this:
        # 
        # Any% (No Tuner, JPN, Wii Emulator)
        # @param [Boolean] show_region
        # @param [Boolean] show_platform
        # @param [Boolean] show_variables
        # @return [String]
        def extended_category_name(show_region, show_platform, show_variables)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_extended_category_name(@handle.ptr, show_region, show_platform, show_variables)
            result
        end
        # Returns the amount of runs that have been attempted with these splits.
        # @return [Integer]
        def attempt_count()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_attempt_count(@handle.ptr)
            result
        end
        # Accesses additional metadata of this Run, like the platform and region
        # of the game.
        # @return [RunMetadataRef]
        def metadata()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunMetadataRef.new(Native.Run_metadata(@handle.ptr))
            result
        end
        # Accesses the time an attempt of this Run should start at.
        # @return [TimeSpanRef]
        def offset()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpanRef.new(Native.Run_offset(@handle.ptr))
            result
        end
        # Returns the amount of segments stored in this Run.
        # @return [Integer]
        def len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_len(@handle.ptr)
            result
        end
        # Returns whether the Run has been modified and should be saved so that the
        # changes don't get lost.
        # @return [Boolean]
        def has_been_modified()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_has_been_modified(@handle.ptr)
            result
        end
        # Accesses a certain segment of this Run. You may not provide an out of bounds
        # index.
        # @param [Integer] index
        # @return [SegmentRef]
        def segment(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SegmentRef.new(Native.Run_segment(@handle.ptr, index))
            result
        end
        # Returns the amount attempt history elements are stored in this Run.
        # @return [Integer]
        def attempt_history_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_attempt_history_len(@handle.ptr)
            result
        end
        # Accesses the an attempt history element by its index. This does not store
        # the actual segment times, just the overall attempt information. Information
        # about the individual segments is stored within each segment. You may not
        # provide an out of bounds index.
        # @param [Integer] index
        # @return [AttemptRef]
        def attempt_history_index(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = AttemptRef.new(Native.Run_attempt_history_index(@handle.ptr, index))
            result
        end
        # Saves a Run as a LiveSplit splits file (*.lss). If the run is actively in
        # use by a timer, use the appropriate method on the timer instead, in order to
        # properly save the current attempt as well.
        # @return [String]
        def save_as_lss()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_save_as_lss(@handle.ptr)
            result
        end
        # Returns the amount of custom comparisons stored in this Run.
        # @return [Integer]
        def custom_comparisons_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_custom_comparisons_len(@handle.ptr)
            result
        end
        # Accesses a custom comparison stored in this Run by its index. This includes
        # `Personal Best` but excludes all the other Comparison Generators. You may
        # not provide an out of bounds index.
        # @param [Integer] index
        # @return [String]
        def custom_comparison(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_custom_comparison(@handle.ptr, index)
            result
        end
        # Accesses the Auto Splitter Settings that are encoded as XML.
        # @return [String]
        def auto_splitter_settings()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_auto_splitter_settings(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Run stores the split times for a specific game and category of a runner.
    class RunRefMut < RunRef
        # Pushes the segment provided to the end of the list of segments of this Run.
        # @param [Segment] segment
        def push_segment(segment)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if segment.handle.ptr == nil
                raise "segment is disposed"
            end
            Native.Run_push_segment(@handle.ptr, segment.handle.ptr)
            segment.handle.ptr = nil
        end
        # Sets the name of the game this Run is for.
        # @param [String] game
        def set_game_name(game)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Run_set_game_name(@handle.ptr, game)
        end
        # Sets the name of the category this Run is for.
        # @param [String] category
        def set_category_name(category)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Run_set_category_name(@handle.ptr, category)
        end
        # Marks the Run as modified, so that it is known that there are changes
        # that should be saved.
        def mark_as_modified()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Run_mark_as_modified(@handle.ptr)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Run stores the split times for a specific game and category of a runner.
    class Run < RunRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.Run_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = Run.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Run object with no segments.
        # @return [Run]
        def self.create()
            result = Run.new(Native.Run_new())
            result
        end
        # Attempts to parse a splits file from an array by invoking the corresponding
        # parser for the file format detected. Additionally you can provide the path
        # of the splits file so additional files, like external images, can be loaded.
        # If you are using livesplit-core in a server-like environment, set this to
        # nil. Only client-side applications should provide a path here. Unlike the
        # normal parsing function, it also fixes problems in the Run, such as
        # decreasing times and missing information.
        # @param [Integer] data
        # @param [Integer] length
        # @param [String] load_files_path
        # @return [ParseRunResult]
        def self.parse(data, length, load_files_path)
            result = ParseRunResult.new(Native.Run_parse(data, length, load_files_path))
            result
        end
        # Attempts to parse a splits file from a file by invoking the corresponding
        # parser for the file format detected. Additionally you can provide the path
        # of the splits file so additional files, like external images, can be loaded.
        # If you are using livesplit-core in a server-like environment, set this to
        # nil. Only client-side applications should provide a path here. Unlike the
        # normal parsing function, it also fixes problems in the Run, such as
        # decreasing times and missing information. On Unix you pass a file descriptor
        # to this function. On Windows you pass a file handle to this function. The
        # file descriptor / handle does not get closed.
        # @param [Integer] handle
        # @param [String] load_files_path
        # @return [ParseRunResult]
        def self.parse_file_handle(handle, load_files_path)
            result = ParseRunResult.new(Native.Run_parse_file_handle(handle, load_files_path))
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Run Editor allows modifying Runs while ensuring that all the different
    # invariants of the Run objects are upheld no matter what kind of operations
    # are being applied to the Run. It provides the current state of the editor as
    # state objects that can be visualized by any kind of User Interface.
    class RunEditorRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Run Editor allows modifying Runs while ensuring that all the different
    # invariants of the Run objects are upheld no matter what kind of operations
    # are being applied to the Run. It provides the current state of the editor as
    # state objects that can be visualized by any kind of User Interface.
    class RunEditorRefMut < RunEditorRef
        # Calculates the Run Editor's state and encodes it as
        # JSON in order to visualize it.
        # @return [String]
        def state_as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_state_as_json(@handle.ptr)
            result
        end
        # Selects a different timing method for being modified.
        # @param [Integer] method
        def select_timing_method(method)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_select_timing_method(@handle.ptr, method)
        end
        # Unselects the segment with the given index. If it's not selected or the
        # index is out of bounds, nothing happens. The segment is not unselected,
        # when it is the only segment that is selected. If the active segment is
        # unselected, the most recently selected segment remaining becomes the
        # active segment.
        # @param [Integer] index
        def unselect(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_unselect(@handle.ptr, index)
        end
        # In addition to the segments that are already selected, the segment with
        # the given index is being selected. The segment chosen also becomes the
        # active segment.
        # 
        # This panics if the index of the segment provided is out of bounds.
        # @param [Integer] index
        def select_additionally(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_select_additionally(@handle.ptr, index)
        end
        # Selects the segment with the given index. All other segments are
        # unselected. The segment chosen also becomes the active segment.
        # 
        # This panics if the index of the segment provided is out of bounds.
        # @param [Integer] index
        def select_only(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_select_only(@handle.ptr, index)
        end
        # Sets the name of the game.
        # @param [String] game
        def set_game_name(game)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_game_name(@handle.ptr, game)
        end
        # Sets the name of the category.
        # @param [String] category
        def set_category_name(category)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_category_name(@handle.ptr, category)
        end
        # Parses and sets the timer offset from the string provided. The timer
        # offset specifies the time, the timer starts at when starting a new
        # attempt.
        # @param [String] offset
        # @return [Boolean]
        def parse_and_set_offset(offset)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_parse_and_set_offset(@handle.ptr, offset)
            result
        end
        # Parses and sets the attempt count from the string provided. Changing
        # this has no affect on the attempt history or the segment history. This
        # number is mostly just a visual number for the runner.
        # @param [String] attempts
        # @return [Boolean]
        def parse_and_set_attempt_count(attempts)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_parse_and_set_attempt_count(@handle.ptr, attempts)
            result
        end
        # Sets the game's icon.
        # @param [Integer] data
        # @param [Integer] length
        def set_game_icon(data, length)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_game_icon(@handle.ptr, data, length)
        end
        # Removes the game's icon.
        def remove_game_icon()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_remove_game_icon(@handle.ptr)
        end
        # Sets the speedrun.com Run ID of the run. You need to ensure that the
        # record on speedrun.com matches up with the Personal Best of this run.
        # This may be empty if there's no association.
        # @param [String] name
        def set_run_id(name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_run_id(@handle.ptr, name)
        end
        # Sets the name of the region this game is from. This may be empty if it's
        # not specified.
        # @param [String] name
        def set_region_name(name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_region_name(@handle.ptr, name)
        end
        # Sets the name of the platform this game is run on. This may be empty if
        # it's not specified.
        # @param [String] name
        def set_platform_name(name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_platform_name(@handle.ptr, name)
        end
        # Specifies whether this speedrun is done on an emulator. Keep in mind
        # that false may also mean that this information is simply not known.
        # @param [Boolean] uses_emulator
        def set_emulator_usage(uses_emulator)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_emulator_usage(@handle.ptr, uses_emulator)
        end
        # Sets the speedrun.com variable with the name specified to the value specified. A
        # variable is an arbitrary key value pair storing additional information
        # about the category. An example of this may be whether Amiibos are used
        # in this category. If the variable doesn't exist yet, it is being
        # inserted.
        # @param [String] name
        # @param [String] value
        def set_speedrun_com_variable(name, value)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_speedrun_com_variable(@handle.ptr, name, value)
        end
        # Removes the speedrun.com variable with the name specified.
        # @param [String] name
        def remove_speedrun_com_variable(name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_remove_speedrun_com_variable(@handle.ptr, name)
        end
        # Adds a new permanent custom variable. If there's a temporary variable with
        # the same name, it gets turned into a permanent variable and its value stays.
        # If a permanent variable with the name already exists, nothing happens.
        # @param [String] name
        def add_custom_variable(name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_add_custom_variable(@handle.ptr, name)
        end
        # Sets the value of a custom variable with the name specified. If the custom
        # variable does not exist, or is not a permanent variable, nothing happens.
        # @param [String] name
        # @param [String] value
        def set_custom_variable(name, value)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_custom_variable(@handle.ptr, name, value)
        end
        # Removes the custom variable with the name specified. If the custom variable
        # does not exist, or is not a permanent variable, nothing happens.
        # @param [String] name
        def remove_custom_variable(name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_remove_custom_variable(@handle.ptr, name)
        end
        # Resets all the Metadata Information.
        def clear_metadata()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_clear_metadata(@handle.ptr)
        end
        # Inserts a new empty segment above the active segment and adjusts the
        # Run's history information accordingly. The newly created segment is then
        # the only selected segment and also the active segment.
        def insert_segment_above()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_insert_segment_above(@handle.ptr)
        end
        # Inserts a new empty segment below the active segment and adjusts the
        # Run's history information accordingly. The newly created segment is then
        # the only selected segment and also the active segment.
        def insert_segment_below()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_insert_segment_below(@handle.ptr)
        end
        # Removes all the selected segments, unless all of them are selected. The
        # run's information is automatically adjusted properly. The next
        # not-to-be-removed segment after the active segment becomes the new
        # active segment. If there's none, then the next not-to-be-removed segment
        # before the active segment, becomes the new active segment.
        def remove_segments()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_remove_segments(@handle.ptr)
        end
        # Moves all the selected segments up, unless the first segment is
        # selected. The run's information is automatically adjusted properly. The
        # active segment stays the active segment.
        def move_segments_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_move_segments_up(@handle.ptr)
        end
        # Moves all the selected segments down, unless the last segment is
        # selected. The run's information is automatically adjusted properly. The
        # active segment stays the active segment.
        def move_segments_down()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_move_segments_down(@handle.ptr)
        end
        # Sets the icon of the active segment.
        # @param [Integer] data
        # @param [Integer] length
        def active_set_icon(data, length)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_active_set_icon(@handle.ptr, data, length)
        end
        # Removes the icon of the active segment.
        def active_remove_icon()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_active_remove_icon(@handle.ptr)
        end
        # Sets the name of the active segment.
        # @param [String] name
        def active_set_name(name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_active_set_name(@handle.ptr, name)
        end
        # Parses a split time from a string and sets it for the active segment with
        # the chosen timing method.
        # @param [String] time
        # @return [Boolean]
        def active_parse_and_set_split_time(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_active_parse_and_set_split_time(@handle.ptr, time)
            result
        end
        # Parses a segment time from a string and sets it for the active segment with
        # the chosen timing method.
        # @param [String] time
        # @return [Boolean]
        def active_parse_and_set_segment_time(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_active_parse_and_set_segment_time(@handle.ptr, time)
            result
        end
        # Parses a best segment time from a string and sets it for the active segment
        # with the chosen timing method.
        # @param [String] time
        # @return [Boolean]
        def active_parse_and_set_best_segment_time(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_active_parse_and_set_best_segment_time(@handle.ptr, time)
            result
        end
        # Parses a comparison time for the provided comparison and sets it for the
        # active active segment with the chosen timing method.
        # @param [String] comparison
        # @param [String] time
        # @return [Boolean]
        def active_parse_and_set_comparison_time(comparison, time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_active_parse_and_set_comparison_time(@handle.ptr, comparison, time)
            result
        end
        # Adds a new custom comparison. It can't be added if it starts with
        # `[Race]` or already exists.
        # @param [String] comparison
        # @return [Boolean]
        def add_comparison(comparison)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_add_comparison(@handle.ptr, comparison)
            result
        end
        # Imports the Personal Best from the provided run as a comparison. The
        # comparison can't be added if its name starts with `[Race]` or it already
        # exists.
        # @param [RunRef] run
        # @param [String] comparison
        # @return [Boolean]
        def import_comparison(run, comparison)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if run.handle.ptr == nil
                raise "run is disposed"
            end
            result = Native.RunEditor_import_comparison(@handle.ptr, run.handle.ptr, comparison)
            result
        end
        # Removes the chosen custom comparison. You can't remove a Comparison
        # Generator's Comparison or the Personal Best.
        # @param [String] comparison
        def remove_comparison(comparison)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_remove_comparison(@handle.ptr, comparison)
        end
        # Renames a comparison. The comparison can't be renamed if the new name of
        # the comparison starts with `[Race]` or it already exists.
        # @param [String] old_name
        # @param [String] new_name
        # @return [Boolean]
        def rename_comparison(old_name, new_name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_rename_comparison(@handle.ptr, old_name, new_name)
            result
        end
        # Reorders the custom comparisons by moving the comparison with the source
        # index specified to the destination index specified. Returns false if one
        # of the indices is invalid. The indices are based on the comparison names of
        # the Run Editor's state.
        # @param [Integer] src_index
        # @param [Integer] dst_index
        # @return [Boolean]
        def move_comparison(src_index, dst_index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_move_comparison(@handle.ptr, src_index, dst_index)
            result
        end
        # Parses a goal time and generates a custom goal comparison based on the
        # parsed value. The comparison's times are automatically balanced based on the
        # runner's history such that it roughly represents what split times for the
        # goal time would roughly look like. Since it is populated by the runner's
        # history, only goal times within the sum of the best segments and the sum of
        # the worst segments are supported. Everything else is automatically capped by
        # that range. The comparison is only populated for the selected timing method.
        # The other timing method's comparison times are not modified by this, so you
        # can call this again with the other timing method to generate the comparison
        # times for both timing methods.
        # @param [String] time
        # @return [Boolean]
        def parse_and_generate_goal_comparison(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_parse_and_generate_goal_comparison(@handle.ptr, time)
            result
        end
        # Clears out the Attempt History and the Segment Histories of all the
        # segments.
        def clear_history()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_clear_history(@handle.ptr)
        end
        # Clears out the Attempt History, the Segment Histories, all the times,
        # sets the Attempt Count to 0 and clears the speedrun.com run id
        # association. All Custom Comparisons other than `Personal Best` are
        # deleted as well.
        def clear_times()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_clear_times(@handle.ptr)
        end
        # Creates a Sum of Best Cleaner which allows you to interactively remove
        # potential issues in the segment history that lead to an inaccurate Sum
        # of Best. If you skip a split, whenever you will do the next split, the
        # combined segment time might be faster than the sum of the individual
        # best segments. The Sum of Best Cleaner will point out all of these and
        # allows you to delete them individually if any of them seem wrong.
        # @return [SumOfBestCleaner]
        def clean_sum_of_best()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SumOfBestCleaner.new(Native.RunEditor_clean_sum_of_best(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Run Editor allows modifying Runs while ensuring that all the different
    # invariants of the Run objects are upheld no matter what kind of operations
    # are being applied to the Run. It provides the current state of the editor as
    # state objects that can be visualized by any kind of User Interface.
    class RunEditor < RunEditorRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = RunEditor.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Run Editor that modifies the Run provided. Creation of the Run
        # Editor fails when a Run with no segments is provided. If a Run object with
        # no segments is provided, the Run Editor creation fails and nil is
        # returned.
        # @param [Run] run
        # @return [RunEditor, nil]
        def self.create(run)
            if run.handle.ptr == nil
                raise "run is disposed"
            end
            result = RunEditor.new(Native.RunEditor_new(run.handle.ptr))
            run.handle.ptr = nil
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Closes the Run Editor and gives back access to the modified Run object. In
        # case you want to implement a Cancel Button, just dispose the Run object you
        # get here.
        # @return [Run]
        def close()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Run.new(Native.RunEditor_close(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Run Metadata stores additional information about a run, like the
    # platform and region of the game. All of this information is optional.
    class RunMetadataRef
        attr_accessor :handle
        # Accesses the speedrun.com Run ID of the run. This Run ID specify which
        # Record on speedrun.com this run is associated with. This should be
        # changed once the Personal Best doesn't match up with that record
        # anymore. This may be empty if there's no association.
        # @return [String]
        def run_id()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadata_run_id(@handle.ptr)
            result
        end
        # Accesses the name of the platform this game is run on. This may be empty
        # if it's not specified.
        # @return [String]
        def platform_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadata_platform_name(@handle.ptr)
            result
        end
        # Returns true if this speedrun is done on an emulator. However false
        # may also indicate that this information is simply not known.
        # @return [Boolean]
        def uses_emulator()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadata_uses_emulator(@handle.ptr)
            result
        end
        # Accesses the name of the region this game is from. This may be empty if
        # it's not specified.
        # @return [String]
        def region_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadata_region_name(@handle.ptr)
            result
        end
        # Returns an iterator iterating over all the speedrun.com variables and their
        # values that have been specified.
        # @return [RunMetadataSpeedrunComVariablesIter]
        def speedrun_com_variables()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunMetadataSpeedrunComVariablesIter.new(Native.RunMetadata_speedrun_com_variables(@handle.ptr))
            result
        end
        # Returns an iterator iterating over all the custom variables and their
        # values. This includes both temporary and permanent variables.
        # @return [RunMetadataCustomVariablesIter]
        def custom_variables()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunMetadataCustomVariablesIter.new(Native.RunMetadata_custom_variables(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Run Metadata stores additional information about a run, like the
    # platform and region of the game. All of this information is optional.
    class RunMetadataRefMut < RunMetadataRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Run Metadata stores additional information about a run, like the
    # platform and region of the game. All of this information is optional.
    class RunMetadata < RunMetadataRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = RunMetadata.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A custom variable is a key value pair storing additional information about a
    # run. Unlike the speedrun.com variables, these can be fully custom and don't
    # need to correspond to anything on speedrun.com. Permanent custom variables
    # can be specified by the runner. Additionally auto splitters or other sources
    # may provide temporary custom variables that are not stored in the splits
    # files.
    class RunMetadataCustomVariableRef
        attr_accessor :handle
        # Accesses the name of this custom variable.
        # @return [String]
        def name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadataCustomVariable_name(@handle.ptr)
            result
        end
        # Accesses the value of this custom variable.
        # @return [String]
        def value()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadataCustomVariable_value(@handle.ptr)
            result
        end
        # Returns true if the custom variable is permanent. Permanent variables get
        # stored in the splits file and are visible in the run editor. Temporary
        # variables are not.
        # @return [Boolean]
        def is_permanent()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadataCustomVariable_is_permanent(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A custom variable is a key value pair storing additional information about a
    # run. Unlike the speedrun.com variables, these can be fully custom and don't
    # need to correspond to anything on speedrun.com. Permanent custom variables
    # can be specified by the runner. Additionally auto splitters or other sources
    # may provide temporary custom variables that are not stored in the splits
    # files.
    class RunMetadataCustomVariableRefMut < RunMetadataCustomVariableRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A custom variable is a key value pair storing additional information about a
    # run. Unlike the speedrun.com variables, these can be fully custom and don't
    # need to correspond to anything on speedrun.com. Permanent custom variables
    # can be specified by the runner. Additionally auto splitters or other sources
    # may provide temporary custom variables that are not stored in the splits
    # files.
    class RunMetadataCustomVariable < RunMetadataCustomVariableRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.RunMetadataCustomVariable_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = RunMetadataCustomVariable.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # An iterator iterating over all the custom variables and their values
    # that have been specified.
    class RunMetadataCustomVariablesIterRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # An iterator iterating over all the custom variables and their values
    # that have been specified.
    class RunMetadataCustomVariablesIterRefMut < RunMetadataCustomVariablesIterRef
        # Accesses the next custom variable. Returns nil if there are no more
        # variables.
        # @return [RunMetadataCustomVariableRef, nil]
        def next()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunMetadataCustomVariableRef.new(Native.RunMetadataCustomVariablesIter_next(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # An iterator iterating over all the custom variables and their values
    # that have been specified.
    class RunMetadataCustomVariablesIter < RunMetadataCustomVariablesIterRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.RunMetadataCustomVariablesIter_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = RunMetadataCustomVariablesIter.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A speedrun.com variable is an arbitrary key value pair storing additional
    # information about the category. An example of this may be whether Amiibos
    # are used in the category.
    class RunMetadataSpeedrunComVariableRef
        attr_accessor :handle
        # Accesses the name of this speedrun.com variable.
        # @return [String]
        def name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadataSpeedrunComVariable_name(@handle.ptr)
            result
        end
        # Accesses the value of this speedrun.com variable.
        # @return [String]
        def value()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadataSpeedrunComVariable_value(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A speedrun.com variable is an arbitrary key value pair storing additional
    # information about the category. An example of this may be whether Amiibos
    # are used in the category.
    class RunMetadataSpeedrunComVariableRefMut < RunMetadataSpeedrunComVariableRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A speedrun.com variable is an arbitrary key value pair storing additional
    # information about the category. An example of this may be whether Amiibos
    # are used in the category.
    class RunMetadataSpeedrunComVariable < RunMetadataSpeedrunComVariableRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.RunMetadataSpeedrunComVariable_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = RunMetadataSpeedrunComVariable.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # An iterator iterating over all the speedrun.com variables and their values
    # that have been specified.
    class RunMetadataSpeedrunComVariablesIterRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # An iterator iterating over all the speedrun.com variables and their values
    # that have been specified.
    class RunMetadataSpeedrunComVariablesIterRefMut < RunMetadataSpeedrunComVariablesIterRef
        # Accesses the next speedrun.com variable. Returns nil if there are no more
        # variables.
        # @return [RunMetadataSpeedrunComVariableRef, nil]
        def next()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunMetadataSpeedrunComVariableRef.new(Native.RunMetadataSpeedrunComVariablesIter_next(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # An iterator iterating over all the speedrun.com variables and their values
    # that have been specified.
    class RunMetadataSpeedrunComVariablesIter < RunMetadataSpeedrunComVariablesIterRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.RunMetadataSpeedrunComVariablesIter_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = RunMetadataSpeedrunComVariablesIter.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Segment describes a point in a speedrun that is suitable for storing a
    # split time. This stores the name of that segment, an icon, the split times
    # of different comparisons, and a history of segment times.
    class SegmentRef
        attr_accessor :handle
        # Accesses the name of the segment.
        # @return [String]
        def name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Segment_name(@handle.ptr)
            result
        end
        # Accesses the segment icon's data. If there is no segment icon, this returns
        # an empty buffer.
        # @return [Integer]
        def icon_ptr()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Segment_icon_ptr(@handle.ptr)
            result
        end
        # Accesses the amount of bytes the segment icon's data takes up.
        # @return [Integer]
        def icon_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Segment_icon_len(@handle.ptr)
            result
        end
        # Accesses the specified comparison's time. If there's none for this
        # comparison, an empty time is being returned (but not stored in the
        # segment).
        # @param [String] comparison
        # @return [TimeRef]
        def comparison(comparison)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Segment_comparison(@handle.ptr, comparison))
            result
        end
        # Accesses the split time of the Personal Best for this segment. If it
        # doesn't exist, an empty time is returned.
        # @return [TimeRef]
        def personal_best_split_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Segment_personal_best_split_time(@handle.ptr))
            result
        end
        # Accesses the Best Segment Time.
        # @return [TimeRef]
        def best_segment_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Segment_best_segment_time(@handle.ptr))
            result
        end
        # Accesses the Segment History of this segment.
        # @return [SegmentHistoryRef]
        def segment_history()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SegmentHistoryRef.new(Native.Segment_segment_history(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Segment describes a point in a speedrun that is suitable for storing a
    # split time. This stores the name of that segment, an icon, the split times
    # of different comparisons, and a history of segment times.
    class SegmentRefMut < SegmentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Segment describes a point in a speedrun that is suitable for storing a
    # split time. This stores the name of that segment, an icon, the split times
    # of different comparisons, and a history of segment times.
    class Segment < SegmentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.Segment_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = Segment.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Segment with the name given.
        # @param [String] name
        # @return [Segment]
        def self.create(name)
            result = Segment.new(Native.Segment_new(name))
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # Stores the segment times achieved for a certain segment. Each segment is
    # tagged with an index. Only segment times with an index larger than 0 are
    # considered times actually achieved by the runner, while the others are
    # artifacts of route changes and similar algorithmic changes.
    class SegmentHistoryRef
        attr_accessor :handle
        # Iterates over all the segment times and their indices.
        # @return [SegmentHistoryIter]
        def iter()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SegmentHistoryIter.new(Native.SegmentHistory_iter(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Stores the segment times achieved for a certain segment. Each segment is
    # tagged with an index. Only segment times with an index larger than 0 are
    # considered times actually achieved by the runner, while the others are
    # artifacts of route changes and similar algorithmic changes.
    class SegmentHistoryRefMut < SegmentHistoryRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Stores the segment times achieved for a certain segment. Each segment is
    # tagged with an index. Only segment times with an index larger than 0 are
    # considered times actually achieved by the runner, while the others are
    # artifacts of route changes and similar algorithmic changes.
    class SegmentHistory < SegmentHistoryRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SegmentHistory.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A segment time achieved for a segment. It is tagged with an index. Only
    # segment times with an index larger than 0 are considered times actually
    # achieved by the runner, while the others are artifacts of route changes and
    # similar algorithmic changes.
    class SegmentHistoryElementRef
        attr_accessor :handle
        # Accesses the index of the segment history element.
        # @return [Integer]
        def index()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SegmentHistoryElement_index(@handle.ptr)
            result
        end
        # Accesses the segment time of the segment history element.
        # @return [TimeRef]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.SegmentHistoryElement_time(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A segment time achieved for a segment. It is tagged with an index. Only
    # segment times with an index larger than 0 are considered times actually
    # achieved by the runner, while the others are artifacts of route changes and
    # similar algorithmic changes.
    class SegmentHistoryElementRefMut < SegmentHistoryElementRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A segment time achieved for a segment. It is tagged with an index. Only
    # segment times with an index larger than 0 are considered times actually
    # achieved by the runner, while the others are artifacts of route changes and
    # similar algorithmic changes.
    class SegmentHistoryElement < SegmentHistoryElementRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SegmentHistoryElement.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # Iterates over all the segment times of a segment and their indices.
    class SegmentHistoryIterRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Iterates over all the segment times of a segment and their indices.
    class SegmentHistoryIterRefMut < SegmentHistoryIterRef
        # Accesses the next Segment History element. Returns nil if there are no
        # more elements.
        # @return [SegmentHistoryElementRef, nil]
        def next()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SegmentHistoryElementRef.new(Native.SegmentHistoryIter_next(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Iterates over all the segment times of a segment and their indices.
    class SegmentHistoryIter < SegmentHistoryIterRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SegmentHistoryIter_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SegmentHistoryIter.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Segment Time Component is a component that shows the time for the current
    # segment in a comparison of your choosing. If no comparison is specified it
    # uses the timer's current comparison.
    class SegmentTimeComponentRef
        attr_accessor :handle
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.SegmentTimeComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [KeyValueComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = KeyValueComponentState.new(Native.SegmentTimeComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Segment Time Component is a component that shows the time for the current
    # segment in a comparison of your choosing. If no comparison is specified it
    # uses the timer's current comparison.
    class SegmentTimeComponentRefMut < SegmentTimeComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Segment Time Component is a component that shows the time for the current
    # segment in a comparison of your choosing. If no comparison is specified it
    # uses the timer's current comparison.
    class SegmentTimeComponent < SegmentTimeComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SegmentTimeComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SegmentTimeComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Segment Time Component.
        # @return [SegmentTimeComponent]
        def self.create()
            result = SegmentTimeComponent.new(Native.SegmentTimeComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.SegmentTimeComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Separator Component is a simple component that only serves to render
    # separators between components.
    class SeparatorComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Separator Component is a simple component that only serves to render
    # separators between components.
    class SeparatorComponentRefMut < SeparatorComponentRef
        # Calculates the component's state.
        # @return [SeparatorComponentState]
        def state()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SeparatorComponentState.new(Native.SeparatorComponent_state(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Separator Component is a simple component that only serves to render
    # separators between components.
    class SeparatorComponent < SeparatorComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SeparatorComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SeparatorComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Separator Component.
        # @return [SeparatorComponent]
        def self.create()
            result = SeparatorComponent.new(Native.SeparatorComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.SeparatorComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for this component.
    class SeparatorComponentStateRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class SeparatorComponentStateRefMut < SeparatorComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class SeparatorComponentState < SeparatorComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SeparatorComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SeparatorComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # Describes a setting's value. Such a value can be of a variety of different
    # types.
    class SettingValueRef
        attr_accessor :handle
        # Encodes this Setting Value's state as JSON.
        # @return [String]
        def as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SettingValue_as_json(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Describes a setting's value. Such a value can be of a variety of different
    # types.
    class SettingValueRefMut < SettingValueRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # Describes a setting's value. Such a value can be of a variety of different
    # types.
    class SettingValue < SettingValueRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SettingValue_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SettingValue.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new setting value from a boolean value.
        # @param [Boolean] value
        # @return [SettingValue]
        def self.from_bool(value)
            result = SettingValue.new(Native.SettingValue_from_bool(value))
            result
        end
        # Creates a new setting value from an unsigned integer.
        # @param [Integer] value
        # @return [SettingValue]
        def self.from_uint(value)
            result = SettingValue.new(Native.SettingValue_from_uint(value))
            result
        end
        # Creates a new setting value from a signed integer.
        # @param [Integer] value
        # @return [SettingValue]
        def self.from_int(value)
            result = SettingValue.new(Native.SettingValue_from_int(value))
            result
        end
        # Creates a new setting value from a string.
        # @param [String] value
        # @return [SettingValue]
        def self.from_string(value)
            result = SettingValue.new(Native.SettingValue_from_string(value))
            result
        end
        # Creates a new setting value from a string that has the type `optional string`.
        # @param [String] value
        # @return [SettingValue]
        def self.from_optional_string(value)
            result = SettingValue.new(Native.SettingValue_from_optional_string(value))
            result
        end
        # Creates a new empty setting value that has the type `optional string`.
        # @return [SettingValue]
        def self.from_optional_empty_string()
            result = SettingValue.new(Native.SettingValue_from_optional_empty_string())
            result
        end
        # Creates a new setting value from an accuracy name. If it doesn't match a
        # known accuracy, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_accuracy(value)
            result = SettingValue.new(Native.SettingValue_from_accuracy(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new setting value from a digits format name. If it doesn't match a
        # known digits format, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_digits_format(value)
            result = SettingValue.new(Native.SettingValue_from_digits_format(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new setting value from a timing method name with the type
        # `optional timing method`. If it doesn't match a known timing method, nil
        # is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_optional_timing_method(value)
            result = SettingValue.new(Native.SettingValue_from_optional_timing_method(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new empty setting value with the type `optional timing method`.
        # @return [SettingValue]
        def self.from_optional_empty_timing_method()
            result = SettingValue.new(Native.SettingValue_from_optional_empty_timing_method())
            result
        end
        # Creates a new setting value from the color provided as RGBA.
        # @param [Float] r
        # @param [Float] g
        # @param [Float] b
        # @param [Float] a
        # @return [SettingValue]
        def self.from_color(r, g, b, a)
            result = SettingValue.new(Native.SettingValue_from_color(r, g, b, a))
            result
        end
        # Creates a new setting value from the color provided as RGBA with the type
        # `optional color`.
        # @param [Float] r
        # @param [Float] g
        # @param [Float] b
        # @param [Float] a
        # @return [SettingValue]
        def self.from_optional_color(r, g, b, a)
            result = SettingValue.new(Native.SettingValue_from_optional_color(r, g, b, a))
            result
        end
        # Creates a new empty setting value with the type `optional color`.
        # @return [SettingValue]
        def self.from_optional_empty_color()
            result = SettingValue.new(Native.SettingValue_from_optional_empty_color())
            result
        end
        # Creates a new setting value that is a transparent gradient.
        # @return [SettingValue]
        def self.from_transparent_gradient()
            result = SettingValue.new(Native.SettingValue_from_transparent_gradient())
            result
        end
        # Creates a new setting value from the vertical gradient provided as two RGBA colors.
        # @param [Float] r1
        # @param [Float] g1
        # @param [Float] b1
        # @param [Float] a1
        # @param [Float] r2
        # @param [Float] g2
        # @param [Float] b2
        # @param [Float] a2
        # @return [SettingValue]
        def self.from_vertical_gradient(r1, g1, b1, a1, r2, g2, b2, a2)
            result = SettingValue.new(Native.SettingValue_from_vertical_gradient(r1, g1, b1, a1, r2, g2, b2, a2))
            result
        end
        # Creates a new setting value from the horizontal gradient provided as two RGBA colors.
        # @param [Float] r1
        # @param [Float] g1
        # @param [Float] b1
        # @param [Float] a1
        # @param [Float] r2
        # @param [Float] g2
        # @param [Float] b2
        # @param [Float] a2
        # @return [SettingValue]
        def self.from_horizontal_gradient(r1, g1, b1, a1, r2, g2, b2, a2)
            result = SettingValue.new(Native.SettingValue_from_horizontal_gradient(r1, g1, b1, a1, r2, g2, b2, a2))
            result
        end
        # Creates a new setting value from the alternating gradient provided as two RGBA colors.
        # @param [Float] r1
        # @param [Float] g1
        # @param [Float] b1
        # @param [Float] a1
        # @param [Float] r2
        # @param [Float] g2
        # @param [Float] b2
        # @param [Float] a2
        # @return [SettingValue]
        def self.from_alternating_gradient(r1, g1, b1, a1, r2, g2, b2, a2)
            result = SettingValue.new(Native.SettingValue_from_alternating_gradient(r1, g1, b1, a1, r2, g2, b2, a2))
            result
        end
        # Creates a new setting value from the alignment name provided. If it doesn't
        # match a known alignment, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_alignment(value)
            result = SettingValue.new(Native.SettingValue_from_alignment(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new setting value from the column kind with the name provided. If
        # it doesn't match a known column kind, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_column_kind(value)
            result = SettingValue.new(Native.SettingValue_from_column_kind(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new setting value from the column start with the name provided. If
        # it doesn't match a known column start with, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_column_start_with(value)
            result = SettingValue.new(Native.SettingValue_from_column_start_with(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new setting value from the column update with the name provided.
        # If it doesn't match a known column update with, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_column_update_with(value)
            result = SettingValue.new(Native.SettingValue_from_column_update_with(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new setting value from the column update trigger. If it doesn't
        # match a known column update trigger, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_column_update_trigger(value)
            result = SettingValue.new(Native.SettingValue_from_column_update_trigger(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new setting value from the layout direction. If it doesn't
        # match a known layout direction, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_layout_direction(value)
            result = SettingValue.new(Native.SettingValue_from_layout_direction(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new setting value with the type `font`.
        # @param [String] family
        # @param [String] style
        # @param [String] weight
        # @param [String] stretch
        # @return [SettingValue, nil]
        def self.from_font(family, style, weight, stretch)
            result = SettingValue.new(Native.SettingValue_from_font(family, style, weight, stretch))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Creates a new empty setting value with the type `font`.
        # @return [SettingValue]
        def self.from_empty_font()
            result = SettingValue.new(Native.SettingValue_from_empty_font())
            result
        end
        # Creates a new setting value from the delta gradient with the name provided.
        # If it doesn't match a known delta gradient, nil is returned.
        # @param [String] value
        # @return [SettingValue, nil]
        def self.from_delta_gradient(value)
            result = SettingValue.new(Native.SettingValue_from_delta_gradient(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Shared Timer that can be used to share a single timer object with multiple
    # owners.
    class SharedTimerRef
        attr_accessor :handle
        # Creates a new shared timer handle that shares the same timer. The inner
        # timer object only gets disposed when the final handle gets disposed.
        # @return [SharedTimer]
        def share()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SharedTimer.new(Native.SharedTimer_share(@handle.ptr))
            result
        end
        # Requests read access to the timer that is being shared. This blocks the
        # thread as long as there is an active write lock. Dispose the read lock when
        # you are done using the timer.
        # @return [TimerReadLock]
        def read()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimerReadLock.new(Native.SharedTimer_read(@handle.ptr))
            result
        end
        # Requests write access to the timer that is being shared. This blocks the
        # thread as long as there are active write or read locks. Dispose the write
        # lock when you are done using the timer.
        # @return [TimerWriteLock]
        def write()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimerWriteLock.new(Native.SharedTimer_write(@handle.ptr))
            result
        end
        # Replaces the timer that is being shared by the timer provided. This blocks
        # the thread as long as there are active write or read locks. Everyone who is
        # sharing the old timer will share the provided timer after successful
        # completion.
        # @param [Timer] timer
        def replace_inner(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            Native.SharedTimer_replace_inner(@handle.ptr, timer.handle.ptr)
            timer.handle.ptr = nil
        end
        def read_with
            self.read.wtih do |lock|
                yield lock.timer
            end
        end
        def write_with
            self.write.with do |lock|
                yield lock.timer
            end
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Shared Timer that can be used to share a single timer object with multiple
    # owners.
    class SharedTimerRefMut < SharedTimerRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Shared Timer that can be used to share a single timer object with multiple
    # owners.
    class SharedTimer < SharedTimerRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SharedTimer_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SharedTimer.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The software renderer allows rendering layouts entirely on the CPU. This is
    # surprisingly fast and can be considered the default renderer.
    class SoftwareRendererRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The software renderer allows rendering layouts entirely on the CPU. This is
    # surprisingly fast and can be considered the default renderer.
    class SoftwareRendererRefMut < SoftwareRendererRef
        # Renders the layout state provided into the image buffer provided. The image
        # has to be an array of RGBA8 encoded pixels (red, green, blue, alpha with
        # each channel being an u8). Some frameworks may over allocate an image's
        # dimensions. So an image with dimensions 100x50 may be over allocated as
        # 128x64. In that case you provide the real dimensions of 100x50 as the width
        # and height, but a stride of 128 pixels as that correlates with the real
        # width of the underlying buffer. By default the renderer will try not to
        # redraw parts of the image that haven't changed. You can force a redraw in
        # case the image provided or its contents have changed.
        # @param [LayoutStateRef] layout_state
        # @param [Integer] data
        # @param [Integer] width
        # @param [Integer] height
        # @param [Integer] stride
        # @param [Boolean] force_redraw
        def render(layout_state, data, width, height, stride, force_redraw)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if layout_state.handle.ptr == nil
                raise "layout_state is disposed"
            end
            Native.SoftwareRenderer_render(@handle.ptr, layout_state.handle.ptr, data, width, height, stride, force_redraw)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The software renderer allows rendering layouts entirely on the CPU. This is
    # surprisingly fast and can be considered the default renderer.
    class SoftwareRenderer < SoftwareRendererRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SoftwareRenderer_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SoftwareRenderer.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new software renderer.
        # @return [SoftwareRenderer]
        def self.create()
            result = SoftwareRenderer.new(Native.SoftwareRenderer_new())
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Splits Component is the main component for visualizing all the split
    # times. Each segment is shown in a tabular fashion showing the segment icon,
    # segment name, the delta compared to the chosen comparison, and the split
    # time. The list provides scrolling functionality, so not every segment needs
    # to be shown all the time.
    class SplitsComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Splits Component is the main component for visualizing all the split
    # times. Each segment is shown in a tabular fashion showing the segment icon,
    # segment name, the delta compared to the chosen comparison, and the split
    # time. The list provides scrolling functionality, so not every segment needs
    # to be shown all the time.
    class SplitsComponentRefMut < SplitsComponentRef
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [String]
        def state_as_json(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = Native.SplitsComponent_state_as_json(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer and layout settings
        # provided.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [SplitsComponentState]
        def state(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = SplitsComponentState.new(Native.SplitsComponent_state(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr))
            result
        end
        # Scrolls up the window of the segments that are shown. Doesn't move the
        # scroll window if it reaches the top of the segments.
        def scroll_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_scroll_up(@handle.ptr)
        end
        # Scrolls down the window of the segments that are shown. Doesn't move the
        # scroll window if it reaches the bottom of the segments.
        def scroll_down()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_scroll_down(@handle.ptr)
        end
        # The amount of segments to show in the list at any given time. If this is
        # set to 0, all the segments are shown. If this is set to a number lower
        # than the total amount of segments, only a certain window of all the
        # segments is shown. This window can scroll up or down.
        # @param [Integer] count
        def set_visual_split_count(count)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_set_visual_split_count(@handle.ptr, count)
        end
        # If there's more segments than segments that are shown, the window
        # showing the segments automatically scrolls up and down when the current
        # segment changes. This count determines the minimum number of future
        # segments to be shown in this scrolling window when it automatically
        # scrolls.
        # @param [Integer] count
        def set_split_preview_count(count)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_set_split_preview_count(@handle.ptr, count)
        end
        # If not every segment is shown in the scrolling window of segments, then
        # this determines whether the final segment is always to be shown, as it
        # contains valuable information about the total duration of the chosen
        # comparison, which is often the runner's Personal Best.
        # @param [Boolean] always_show_last_split
        def set_always_show_last_split(always_show_last_split)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_set_always_show_last_split(@handle.ptr, always_show_last_split)
        end
        # If the last segment is to always be shown, this determines whether to
        # show a more pronounced separator in front of the last segment, if it is
        # not directly adjacent to the segment shown right before it in the
        # scrolling window.
        # @param [Boolean] separator_last_split
        def set_separator_last_split(separator_last_split)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_set_separator_last_split(@handle.ptr, separator_last_split)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Splits Component is the main component for visualizing all the split
    # times. Each segment is shown in a tabular fashion showing the segment icon,
    # segment name, the delta compared to the chosen comparison, and the split
    # time. The list provides scrolling functionality, so not every segment needs
    # to be shown all the time.
    class SplitsComponent < SplitsComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SplitsComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SplitsComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Splits Component.
        # @return [SplitsComponent]
        def self.create()
            result = SplitsComponent.new(Native.SplitsComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.SplitsComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object that describes a single segment's information to visualize.
    class SplitsComponentStateRef
        attr_accessor :handle
        # Describes whether a more pronounced separator should be shown in front of
        # the last segment provided.
        # @return [Boolean]
        def final_separator_shown()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_final_separator_shown(@handle.ptr)
            result
        end
        # Returns the amount of segments to visualize.
        # @return [Integer]
        def len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_len(@handle.ptr)
            result
        end
        # Returns the amount of icon changes that happened in this state object.
        # @return [Integer]
        def icon_change_count()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_icon_change_count(@handle.ptr)
            result
        end
        # Accesses the index of the segment of the icon change with the specified
        # index. This is based on the index in the run, not on the index of the
        # SplitState in the State object. The corresponding index is the index field
        # of the SplitState object. You may not provide an out of bounds index.
        # @param [Integer] icon_change_index
        # @return [Integer]
        def icon_change_segment_index(icon_change_index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_icon_change_segment_index(@handle.ptr, icon_change_index)
            result
        end
        # The icon data of the segment of the icon change with the specified index.
        # The buffer may be empty. This indicates that there is no icon. You may not
        # provide an out of bounds index.
        # @param [Integer] icon_change_index
        # @return [Integer]
        def icon_change_icon_ptr(icon_change_index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_icon_change_icon_ptr(@handle.ptr, icon_change_index)
            result
        end
        # The length of the icon data of the segment of the icon change with the
        # specified index.
        # @param [Integer] icon_change_index
        # @return [Integer]
        def icon_change_icon_len(icon_change_index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_icon_change_icon_len(@handle.ptr, icon_change_index)
            result
        end
        # The name of the segment with the specified index. You may not provide an out
        # of bounds index.
        # @param [Integer] index
        # @return [String]
        def name(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_name(@handle.ptr, index)
            result
        end
        # The amount of columns to visualize for the segment with the specified index.
        # The columns are specified from right to left. You may not provide an out of
        # bounds index. The amount of columns to visualize may differ from segment to
        # segment.
        # @param [Integer] index
        # @return [Integer]
        def columns_len(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_columns_len(@handle.ptr, index)
            result
        end
        # The column's value to show for the split and column with the specified
        # index. The columns are specified from right to left. You may not provide an
        # out of bounds index.
        # @param [Integer] index
        # @param [Integer] column_index
        # @return [String]
        def column_value(index, column_index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_column_value(@handle.ptr, index, column_index)
            result
        end
        # The semantic coloring information the column's value carries of the segment
        # and column with the specified index. The columns are specified from right to
        # left. You may not provide an out of bounds index.
        # @param [Integer] index
        # @param [Integer] column_index
        # @return [String]
        def column_semantic_color(index, column_index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_column_semantic_color(@handle.ptr, index, column_index)
            result
        end
        # Describes if the segment with the specified index is the segment the active
        # attempt is currently on.
        # @param [Integer] index
        # @return [Boolean]
        def is_current_split(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_is_current_split(@handle.ptr, index)
            result
        end
        # Describes if the columns have labels that are meant to be shown. If this is
        # `false`, no labels are supposed to be visualized.
        # @return [Boolean]
        def has_column_labels()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_has_column_labels(@handle.ptr)
            result
        end
        # Returns the label of the column specified. The list is specified from right
        # to left. You may not provide an out of bounds index.
        # @param [Integer] index
        # @return [String]
        def column_label(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_column_label(@handle.ptr, index)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object that describes a single segment's information to visualize.
    class SplitsComponentStateRefMut < SplitsComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object that describes a single segment's information to visualize.
    class SplitsComponentState < SplitsComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SplitsComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SplitsComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Sum of Best Cleaner allows you to interactively remove potential issues in
    # the Segment History that lead to an inaccurate Sum of Best. If you skip a
    # split, whenever you get to the next split, the combined segment time might
    # be faster than the sum of the individual best segments. The Sum of Best
    # Cleaner will point out all of occurrences of this and allows you to delete
    # them individually if any of them seem wrong.
    class SumOfBestCleanerRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Sum of Best Cleaner allows you to interactively remove potential issues in
    # the Segment History that lead to an inaccurate Sum of Best. If you skip a
    # split, whenever you get to the next split, the combined segment time might
    # be faster than the sum of the individual best segments. The Sum of Best
    # Cleaner will point out all of occurrences of this and allows you to delete
    # them individually if any of them seem wrong.
    class SumOfBestCleanerRefMut < SumOfBestCleanerRef
        # Returns the next potential clean up. If there are no more potential
        # clean ups, nil is returned.
        # @return [PotentialCleanUp, nil]
        def next_potential_clean_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = PotentialCleanUp.new(Native.SumOfBestCleaner_next_potential_clean_up(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Applies a clean up to the Run.
        # @param [PotentialCleanUp] clean_up
        def apply(clean_up)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if clean_up.handle.ptr == nil
                raise "clean_up is disposed"
            end
            Native.SumOfBestCleaner_apply(@handle.ptr, clean_up.handle.ptr)
            clean_up.handle.ptr = nil
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Sum of Best Cleaner allows you to interactively remove potential issues in
    # the Segment History that lead to an inaccurate Sum of Best. If you skip a
    # split, whenever you get to the next split, the combined segment time might
    # be faster than the sum of the individual best segments. The Sum of Best
    # Cleaner will point out all of occurrences of this and allows you to delete
    # them individually if any of them seem wrong.
    class SumOfBestCleaner < SumOfBestCleanerRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SumOfBestCleaner_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SumOfBestCleaner.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Sum of Best Segments Component shows the fastest possible time to
    # complete a run of this category, based on information collected from all the
    # previous attempts. This often matches up with the sum of the best segment
    # times of all the segments, but that may not always be the case, as skipped
    # segments may introduce combined segments that may be faster than the actual
    # sum of their best segment times. The name is therefore a bit misleading, but
    # sticks around for historical reasons.
    class SumOfBestComponentRef
        attr_accessor :handle
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.SumOfBestComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [KeyValueComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = KeyValueComponentState.new(Native.SumOfBestComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Sum of Best Segments Component shows the fastest possible time to
    # complete a run of this category, based on information collected from all the
    # previous attempts. This often matches up with the sum of the best segment
    # times of all the segments, but that may not always be the case, as skipped
    # segments may introduce combined segments that may be faster than the actual
    # sum of their best segment times. The name is therefore a bit misleading, but
    # sticks around for historical reasons.
    class SumOfBestComponentRefMut < SumOfBestComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Sum of Best Segments Component shows the fastest possible time to
    # complete a run of this category, based on information collected from all the
    # previous attempts. This often matches up with the sum of the best segment
    # times of all the segments, but that may not always be the case, as skipped
    # segments may introduce combined segments that may be faster than the actual
    # sum of their best segment times. The name is therefore a bit misleading, but
    # sticks around for historical reasons.
    class SumOfBestComponent < SumOfBestComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SumOfBestComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SumOfBestComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Sum of Best Segments Component.
        # @return [SumOfBestComponent]
        def self.create()
            result = SumOfBestComponent.new(Native.SumOfBestComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.SumOfBestComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Text Component simply visualizes any given text. This can either be a
    # single centered text, or split up into a left and right text, which is
    # suitable for a situation where you have a label and a value.
    class TextComponentRef
        attr_accessor :handle
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.TextComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state.
        # @param [TimerRef] timer
        # @return [TextComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = TextComponentState.new(Native.TextComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Text Component simply visualizes any given text. This can either be a
    # single centered text, or split up into a left and right text, which is
    # suitable for a situation where you have a label and a value.
    class TextComponentRefMut < TextComponentRef
        # Sets the centered text. If the current mode is split, it is switched to
        # centered mode.
        # @param [String] text
        def set_center(text)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.TextComponent_set_center(@handle.ptr, text)
        end
        # Sets the left text. If the current mode is centered, it is switched to
        # split mode, with the right text being empty.
        # @param [String] text
        def set_left(text)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.TextComponent_set_left(@handle.ptr, text)
        end
        # Sets the right text. If the current mode is centered, it is switched to
        # split mode, with the left text being empty.
        # @param [String] text
        def set_right(text)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.TextComponent_set_right(@handle.ptr, text)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Text Component simply visualizes any given text. This can either be a
    # single centered text, or split up into a left and right text, which is
    # suitable for a situation where you have a label and a value.
    class TextComponent < TextComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TextComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TextComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Text Component.
        # @return [TextComponent]
        def self.create()
            result = TextComponent.new(Native.TextComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.TextComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for this component.
    class TextComponentStateRef
        attr_accessor :handle
        # Accesses the left part of the text. If the text isn't split up, an empty
        # string is returned instead.
        # @return [String]
        def left()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TextComponentState_left(@handle.ptr)
            result
        end
        # Accesses the right part of the text. If the text isn't split up, an empty
        # string is returned instead.
        # @return [String]
        def right()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TextComponentState_right(@handle.ptr)
            result
        end
        # Accesses the centered text. If the text isn't centered, an empty string is
        # returned instead.
        # @return [String]
        def center()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TextComponentState_center(@handle.ptr)
            result
        end
        # Returns whether the text is split up into a left and right part.
        # @return [Boolean]
        def is_split()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TextComponentState_is_split(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class TextComponentStateRefMut < TextComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class TextComponentState < TextComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TextComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TextComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A time that can store a Real Time and a Game Time. Both of them are
    # optional.
    class TimeRef
        attr_accessor :handle
        # Clones the time.
        # @return [Time]
        def clone()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Time.new(Native.Time_clone(@handle.ptr))
            result
        end
        # The Real Time value. This may be nil if this time has no Real Time value.
        # @return [TimeSpanRef, nil]
        def real_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpanRef.new(Native.Time_real_time(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # The Game Time value. This may be nil if this time has no Game Time value.
        # @return [TimeSpanRef, nil]
        def game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpanRef.new(Native.Time_game_time(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Access the time's value for the timing method specified.
        # @param [Integer] timing_method
        # @return [TimeSpanRef, nil]
        def index(timing_method)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpanRef.new(Native.Time_index(@handle.ptr, timing_method))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A time that can store a Real Time and a Game Time. Both of them are
    # optional.
    class TimeRefMut < TimeRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A time that can store a Real Time and a Game Time. Both of them are
    # optional.
    class Time < TimeRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.Time_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = Time.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Time Span represents a certain span of time.
    class TimeSpanRef
        attr_accessor :handle
        # Clones the Time Span.
        # @return [TimeSpan]
        def clone()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpan.new(Native.TimeSpan_clone(@handle.ptr))
            result
        end
        # Returns the total amount of seconds (including decimals) this Time Span
        # represents.
        # @return [Float]
        def total_seconds()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TimeSpan_total_seconds(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Time Span represents a certain span of time.
    class TimeSpanRefMut < TimeSpanRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Time Span represents a certain span of time.
    class TimeSpan < TimeSpanRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TimeSpan_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TimeSpan.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Time Span from a given amount of seconds.
        # @param [Float] seconds
        # @return [TimeSpan]
        def self.from_seconds(seconds)
            result = TimeSpan.new(Native.TimeSpan_from_seconds(seconds))
            result
        end
        # Parses a Time Span from a string. Returns nil if the time can't be
        # parsed.
        # @param [String] text
        # @return [TimeSpan, nil]
        def self.parse(text)
            result = TimeSpan.new(Native.TimeSpan_parse(text))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Timer provides all the capabilities necessary for doing speedrun attempts.
    class TimerRef
        attr_accessor :handle
        # Accesses the index of the split the attempt is currently on. If there's
        # no attempt in progress, `-1` is returned instead. This returns an
        # index that is equal to the amount of segments when the attempt is
        # finished, but has not been reset. So you need to be careful when using
        # this value for indexing.
        # @return [Integer]
        def current_split_index()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_current_split_index(@handle.ptr)
            result
        end
        # Returns the currently selected Timing Method.
        # @return [Integer]
        def current_timing_method()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_current_timing_method(@handle.ptr)
            result
        end
        # Returns the current comparison that is being compared against. This may
        # be a custom comparison or one of the Comparison Generators.
        # @return [String]
        def current_comparison()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_current_comparison(@handle.ptr)
            result
        end
        # Returns whether Game Time is currently initialized. Game Time
        # automatically gets uninitialized for each new attempt.
        # @return [Boolean]
        def is_game_time_initialized()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_is_game_time_initialized(@handle.ptr)
            result
        end
        # Returns whether the Game Timer is currently paused. If the Game Timer is
        # not paused, it automatically increments similar to Real Time.
        # @return [Boolean]
        def is_game_time_paused()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_is_game_time_paused(@handle.ptr)
            result
        end
        # Accesses the loading times. Loading times are defined as Game Time - Real Time.
        # @return [TimeSpanRef]
        def loading_times()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpanRef.new(Native.Timer_loading_times(@handle.ptr))
            result
        end
        # Returns the current Timer Phase.
        # @return [Integer]
        def current_phase()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_current_phase(@handle.ptr)
            result
        end
        # Accesses the Run in use by the Timer.
        # @return [RunRef]
        def get_run()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunRef.new(Native.Timer_get_run(@handle.ptr))
            result
        end
        # Saves the Run in use by the Timer as a LiveSplit splits file (*.lss).
        # @return [String]
        def save_as_lss()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_save_as_lss(@handle.ptr)
            result
        end
        # Prints out debug information representing the whole state of the Timer. This
        # is being written to stdout.
        def print_debug()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_print_debug(@handle.ptr)
        end
        # Returns the current time of the Timer. The Game Time is nil if the Game
        # Time has not been initialized.
        # @return [TimeRef]
        def current_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Timer_current_time(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Timer provides all the capabilities necessary for doing speedrun attempts.
    class TimerRefMut < TimerRef
        # Replaces the Run object used by the Timer with the Run object provided. If
        # the Run provided contains no segments, it can't be used for timing and is
        # not being modified. Otherwise the Run that was in use by the Timer gets
        # stored in the Run object provided. Before the Run is returned, the current
        # attempt is reset and the splits are being updated depending on the
        # `update_splits` parameter. The return value indicates whether the Run got
        # replaced successfully.
        # @param [RunRefMut] run
        # @param [Boolean] update_splits
        # @return [Boolean]
        def replace_run(run, update_splits)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if run.handle.ptr == nil
                raise "run is disposed"
            end
            result = Native.Timer_replace_run(@handle.ptr, run.handle.ptr, update_splits)
            result
        end
        # Sets the Run object used by the Timer with the Run object provided. If the
        # Run provided contains no segments, it can't be used for timing and gets
        # returned again. If the Run object can be set, the original Run object in use
        # by the Timer is disposed by this method and nil is returned.
        # @param [Run] run
        # @return [Run, nil]
        def set_run(run)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if run.handle.ptr == nil
                raise "run is disposed"
            end
            result = Run.new(Native.Timer_set_run(@handle.ptr, run.handle.ptr))
            run.handle.ptr = nil
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Starts the Timer if there is no attempt in progress. If that's not the
        # case, nothing happens.
        def start()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_start(@handle.ptr)
        end
        # If an attempt is in progress, stores the current time as the time of the
        # current split. The attempt ends if the last split time is stored.
        def split()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_split(@handle.ptr)
        end
        # Starts a new attempt or stores the current time as the time of the
        # current split. The attempt ends if the last split time is stored.
        def split_or_start()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_split_or_start(@handle.ptr)
        end
        # Skips the current split if an attempt is in progress and the
        # current split is not the last split.
        def skip_split()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_skip_split(@handle.ptr)
        end
        # Removes the split time from the last split if an attempt is in progress
        # and there is a previous split. The Timer Phase also switches to
        # `Running` if it previously was `Ended`.
        def undo_split()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_undo_split(@handle.ptr)
        end
        # Resets the current attempt if there is one in progress. If the splits
        # are to be updated, all the information of the current attempt is stored
        # in the Run's history. Otherwise the current attempt's information is
        # discarded.
        # @param [Boolean] update_splits
        def reset(update_splits)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_reset(@handle.ptr, update_splits)
        end
        # Resets the current attempt if there is one in progress. The splits are
        # updated such that the current attempt's split times are being stored as
        # the new Personal Best.
        def reset_and_set_attempt_as_pb()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_reset_and_set_attempt_as_pb(@handle.ptr)
        end
        # Pauses an active attempt that is not paused.
        def pause()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_pause(@handle.ptr)
        end
        # Resumes an attempt that is paused.
        def resume()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_resume(@handle.ptr)
        end
        # Toggles an active attempt between `Paused` and `Running`.
        def toggle_pause()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_toggle_pause(@handle.ptr)
        end
        # Toggles an active attempt between `Paused` and `Running` or starts an
        # attempt if there's none in progress.
        def toggle_pause_or_start()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_toggle_pause_or_start(@handle.ptr)
        end
        # Removes all the pause times from the current time. If the current
        # attempt is paused, it also resumes that attempt. Additionally, if the
        # attempt is finished, the final split time is adjusted to not include the
        # pause times as well.
        # 
        # # Warning
        # 
        # This behavior is not entirely optimal, as generally only the final split
        # time is modified, while all other split times are left unmodified, which
        # may not be what actually happened during the run.
        def undo_all_pauses()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_undo_all_pauses(@handle.ptr)
        end
        # Sets the current Timing Method to the Timing Method provided.
        # @param [Integer] method
        def set_current_timing_method(method)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_set_current_timing_method(@handle.ptr, method)
        end
        # Switches the current comparison to the next comparison in the list.
        def switch_to_next_comparison()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_switch_to_next_comparison(@handle.ptr)
        end
        # Switches the current comparison to the previous comparison in the list.
        def switch_to_previous_comparison()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_switch_to_previous_comparison(@handle.ptr)
        end
        # Initializes Game Time for the current attempt. Game Time automatically
        # gets uninitialized for each new attempt.
        def initialize_game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_initialize_game_time(@handle.ptr)
        end
        # Deinitializes Game Time for the current attempt.
        def deinitialize_game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_deinitialize_game_time(@handle.ptr)
        end
        # Pauses the Game Timer such that it doesn't automatically increment
        # similar to Real Time.
        def pause_game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_pause_game_time(@handle.ptr)
        end
        # Resumes the Game Timer such that it automatically increments similar to
        # Real Time, starting from the Game Time it was paused at.
        def resume_game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_resume_game_time(@handle.ptr)
        end
        # Sets the Game Time to the time specified. This also works if the Game
        # Time is paused, which can be used as a way of updating the Game Timer
        # periodically without it automatically moving forward. This ensures that
        # the Game Timer never shows any time that is not coming from the game.
        # @param [TimeSpanRef] time
        def set_game_time(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if time.handle.ptr == nil
                raise "time is disposed"
            end
            Native.Timer_set_game_time(@handle.ptr, time.handle.ptr)
        end
        # Instead of setting the Game Time directly, this method can be used to
        # just specify the amount of time the game has been loading. The Game Time
        # is then automatically determined by Real Time - Loading Times.
        # @param [TimeSpanRef] time
        def set_loading_times(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if time.handle.ptr == nil
                raise "time is disposed"
            end
            Native.Timer_set_loading_times(@handle.ptr, time.handle.ptr)
        end
        # Marks the Run as unmodified, so that it is known that all the changes
        # have been saved.
        def mark_as_unmodified()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_mark_as_unmodified(@handle.ptr)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Timer provides all the capabilities necessary for doing speedrun attempts.
    class Timer < TimerRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.Timer_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = Timer.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Timer based on a Run object storing all the information
        # about the splits. The Run object needs to have at least one segment, so
        # that the Timer can store the final time. If a Run object with no
        # segments is provided, the Timer creation fails and nil is returned.
        # @param [Run] run
        # @return [Timer, nil]
        def self.create(run)
            if run.handle.ptr == nil
                raise "run is disposed"
            end
            result = Timer.new(Native.Timer_new(run.handle.ptr))
            run.handle.ptr = nil
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # Consumes the Timer and creates a Shared Timer that can be shared across
        # multiple threads with multiple owners.
        # @return [SharedTimer]
        def into_shared()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SharedTimer.new(Native.Timer_into_shared(@handle.ptr))
            @handle.ptr = nil
            result
        end
        # Takes out the Run from the Timer and resets the current attempt if there
        # is one in progress. If the splits are to be updated, all the information
        # of the current attempt is stored in the Run's history. Otherwise the
        # current attempt's information is discarded.
        # @param [Boolean] update_splits
        # @return [Run]
        def into_run(update_splits)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Run.new(Native.Timer_into_run(@handle.ptr, update_splits))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Timer Component is a component that shows the total time of the current
    # attempt as a digital clock. The color of the time shown is based on a how
    # well the current attempt is doing compared to the chosen comparison.
    class TimerComponentRef
        attr_accessor :handle
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [String]
        def state_as_json(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = Native.TimerComponent_state_as_json(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer and the layout
        # settings provided.
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [TimerComponentState]
        def state(timer, layout_settings)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            if layout_settings.handle.ptr == nil
                raise "layout_settings is disposed"
            end
            result = TimerComponentState.new(Native.TimerComponent_state(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Timer Component is a component that shows the total time of the current
    # attempt as a digital clock. The color of the time shown is based on a how
    # well the current attempt is doing compared to the chosen comparison.
    class TimerComponentRefMut < TimerComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Timer Component is a component that shows the total time of the current
    # attempt as a digital clock. The color of the time shown is based on a how
    # well the current attempt is doing compared to the chosen comparison.
    class TimerComponent < TimerComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TimerComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TimerComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Timer Component.
        # @return [TimerComponent]
        def self.create()
            result = TimerComponent.new(Native.TimerComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.TimerComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for this component.
    class TimerComponentStateRef
        attr_accessor :handle
        # The time shown by the component without the fractional part.
        # @return [String]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TimerComponentState_time(@handle.ptr)
            result
        end
        # The fractional part of the time shown (including the dot).
        # @return [String]
        def fraction()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TimerComponentState_fraction(@handle.ptr)
            result
        end
        # The semantic coloring information the time carries.
        # @return [String]
        def semantic_color()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TimerComponentState_semantic_color(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class TimerComponentStateRefMut < TimerComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class TimerComponentState < TimerComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TimerComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TimerComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Timer Read Lock allows temporary read access to a timer. Dispose this to
    # release the read lock.
    class TimerReadLockRef
        attr_accessor :handle
        # Accesses the timer.
        # @return [TimerRef]
        def timer()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimerRef.new(Native.TimerReadLock_timer(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Timer Read Lock allows temporary read access to a timer. Dispose this to
    # release the read lock.
    class TimerReadLockRefMut < TimerReadLockRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Timer Read Lock allows temporary read access to a timer. Dispose this to
    # release the read lock.
    class TimerReadLock < TimerReadLockRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TimerReadLock_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TimerReadLock.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # A Timer Write Lock allows temporary write access to a timer. Dispose this to
    # release the write lock.
    class TimerWriteLockRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Timer Write Lock allows temporary write access to a timer. Dispose this to
    # release the write lock.
    class TimerWriteLockRefMut < TimerWriteLockRef
        # Accesses the timer.
        # @return [TimerRefMut]
        def timer()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimerRefMut.new(Native.TimerWriteLock_timer(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # A Timer Write Lock allows temporary write access to a timer. Dispose this to
    # release the write lock.
    class TimerWriteLock < TimerWriteLockRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TimerWriteLock_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TimerWriteLock.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Title Component is a component that shows the name of the game and the
    # category that is being run. Additionally, the game icon, the attempt count,
    # and the total number of successfully finished runs can be shown.
    class TitleComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Title Component is a component that shows the name of the game and the
    # category that is being run. Additionally, the game icon, the attempt count,
    # and the total number of successfully finished runs can be shown.
    class TitleComponentRefMut < TitleComponentRef
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.TitleComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [TitleComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = TitleComponentState.new(Native.TitleComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Title Component is a component that shows the name of the game and the
    # category that is being run. Additionally, the game icon, the attempt count,
    # and the total number of successfully finished runs can be shown.
    class TitleComponent < TitleComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TitleComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TitleComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Title Component.
        # @return [TitleComponent]
        def self.create()
            result = TitleComponent.new(Native.TitleComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.TitleComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The state object describes the information to visualize for this component.
    class TitleComponentStateRef
        attr_accessor :handle
        # The data of the game's icon. This value is only specified whenever the icon
        # changes. If you explicitly want to query this value, remount the component.
        # The buffer may be empty. This indicates that there is no icon. If no change
        # occurred, nil is returned instead.
        # @return [Integer]
        def icon_change_ptr()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_icon_change_ptr(@handle.ptr)
            result
        end
        # The length of the game's icon data.
        # @return [Integer]
        def icon_change_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_icon_change_len(@handle.ptr)
            result
        end
        # The first title line to show. This is either the game's name, or a
        # combination of the game's name and the category.
        # @return [String]
        def line1()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_line1(@handle.ptr)
            result
        end
        # By default the category name is shown on the second line. Based on the
        # settings, it can however instead be shown in a single line together with
        # the game name. In that case nil is returned instead.
        # @return [String, nil]
        def line2()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_line2(@handle.ptr)
            result
        end
        # Specifies whether the title should centered or aligned to the left
        # instead.
        # @return [Boolean]
        def is_centered()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_is_centered(@handle.ptr)
            result
        end
        # Returns whether the amount of successfully finished attempts is supposed to
        # be shown.
        # @return [Boolean]
        def shows_finished_runs()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_shows_finished_runs(@handle.ptr)
            result
        end
        # Returns the amount of successfully finished attempts.
        # @return [Integer]
        def finished_runs()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_finished_runs(@handle.ptr)
            result
        end
        # Returns whether the amount of total attempts is supposed to be shown.
        # @return [Boolean]
        def shows_attempts()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_shows_attempts(@handle.ptr)
            result
        end
        # Returns the amount of total attempts.
        # @return [Integer]
        def attempts()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_attempts(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class TitleComponentStateRefMut < TitleComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The state object describes the information to visualize for this component.
    class TitleComponentState < TitleComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TitleComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TitleComponentState.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    # The Total Playtime Component is a component that shows the total amount of
    # time that the current category has been played for.
    class TotalPlaytimeComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Total Playtime Component is a component that shows the total amount of
    # time that the current category has been played for.
    class TotalPlaytimeComponentRefMut < TotalPlaytimeComponentRef
        # Encodes the component's state information as JSON.
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.TotalPlaytimeComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # Calculates the component's state based on the timer provided.
        # @param [TimerRef] timer
        # @return [KeyValueComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = KeyValueComponentState.new(Native.TotalPlaytimeComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    # The Total Playtime Component is a component that shows the total amount of
    # time that the current category has been played for.
    class TotalPlaytimeComponent < TotalPlaytimeComponentRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TotalPlaytimeComponent_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TotalPlaytimeComponent.finalize @handle
            finalizer.call
        end
        def with
            yield self
            self.dispose
        end
        # Creates a new Total Playtime Component.
        # @return [TotalPlaytimeComponent]
        def self.create()
            result = TotalPlaytimeComponent.new(Native.TotalPlaytimeComponent_new())
            result
        end
        # Converts the component into a generic component suitable for using with a
        # layout.
        # @return [Component]
        def into_generic()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Component.new(Native.TotalPlaytimeComponent_into_generic(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end
end

Parser::LiveSplitCore = LiveSplitCore

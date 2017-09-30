# coding: utf-8
require 'ffi'

module LiveSplitCore
    module Native
        extend FFI::Library
        ffi_lib File.expand_path('../liblivesplit_core.so', __FILE__)
    
        attach_function :AtomicDateTime_drop, [:pointer], :void
        attach_function :AtomicDateTime_is_synchronized, [:pointer], :bool
        attach_function :AtomicDateTime_to_rfc2822, [:pointer], :string
        attach_function :AtomicDateTime_to_rfc3339, [:pointer], :string
        attach_function :Attempt_index, [:pointer], :int32
        attach_function :Attempt_time, [:pointer], :pointer
        attach_function :Attempt_pause_time, [:pointer], :pointer
        attach_function :Attempt_started, [:pointer], :pointer
        attach_function :Attempt_ended, [:pointer], :pointer
        attach_function :BlankSpaceComponent_new, [], :pointer
        attach_function :BlankSpaceComponent_drop, [:pointer], :void
        attach_function :BlankSpaceComponent_into_generic, [:pointer], :pointer
        attach_function :BlankSpaceComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :BlankSpaceComponent_state, [:pointer, :pointer], :pointer
        attach_function :BlankSpaceComponentState_drop, [:pointer], :void
        attach_function :BlankSpaceComponentState_height, [:pointer], :uint32
        attach_function :Component_drop, [:pointer], :void
        attach_function :CurrentComparisonComponent_new, [], :pointer
        attach_function :CurrentComparisonComponent_drop, [:pointer], :void
        attach_function :CurrentComparisonComponent_into_generic, [:pointer], :pointer
        attach_function :CurrentComparisonComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :CurrentComparisonComponent_state, [:pointer, :pointer], :pointer
        attach_function :CurrentComparisonComponentState_drop, [:pointer], :void
        attach_function :CurrentComparisonComponentState_text, [:pointer], :string
        attach_function :CurrentComparisonComponentState_comparison, [:pointer], :string
        attach_function :CurrentPaceComponent_new, [], :pointer
        attach_function :CurrentPaceComponent_drop, [:pointer], :void
        attach_function :CurrentPaceComponent_into_generic, [:pointer], :pointer
        attach_function :CurrentPaceComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :CurrentPaceComponent_state, [:pointer, :pointer], :pointer
        attach_function :CurrentPaceComponentState_drop, [:pointer], :void
        attach_function :CurrentPaceComponentState_text, [:pointer], :string
        attach_function :CurrentPaceComponentState_time, [:pointer], :string
        attach_function :DeltaComponent_new, [], :pointer
        attach_function :DeltaComponent_drop, [:pointer], :void
        attach_function :DeltaComponent_into_generic, [:pointer], :pointer
        attach_function :DeltaComponent_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :DeltaComponent_state, [:pointer, :pointer, :pointer], :pointer
        attach_function :DeltaComponentState_drop, [:pointer], :void
        attach_function :DeltaComponentState_text, [:pointer], :string
        attach_function :DeltaComponentState_time, [:pointer], :string
        attach_function :DeltaComponentState_semantic_color, [:pointer], :string
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
        attach_function :DetailedTimerComponentState_icon_change, [:pointer], :string
        attach_function :DetailedTimerComponentState_name, [:pointer], :string
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
        attach_function :HotkeySystem_new, [:pointer], :pointer
        attach_function :HotkeySystem_drop, [:pointer], :void
        attach_function :Layout_new, [], :pointer
        attach_function :Layout_default_layout, [], :pointer
        attach_function :Layout_parse_json, [:string], :pointer
        attach_function :Layout_drop, [:pointer], :void
        attach_function :Layout_clone, [:pointer], :pointer
        attach_function :Layout_settings_as_json, [:pointer], :string
        attach_function :Layout_state_as_json, [:pointer, :pointer], :string
        attach_function :Layout_push, [:pointer, :pointer], :void
        attach_function :Layout_scroll_up, [:pointer], :void
        attach_function :Layout_scroll_down, [:pointer], :void
        attach_function :Layout_remount, [:pointer], :void
        attach_function :LayoutEditor_new, [:pointer], :pointer
        attach_function :LayoutEditor_close, [:pointer], :pointer
        attach_function :LayoutEditor_state_as_json, [:pointer], :string
        attach_function :LayoutEditor_layout_state_as_json, [:pointer, :pointer], :string
        attach_function :LayoutEditor_select, [:pointer, :size_t], :void
        attach_function :LayoutEditor_add_component, [:pointer, :pointer], :void
        attach_function :LayoutEditor_remove_component, [:pointer], :void
        attach_function :LayoutEditor_move_component_up, [:pointer], :void
        attach_function :LayoutEditor_move_component_down, [:pointer], :void
        attach_function :LayoutEditor_move_component, [:pointer, :size_t], :void
        attach_function :LayoutEditor_duplicate_component, [:pointer], :void
        attach_function :LayoutEditor_set_component_settings_value, [:pointer, :size_t, :pointer], :void
        attach_function :LayoutEditor_set_general_settings_value, [:pointer, :size_t, :pointer], :void
        attach_function :ParseRunResult_drop, [:pointer], :void
        attach_function :ParseRunResult_unwrap, [:pointer], :pointer
        attach_function :ParseRunResult_parsed_successfully, [:pointer], :bool
        attach_function :ParseRunResult_timer_kind, [:pointer], :string
        attach_function :PossibleTimeSaveComponent_new, [], :pointer
        attach_function :PossibleTimeSaveComponent_drop, [:pointer], :void
        attach_function :PossibleTimeSaveComponent_into_generic, [:pointer], :pointer
        attach_function :PossibleTimeSaveComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :PossibleTimeSaveComponent_state, [:pointer, :pointer], :pointer
        attach_function :PossibleTimeSaveComponentState_drop, [:pointer], :void
        attach_function :PossibleTimeSaveComponentState_text, [:pointer], :string
        attach_function :PossibleTimeSaveComponentState_time, [:pointer], :string
        attach_function :PotentialCleanUp_drop, [:pointer], :void
        attach_function :PotentialCleanUp_message, [:pointer], :string
        attach_function :PreviousSegmentComponent_new, [], :pointer
        attach_function :PreviousSegmentComponent_drop, [:pointer], :void
        attach_function :PreviousSegmentComponent_into_generic, [:pointer], :pointer
        attach_function :PreviousSegmentComponent_state_as_json, [:pointer, :pointer, :pointer], :string
        attach_function :PreviousSegmentComponent_state, [:pointer, :pointer, :pointer], :pointer
        attach_function :PreviousSegmentComponentState_drop, [:pointer], :void
        attach_function :PreviousSegmentComponentState_text, [:pointer], :string
        attach_function :PreviousSegmentComponentState_time, [:pointer], :string
        attach_function :PreviousSegmentComponentState_semantic_color, [:pointer], :string
        attach_function :Run_new, [], :pointer
        attach_function :Run_parse, [:pointer, :size_t, :string, :bool], :pointer
        attach_function :Run_parse_file_handle, [:int64, :string, :bool], :pointer
        attach_function :Run_drop, [:pointer], :void
        attach_function :Run_clone, [:pointer], :pointer
        attach_function :Run_game_name, [:pointer], :string
        attach_function :Run_game_icon, [:pointer], :string
        attach_function :Run_category_name, [:pointer], :string
        attach_function :Run_extended_file_name, [:pointer, :bool], :string
        attach_function :Run_extended_name, [:pointer, :bool], :string
        attach_function :Run_extended_category_name, [:pointer, :bool, :bool, :bool], :string
        attach_function :Run_attempt_count, [:pointer], :uint32
        attach_function :Run_metadata, [:pointer], :pointer
        attach_function :Run_offset, [:pointer], :pointer
        attach_function :Run_len, [:pointer], :size_t
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
        attach_function :RunEditor_insert_segment_above, [:pointer], :void
        attach_function :RunEditor_insert_segment_below, [:pointer], :void
        attach_function :RunEditor_remove_segments, [:pointer], :void
        attach_function :RunEditor_move_segments_up, [:pointer], :void
        attach_function :RunEditor_move_segments_down, [:pointer], :void
        attach_function :RunEditor_selected_set_icon, [:pointer, :pointer, :size_t], :void
        attach_function :RunEditor_selected_remove_icon, [:pointer], :void
        attach_function :RunEditor_selected_set_name, [:pointer, :string], :void
        attach_function :RunEditor_selected_parse_and_set_split_time, [:pointer, :string], :bool
        attach_function :RunEditor_selected_parse_and_set_segment_time, [:pointer, :string], :bool
        attach_function :RunEditor_selected_parse_and_set_best_segment_time, [:pointer, :string], :bool
        attach_function :RunEditor_selected_parse_and_set_comparison_time, [:pointer, :string, :string], :bool
        attach_function :RunEditor_add_comparison, [:pointer, :string], :bool
        attach_function :RunEditor_import_comparison, [:pointer, :pointer, :string], :bool
        attach_function :RunEditor_remove_comparison, [:pointer, :string], :void
        attach_function :RunEditor_rename_comparison, [:pointer, :string, :string], :bool
        attach_function :RunEditor_clear_history, [:pointer], :void
        attach_function :RunEditor_clear_times, [:pointer], :void
        attach_function :RunEditor_clean_sum_of_best, [:pointer], :pointer
        attach_function :RunMetadata_run_id, [:pointer], :string
        attach_function :RunMetadata_platform_name, [:pointer], :string
        attach_function :RunMetadata_uses_emulator, [:pointer], :bool
        attach_function :RunMetadata_region_name, [:pointer], :string
        attach_function :RunMetadata_variables, [:pointer], :pointer
        attach_function :RunMetadataVariable_drop, [:pointer], :void
        attach_function :RunMetadataVariable_name, [:pointer], :string
        attach_function :RunMetadataVariable_value, [:pointer], :string
        attach_function :RunMetadataVariablesIter_drop, [:pointer], :void
        attach_function :RunMetadataVariablesIter_next, [:pointer], :pointer
        attach_function :Segment_new, [:string], :pointer
        attach_function :Segment_drop, [:pointer], :void
        attach_function :Segment_name, [:pointer], :string
        attach_function :Segment_icon, [:pointer], :string
        attach_function :Segment_comparison, [:pointer, :string], :pointer
        attach_function :Segment_personal_best_split_time, [:pointer], :pointer
        attach_function :Segment_best_segment_time, [:pointer], :pointer
        attach_function :Segment_segment_history, [:pointer], :pointer
        attach_function :SegmentHistory_iter, [:pointer], :pointer
        attach_function :SegmentHistoryElement_index, [:pointer], :int32
        attach_function :SegmentHistoryElement_time, [:pointer], :pointer
        attach_function :SegmentHistoryIter_drop, [:pointer], :void
        attach_function :SegmentHistoryIter_next, [:pointer], :pointer
        attach_function :SeparatorComponent_new, [], :pointer
        attach_function :SeparatorComponent_drop, [:pointer], :void
        attach_function :SeparatorComponent_into_generic, [:pointer], :pointer
        attach_function :SettingValue_from_bool, [:bool], :pointer
        attach_function :SettingValue_from_uint, [:uint64], :pointer
        attach_function :SettingValue_from_int, [:int64], :pointer
        attach_function :SettingValue_from_string, [:string], :pointer
        attach_function :SettingValue_from_optional_string, [:string], :pointer
        attach_function :SettingValue_from_optional_empty_string, [], :pointer
        attach_function :SettingValue_from_float, [:double], :pointer
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
        attach_function :SettingValue_drop, [:pointer], :void
        attach_function :SharedTimer_drop, [:pointer], :void
        attach_function :SharedTimer_share, [:pointer], :pointer
        attach_function :SharedTimer_read, [:pointer], :pointer
        attach_function :SharedTimer_write, [:pointer], :pointer
        attach_function :SharedTimer_replace_inner, [:pointer, :pointer], :void
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
        attach_function :SplitsComponentState_icon_change_icon, [:pointer, :size_t], :string
        attach_function :SplitsComponentState_name, [:pointer, :size_t], :string
        attach_function :SplitsComponentState_delta, [:pointer, :size_t], :string
        attach_function :SplitsComponentState_time, [:pointer, :size_t], :string
        attach_function :SplitsComponentState_semantic_color, [:pointer, :size_t], :string
        attach_function :SplitsComponentState_is_current_split, [:pointer, :size_t], :bool
        attach_function :SumOfBestCleaner_drop, [:pointer], :void
        attach_function :SumOfBestCleaner_next_potential_clean_up, [:pointer], :pointer
        attach_function :SumOfBestCleaner_apply, [:pointer, :pointer], :void
        attach_function :SumOfBestComponent_new, [], :pointer
        attach_function :SumOfBestComponent_drop, [:pointer], :void
        attach_function :SumOfBestComponent_into_generic, [:pointer], :pointer
        attach_function :SumOfBestComponent_state_as_json, [:pointer, :pointer], :string
        attach_function :SumOfBestComponent_state, [:pointer, :pointer], :pointer
        attach_function :SumOfBestComponentState_drop, [:pointer], :void
        attach_function :SumOfBestComponentState_text, [:pointer], :string
        attach_function :SumOfBestComponentState_time, [:pointer], :string
        attach_function :TextComponent_new, [], :pointer
        attach_function :TextComponent_drop, [:pointer], :void
        attach_function :TextComponent_into_generic, [:pointer], :pointer
        attach_function :TextComponent_state_as_json, [:pointer], :string
        attach_function :TextComponent_state, [:pointer], :pointer
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
        attach_function :TimeSpan_drop, [:pointer], :void
        attach_function :TimeSpan_clone, [:pointer], :pointer
        attach_function :TimeSpan_total_seconds, [:pointer], :double
        attach_function :Timer_new, [:pointer], :pointer
        attach_function :Timer_into_shared, [:pointer], :pointer
        attach_function :Timer_drop, [:pointer], :void
        attach_function :Timer_current_timing_method, [:pointer], :uint8
        attach_function :Timer_current_comparison, [:pointer], :string
        attach_function :Timer_is_game_time_initialized, [:pointer], :bool
        attach_function :Timer_is_game_time_paused, [:pointer], :bool
        attach_function :Timer_loading_times, [:pointer], :pointer
        attach_function :Timer_current_phase, [:pointer], :uint8
        attach_function :Timer_get_run, [:pointer], :pointer
        attach_function :Timer_print_debug, [:pointer], :void
        attach_function :Timer_replace_run, [:pointer, :pointer, :bool], :bool
        attach_function :Timer_set_run, [:pointer, :pointer], :pointer
        attach_function :Timer_start, [:pointer], :void
        attach_function :Timer_split, [:pointer], :void
        attach_function :Timer_split_or_start, [:pointer], :void
        attach_function :Timer_skip_split, [:pointer], :void
        attach_function :Timer_undo_split, [:pointer], :void
        attach_function :Timer_reset, [:pointer, :bool], :void
        attach_function :Timer_pause, [:pointer], :void
        attach_function :Timer_resume, [:pointer], :void
        attach_function :Timer_toggle_pause, [:pointer], :void
        attach_function :Timer_toggle_pause_or_start, [:pointer], :void
        attach_function :Timer_undo_all_pauses, [:pointer], :void
        attach_function :Timer_set_current_timing_method, [:pointer, :uint8], :void
        attach_function :Timer_switch_to_next_comparison, [:pointer], :void
        attach_function :Timer_switch_to_previous_comparison, [:pointer], :void
        attach_function :Timer_initialize_game_time, [:pointer], :void
        attach_function :Timer_uninitialize_game_time, [:pointer], :void
        attach_function :Timer_pause_game_time, [:pointer], :void
        attach_function :Timer_unpause_game_time, [:pointer], :void
        attach_function :Timer_set_game_time, [:pointer, :pointer], :void
        attach_function :Timer_set_loading_times, [:pointer, :pointer], :void
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
        attach_function :TitleComponentState_icon_change, [:pointer], :string
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
        attach_function :TotalPlaytimeComponentState_drop, [:pointer], :void
        attach_function :TotalPlaytimeComponentState_text, [:pointer], :string
        attach_function :TotalPlaytimeComponentState_time, [:pointer], :string
    end

    class LSCHandle
        attr_accessor :ptr
        def initialize(ptr)
            @ptr = ptr
        end
    end
    

    class AtomicDateTimeRef
        attr_accessor :handle
        # @return [Boolean]
        def is_synchronized()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.AtomicDateTime_is_synchronized(@handle.ptr)
            result
        end
        # @return [String]
        def to_rfc2822()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.AtomicDateTime_to_rfc2822(@handle.ptr)
            result
        end
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

    class AtomicDateTimeRefMut < AtomicDateTimeRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class AttemptRef
        attr_accessor :handle
        # @return [Integer]
        def index()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Attempt_index(@handle.ptr)
            result
        end
        # @return [TimeRef]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Attempt_time(@handle.ptr))
            result
        end
        # @return [TimeSpanRef]
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
        # @return [AtomicDateTime]
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
        # @return [AtomicDateTime]
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

    class AttemptRefMut < AttemptRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class BlankSpaceComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class BlankSpaceComponentRefMut < BlankSpaceComponentRef
        # @param [TimerRef] timer
        # @return [String]
        def state_as_json(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = Native.BlankSpaceComponent_state_as_json(@handle.ptr, timer.handle.ptr)
            result
        end
        # @param [TimerRef] timer
        # @return [BlankSpaceComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = BlankSpaceComponentState.new(Native.BlankSpaceComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [BlankSpaceComponent]
        def self.create()
            result = BlankSpaceComponent.new(Native.BlankSpaceComponent_new())
            result
        end
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

    class BlankSpaceComponentStateRef
        attr_accessor :handle
        # @return [Integer]
        def height()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.BlankSpaceComponentState_height(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class BlankSpaceComponentStateRefMut < BlankSpaceComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class ComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class ComponentRefMut < ComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class CurrentComparisonComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class CurrentComparisonComponentRefMut < CurrentComparisonComponentRef
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
        # @param [TimerRef] timer
        # @return [CurrentComparisonComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = CurrentComparisonComponentState.new(Native.CurrentComparisonComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [CurrentComparisonComponent]
        def self.create()
            result = CurrentComparisonComponent.new(Native.CurrentComparisonComponent_new())
            result
        end
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

    class CurrentComparisonComponentStateRef
        attr_accessor :handle
        # @return [String]
        def text()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.CurrentComparisonComponentState_text(@handle.ptr)
            result
        end
        # @return [String]
        def comparison()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.CurrentComparisonComponentState_comparison(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class CurrentComparisonComponentStateRefMut < CurrentComparisonComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class CurrentComparisonComponentState < CurrentComparisonComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.CurrentComparisonComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = CurrentComparisonComponentState.finalize @handle
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

    class CurrentPaceComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class CurrentPaceComponentRefMut < CurrentPaceComponentRef
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
        # @param [TimerRef] timer
        # @return [CurrentPaceComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = CurrentPaceComponentState.new(Native.CurrentPaceComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [CurrentPaceComponent]
        def self.create()
            result = CurrentPaceComponent.new(Native.CurrentPaceComponent_new())
            result
        end
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

    class CurrentPaceComponentStateRef
        attr_accessor :handle
        # @return [String]
        def text()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.CurrentPaceComponentState_text(@handle.ptr)
            result
        end
        # @return [String]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.CurrentPaceComponentState_time(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class CurrentPaceComponentStateRefMut < CurrentPaceComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class CurrentPaceComponentState < CurrentPaceComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.CurrentPaceComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = CurrentPaceComponentState.finalize @handle
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

    class DeltaComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class DeltaComponentRefMut < DeltaComponentRef
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
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [DeltaComponentState]
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
            result = DeltaComponentState.new(Native.DeltaComponent_state(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [DeltaComponent]
        def self.create()
            result = DeltaComponent.new(Native.DeltaComponent_new())
            result
        end
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

    class DeltaComponentStateRef
        attr_accessor :handle
        # @return [String]
        def text()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DeltaComponentState_text(@handle.ptr)
            result
        end
        # @return [String]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DeltaComponentState_time(@handle.ptr)
            result
        end
        # @return [String]
        def semantic_color()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DeltaComponentState_semantic_color(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class DeltaComponentStateRefMut < DeltaComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class DeltaComponentState < DeltaComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.DeltaComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = DeltaComponentState.finalize @handle
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

    class DetailedTimerComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class DetailedTimerComponentRefMut < DetailedTimerComponentRef
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
        # @return [DetailedTimerComponent]
        def self.create()
            result = DetailedTimerComponent.new(Native.DetailedTimerComponent_new())
            result
        end
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

    class DetailedTimerComponentStateRef
        attr_accessor :handle
        # @return [String]
        def timer_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_timer_time(@handle.ptr)
            result
        end
        # @return [String]
        def timer_fraction()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_timer_fraction(@handle.ptr)
            result
        end
        # @return [String]
        def timer_semantic_color()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_timer_semantic_color(@handle.ptr)
            result
        end
        # @return [String]
        def segment_timer_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_segment_timer_time(@handle.ptr)
            result
        end
        # @return [String]
        def segment_timer_fraction()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_segment_timer_fraction(@handle.ptr)
            result
        end
        # @return [Boolean]
        def comparison1_visible()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison1_visible(@handle.ptr)
            result
        end
        # @return [String]
        def comparison1_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison1_name(@handle.ptr)
            result
        end
        # @return [String]
        def comparison1_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison1_time(@handle.ptr)
            result
        end
        # @return [Boolean]
        def comparison2_visible()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison2_visible(@handle.ptr)
            result
        end
        # @return [String]
        def comparison2_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison2_name(@handle.ptr)
            result
        end
        # @return [String]
        def comparison2_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_comparison2_time(@handle.ptr)
            result
        end
        # @return [String]
        def icon_change()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_icon_change(@handle.ptr)
            result
        end
        # @return [String]
        def name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.DetailedTimerComponentState_name(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class DetailedTimerComponentStateRefMut < DetailedTimerComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class GeneralLayoutSettingsRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class GeneralLayoutSettingsRefMut < GeneralLayoutSettingsRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class GraphComponentRef
        attr_accessor :handle
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

    class GraphComponentRefMut < GraphComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [GraphComponent]
        def self.create()
            result = GraphComponent.new(Native.GraphComponent_new())
            result
        end
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

    class GraphComponentStateRef
        attr_accessor :handle
        # @return [Integer]
        def points_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_points_len(@handle.ptr)
            result
        end
        # @param [Integer] index
        # @return [Float]
        def point_x(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_point_x(@handle.ptr, index)
            result
        end
        # @param [Integer] index
        # @return [Float]
        def point_y(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_point_y(@handle.ptr, index)
            result
        end
        # @param [Integer] index
        # @return [Boolean]
        def point_is_best_segment(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_point_is_best_segment(@handle.ptr, index)
            result
        end
        # @return [Integer]
        def horizontal_grid_lines_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_horizontal_grid_lines_len(@handle.ptr)
            result
        end
        # @param [Integer] index
        # @return [Float]
        def horizontal_grid_line(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_horizontal_grid_line(@handle.ptr, index)
            result
        end
        # @return [Integer]
        def vertical_grid_lines_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_vertical_grid_lines_len(@handle.ptr)
            result
        end
        # @param [Integer] index
        # @return [Float]
        def vertical_grid_line(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_vertical_grid_line(@handle.ptr, index)
            result
        end
        # @return [Float]
        def middle()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_middle(@handle.ptr)
            result
        end
        # @return [Boolean]
        def is_live_delta_active()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.GraphComponentState_is_live_delta_active(@handle.ptr)
            result
        end
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

    class GraphComponentStateRefMut < GraphComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class HotkeySystemRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class HotkeySystemRefMut < HotkeySystemRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @param [SharedTimer] shared_timer
        # @return [HotkeySystem]
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
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    class LayoutRef
        attr_accessor :handle
        # @return [Layout]
        def clone()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Layout.new(Native.Layout_clone(@handle.ptr))
            result
        end
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

    class LayoutRefMut < LayoutRef
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
        def scroll_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Layout_scroll_up(@handle.ptr)
        end
        def scroll_down()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Layout_scroll_down(@handle.ptr)
        end
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
        # @return [Layout]
        def self.create()
            result = Layout.new(Native.Layout_new())
            result
        end
        # @return [Layout]
        def self.default_layout()
            result = Layout.new(Native.Layout_default_layout())
            result
        end
        # @param [String] settings
        # @return [Layout]
        def self.parse_json(settings)
            result = Layout.new(Native.Layout_parse_json(settings))
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

    class LayoutEditorRef
        attr_accessor :handle
        # @return [String]
        def state_as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.LayoutEditor_state_as_json(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class LayoutEditorRefMut < LayoutEditorRef
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
        # @param [Integer] index
        def select(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_select(@handle.ptr, index)
        end
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
        def remove_component()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_remove_component(@handle.ptr)
        end
        def move_component_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_move_component_up(@handle.ptr)
        end
        def move_component_down()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_move_component_down(@handle.ptr)
        end
        # @param [Integer] dst_index
        def move_component(dst_index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_move_component(@handle.ptr, dst_index)
        end
        def duplicate_component()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.LayoutEditor_duplicate_component(@handle.ptr)
        end
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
        # @param [Layout] layout
        # @return [LayoutEditor]
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

    class ParseRunResultRef
        attr_accessor :handle
        # @return [Boolean]
        def parsed_successfully()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.ParseRunResult_parsed_successfully(@handle.ptr)
            result
        end
        # @return [String]
        def timer_kind()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.ParseRunResult_timer_kind(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class ParseRunResultRefMut < ParseRunResultRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class PossibleTimeSaveComponentRef
        attr_accessor :handle
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
        # @param [TimerRef] timer
        # @return [PossibleTimeSaveComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = PossibleTimeSaveComponentState.new(Native.PossibleTimeSaveComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class PossibleTimeSaveComponentRefMut < PossibleTimeSaveComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [PossibleTimeSaveComponent]
        def self.create()
            result = PossibleTimeSaveComponent.new(Native.PossibleTimeSaveComponent_new())
            result
        end
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

    class PossibleTimeSaveComponentStateRef
        attr_accessor :handle
        # @return [String]
        def text()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.PossibleTimeSaveComponentState_text(@handle.ptr)
            result
        end
        # @return [String]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.PossibleTimeSaveComponentState_time(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class PossibleTimeSaveComponentStateRefMut < PossibleTimeSaveComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class PossibleTimeSaveComponentState < PossibleTimeSaveComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.PossibleTimeSaveComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = PossibleTimeSaveComponentState.finalize @handle
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

    class PotentialCleanUpRef
        attr_accessor :handle
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

    class PotentialCleanUpRefMut < PotentialCleanUpRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class PreviousSegmentComponentRef
        attr_accessor :handle
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
        # @param [TimerRef] timer
        # @param [GeneralLayoutSettingsRef] layout_settings
        # @return [PreviousSegmentComponentState]
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
            result = PreviousSegmentComponentState.new(Native.PreviousSegmentComponent_state(@handle.ptr, timer.handle.ptr, layout_settings.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class PreviousSegmentComponentRefMut < PreviousSegmentComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [PreviousSegmentComponent]
        def self.create()
            result = PreviousSegmentComponent.new(Native.PreviousSegmentComponent_new())
            result
        end
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

    class PreviousSegmentComponentStateRef
        attr_accessor :handle
        # @return [String]
        def text()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.PreviousSegmentComponentState_text(@handle.ptr)
            result
        end
        # @return [String]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.PreviousSegmentComponentState_time(@handle.ptr)
            result
        end
        # @return [String]
        def semantic_color()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.PreviousSegmentComponentState_semantic_color(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class PreviousSegmentComponentStateRefMut < PreviousSegmentComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class PreviousSegmentComponentState < PreviousSegmentComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.PreviousSegmentComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = PreviousSegmentComponentState.finalize @handle
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

    class RunRef
        attr_accessor :handle
        # @return [Run]
        def clone()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Run.new(Native.Run_clone(@handle.ptr))
            result
        end
        # @return [String]
        def game_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_game_name(@handle.ptr)
            result
        end
        # @return [String]
        def game_icon()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_game_icon(@handle.ptr)
            result
        end
        # @return [String]
        def category_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_category_name(@handle.ptr)
            result
        end
        # @param [Boolean] use_extended_category_name
        # @return [String]
        def extended_file_name(use_extended_category_name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_extended_file_name(@handle.ptr, use_extended_category_name)
            result
        end
        # @param [Boolean] use_extended_category_name
        # @return [String]
        def extended_name(use_extended_category_name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_extended_name(@handle.ptr, use_extended_category_name)
            result
        end
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
        # @return [Integer]
        def attempt_count()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_attempt_count(@handle.ptr)
            result
        end
        # @return [RunMetadataRef]
        def metadata()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunMetadataRef.new(Native.Run_metadata(@handle.ptr))
            result
        end
        # @return [TimeSpanRef]
        def offset()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpanRef.new(Native.Run_offset(@handle.ptr))
            result
        end
        # @return [Integer]
        def len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_len(@handle.ptr)
            result
        end
        # @param [Integer] index
        # @return [SegmentRef]
        def segment(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SegmentRef.new(Native.Run_segment(@handle.ptr, index))
            result
        end
        # @return [Integer]
        def attempt_history_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_attempt_history_len(@handle.ptr)
            result
        end
        # @param [Integer] index
        # @return [AttemptRef]
        def attempt_history_index(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = AttemptRef.new(Native.Run_attempt_history_index(@handle.ptr, index))
            result
        end
        # @return [String]
        def save_as_lss()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_save_as_lss(@handle.ptr)
            result
        end
        # @return [Integer]
        def custom_comparisons_len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_custom_comparisons_len(@handle.ptr)
            result
        end
        # @param [Integer] index
        # @return [String]
        def custom_comparison(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Run_custom_comparison(@handle.ptr, index)
            result
        end
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

    class RunRefMut < RunRef
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
        # @param [String] game
        def set_game_name(game)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Run_set_game_name(@handle.ptr, game)
        end
        # @param [String] category
        def set_category_name(category)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Run_set_category_name(@handle.ptr, category)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [Run]
        def self.create()
            result = Run.new(Native.Run_new())
            result
        end
        # @param [Integer] data
        # @param [Integer] length
        # @param [String] path
        # @param [Boolean] load_files
        # @return [ParseRunResult]
        def self.parse(data, length, path, load_files)
            result = ParseRunResult.new(Native.Run_parse(data, length, path, load_files))
            result
        end
        # @param [Integer] handle
        # @param [String] path
        # @param [Boolean] load_files
        # @return [ParseRunResult]
        def self.parse_file_handle(handle, path, load_files)
            result = ParseRunResult.new(Native.Run_parse_file_handle(handle, path, load_files))
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    class RunEditorRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class RunEditorRefMut < RunEditorRef
        # @return [String]
        def state_as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_state_as_json(@handle.ptr)
            result
        end
        # @param [Integer] method
        def select_timing_method(method)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_select_timing_method(@handle.ptr, method)
        end
        # @param [Integer] index
        def unselect(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_unselect(@handle.ptr, index)
        end
        # @param [Integer] index
        def select_additionally(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_select_additionally(@handle.ptr, index)
        end
        # @param [Integer] index
        def select_only(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_select_only(@handle.ptr, index)
        end
        # @param [String] game
        def set_game_name(game)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_game_name(@handle.ptr, game)
        end
        # @param [String] category
        def set_category_name(category)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_category_name(@handle.ptr, category)
        end
        # @param [String] offset
        # @return [Boolean]
        def parse_and_set_offset(offset)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_parse_and_set_offset(@handle.ptr, offset)
            result
        end
        # @param [String] attempts
        # @return [Boolean]
        def parse_and_set_attempt_count(attempts)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_parse_and_set_attempt_count(@handle.ptr, attempts)
            result
        end
        # @param [Integer] data
        # @param [Integer] length
        def set_game_icon(data, length)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_set_game_icon(@handle.ptr, data, length)
        end
        def remove_game_icon()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_remove_game_icon(@handle.ptr)
        end
        def insert_segment_above()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_insert_segment_above(@handle.ptr)
        end
        def insert_segment_below()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_insert_segment_below(@handle.ptr)
        end
        def remove_segments()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_remove_segments(@handle.ptr)
        end
        def move_segments_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_move_segments_up(@handle.ptr)
        end
        def move_segments_down()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_move_segments_down(@handle.ptr)
        end
        # @param [Integer] data
        # @param [Integer] length
        def selected_set_icon(data, length)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_selected_set_icon(@handle.ptr, data, length)
        end
        def selected_remove_icon()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_selected_remove_icon(@handle.ptr)
        end
        # @param [String] name
        def selected_set_name(name)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_selected_set_name(@handle.ptr, name)
        end
        # @param [String] time
        # @return [Boolean]
        def selected_parse_and_set_split_time(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_selected_parse_and_set_split_time(@handle.ptr, time)
            result
        end
        # @param [String] time
        # @return [Boolean]
        def selected_parse_and_set_segment_time(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_selected_parse_and_set_segment_time(@handle.ptr, time)
            result
        end
        # @param [String] time
        # @return [Boolean]
        def selected_parse_and_set_best_segment_time(time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_selected_parse_and_set_best_segment_time(@handle.ptr, time)
            result
        end
        # @param [String] comparison
        # @param [String] time
        # @return [Boolean]
        def selected_parse_and_set_comparison_time(comparison, time)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_selected_parse_and_set_comparison_time(@handle.ptr, comparison, time)
            result
        end
        # @param [String] comparison
        # @return [Boolean]
        def add_comparison(comparison)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunEditor_add_comparison(@handle.ptr, comparison)
            result
        end
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
        # @param [String] comparison
        def remove_comparison(comparison)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_remove_comparison(@handle.ptr, comparison)
        end
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
        def clear_history()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_clear_history(@handle.ptr)
        end
        def clear_times()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.RunEditor_clear_times(@handle.ptr)
        end
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
        # @param [Run] run
        # @return [RunEditor]
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

    class RunMetadataRef
        attr_accessor :handle
        # @return [String]
        def run_id()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadata_run_id(@handle.ptr)
            result
        end
        # @return [String]
        def platform_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadata_platform_name(@handle.ptr)
            result
        end
        # @return [Boolean]
        def uses_emulator()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadata_uses_emulator(@handle.ptr)
            result
        end
        # @return [String]
        def region_name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadata_region_name(@handle.ptr)
            result
        end
        # @return [RunMetadataVariablesIter]
        def variables()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunMetadataVariablesIter.new(Native.RunMetadata_variables(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class RunMetadataRefMut < RunMetadataRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class RunMetadataVariableRef
        attr_accessor :handle
        # @return [String]
        def name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadataVariable_name(@handle.ptr)
            result
        end
        # @return [String]
        def value()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.RunMetadataVariable_value(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class RunMetadataVariableRefMut < RunMetadataVariableRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class RunMetadataVariable < RunMetadataVariableRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.RunMetadataVariable_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = RunMetadataVariable.finalize @handle
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

    class RunMetadataVariablesIterRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class RunMetadataVariablesIterRefMut < RunMetadataVariablesIterRef
        # @return [RunMetadataVariableRef]
        def next()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunMetadataVariableRef.new(Native.RunMetadataVariablesIter_next(@handle.ptr))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class RunMetadataVariablesIter < RunMetadataVariablesIterRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.RunMetadataVariablesIter_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = RunMetadataVariablesIter.finalize @handle
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

    class SegmentRef
        attr_accessor :handle
        # @return [String]
        def name()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Segment_name(@handle.ptr)
            result
        end
        # @return [String]
        def icon()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Segment_icon(@handle.ptr)
            result
        end
        # @param [String] comparison
        # @return [TimeRef]
        def comparison(comparison)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Segment_comparison(@handle.ptr, comparison))
            result
        end
        # @return [TimeRef]
        def personal_best_split_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Segment_personal_best_split_time(@handle.ptr))
            result
        end
        # @return [TimeRef]
        def best_segment_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeRef.new(Native.Segment_best_segment_time(@handle.ptr))
            result
        end
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

    class SegmentRefMut < SegmentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class SegmentHistoryRef
        attr_accessor :handle
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

    class SegmentHistoryRefMut < SegmentHistoryRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class SegmentHistoryElementRef
        attr_accessor :handle
        # @return [Integer]
        def index()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SegmentHistoryElement_index(@handle.ptr)
            result
        end
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

    class SegmentHistoryElementRefMut < SegmentHistoryElementRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class SegmentHistoryIterRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SegmentHistoryIterRefMut < SegmentHistoryIterRef
        # @return [SegmentHistoryElementRef]
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

    class SeparatorComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SeparatorComponentRefMut < SeparatorComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [SeparatorComponent]
        def self.create()
            result = SeparatorComponent.new(Native.SeparatorComponent_new())
            result
        end
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

    class SettingValueRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SettingValueRefMut < SettingValueRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @param [Boolean] value
        # @return [SettingValue]
        def self.from_bool(value)
            result = SettingValue.new(Native.SettingValue_from_bool(value))
            result
        end
        # @param [Integer] value
        # @return [SettingValue]
        def self.from_uint(value)
            result = SettingValue.new(Native.SettingValue_from_uint(value))
            result
        end
        # @param [Integer] value
        # @return [SettingValue]
        def self.from_int(value)
            result = SettingValue.new(Native.SettingValue_from_int(value))
            result
        end
        # @param [String] value
        # @return [SettingValue]
        def self.from_string(value)
            result = SettingValue.new(Native.SettingValue_from_string(value))
            result
        end
        # @param [String] value
        # @return [SettingValue]
        def self.from_optional_string(value)
            result = SettingValue.new(Native.SettingValue_from_optional_string(value))
            result
        end
        # @return [SettingValue]
        def self.from_optional_empty_string()
            result = SettingValue.new(Native.SettingValue_from_optional_empty_string())
            result
        end
        # @param [Float] value
        # @return [SettingValue]
        def self.from_float(value)
            result = SettingValue.new(Native.SettingValue_from_float(value))
            result
        end
        # @param [String] value
        # @return [SettingValue]
        def self.from_accuracy(value)
            result = SettingValue.new(Native.SettingValue_from_accuracy(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # @param [String] value
        # @return [SettingValue]
        def self.from_digits_format(value)
            result = SettingValue.new(Native.SettingValue_from_digits_format(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # @param [String] value
        # @return [SettingValue]
        def self.from_optional_timing_method(value)
            result = SettingValue.new(Native.SettingValue_from_optional_timing_method(value))
            if result.handle.ptr == nil
                return nil
            end
            result
        end
        # @return [SettingValue]
        def self.from_optional_empty_timing_method()
            result = SettingValue.new(Native.SettingValue_from_optional_empty_timing_method())
            result
        end
        # @param [Float] r
        # @param [Float] g
        # @param [Float] b
        # @param [Float] a
        # @return [SettingValue]
        def self.from_color(r, g, b, a)
            result = SettingValue.new(Native.SettingValue_from_color(r, g, b, a))
            result
        end
        # @param [Float] r
        # @param [Float] g
        # @param [Float] b
        # @param [Float] a
        # @return [SettingValue]
        def self.from_optional_color(r, g, b, a)
            result = SettingValue.new(Native.SettingValue_from_optional_color(r, g, b, a))
            result
        end
        # @return [SettingValue]
        def self.from_optional_empty_color()
            result = SettingValue.new(Native.SettingValue_from_optional_empty_color())
            result
        end
        # @return [SettingValue]
        def self.from_transparent_gradient()
            result = SettingValue.new(Native.SettingValue_from_transparent_gradient())
            result
        end
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
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    class SharedTimerRef
        attr_accessor :handle
        # @return [SharedTimer]
        def share()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SharedTimer.new(Native.SharedTimer_share(@handle.ptr))
            result
        end
        # @return [TimerReadLock]
        def read()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimerReadLock.new(Native.SharedTimer_read(@handle.ptr))
            result
        end
        # @return [TimerWriteLock]
        def write()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimerWriteLock.new(Native.SharedTimer_write(@handle.ptr))
            result
        end
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

    class SharedTimerRefMut < SharedTimerRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class SplitsComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SplitsComponentRefMut < SplitsComponentRef
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
        def scroll_up()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_scroll_up(@handle.ptr)
        end
        def scroll_down()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_scroll_down(@handle.ptr)
        end
        # @param [Integer] count
        def set_visual_split_count(count)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_set_visual_split_count(@handle.ptr, count)
        end
        # @param [Integer] count
        def set_split_preview_count(count)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_set_split_preview_count(@handle.ptr, count)
        end
        # @param [Boolean] always_show_last_split
        def set_always_show_last_split(always_show_last_split)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.SplitsComponent_set_always_show_last_split(@handle.ptr, always_show_last_split)
        end
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
        # @return [SplitsComponent]
        def self.create()
            result = SplitsComponent.new(Native.SplitsComponent_new())
            result
        end
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

    class SplitsComponentStateRef
        attr_accessor :handle
        # @return [Boolean]
        def final_separator_shown()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_final_separator_shown(@handle.ptr)
            result
        end
        # @return [Integer]
        def len()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_len(@handle.ptr)
            result
        end
        # @return [Integer]
        def icon_change_count()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_icon_change_count(@handle.ptr)
            result
        end
        # @param [Integer] index
        # @return [Integer]
        def icon_change_segment_index(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_icon_change_segment_index(@handle.ptr, index)
            result
        end
        # @param [Integer] index
        # @return [String]
        def icon_change_icon(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_icon_change_icon(@handle.ptr, index)
            result
        end
        # @param [Integer] index
        # @return [String]
        def name(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_name(@handle.ptr, index)
            result
        end
        # @param [Integer] index
        # @return [String]
        def delta(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_delta(@handle.ptr, index)
            result
        end
        # @param [Integer] index
        # @return [String]
        def time(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_time(@handle.ptr, index)
            result
        end
        # @param [Integer] index
        # @return [String]
        def semantic_color(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_semantic_color(@handle.ptr, index)
            result
        end
        # @param [Integer] index
        # @return [Boolean]
        def is_current_split(index)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SplitsComponentState_is_current_split(@handle.ptr, index)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SplitsComponentStateRefMut < SplitsComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class SumOfBestCleanerRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SumOfBestCleanerRefMut < SumOfBestCleanerRef
        # @return [PotentialCleanUp]
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

    class SumOfBestComponentRef
        attr_accessor :handle
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
        # @param [TimerRef] timer
        # @return [SumOfBestComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = SumOfBestComponentState.new(Native.SumOfBestComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SumOfBestComponentRefMut < SumOfBestComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [SumOfBestComponent]
        def self.create()
            result = SumOfBestComponent.new(Native.SumOfBestComponent_new())
            result
        end
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

    class SumOfBestComponentStateRef
        attr_accessor :handle
        # @return [String]
        def text()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SumOfBestComponentState_text(@handle.ptr)
            result
        end
        # @return [String]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.SumOfBestComponentState_time(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SumOfBestComponentStateRefMut < SumOfBestComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class SumOfBestComponentState < SumOfBestComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.SumOfBestComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = SumOfBestComponentState.finalize @handle
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

    class TextComponentRef
        attr_accessor :handle
        # @return [String]
        def state_as_json()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TextComponent_state_as_json(@handle.ptr)
            result
        end
        # @return [TextComponentState]
        def state()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TextComponentState.new(Native.TextComponent_state(@handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class TextComponentRefMut < TextComponentRef
        # @param [String] text
        def set_center(text)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.TextComponent_set_center(@handle.ptr, text)
        end
        # @param [String] text
        def set_left(text)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.TextComponent_set_left(@handle.ptr, text)
        end
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
        # @return [TextComponent]
        def self.create()
            result = TextComponent.new(Native.TextComponent_new())
            result
        end
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

    class TextComponentStateRef
        attr_accessor :handle
        # @return [String]
        def left()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TextComponentState_left(@handle.ptr)
            result
        end
        # @return [String]
        def right()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TextComponentState_right(@handle.ptr)
            result
        end
        # @return [String]
        def center()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TextComponentState_center(@handle.ptr)
            result
        end
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

    class TextComponentStateRefMut < TextComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class TimeRef
        attr_accessor :handle
        # @return [Time]
        def clone()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Time.new(Native.Time_clone(@handle.ptr))
            result
        end
        # @return [TimeSpanRef]
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
        # @return [TimeSpanRef]
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
        # @param [Integer] timing_method
        # @return [TimeSpanRef]
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

    class TimeRefMut < TimeRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class TimeSpanRef
        attr_accessor :handle
        # @return [TimeSpan]
        def clone()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpan.new(Native.TimeSpan_clone(@handle.ptr))
            result
        end
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

    class TimeSpanRefMut < TimeSpanRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @param [Float] seconds
        # @return [TimeSpan]
        def self.from_seconds(seconds)
            result = TimeSpan.new(Native.TimeSpan_from_seconds(seconds))
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    class TimerRef
        attr_accessor :handle
        # @return [Integer]
        def current_timing_method()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_current_timing_method(@handle.ptr)
            result
        end
        # @return [String]
        def current_comparison()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_current_comparison(@handle.ptr)
            result
        end
        # @return [Boolean]
        def is_game_time_initialized()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_is_game_time_initialized(@handle.ptr)
            result
        end
        # @return [Boolean]
        def is_game_time_paused()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_is_game_time_paused(@handle.ptr)
            result
        end
        # @return [TimeSpanRef]
        def loading_times()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = TimeSpanRef.new(Native.Timer_loading_times(@handle.ptr))
            result
        end
        # @return [Integer]
        def current_phase()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.Timer_current_phase(@handle.ptr)
            result
        end
        # @return [RunRef]
        def get_run()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = RunRef.new(Native.Timer_get_run(@handle.ptr))
            result
        end
        def print_debug()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_print_debug(@handle.ptr)
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class TimerRefMut < TimerRef
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
        # @param [Run] run
        # @return [Run]
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
        def start()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_start(@handle.ptr)
        end
        def split()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_split(@handle.ptr)
        end
        def split_or_start()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_split_or_start(@handle.ptr)
        end
        def skip_split()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_skip_split(@handle.ptr)
        end
        def undo_split()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_undo_split(@handle.ptr)
        end
        # @param [Boolean] update_splits
        def reset(update_splits)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_reset(@handle.ptr, update_splits)
        end
        def pause()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_pause(@handle.ptr)
        end
        def resume()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_resume(@handle.ptr)
        end
        def toggle_pause()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_toggle_pause(@handle.ptr)
        end
        def toggle_pause_or_start()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_toggle_pause_or_start(@handle.ptr)
        end
        def undo_all_pauses()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_undo_all_pauses(@handle.ptr)
        end
        # @param [Integer] method
        def set_current_timing_method(method)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_set_current_timing_method(@handle.ptr, method)
        end
        def switch_to_next_comparison()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_switch_to_next_comparison(@handle.ptr)
        end
        def switch_to_previous_comparison()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_switch_to_previous_comparison(@handle.ptr)
        end
        def initialize_game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_initialize_game_time(@handle.ptr)
        end
        def uninitialize_game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_uninitialize_game_time(@handle.ptr)
        end
        def pause_game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_pause_game_time(@handle.ptr)
        end
        def unpause_game_time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            Native.Timer_unpause_game_time(@handle.ptr)
        end
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
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @param [Run] run
        # @return [Timer]
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
        # @return [SharedTimer]
        def into_shared()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = SharedTimer.new(Native.Timer_into_shared(@handle.ptr))
            @handle.ptr = nil
            result
        end
        def initialize(ptr)
            handle = LSCHandle.new ptr
            @handle = handle
            ObjectSpace.define_finalizer(self, self.class.finalize(handle))
        end
    end

    class TimerComponentRef
        attr_accessor :handle
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

    class TimerComponentRefMut < TimerComponentRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [TimerComponent]
        def self.create()
            result = TimerComponent.new(Native.TimerComponent_new())
            result
        end
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

    class TimerComponentStateRef
        attr_accessor :handle
        # @return [String]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TimerComponentState_time(@handle.ptr)
            result
        end
        # @return [String]
        def fraction()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TimerComponentState_fraction(@handle.ptr)
            result
        end
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

    class TimerComponentStateRefMut < TimerComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class TimerReadLockRef
        attr_accessor :handle
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

    class TimerReadLockRefMut < TimerReadLockRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class TimerWriteLockRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class TimerWriteLockRefMut < TimerWriteLockRef
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

    class TitleComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class TitleComponentRefMut < TitleComponentRef
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
        # @return [TitleComponent]
        def self.create()
            result = TitleComponent.new(Native.TitleComponent_new())
            result
        end
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

    class TitleComponentStateRef
        attr_accessor :handle
        # @return [String]
        def icon_change()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_icon_change(@handle.ptr)
            result
        end
        # @return [String]
        def line1()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_line1(@handle.ptr)
            result
        end
        # @return [String]
        def line2()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_line2(@handle.ptr)
            result
        end
        # @return [Boolean]
        def is_centered()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_is_centered(@handle.ptr)
            result
        end
        # @return [Boolean]
        def shows_finished_runs()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_shows_finished_runs(@handle.ptr)
            result
        end
        # @return [Integer]
        def finished_runs()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_finished_runs(@handle.ptr)
            result
        end
        # @return [Boolean]
        def shows_attempts()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TitleComponentState_shows_attempts(@handle.ptr)
            result
        end
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

    class TitleComponentStateRefMut < TitleComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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

    class TotalPlaytimeComponentRef
        attr_accessor :handle
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class TotalPlaytimeComponentRefMut < TotalPlaytimeComponentRef
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
        # @param [TimerRef] timer
        # @return [TotalPlaytimeComponentState]
        def state(timer)
            if @handle.ptr == nil
                raise "this is disposed"
            end
            if timer.handle.ptr == nil
                raise "timer is disposed"
            end
            result = TotalPlaytimeComponentState.new(Native.TotalPlaytimeComponent_state(@handle.ptr, timer.handle.ptr))
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

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
        # @return [TotalPlaytimeComponent]
        def self.create()
            result = TotalPlaytimeComponent.new(Native.TotalPlaytimeComponent_new())
            result
        end
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

    class TotalPlaytimeComponentStateRef
        attr_accessor :handle
        # @return [String]
        def text()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TotalPlaytimeComponentState_text(@handle.ptr)
            result
        end
        # @return [String]
        def time()
            if @handle.ptr == nil
                raise "this is disposed"
            end
            result = Native.TotalPlaytimeComponentState_time(@handle.ptr)
            result
        end
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class TotalPlaytimeComponentStateRefMut < TotalPlaytimeComponentStateRef
        def initialize(ptr)
            @handle = LSCHandle.new ptr
        end
    end

    class TotalPlaytimeComponentState < TotalPlaytimeComponentStateRefMut
        def self.finalize(handle)
            proc {
                if handle.ptr != nil
                    Native.TotalPlaytimeComponentState_drop handle.ptr
                    handle.ptr = nil
                end
            }
        end
        def dispose
            finalizer = TotalPlaytimeComponentState.finalize @handle
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
end

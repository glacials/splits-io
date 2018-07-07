"use strict";
const ffi = require('ffi');
const fs = require('fs');
const ref = require('ref');

const liveSplitCoreNative = ffi.Library('livesplit_core', {
    'AtomicDateTime_drop': ['void', ['pointer']],
    'AtomicDateTime_is_synchronized': ['bool', ['pointer']],
    'AtomicDateTime_to_rfc2822': ['CString', ['pointer']],
    'AtomicDateTime_to_rfc3339': ['CString', ['pointer']],
    'Attempt_index': ['int32', ['pointer']],
    'Attempt_time': ['pointer', ['pointer']],
    'Attempt_pause_time': ['pointer', ['pointer']],
    'Attempt_started': ['pointer', ['pointer']],
    'Attempt_ended': ['pointer', ['pointer']],
    'BlankSpaceComponent_new': ['pointer', []],
    'BlankSpaceComponent_drop': ['void', ['pointer']],
    'BlankSpaceComponent_into_generic': ['pointer', ['pointer']],
    'BlankSpaceComponent_state_as_json': ['CString', ['pointer', 'pointer']],
    'BlankSpaceComponent_state': ['pointer', ['pointer', 'pointer']],
    'BlankSpaceComponentState_drop': ['void', ['pointer']],
    'BlankSpaceComponentState_height': ['uint32', ['pointer']],
    'Component_drop': ['void', ['pointer']],
    'CurrentComparisonComponent_new': ['pointer', []],
    'CurrentComparisonComponent_drop': ['void', ['pointer']],
    'CurrentComparisonComponent_into_generic': ['pointer', ['pointer']],
    'CurrentComparisonComponent_state_as_json': ['CString', ['pointer', 'pointer']],
    'CurrentComparisonComponent_state': ['pointer', ['pointer', 'pointer']],
    'CurrentComparisonComponentState_drop': ['void', ['pointer']],
    'CurrentComparisonComponentState_text': ['CString', ['pointer']],
    'CurrentComparisonComponentState_comparison': ['CString', ['pointer']],
    'CurrentPaceComponent_new': ['pointer', []],
    'CurrentPaceComponent_drop': ['void', ['pointer']],
    'CurrentPaceComponent_into_generic': ['pointer', ['pointer']],
    'CurrentPaceComponent_state_as_json': ['CString', ['pointer', 'pointer']],
    'CurrentPaceComponent_state': ['pointer', ['pointer', 'pointer']],
    'CurrentPaceComponentState_drop': ['void', ['pointer']],
    'CurrentPaceComponentState_text': ['CString', ['pointer']],
    'CurrentPaceComponentState_time': ['CString', ['pointer']],
    'DeltaComponent_new': ['pointer', []],
    'DeltaComponent_drop': ['void', ['pointer']],
    'DeltaComponent_into_generic': ['pointer', ['pointer']],
    'DeltaComponent_state_as_json': ['CString', ['pointer', 'pointer', 'pointer']],
    'DeltaComponent_state': ['pointer', ['pointer', 'pointer', 'pointer']],
    'DeltaComponentState_drop': ['void', ['pointer']],
    'DeltaComponentState_text': ['CString', ['pointer']],
    'DeltaComponentState_time': ['CString', ['pointer']],
    'DeltaComponentState_semantic_color': ['CString', ['pointer']],
    'DetailedTimerComponent_new': ['pointer', []],
    'DetailedTimerComponent_drop': ['void', ['pointer']],
    'DetailedTimerComponent_into_generic': ['pointer', ['pointer']],
    'DetailedTimerComponent_state_as_json': ['CString', ['pointer', 'pointer', 'pointer']],
    'DetailedTimerComponent_state': ['pointer', ['pointer', 'pointer', 'pointer']],
    'DetailedTimerComponentState_drop': ['void', ['pointer']],
    'DetailedTimerComponentState_timer_time': ['CString', ['pointer']],
    'DetailedTimerComponentState_timer_fraction': ['CString', ['pointer']],
    'DetailedTimerComponentState_timer_semantic_color': ['CString', ['pointer']],
    'DetailedTimerComponentState_segment_timer_time': ['CString', ['pointer']],
    'DetailedTimerComponentState_segment_timer_fraction': ['CString', ['pointer']],
    'DetailedTimerComponentState_comparison1_visible': ['bool', ['pointer']],
    'DetailedTimerComponentState_comparison1_name': ['CString', ['pointer']],
    'DetailedTimerComponentState_comparison1_time': ['CString', ['pointer']],
    'DetailedTimerComponentState_comparison2_visible': ['bool', ['pointer']],
    'DetailedTimerComponentState_comparison2_name': ['CString', ['pointer']],
    'DetailedTimerComponentState_comparison2_time': ['CString', ['pointer']],
    'DetailedTimerComponentState_icon_change': ['CString', ['pointer']],
    'DetailedTimerComponentState_name': ['CString', ['pointer']],
    'GeneralLayoutSettings_default': ['pointer', []],
    'GeneralLayoutSettings_drop': ['void', ['pointer']],
    'GraphComponent_new': ['pointer', []],
    'GraphComponent_drop': ['void', ['pointer']],
    'GraphComponent_into_generic': ['pointer', ['pointer']],
    'GraphComponent_state_as_json': ['CString', ['pointer', 'pointer', 'pointer']],
    'GraphComponent_state': ['pointer', ['pointer', 'pointer', 'pointer']],
    'GraphComponentState_drop': ['void', ['pointer']],
    'GraphComponentState_points_len': ['size_t', ['pointer']],
    'GraphComponentState_point_x': ['float', ['pointer', 'size_t']],
    'GraphComponentState_point_y': ['float', ['pointer', 'size_t']],
    'GraphComponentState_point_is_best_segment': ['bool', ['pointer', 'size_t']],
    'GraphComponentState_horizontal_grid_lines_len': ['size_t', ['pointer']],
    'GraphComponentState_horizontal_grid_line': ['float', ['pointer', 'size_t']],
    'GraphComponentState_vertical_grid_lines_len': ['size_t', ['pointer']],
    'GraphComponentState_vertical_grid_line': ['float', ['pointer', 'size_t']],
    'GraphComponentState_middle': ['float', ['pointer']],
    'GraphComponentState_is_live_delta_active': ['bool', ['pointer']],
    'GraphComponentState_is_flipped': ['bool', ['pointer']],
    'HotkeySystem_new': ['pointer', ['pointer']],
    'HotkeySystem_drop': ['void', ['pointer']],
    'Layout_new': ['pointer', []],
    'Layout_default_layout': ['pointer', []],
    'Layout_parse_json': ['pointer', ['CString']],
    'Layout_drop': ['void', ['pointer']],
    'Layout_clone': ['pointer', ['pointer']],
    'Layout_settings_as_json': ['CString', ['pointer']],
    'Layout_state_as_json': ['CString', ['pointer', 'pointer']],
    'Layout_push': ['void', ['pointer', 'pointer']],
    'Layout_scroll_up': ['void', ['pointer']],
    'Layout_scroll_down': ['void', ['pointer']],
    'Layout_remount': ['void', ['pointer']],
    'LayoutEditor_new': ['pointer', ['pointer']],
    'LayoutEditor_close': ['pointer', ['pointer']],
    'LayoutEditor_state_as_json': ['CString', ['pointer']],
    'LayoutEditor_layout_state_as_json': ['CString', ['pointer', 'pointer']],
    'LayoutEditor_select': ['void', ['pointer', 'size_t']],
    'LayoutEditor_add_component': ['void', ['pointer', 'pointer']],
    'LayoutEditor_remove_component': ['void', ['pointer']],
    'LayoutEditor_move_component_up': ['void', ['pointer']],
    'LayoutEditor_move_component_down': ['void', ['pointer']],
    'LayoutEditor_move_component': ['void', ['pointer', 'size_t']],
    'LayoutEditor_duplicate_component': ['void', ['pointer']],
    'LayoutEditor_set_component_settings_value': ['void', ['pointer', 'size_t', 'pointer']],
    'LayoutEditor_set_general_settings_value': ['void', ['pointer', 'size_t', 'pointer']],
    'ParseRunResult_drop': ['void', ['pointer']],
    'ParseRunResult_unwrap': ['pointer', ['pointer']],
    'ParseRunResult_parsed_successfully': ['bool', ['pointer']],
    'ParseRunResult_timer_kind': ['CString', ['pointer']],
    'PossibleTimeSaveComponent_new': ['pointer', []],
    'PossibleTimeSaveComponent_drop': ['void', ['pointer']],
    'PossibleTimeSaveComponent_into_generic': ['pointer', ['pointer']],
    'PossibleTimeSaveComponent_state_as_json': ['CString', ['pointer', 'pointer']],
    'PossibleTimeSaveComponent_state': ['pointer', ['pointer', 'pointer']],
    'PossibleTimeSaveComponentState_drop': ['void', ['pointer']],
    'PossibleTimeSaveComponentState_text': ['CString', ['pointer']],
    'PossibleTimeSaveComponentState_time': ['CString', ['pointer']],
    'PotentialCleanUp_drop': ['void', ['pointer']],
    'PotentialCleanUp_message': ['CString', ['pointer']],
    'PreviousSegmentComponent_new': ['pointer', []],
    'PreviousSegmentComponent_drop': ['void', ['pointer']],
    'PreviousSegmentComponent_into_generic': ['pointer', ['pointer']],
    'PreviousSegmentComponent_state_as_json': ['CString', ['pointer', 'pointer', 'pointer']],
    'PreviousSegmentComponent_state': ['pointer', ['pointer', 'pointer', 'pointer']],
    'PreviousSegmentComponentState_drop': ['void', ['pointer']],
    'PreviousSegmentComponentState_text': ['CString', ['pointer']],
    'PreviousSegmentComponentState_time': ['CString', ['pointer']],
    'PreviousSegmentComponentState_semantic_color': ['CString', ['pointer']],
    'Run_new': ['pointer', []],
    'Run_parse': ['pointer', ['pointer', 'size_t', 'CString', 'bool']],
    'Run_parse_file_handle': ['pointer', ['int64', 'CString', 'bool']],
    'Run_drop': ['void', ['pointer']],
    'Run_clone': ['pointer', ['pointer']],
    'Run_game_name': ['CString', ['pointer']],
    'Run_game_icon': ['CString', ['pointer']],
    'Run_category_name': ['CString', ['pointer']],
    'Run_extended_file_name': ['CString', ['pointer', 'bool']],
    'Run_extended_name': ['CString', ['pointer', 'bool']],
    'Run_extended_category_name': ['CString', ['pointer', 'bool', 'bool', 'bool']],
    'Run_attempt_count': ['uint32', ['pointer']],
    'Run_metadata': ['pointer', ['pointer']],
    'Run_offset': ['pointer', ['pointer']],
    'Run_len': ['size_t', ['pointer']],
    'Run_segment': ['pointer', ['pointer', 'size_t']],
    'Run_attempt_history_len': ['size_t', ['pointer']],
    'Run_attempt_history_index': ['pointer', ['pointer', 'size_t']],
    'Run_save_as_lss': ['CString', ['pointer']],
    'Run_custom_comparisons_len': ['size_t', ['pointer']],
    'Run_custom_comparison': ['CString', ['pointer', 'size_t']],
    'Run_auto_splitter_settings': ['CString', ['pointer']],
    'Run_push_segment': ['void', ['pointer', 'pointer']],
    'Run_set_game_name': ['void', ['pointer', 'CString']],
    'Run_set_category_name': ['void', ['pointer', 'CString']],
    'RunEditor_new': ['pointer', ['pointer']],
    'RunEditor_close': ['pointer', ['pointer']],
    'RunEditor_state_as_json': ['CString', ['pointer']],
    'RunEditor_select_timing_method': ['void', ['pointer', 'uint8']],
    'RunEditor_unselect': ['void', ['pointer', 'size_t']],
    'RunEditor_select_additionally': ['void', ['pointer', 'size_t']],
    'RunEditor_select_only': ['void', ['pointer', 'size_t']],
    'RunEditor_set_game_name': ['void', ['pointer', 'CString']],
    'RunEditor_set_category_name': ['void', ['pointer', 'CString']],
    'RunEditor_parse_and_set_offset': ['bool', ['pointer', 'CString']],
    'RunEditor_parse_and_set_attempt_count': ['bool', ['pointer', 'CString']],
    'RunEditor_set_game_icon': ['void', ['pointer', 'pointer', 'size_t']],
    'RunEditor_remove_game_icon': ['void', ['pointer']],
    'RunEditor_insert_segment_above': ['void', ['pointer']],
    'RunEditor_insert_segment_below': ['void', ['pointer']],
    'RunEditor_remove_segments': ['void', ['pointer']],
    'RunEditor_move_segments_up': ['void', ['pointer']],
    'RunEditor_move_segments_down': ['void', ['pointer']],
    'RunEditor_selected_set_icon': ['void', ['pointer', 'pointer', 'size_t']],
    'RunEditor_selected_remove_icon': ['void', ['pointer']],
    'RunEditor_selected_set_name': ['void', ['pointer', 'CString']],
    'RunEditor_selected_parse_and_set_split_time': ['bool', ['pointer', 'CString']],
    'RunEditor_selected_parse_and_set_segment_time': ['bool', ['pointer', 'CString']],
    'RunEditor_selected_parse_and_set_best_segment_time': ['bool', ['pointer', 'CString']],
    'RunEditor_selected_parse_and_set_comparison_time': ['bool', ['pointer', 'CString', 'CString']],
    'RunEditor_add_comparison': ['bool', ['pointer', 'CString']],
    'RunEditor_import_comparison': ['bool', ['pointer', 'pointer', 'CString']],
    'RunEditor_remove_comparison': ['void', ['pointer', 'CString']],
    'RunEditor_rename_comparison': ['bool', ['pointer', 'CString', 'CString']],
    'RunEditor_clear_history': ['void', ['pointer']],
    'RunEditor_clear_times': ['void', ['pointer']],
    'RunEditor_clean_sum_of_best': ['pointer', ['pointer']],
    'RunMetadata_run_id': ['CString', ['pointer']],
    'RunMetadata_platform_name': ['CString', ['pointer']],
    'RunMetadata_uses_emulator': ['bool', ['pointer']],
    'RunMetadata_region_name': ['CString', ['pointer']],
    'RunMetadata_variables': ['pointer', ['pointer']],
    'RunMetadataVariable_drop': ['void', ['pointer']],
    'RunMetadataVariable_name': ['CString', ['pointer']],
    'RunMetadataVariable_value': ['CString', ['pointer']],
    'RunMetadataVariablesIter_drop': ['void', ['pointer']],
    'RunMetadataVariablesIter_next': ['pointer', ['pointer']],
    'Segment_new': ['pointer', ['CString']],
    'Segment_drop': ['void', ['pointer']],
    'Segment_name': ['CString', ['pointer']],
    'Segment_icon': ['CString', ['pointer']],
    'Segment_comparison': ['pointer', ['pointer', 'CString']],
    'Segment_personal_best_split_time': ['pointer', ['pointer']],
    'Segment_best_segment_time': ['pointer', ['pointer']],
    'Segment_segment_history': ['pointer', ['pointer']],
    'SegmentHistory_iter': ['pointer', ['pointer']],
    'SegmentHistoryElement_index': ['int32', ['pointer']],
    'SegmentHistoryElement_time': ['pointer', ['pointer']],
    'SegmentHistoryIter_drop': ['void', ['pointer']],
    'SegmentHistoryIter_next': ['pointer', ['pointer']],
    'SeparatorComponent_new': ['pointer', []],
    'SeparatorComponent_drop': ['void', ['pointer']],
    'SeparatorComponent_into_generic': ['pointer', ['pointer']],
    'SettingValue_from_bool': ['pointer', ['bool']],
    'SettingValue_from_uint': ['pointer', ['uint64']],
    'SettingValue_from_int': ['pointer', ['int64']],
    'SettingValue_from_string': ['pointer', ['CString']],
    'SettingValue_from_optional_string': ['pointer', ['CString']],
    'SettingValue_from_optional_empty_string': ['pointer', []],
    'SettingValue_from_float': ['pointer', ['double']],
    'SettingValue_from_accuracy': ['pointer', ['CString']],
    'SettingValue_from_digits_format': ['pointer', ['CString']],
    'SettingValue_from_optional_timing_method': ['pointer', ['CString']],
    'SettingValue_from_optional_empty_timing_method': ['pointer', []],
    'SettingValue_from_color': ['pointer', ['float', 'float', 'float', 'float']],
    'SettingValue_from_optional_color': ['pointer', ['float', 'float', 'float', 'float']],
    'SettingValue_from_optional_empty_color': ['pointer', []],
    'SettingValue_from_transparent_gradient': ['pointer', []],
    'SettingValue_from_vertical_gradient': ['pointer', ['float', 'float', 'float', 'float', 'float', 'float', 'float', 'float']],
    'SettingValue_from_horizontal_gradient': ['pointer', ['float', 'float', 'float', 'float', 'float', 'float', 'float', 'float']],
    'SettingValue_drop': ['void', ['pointer']],
    'SharedTimer_drop': ['void', ['pointer']],
    'SharedTimer_share': ['pointer', ['pointer']],
    'SharedTimer_read': ['pointer', ['pointer']],
    'SharedTimer_write': ['pointer', ['pointer']],
    'SharedTimer_replace_inner': ['void', ['pointer', 'pointer']],
    'SplitsComponent_new': ['pointer', []],
    'SplitsComponent_drop': ['void', ['pointer']],
    'SplitsComponent_into_generic': ['pointer', ['pointer']],
    'SplitsComponent_state_as_json': ['CString', ['pointer', 'pointer', 'pointer']],
    'SplitsComponent_state': ['pointer', ['pointer', 'pointer', 'pointer']],
    'SplitsComponent_scroll_up': ['void', ['pointer']],
    'SplitsComponent_scroll_down': ['void', ['pointer']],
    'SplitsComponent_set_visual_split_count': ['void', ['pointer', 'size_t']],
    'SplitsComponent_set_split_preview_count': ['void', ['pointer', 'size_t']],
    'SplitsComponent_set_always_show_last_split': ['void', ['pointer', 'bool']],
    'SplitsComponent_set_separator_last_split': ['void', ['pointer', 'bool']],
    'SplitsComponentState_drop': ['void', ['pointer']],
    'SplitsComponentState_final_separator_shown': ['bool', ['pointer']],
    'SplitsComponentState_len': ['size_t', ['pointer']],
    'SplitsComponentState_icon_change_count': ['size_t', ['pointer']],
    'SplitsComponentState_icon_change_segment_index': ['size_t', ['pointer', 'size_t']],
    'SplitsComponentState_icon_change_icon': ['CString', ['pointer', 'size_t']],
    'SplitsComponentState_name': ['CString', ['pointer', 'size_t']],
    'SplitsComponentState_delta': ['CString', ['pointer', 'size_t']],
    'SplitsComponentState_time': ['CString', ['pointer', 'size_t']],
    'SplitsComponentState_semantic_color': ['CString', ['pointer', 'size_t']],
    'SplitsComponentState_is_current_split': ['bool', ['pointer', 'size_t']],
    'SumOfBestCleaner_drop': ['void', ['pointer']],
    'SumOfBestCleaner_next_potential_clean_up': ['pointer', ['pointer']],
    'SumOfBestCleaner_apply': ['void', ['pointer', 'pointer']],
    'SumOfBestComponent_new': ['pointer', []],
    'SumOfBestComponent_drop': ['void', ['pointer']],
    'SumOfBestComponent_into_generic': ['pointer', ['pointer']],
    'SumOfBestComponent_state_as_json': ['CString', ['pointer', 'pointer']],
    'SumOfBestComponent_state': ['pointer', ['pointer', 'pointer']],
    'SumOfBestComponentState_drop': ['void', ['pointer']],
    'SumOfBestComponentState_text': ['CString', ['pointer']],
    'SumOfBestComponentState_time': ['CString', ['pointer']],
    'TextComponent_new': ['pointer', []],
    'TextComponent_drop': ['void', ['pointer']],
    'TextComponent_into_generic': ['pointer', ['pointer']],
    'TextComponent_state_as_json': ['CString', ['pointer']],
    'TextComponent_state': ['pointer', ['pointer']],
    'TextComponent_set_center': ['void', ['pointer', 'CString']],
    'TextComponent_set_left': ['void', ['pointer', 'CString']],
    'TextComponent_set_right': ['void', ['pointer', 'CString']],
    'TextComponentState_drop': ['void', ['pointer']],
    'TextComponentState_left': ['CString', ['pointer']],
    'TextComponentState_right': ['CString', ['pointer']],
    'TextComponentState_center': ['CString', ['pointer']],
    'TextComponentState_is_split': ['bool', ['pointer']],
    'Time_drop': ['void', ['pointer']],
    'Time_clone': ['pointer', ['pointer']],
    'Time_real_time': ['pointer', ['pointer']],
    'Time_game_time': ['pointer', ['pointer']],
    'Time_index': ['pointer', ['pointer', 'uint8']],
    'TimeSpan_from_seconds': ['pointer', ['double']],
    'TimeSpan_drop': ['void', ['pointer']],
    'TimeSpan_clone': ['pointer', ['pointer']],
    'TimeSpan_total_seconds': ['double', ['pointer']],
    'Timer_new': ['pointer', ['pointer']],
    'Timer_into_shared': ['pointer', ['pointer']],
    'Timer_drop': ['void', ['pointer']],
    'Timer_current_timing_method': ['uint8', ['pointer']],
    'Timer_current_comparison': ['CString', ['pointer']],
    'Timer_is_game_time_initialized': ['bool', ['pointer']],
    'Timer_is_game_time_paused': ['bool', ['pointer']],
    'Timer_loading_times': ['pointer', ['pointer']],
    'Timer_current_phase': ['uint8', ['pointer']],
    'Timer_get_run': ['pointer', ['pointer']],
    'Timer_print_debug': ['void', ['pointer']],
    'Timer_replace_run': ['bool', ['pointer', 'pointer', 'bool']],
    'Timer_set_run': ['pointer', ['pointer', 'pointer']],
    'Timer_start': ['void', ['pointer']],
    'Timer_split': ['void', ['pointer']],
    'Timer_split_or_start': ['void', ['pointer']],
    'Timer_skip_split': ['void', ['pointer']],
    'Timer_undo_split': ['void', ['pointer']],
    'Timer_reset': ['void', ['pointer', 'bool']],
    'Timer_pause': ['void', ['pointer']],
    'Timer_resume': ['void', ['pointer']],
    'Timer_toggle_pause': ['void', ['pointer']],
    'Timer_toggle_pause_or_start': ['void', ['pointer']],
    'Timer_undo_all_pauses': ['void', ['pointer']],
    'Timer_set_current_timing_method': ['void', ['pointer', 'uint8']],
    'Timer_switch_to_next_comparison': ['void', ['pointer']],
    'Timer_switch_to_previous_comparison': ['void', ['pointer']],
    'Timer_initialize_game_time': ['void', ['pointer']],
    'Timer_uninitialize_game_time': ['void', ['pointer']],
    'Timer_pause_game_time': ['void', ['pointer']],
    'Timer_unpause_game_time': ['void', ['pointer']],
    'Timer_set_game_time': ['void', ['pointer', 'pointer']],
    'Timer_set_loading_times': ['void', ['pointer', 'pointer']],
    'TimerComponent_new': ['pointer', []],
    'TimerComponent_drop': ['void', ['pointer']],
    'TimerComponent_into_generic': ['pointer', ['pointer']],
    'TimerComponent_state_as_json': ['CString', ['pointer', 'pointer', 'pointer']],
    'TimerComponent_state': ['pointer', ['pointer', 'pointer', 'pointer']],
    'TimerComponentState_drop': ['void', ['pointer']],
    'TimerComponentState_time': ['CString', ['pointer']],
    'TimerComponentState_fraction': ['CString', ['pointer']],
    'TimerComponentState_semantic_color': ['CString', ['pointer']],
    'TimerReadLock_drop': ['void', ['pointer']],
    'TimerReadLock_timer': ['pointer', ['pointer']],
    'TimerWriteLock_drop': ['void', ['pointer']],
    'TimerWriteLock_timer': ['pointer', ['pointer']],
    'TitleComponent_new': ['pointer', []],
    'TitleComponent_drop': ['void', ['pointer']],
    'TitleComponent_into_generic': ['pointer', ['pointer']],
    'TitleComponent_state_as_json': ['CString', ['pointer', 'pointer']],
    'TitleComponent_state': ['pointer', ['pointer', 'pointer']],
    'TitleComponentState_drop': ['void', ['pointer']],
    'TitleComponentState_icon_change': ['CString', ['pointer']],
    'TitleComponentState_line1': ['CString', ['pointer']],
    'TitleComponentState_line2': ['CString', ['pointer']],
    'TitleComponentState_is_centered': ['bool', ['pointer']],
    'TitleComponentState_shows_finished_runs': ['bool', ['pointer']],
    'TitleComponentState_finished_runs': ['uint32', ['pointer']],
    'TitleComponentState_shows_attempts': ['bool', ['pointer']],
    'TitleComponentState_attempts': ['uint32', ['pointer']],
    'TotalPlaytimeComponent_new': ['pointer', []],
    'TotalPlaytimeComponent_drop': ['void', ['pointer']],
    'TotalPlaytimeComponent_into_generic': ['pointer', ['pointer']],
    'TotalPlaytimeComponent_state_as_json': ['CString', ['pointer', 'pointer']],
    'TotalPlaytimeComponent_state': ['pointer', ['pointer', 'pointer']],
    'TotalPlaytimeComponentState_drop': ['void', ['pointer']],
    'TotalPlaytimeComponentState_text': ['CString', ['pointer']],
    'TotalPlaytimeComponentState_time': ['CString', ['pointer']],
});

class AtomicDateTimeRef {
    /**
     * @return {boolean}
     */
    isSynchronized() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.AtomicDateTime_is_synchronized(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    toRfc2822() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.AtomicDateTime_to_rfc2822(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    toRfc3339() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.AtomicDateTime_to_rfc3339(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.AtomicDateTimeRef = AtomicDateTimeRef;

class AtomicDateTimeRefMut extends AtomicDateTimeRef {
}
exports.AtomicDateTimeRefMut = AtomicDateTimeRefMut;

class AtomicDateTime extends AtomicDateTimeRefMut {
    /**
     * @param {function(AtomicDateTime)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.AtomicDateTime_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.AtomicDateTime = AtomicDateTime;

class AttemptRef {
    /**
     * @return {number}
     */
    index() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Attempt_index(this.ptr);
        return result;
    }
    /**
     * @return {TimeRef}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeRef(liveSplitCoreNative.Attempt_time(this.ptr));
        return result;
    }
    /**
     * @return {TimeSpanRef | null}
     */
    pauseTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeSpanRef(liveSplitCoreNative.Attempt_pause_time(this.ptr));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @return {AtomicDateTime | null}
     */
    started() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new AtomicDateTime(liveSplitCoreNative.Attempt_started(this.ptr));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @return {AtomicDateTime | null}
     */
    ended() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new AtomicDateTime(liveSplitCoreNative.Attempt_ended(this.ptr));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.AttemptRef = AttemptRef;

class AttemptRefMut extends AttemptRef {
}
exports.AttemptRefMut = AttemptRefMut;

class Attempt extends AttemptRefMut {
    /**
     * @param {function(Attempt)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            this.ptr = ref.NULL;
        }
    }
}
exports.Attempt = Attempt;

class BlankSpaceComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.BlankSpaceComponentRef = BlankSpaceComponentRef;

class BlankSpaceComponentRefMut extends BlankSpaceComponentRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    stateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.BlankSpaceComponent_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @return {BlankSpaceComponentState}
     */
    state(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = new BlankSpaceComponentState(liveSplitCoreNative.BlankSpaceComponent_state(this.ptr, timer.ptr));
        return result;
    }
}
exports.BlankSpaceComponentRefMut = BlankSpaceComponentRefMut;

class BlankSpaceComponent extends BlankSpaceComponentRefMut {
    /**
     * @param {function(BlankSpaceComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.BlankSpaceComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {BlankSpaceComponent}
     */
    static new() {
        const result = new BlankSpaceComponent(liveSplitCoreNative.BlankSpaceComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.BlankSpaceComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.BlankSpaceComponent = BlankSpaceComponent;

class BlankSpaceComponentStateRef {
    /**
     * @return {number}
     */
    height() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.BlankSpaceComponentState_height(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.BlankSpaceComponentStateRef = BlankSpaceComponentStateRef;

class BlankSpaceComponentStateRefMut extends BlankSpaceComponentStateRef {
}
exports.BlankSpaceComponentStateRefMut = BlankSpaceComponentStateRefMut;

class BlankSpaceComponentState extends BlankSpaceComponentStateRefMut {
    /**
     * @param {function(BlankSpaceComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.BlankSpaceComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.BlankSpaceComponentState = BlankSpaceComponentState;

class ComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.ComponentRef = ComponentRef;

class ComponentRefMut extends ComponentRef {
}
exports.ComponentRefMut = ComponentRefMut;

class Component extends ComponentRefMut {
    /**
     * @param {function(Component)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.Component_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.Component = Component;

class CurrentComparisonComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.CurrentComparisonComponentRef = CurrentComparisonComponentRef;

class CurrentComparisonComponentRefMut extends CurrentComparisonComponentRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    stateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.CurrentComparisonComponent_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @return {CurrentComparisonComponentState}
     */
    state(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = new CurrentComparisonComponentState(liveSplitCoreNative.CurrentComparisonComponent_state(this.ptr, timer.ptr));
        return result;
    }
}
exports.CurrentComparisonComponentRefMut = CurrentComparisonComponentRefMut;

class CurrentComparisonComponent extends CurrentComparisonComponentRefMut {
    /**
     * @param {function(CurrentComparisonComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.CurrentComparisonComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {CurrentComparisonComponent}
     */
    static new() {
        const result = new CurrentComparisonComponent(liveSplitCoreNative.CurrentComparisonComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.CurrentComparisonComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.CurrentComparisonComponent = CurrentComparisonComponent;

class CurrentComparisonComponentStateRef {
    /**
     * @return {string}
     */
    text() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.CurrentComparisonComponentState_text(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    comparison() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.CurrentComparisonComponentState_comparison(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.CurrentComparisonComponentStateRef = CurrentComparisonComponentStateRef;

class CurrentComparisonComponentStateRefMut extends CurrentComparisonComponentStateRef {
}
exports.CurrentComparisonComponentStateRefMut = CurrentComparisonComponentStateRefMut;

class CurrentComparisonComponentState extends CurrentComparisonComponentStateRefMut {
    /**
     * @param {function(CurrentComparisonComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.CurrentComparisonComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.CurrentComparisonComponentState = CurrentComparisonComponentState;

class CurrentPaceComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.CurrentPaceComponentRef = CurrentPaceComponentRef;

class CurrentPaceComponentRefMut extends CurrentPaceComponentRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    stateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.CurrentPaceComponent_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @return {CurrentPaceComponentState}
     */
    state(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = new CurrentPaceComponentState(liveSplitCoreNative.CurrentPaceComponent_state(this.ptr, timer.ptr));
        return result;
    }
}
exports.CurrentPaceComponentRefMut = CurrentPaceComponentRefMut;

class CurrentPaceComponent extends CurrentPaceComponentRefMut {
    /**
     * @param {function(CurrentPaceComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.CurrentPaceComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {CurrentPaceComponent}
     */
    static new() {
        const result = new CurrentPaceComponent(liveSplitCoreNative.CurrentPaceComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.CurrentPaceComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.CurrentPaceComponent = CurrentPaceComponent;

class CurrentPaceComponentStateRef {
    /**
     * @return {string}
     */
    text() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.CurrentPaceComponentState_text(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.CurrentPaceComponentState_time(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.CurrentPaceComponentStateRef = CurrentPaceComponentStateRef;

class CurrentPaceComponentStateRefMut extends CurrentPaceComponentStateRef {
}
exports.CurrentPaceComponentStateRefMut = CurrentPaceComponentStateRefMut;

class CurrentPaceComponentState extends CurrentPaceComponentStateRefMut {
    /**
     * @param {function(CurrentPaceComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.CurrentPaceComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.CurrentPaceComponentState = CurrentPaceComponentState;

class DeltaComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.DeltaComponentRef = DeltaComponentRef;

class DeltaComponentRefMut extends DeltaComponentRef {
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {any}
     */
    stateAsJson(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = liveSplitCoreNative.DeltaComponent_state_as_json(this.ptr, timer.ptr, layoutSettings.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {DeltaComponentState}
     */
    state(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = new DeltaComponentState(liveSplitCoreNative.DeltaComponent_state(this.ptr, timer.ptr, layoutSettings.ptr));
        return result;
    }
}
exports.DeltaComponentRefMut = DeltaComponentRefMut;

class DeltaComponent extends DeltaComponentRefMut {
    /**
     * @param {function(DeltaComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.DeltaComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {DeltaComponent}
     */
    static new() {
        const result = new DeltaComponent(liveSplitCoreNative.DeltaComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.DeltaComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.DeltaComponent = DeltaComponent;

class DeltaComponentStateRef {
    /**
     * @return {string}
     */
    text() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DeltaComponentState_text(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DeltaComponentState_time(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    semanticColor() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DeltaComponentState_semantic_color(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.DeltaComponentStateRef = DeltaComponentStateRef;

class DeltaComponentStateRefMut extends DeltaComponentStateRef {
}
exports.DeltaComponentStateRefMut = DeltaComponentStateRefMut;

class DeltaComponentState extends DeltaComponentStateRefMut {
    /**
     * @param {function(DeltaComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.DeltaComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.DeltaComponentState = DeltaComponentState;

class DetailedTimerComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.DetailedTimerComponentRef = DetailedTimerComponentRef;

class DetailedTimerComponentRefMut extends DetailedTimerComponentRef {
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {any}
     */
    stateAsJson(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponent_state_as_json(this.ptr, timer.ptr, layoutSettings.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {DetailedTimerComponentState}
     */
    state(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = new DetailedTimerComponentState(liveSplitCoreNative.DetailedTimerComponent_state(this.ptr, timer.ptr, layoutSettings.ptr));
        return result;
    }
}
exports.DetailedTimerComponentRefMut = DetailedTimerComponentRefMut;

class DetailedTimerComponent extends DetailedTimerComponentRefMut {
    /**
     * @param {function(DetailedTimerComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.DetailedTimerComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {DetailedTimerComponent}
     */
    static new() {
        const result = new DetailedTimerComponent(liveSplitCoreNative.DetailedTimerComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.DetailedTimerComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.DetailedTimerComponent = DetailedTimerComponent;

class DetailedTimerComponentStateRef {
    /**
     * @return {string}
     */
    timerTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_timer_time(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    timerFraction() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_timer_fraction(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    timerSemanticColor() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_timer_semantic_color(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    segmentTimerTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_segment_timer_time(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    segmentTimerFraction() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_segment_timer_fraction(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    comparison1Visible() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_comparison1_visible(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    comparison1Name() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_comparison1_name(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    comparison1Time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_comparison1_time(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    comparison2Visible() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_comparison2_visible(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    comparison2Name() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_comparison2_name(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    comparison2Time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_comparison2_time(this.ptr);
        return result;
    }
    /**
     * @return {string | null}
     */
    iconChange() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_icon_change(this.ptr);
        return result;
    }
    /**
     * @return {string | null}
     */
    name() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.DetailedTimerComponentState_name(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.DetailedTimerComponentStateRef = DetailedTimerComponentStateRef;

class DetailedTimerComponentStateRefMut extends DetailedTimerComponentStateRef {
}
exports.DetailedTimerComponentStateRefMut = DetailedTimerComponentStateRefMut;

class DetailedTimerComponentState extends DetailedTimerComponentStateRefMut {
    /**
     * @param {function(DetailedTimerComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.DetailedTimerComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.DetailedTimerComponentState = DetailedTimerComponentState;

class GeneralLayoutSettingsRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.GeneralLayoutSettingsRef = GeneralLayoutSettingsRef;

class GeneralLayoutSettingsRefMut extends GeneralLayoutSettingsRef {
}
exports.GeneralLayoutSettingsRefMut = GeneralLayoutSettingsRefMut;

class GeneralLayoutSettings extends GeneralLayoutSettingsRefMut {
    /**
     * @param {function(GeneralLayoutSettings)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.GeneralLayoutSettings_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {GeneralLayoutSettings}
     */
    static default() {
        const result = new GeneralLayoutSettings(liveSplitCoreNative.GeneralLayoutSettings_default());
        return result;
    }
}
exports.GeneralLayoutSettings = GeneralLayoutSettings;

class GraphComponentRef {
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {any}
     */
    stateAsJson(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = liveSplitCoreNative.GraphComponent_state_as_json(this.ptr, timer.ptr, layoutSettings.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {GraphComponentState}
     */
    state(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = new GraphComponentState(liveSplitCoreNative.GraphComponent_state(this.ptr, timer.ptr, layoutSettings.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.GraphComponentRef = GraphComponentRef;

class GraphComponentRefMut extends GraphComponentRef {
}
exports.GraphComponentRefMut = GraphComponentRefMut;

class GraphComponent extends GraphComponentRefMut {
    /**
     * @param {function(GraphComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.GraphComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {GraphComponent}
     */
    static new() {
        const result = new GraphComponent(liveSplitCoreNative.GraphComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.GraphComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.GraphComponent = GraphComponent;

class GraphComponentStateRef {
    /**
     * @return {number}
     */
    pointsLen() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_points_len(this.ptr);
        return result;
    }
    /**
     * @param {number} index
     * @return {number}
     */
    pointX(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_point_x(this.ptr, index);
        return result;
    }
    /**
     * @param {number} index
     * @return {number}
     */
    pointY(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_point_y(this.ptr, index);
        return result;
    }
    /**
     * @param {number} index
     * @return {boolean}
     */
    pointIsBestSegment(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_point_is_best_segment(this.ptr, index);
        return result;
    }
    /**
     * @return {number}
     */
    horizontalGridLinesLen() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_horizontal_grid_lines_len(this.ptr);
        return result;
    }
    /**
     * @param {number} index
     * @return {number}
     */
    horizontalGridLine(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_horizontal_grid_line(this.ptr, index);
        return result;
    }
    /**
     * @return {number}
     */
    verticalGridLinesLen() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_vertical_grid_lines_len(this.ptr);
        return result;
    }
    /**
     * @param {number} index
     * @return {number}
     */
    verticalGridLine(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_vertical_grid_line(this.ptr, index);
        return result;
    }
    /**
     * @return {number}
     */
    middle() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_middle(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    isLiveDeltaActive() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_is_live_delta_active(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    isFlipped() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.GraphComponentState_is_flipped(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.GraphComponentStateRef = GraphComponentStateRef;

class GraphComponentStateRefMut extends GraphComponentStateRef {
}
exports.GraphComponentStateRefMut = GraphComponentStateRefMut;

class GraphComponentState extends GraphComponentStateRefMut {
    /**
     * @param {function(GraphComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.GraphComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.GraphComponentState = GraphComponentState;

class HotkeySystemRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.HotkeySystemRef = HotkeySystemRef;

class HotkeySystemRefMut extends HotkeySystemRef {
}
exports.HotkeySystemRefMut = HotkeySystemRefMut;

class HotkeySystem extends HotkeySystemRefMut {
    /**
     * @param {function(HotkeySystem)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.HotkeySystem_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @param {SharedTimer} sharedTimer
     * @return {HotkeySystem | null}
     */
    static new(sharedTimer) {
        if (ref.isNull(sharedTimer.ptr)) {
            throw "sharedTimer is disposed";
        }
        const result = new HotkeySystem(liveSplitCoreNative.HotkeySystem_new(sharedTimer.ptr));
        sharedTimer.ptr = ref.NULL;
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
}
exports.HotkeySystem = HotkeySystem;

class LayoutRef {
    /**
     * @return {Layout}
     */
    clone() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Layout(liveSplitCoreNative.Layout_clone(this.ptr));
        return result;
    }
    /**
     * @return {any}
     */
    settingsAsJson() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Layout_settings_as_json(this.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.LayoutRef = LayoutRef;

class LayoutRefMut extends LayoutRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    stateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.Layout_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {Component} component
     */
    push(component) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(component.ptr)) {
            throw "component is disposed";
        }
        liveSplitCoreNative.Layout_push(this.ptr, component.ptr);
        component.ptr = ref.NULL;
    }
    /**
     */
    scrollUp() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Layout_scroll_up(this.ptr);
    }
    /**
     */
    scrollDown() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Layout_scroll_down(this.ptr);
    }
    /**
     */
    remount() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Layout_remount(this.ptr);
    }
}
exports.LayoutRefMut = LayoutRefMut;

class Layout extends LayoutRefMut {
    /**
     * @param {function(Layout)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.Layout_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {Layout}
     */
    static new() {
        const result = new Layout(liveSplitCoreNative.Layout_new());
        return result;
    }
    /**
     * @return {Layout}
     */
    static defaultLayout() {
        const result = new Layout(liveSplitCoreNative.Layout_default_layout());
        return result;
    }
    /**
     * @param {any} settings
     * @return {Layout | null}
     */
    static parseJson(settings) {
        const result = new Layout(liveSplitCoreNative.Layout_parse_json(JSON.stringify(settings)));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
}
exports.Layout = Layout;

class LayoutEditorRef {
    /**
     * @return {any}
     */
    stateAsJson() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.LayoutEditor_state_as_json(this.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.LayoutEditorRef = LayoutEditorRef;

class LayoutEditorRefMut extends LayoutEditorRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    layoutStateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.LayoutEditor_layout_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {number} index
     */
    select(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.LayoutEditor_select(this.ptr, index);
    }
    /**
     * @param {Component} component
     */
    addComponent(component) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(component.ptr)) {
            throw "component is disposed";
        }
        liveSplitCoreNative.LayoutEditor_add_component(this.ptr, component.ptr);
        component.ptr = ref.NULL;
    }
    /**
     */
    removeComponent() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.LayoutEditor_remove_component(this.ptr);
    }
    /**
     */
    moveComponentUp() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.LayoutEditor_move_component_up(this.ptr);
    }
    /**
     */
    moveComponentDown() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.LayoutEditor_move_component_down(this.ptr);
    }
    /**
     * @param {number} dstIndex
     */
    moveComponent(dstIndex) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.LayoutEditor_move_component(this.ptr, dstIndex);
    }
    /**
     */
    duplicateComponent() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.LayoutEditor_duplicate_component(this.ptr);
    }
    /**
     * @param {number} index
     * @param {SettingValue} value
     */
    setComponentSettingsValue(index, value) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(value.ptr)) {
            throw "value is disposed";
        }
        liveSplitCoreNative.LayoutEditor_set_component_settings_value(this.ptr, index, value.ptr);
        value.ptr = ref.NULL;
    }
    /**
     * @param {number} index
     * @param {SettingValue} value
     */
    setGeneralSettingsValue(index, value) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(value.ptr)) {
            throw "value is disposed";
        }
        liveSplitCoreNative.LayoutEditor_set_general_settings_value(this.ptr, index, value.ptr);
        value.ptr = ref.NULL;
    }
}
exports.LayoutEditorRefMut = LayoutEditorRefMut;

class LayoutEditor extends LayoutEditorRefMut {
    /**
     * @param {function(LayoutEditor)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            this.ptr = ref.NULL;
        }
    }
    /**
     * @param {Layout} layout
     * @return {LayoutEditor | null}
     */
    static new(layout) {
        if (ref.isNull(layout.ptr)) {
            throw "layout is disposed";
        }
        const result = new LayoutEditor(liveSplitCoreNative.LayoutEditor_new(layout.ptr));
        layout.ptr = ref.NULL;
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @return {Layout}
     */
    close() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Layout(liveSplitCoreNative.LayoutEditor_close(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.LayoutEditor = LayoutEditor;

class ParseRunResultRef {
    /**
     * @return {boolean}
     */
    parsedSuccessfully() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.ParseRunResult_parsed_successfully(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    timerKind() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.ParseRunResult_timer_kind(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.ParseRunResultRef = ParseRunResultRef;

class ParseRunResultRefMut extends ParseRunResultRef {
}
exports.ParseRunResultRefMut = ParseRunResultRefMut;

class ParseRunResult extends ParseRunResultRefMut {
    /**
     * @param {function(ParseRunResult)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.ParseRunResult_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {Run}
     */
    unwrap() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Run(liveSplitCoreNative.ParseRunResult_unwrap(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.ParseRunResult = ParseRunResult;

class PossibleTimeSaveComponentRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    stateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.PossibleTimeSaveComponent_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @return {PossibleTimeSaveComponentState}
     */
    state(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = new PossibleTimeSaveComponentState(liveSplitCoreNative.PossibleTimeSaveComponent_state(this.ptr, timer.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.PossibleTimeSaveComponentRef = PossibleTimeSaveComponentRef;

class PossibleTimeSaveComponentRefMut extends PossibleTimeSaveComponentRef {
}
exports.PossibleTimeSaveComponentRefMut = PossibleTimeSaveComponentRefMut;

class PossibleTimeSaveComponent extends PossibleTimeSaveComponentRefMut {
    /**
     * @param {function(PossibleTimeSaveComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.PossibleTimeSaveComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {PossibleTimeSaveComponent}
     */
    static new() {
        const result = new PossibleTimeSaveComponent(liveSplitCoreNative.PossibleTimeSaveComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.PossibleTimeSaveComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.PossibleTimeSaveComponent = PossibleTimeSaveComponent;

class PossibleTimeSaveComponentStateRef {
    /**
     * @return {string}
     */
    text() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.PossibleTimeSaveComponentState_text(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.PossibleTimeSaveComponentState_time(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.PossibleTimeSaveComponentStateRef = PossibleTimeSaveComponentStateRef;

class PossibleTimeSaveComponentStateRefMut extends PossibleTimeSaveComponentStateRef {
}
exports.PossibleTimeSaveComponentStateRefMut = PossibleTimeSaveComponentStateRefMut;

class PossibleTimeSaveComponentState extends PossibleTimeSaveComponentStateRefMut {
    /**
     * @param {function(PossibleTimeSaveComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.PossibleTimeSaveComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.PossibleTimeSaveComponentState = PossibleTimeSaveComponentState;

class PotentialCleanUpRef {
    /**
     * @return {string}
     */
    message() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.PotentialCleanUp_message(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.PotentialCleanUpRef = PotentialCleanUpRef;

class PotentialCleanUpRefMut extends PotentialCleanUpRef {
}
exports.PotentialCleanUpRefMut = PotentialCleanUpRefMut;

class PotentialCleanUp extends PotentialCleanUpRefMut {
    /**
     * @param {function(PotentialCleanUp)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.PotentialCleanUp_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.PotentialCleanUp = PotentialCleanUp;

class PreviousSegmentComponentRef {
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {any}
     */
    stateAsJson(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = liveSplitCoreNative.PreviousSegmentComponent_state_as_json(this.ptr, timer.ptr, layoutSettings.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {PreviousSegmentComponentState}
     */
    state(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = new PreviousSegmentComponentState(liveSplitCoreNative.PreviousSegmentComponent_state(this.ptr, timer.ptr, layoutSettings.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.PreviousSegmentComponentRef = PreviousSegmentComponentRef;

class PreviousSegmentComponentRefMut extends PreviousSegmentComponentRef {
}
exports.PreviousSegmentComponentRefMut = PreviousSegmentComponentRefMut;

class PreviousSegmentComponent extends PreviousSegmentComponentRefMut {
    /**
     * @param {function(PreviousSegmentComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.PreviousSegmentComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {PreviousSegmentComponent}
     */
    static new() {
        const result = new PreviousSegmentComponent(liveSplitCoreNative.PreviousSegmentComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.PreviousSegmentComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.PreviousSegmentComponent = PreviousSegmentComponent;

class PreviousSegmentComponentStateRef {
    /**
     * @return {string}
     */
    text() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.PreviousSegmentComponentState_text(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.PreviousSegmentComponentState_time(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    semanticColor() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.PreviousSegmentComponentState_semantic_color(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.PreviousSegmentComponentStateRef = PreviousSegmentComponentStateRef;

class PreviousSegmentComponentStateRefMut extends PreviousSegmentComponentStateRef {
}
exports.PreviousSegmentComponentStateRefMut = PreviousSegmentComponentStateRefMut;

class PreviousSegmentComponentState extends PreviousSegmentComponentStateRefMut {
    /**
     * @param {function(PreviousSegmentComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.PreviousSegmentComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.PreviousSegmentComponentState = PreviousSegmentComponentState;

class RunRef {
    /**
     * @return {Run}
     */
    clone() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Run(liveSplitCoreNative.Run_clone(this.ptr));
        return result;
    }
    /**
     * @return {string}
     */
    gameName() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_game_name(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    gameIcon() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_game_icon(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    categoryName() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_category_name(this.ptr);
        return result;
    }
    /**
     * @param {boolean} useExtendedCategoryName
     * @return {string}
     */
    extendedFileName(useExtendedCategoryName) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_extended_file_name(this.ptr, useExtendedCategoryName);
        return result;
    }
    /**
     * @param {boolean} useExtendedCategoryName
     * @return {string}
     */
    extendedName(useExtendedCategoryName) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_extended_name(this.ptr, useExtendedCategoryName);
        return result;
    }
    /**
     * @param {boolean} showRegion
     * @param {boolean} showPlatform
     * @param {boolean} showVariables
     * @return {string}
     */
    extendedCategoryName(showRegion, showPlatform, showVariables) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_extended_category_name(this.ptr, showRegion, showPlatform, showVariables);
        return result;
    }
    /**
     * @return {number}
     */
    attemptCount() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_attempt_count(this.ptr);
        return result;
    }
    /**
     * @return {RunMetadataRef}
     */
    metadata() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new RunMetadataRef(liveSplitCoreNative.Run_metadata(this.ptr));
        return result;
    }
    /**
     * @return {TimeSpanRef}
     */
    offset() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeSpanRef(liveSplitCoreNative.Run_offset(this.ptr));
        return result;
    }
    /**
     * @return {number}
     */
    len() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_len(this.ptr);
        return result;
    }
    /**
     * @param {number} index
     * @return {SegmentRef}
     */
    segment(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new SegmentRef(liveSplitCoreNative.Run_segment(this.ptr, index));
        return result;
    }
    /**
     * @return {number}
     */
    attemptHistoryLen() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_attempt_history_len(this.ptr);
        return result;
    }
    /**
     * @param {number} index
     * @return {AttemptRef}
     */
    attemptHistoryIndex(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new AttemptRef(liveSplitCoreNative.Run_attempt_history_index(this.ptr, index));
        return result;
    }
    /**
     * @return {string}
     */
    saveAsLss() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_save_as_lss(this.ptr);
        return result;
    }
    /**
     * @return {number}
     */
    customComparisonsLen() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_custom_comparisons_len(this.ptr);
        return result;
    }
    /**
     * @param {number} index
     * @return {string}
     */
    customComparison(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_custom_comparison(this.ptr, index);
        return result;
    }
    /**
     * @return {string}
     */
    autoSplitterSettings() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Run_auto_splitter_settings(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.RunRef = RunRef;

class RunRefMut extends RunRef {
    /**
     * @param {Segment} segment
     */
    pushSegment(segment) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(segment.ptr)) {
            throw "segment is disposed";
        }
        liveSplitCoreNative.Run_push_segment(this.ptr, segment.ptr);
        segment.ptr = ref.NULL;
    }
    /**
     * @param {string} game
     */
    setGameName(game) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Run_set_game_name(this.ptr, game);
    }
    /**
     * @param {string} category
     */
    setCategoryName(category) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Run_set_category_name(this.ptr, category);
    }
}
exports.RunRefMut = RunRefMut;

class Run extends RunRefMut {
    /**
     * @param {function(Run)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.Run_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {Run}
     */
    static new() {
        const result = new Run(liveSplitCoreNative.Run_new());
        return result;
    }
    /**
     * @param {Buffer} data
     * @param {number} length
     * @param {string} path
     * @param {boolean} loadFiles
     * @return {ParseRunResult}
     */
    static parse(data, length, path, loadFiles) {
        const result = new ParseRunResult(liveSplitCoreNative.Run_parse(data, length, path, loadFiles));
        return result;
    }
    /**
     * @param {number} handle
     * @param {string} path
     * @param {boolean} loadFiles
     * @return {ParseRunResult}
     */
    static parseFileHandle(handle, path, loadFiles) {
        const result = new ParseRunResult(liveSplitCoreNative.Run_parse_file_handle(handle, path, loadFiles));
        return result;
    }
    /**
     * @param {Int8Array} data
     * @param {string} path
     * @param {boolean} loadFiles
     * @return {ParseRunResult}
     */
    static parseArray(data, path, loadFiles) {
        let buf = Buffer.from(data.buffer);
        if (data.byteLength !== data.buffer.byteLength) {
            buf = buf.slice(data.byteOffset, data.byteOffset + data.byteLength);
        }
        return Run.parse(buf, buf.byteLength, path, loadFiles);
    }
    /**
     * @param {string | Buffer | number} file
     * @param {string} path
     * @param {boolean} loadFiles
     * @return {ParseRunResult}
     */
    static parseFile(file, path, loadFiles) {
        const data = fs.readFileSync(file);
        return Run.parse(data, data.byteLength, path, loadFiles);
    }
    /**
     * @param {string} text
     * @param {string} path
     * @param {boolean} loadFiles
     * @return {ParseRunResult}
     */
    static parseString(text, path, loadFiles) {
        const data = new Buffer(text);
        return Run.parse(data, data.byteLength, path, loadFiles);
    }
}
exports.Run = Run;

class RunEditorRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.RunEditorRef = RunEditorRef;

class RunEditorRefMut extends RunEditorRef {
    /**
     * @return {any}
     */
    stateAsJson() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_state_as_json(this.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {number} method
     */
    selectTimingMethod(method) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_select_timing_method(this.ptr, method);
    }
    /**
     * @param {number} index
     */
    unselect(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_unselect(this.ptr, index);
    }
    /**
     * @param {number} index
     */
    selectAdditionally(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_select_additionally(this.ptr, index);
    }
    /**
     * @param {number} index
     */
    selectOnly(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_select_only(this.ptr, index);
    }
    /**
     * @param {string} game
     */
    setGameName(game) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_set_game_name(this.ptr, game);
    }
    /**
     * @param {string} category
     */
    setCategoryName(category) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_set_category_name(this.ptr, category);
    }
    /**
     * @param {string} offset
     * @return {boolean}
     */
    parseAndSetOffset(offset) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_parse_and_set_offset(this.ptr, offset);
        return result;
    }
    /**
     * @param {string} attempts
     * @return {boolean}
     */
    parseAndSetAttemptCount(attempts) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_parse_and_set_attempt_count(this.ptr, attempts);
        return result;
    }
    /**
     * @param {Buffer} data
     * @param {number} length
     */
    setGameIcon(data, length) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_set_game_icon(this.ptr, data, length);
    }
    /**
     */
    removeGameIcon() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_remove_game_icon(this.ptr);
    }
    /**
     */
    insertSegmentAbove() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_insert_segment_above(this.ptr);
    }
    /**
     */
    insertSegmentBelow() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_insert_segment_below(this.ptr);
    }
    /**
     */
    removeSegments() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_remove_segments(this.ptr);
    }
    /**
     */
    moveSegmentsUp() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_move_segments_up(this.ptr);
    }
    /**
     */
    moveSegmentsDown() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_move_segments_down(this.ptr);
    }
    /**
     * @param {Buffer} data
     * @param {number} length
     */
    selectedSetIcon(data, length) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_selected_set_icon(this.ptr, data, length);
    }
    /**
     */
    selectedRemoveIcon() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_selected_remove_icon(this.ptr);
    }
    /**
     * @param {string} name
     */
    selectedSetName(name) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_selected_set_name(this.ptr, name);
    }
    /**
     * @param {string} time
     * @return {boolean}
     */
    selectedParseAndSetSplitTime(time) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_selected_parse_and_set_split_time(this.ptr, time);
        return result;
    }
    /**
     * @param {string} time
     * @return {boolean}
     */
    selectedParseAndSetSegmentTime(time) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_selected_parse_and_set_segment_time(this.ptr, time);
        return result;
    }
    /**
     * @param {string} time
     * @return {boolean}
     */
    selectedParseAndSetBestSegmentTime(time) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_selected_parse_and_set_best_segment_time(this.ptr, time);
        return result;
    }
    /**
     * @param {string} comparison
     * @param {string} time
     * @return {boolean}
     */
    selectedParseAndSetComparisonTime(comparison, time) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_selected_parse_and_set_comparison_time(this.ptr, comparison, time);
        return result;
    }
    /**
     * @param {string} comparison
     * @return {boolean}
     */
    addComparison(comparison) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_add_comparison(this.ptr, comparison);
        return result;
    }
    /**
     * @param {RunRef} run
     * @param {string} comparison
     * @return {boolean}
     */
    importComparison(run, comparison) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(run.ptr)) {
            throw "run is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_import_comparison(this.ptr, run.ptr, comparison);
        return result;
    }
    /**
     * @param {string} comparison
     */
    removeComparison(comparison) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_remove_comparison(this.ptr, comparison);
    }
    /**
     * @param {string} oldName
     * @param {string} newName
     * @return {boolean}
     */
    renameComparison(oldName, newName) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunEditor_rename_comparison(this.ptr, oldName, newName);
        return result;
    }
    /**
     */
    clearHistory() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_clear_history(this.ptr);
    }
    /**
     */
    clearTimes() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.RunEditor_clear_times(this.ptr);
    }
    /**
     * @return {SumOfBestCleaner}
     */
    cleanSumOfBest() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new SumOfBestCleaner(liveSplitCoreNative.RunEditor_clean_sum_of_best(this.ptr));
        return result;
    }
    /**
     * @param {Int8Array} data
     */
    setGameIconFromArray(data) {
        let buf = Buffer.from(data.buffer);
        if (data.byteLength !== data.buffer.byteLength) {
            buf = buf.slice(data.byteOffset, data.byteOffset + data.byteLength);
        }
        this.setGameIcon(buf, buf.byteLength);
    }
    /**
     * @param {Int8Array} data
     */
    selectedSetIconFromArray(data) {
        let buf = Buffer.from(data.buffer);
        if (data.byteLength !== data.buffer.byteLength) {
            buf = buf.slice(data.byteOffset, data.byteOffset + data.byteLength);
        }
        this.selectedSetIconFromArray(buf, buf.byteLength);
    }
}
exports.RunEditorRefMut = RunEditorRefMut;

class RunEditor extends RunEditorRefMut {
    /**
     * @param {function(RunEditor)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            this.ptr = ref.NULL;
        }
    }
    /**
     * @param {Run} run
     * @return {RunEditor | null}
     */
    static new(run) {
        if (ref.isNull(run.ptr)) {
            throw "run is disposed";
        }
        const result = new RunEditor(liveSplitCoreNative.RunEditor_new(run.ptr));
        run.ptr = ref.NULL;
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @return {Run}
     */
    close() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Run(liveSplitCoreNative.RunEditor_close(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.RunEditor = RunEditor;

class RunMetadataRef {
    /**
     * @return {string}
     */
    runId() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunMetadata_run_id(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    platformName() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunMetadata_platform_name(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    usesEmulator() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunMetadata_uses_emulator(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    regionName() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunMetadata_region_name(this.ptr);
        return result;
    }
    /**
     * @return {RunMetadataVariablesIter}
     */
    variables() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new RunMetadataVariablesIter(liveSplitCoreNative.RunMetadata_variables(this.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.RunMetadataRef = RunMetadataRef;

class RunMetadataRefMut extends RunMetadataRef {
}
exports.RunMetadataRefMut = RunMetadataRefMut;

class RunMetadata extends RunMetadataRefMut {
    /**
     * @param {function(RunMetadata)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            this.ptr = ref.NULL;
        }
    }
}
exports.RunMetadata = RunMetadata;

class RunMetadataVariableRef {
    /**
     * @return {string}
     */
    name() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunMetadataVariable_name(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    value() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.RunMetadataVariable_value(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.RunMetadataVariableRef = RunMetadataVariableRef;

class RunMetadataVariableRefMut extends RunMetadataVariableRef {
}
exports.RunMetadataVariableRefMut = RunMetadataVariableRefMut;

class RunMetadataVariable extends RunMetadataVariableRefMut {
    /**
     * @param {function(RunMetadataVariable)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.RunMetadataVariable_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.RunMetadataVariable = RunMetadataVariable;

class RunMetadataVariablesIterRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.RunMetadataVariablesIterRef = RunMetadataVariablesIterRef;

class RunMetadataVariablesIterRefMut extends RunMetadataVariablesIterRef {
    /**
     * @return {RunMetadataVariableRef | null}
     */
    next() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new RunMetadataVariableRef(liveSplitCoreNative.RunMetadataVariablesIter_next(this.ptr));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
}
exports.RunMetadataVariablesIterRefMut = RunMetadataVariablesIterRefMut;

class RunMetadataVariablesIter extends RunMetadataVariablesIterRefMut {
    /**
     * @param {function(RunMetadataVariablesIter)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.RunMetadataVariablesIter_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.RunMetadataVariablesIter = RunMetadataVariablesIter;

class SegmentRef {
    /**
     * @return {string}
     */
    name() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Segment_name(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    icon() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Segment_icon(this.ptr);
        return result;
    }
    /**
     * @param {string} comparison
     * @return {TimeRef}
     */
    comparison(comparison) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeRef(liveSplitCoreNative.Segment_comparison(this.ptr, comparison));
        return result;
    }
    /**
     * @return {TimeRef}
     */
    personalBestSplitTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeRef(liveSplitCoreNative.Segment_personal_best_split_time(this.ptr));
        return result;
    }
    /**
     * @return {TimeRef}
     */
    bestSegmentTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeRef(liveSplitCoreNative.Segment_best_segment_time(this.ptr));
        return result;
    }
    /**
     * @return {SegmentHistoryRef}
     */
    segmentHistory() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new SegmentHistoryRef(liveSplitCoreNative.Segment_segment_history(this.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SegmentRef = SegmentRef;

class SegmentRefMut extends SegmentRef {
}
exports.SegmentRefMut = SegmentRefMut;

class Segment extends SegmentRefMut {
    /**
     * @param {function(Segment)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.Segment_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @param {string} name
     * @return {Segment}
     */
    static new(name) {
        const result = new Segment(liveSplitCoreNative.Segment_new(name));
        return result;
    }
}
exports.Segment = Segment;

class SegmentHistoryRef {
    /**
     * @return {SegmentHistoryIter}
     */
    iter() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new SegmentHistoryIter(liveSplitCoreNative.SegmentHistory_iter(this.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SegmentHistoryRef = SegmentHistoryRef;

class SegmentHistoryRefMut extends SegmentHistoryRef {
}
exports.SegmentHistoryRefMut = SegmentHistoryRefMut;

class SegmentHistory extends SegmentHistoryRefMut {
    /**
     * @param {function(SegmentHistory)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            this.ptr = ref.NULL;
        }
    }
}
exports.SegmentHistory = SegmentHistory;

class SegmentHistoryElementRef {
    /**
     * @return {number}
     */
    index() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SegmentHistoryElement_index(this.ptr);
        return result;
    }
    /**
     * @return {TimeRef}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeRef(liveSplitCoreNative.SegmentHistoryElement_time(this.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SegmentHistoryElementRef = SegmentHistoryElementRef;

class SegmentHistoryElementRefMut extends SegmentHistoryElementRef {
}
exports.SegmentHistoryElementRefMut = SegmentHistoryElementRefMut;

class SegmentHistoryElement extends SegmentHistoryElementRefMut {
    /**
     * @param {function(SegmentHistoryElement)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            this.ptr = ref.NULL;
        }
    }
}
exports.SegmentHistoryElement = SegmentHistoryElement;

class SegmentHistoryIterRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SegmentHistoryIterRef = SegmentHistoryIterRef;

class SegmentHistoryIterRefMut extends SegmentHistoryIterRef {
    /**
     * @return {SegmentHistoryElementRef | null}
     */
    next() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new SegmentHistoryElementRef(liveSplitCoreNative.SegmentHistoryIter_next(this.ptr));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
}
exports.SegmentHistoryIterRefMut = SegmentHistoryIterRefMut;

class SegmentHistoryIter extends SegmentHistoryIterRefMut {
    /**
     * @param {function(SegmentHistoryIter)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SegmentHistoryIter_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.SegmentHistoryIter = SegmentHistoryIter;

class SeparatorComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SeparatorComponentRef = SeparatorComponentRef;

class SeparatorComponentRefMut extends SeparatorComponentRef {
}
exports.SeparatorComponentRefMut = SeparatorComponentRefMut;

class SeparatorComponent extends SeparatorComponentRefMut {
    /**
     * @param {function(SeparatorComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SeparatorComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {SeparatorComponent}
     */
    static new() {
        const result = new SeparatorComponent(liveSplitCoreNative.SeparatorComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.SeparatorComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.SeparatorComponent = SeparatorComponent;

class SettingValueRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SettingValueRef = SettingValueRef;

class SettingValueRefMut extends SettingValueRef {
}
exports.SettingValueRefMut = SettingValueRefMut;

class SettingValue extends SettingValueRefMut {
    /**
     * @param {function(SettingValue)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SettingValue_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @param {boolean} value
     * @return {SettingValue}
     */
    static fromBool(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_bool(value));
        return result;
    }
    /**
     * @param {number} value
     * @return {SettingValue}
     */
    static fromUint(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_uint(value));
        return result;
    }
    /**
     * @param {number} value
     * @return {SettingValue}
     */
    static fromInt(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_int(value));
        return result;
    }
    /**
     * @param {string} value
     * @return {SettingValue}
     */
    static fromString(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_string(value));
        return result;
    }
    /**
     * @param {string} value
     * @return {SettingValue}
     */
    static fromOptionalString(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_optional_string(value));
        return result;
    }
    /**
     * @return {SettingValue}
     */
    static fromOptionalEmptyString() {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_optional_empty_string());
        return result;
    }
    /**
     * @param {number} value
     * @return {SettingValue}
     */
    static fromFloat(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_float(value));
        return result;
    }
    /**
     * @param {string} value
     * @return {SettingValue | null}
     */
    static fromAccuracy(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_accuracy(value));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @param {string} value
     * @return {SettingValue | null}
     */
    static fromDigitsFormat(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_digits_format(value));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @param {string} value
     * @return {SettingValue | null}
     */
    static fromOptionalTimingMethod(value) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_optional_timing_method(value));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @return {SettingValue}
     */
    static fromOptionalEmptyTimingMethod() {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_optional_empty_timing_method());
        return result;
    }
    /**
     * @param {number} r
     * @param {number} g
     * @param {number} b
     * @param {number} a
     * @return {SettingValue}
     */
    static fromColor(r, g, b, a) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_color(r, g, b, a));
        return result;
    }
    /**
     * @param {number} r
     * @param {number} g
     * @param {number} b
     * @param {number} a
     * @return {SettingValue}
     */
    static fromOptionalColor(r, g, b, a) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_optional_color(r, g, b, a));
        return result;
    }
    /**
     * @return {SettingValue}
     */
    static fromOptionalEmptyColor() {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_optional_empty_color());
        return result;
    }
    /**
     * @return {SettingValue}
     */
    static fromTransparentGradient() {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_transparent_gradient());
        return result;
    }
    /**
     * @param {number} r1
     * @param {number} g1
     * @param {number} b1
     * @param {number} a1
     * @param {number} r2
     * @param {number} g2
     * @param {number} b2
     * @param {number} a2
     * @return {SettingValue}
     */
    static fromVerticalGradient(r1, g1, b1, a1, r2, g2, b2, a2) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_vertical_gradient(r1, g1, b1, a1, r2, g2, b2, a2));
        return result;
    }
    /**
     * @param {number} r1
     * @param {number} g1
     * @param {number} b1
     * @param {number} a1
     * @param {number} r2
     * @param {number} g2
     * @param {number} b2
     * @param {number} a2
     * @return {SettingValue}
     */
    static fromHorizontalGradient(r1, g1, b1, a1, r2, g2, b2, a2) {
        const result = new SettingValue(liveSplitCoreNative.SettingValue_from_horizontal_gradient(r1, g1, b1, a1, r2, g2, b2, a2));
        return result;
    }
}
exports.SettingValue = SettingValue;

class SharedTimerRef {
    /**
     * @return {SharedTimer}
     */
    share() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new SharedTimer(liveSplitCoreNative.SharedTimer_share(this.ptr));
        return result;
    }
    /**
     * @return {TimerReadLock}
     */
    read() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimerReadLock(liveSplitCoreNative.SharedTimer_read(this.ptr));
        return result;
    }
    /**
     * @return {TimerWriteLock}
     */
    write() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimerWriteLock(liveSplitCoreNative.SharedTimer_write(this.ptr));
        return result;
    }
    /**
     * @param {Timer} timer
     */
    replaceInner(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        liveSplitCoreNative.SharedTimer_replace_inner(this.ptr, timer.ptr);
        timer.ptr = ref.NULL;
    }
    /**
     * @param {function(TimerRef)} action
     */
    readWith(action) {
        return this.read().with(function (lock) {
            return action(lock.timer());
        });
    }
    /**
     * @param {function(TimerRefMut)} action
     */
    writeWith(action) {
        return this.write().with(function (lock) {
            return action(lock.timer());
        });
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SharedTimerRef = SharedTimerRef;

class SharedTimerRefMut extends SharedTimerRef {
}
exports.SharedTimerRefMut = SharedTimerRefMut;

class SharedTimer extends SharedTimerRefMut {
    /**
     * @param {function(SharedTimer)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SharedTimer_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.SharedTimer = SharedTimer;

class SplitsComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SplitsComponentRef = SplitsComponentRef;

class SplitsComponentRefMut extends SplitsComponentRef {
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {any}
     */
    stateAsJson(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponent_state_as_json(this.ptr, timer.ptr, layoutSettings.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {SplitsComponentState}
     */
    state(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = new SplitsComponentState(liveSplitCoreNative.SplitsComponent_state(this.ptr, timer.ptr, layoutSettings.ptr));
        return result;
    }
    /**
     */
    scrollUp() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.SplitsComponent_scroll_up(this.ptr);
    }
    /**
     */
    scrollDown() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.SplitsComponent_scroll_down(this.ptr);
    }
    /**
     * @param {number} count
     */
    setVisualSplitCount(count) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.SplitsComponent_set_visual_split_count(this.ptr, count);
    }
    /**
     * @param {number} count
     */
    setSplitPreviewCount(count) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.SplitsComponent_set_split_preview_count(this.ptr, count);
    }
    /**
     * @param {boolean} alwaysShowLastSplit
     */
    setAlwaysShowLastSplit(alwaysShowLastSplit) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.SplitsComponent_set_always_show_last_split(this.ptr, alwaysShowLastSplit);
    }
    /**
     * @param {boolean} separatorLastSplit
     */
    setSeparatorLastSplit(separatorLastSplit) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.SplitsComponent_set_separator_last_split(this.ptr, separatorLastSplit);
    }
}
exports.SplitsComponentRefMut = SplitsComponentRefMut;

class SplitsComponent extends SplitsComponentRefMut {
    /**
     * @param {function(SplitsComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SplitsComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {SplitsComponent}
     */
    static new() {
        const result = new SplitsComponent(liveSplitCoreNative.SplitsComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.SplitsComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.SplitsComponent = SplitsComponent;

class SplitsComponentStateRef {
    /**
     * @return {boolean}
     */
    finalSeparatorShown() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_final_separator_shown(this.ptr);
        return result;
    }
    /**
     * @return {number}
     */
    len() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_len(this.ptr);
        return result;
    }
    /**
     * @return {number}
     */
    iconChangeCount() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_icon_change_count(this.ptr);
        return result;
    }
    /**
     * @param {number} index
     * @return {number}
     */
    iconChangeSegmentIndex(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_icon_change_segment_index(this.ptr, index);
        return result;
    }
    /**
     * @param {number} index
     * @return {string}
     */
    iconChangeIcon(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_icon_change_icon(this.ptr, index);
        return result;
    }
    /**
     * @param {number} index
     * @return {string}
     */
    name(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_name(this.ptr, index);
        return result;
    }
    /**
     * @param {number} index
     * @return {string}
     */
    delta(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_delta(this.ptr, index);
        return result;
    }
    /**
     * @param {number} index
     * @return {string}
     */
    time(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_time(this.ptr, index);
        return result;
    }
    /**
     * @param {number} index
     * @return {string}
     */
    semanticColor(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_semantic_color(this.ptr, index);
        return result;
    }
    /**
     * @param {number} index
     * @return {boolean}
     */
    isCurrentSplit(index) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SplitsComponentState_is_current_split(this.ptr, index);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SplitsComponentStateRef = SplitsComponentStateRef;

class SplitsComponentStateRefMut extends SplitsComponentStateRef {
}
exports.SplitsComponentStateRefMut = SplitsComponentStateRefMut;

class SplitsComponentState extends SplitsComponentStateRefMut {
    /**
     * @param {function(SplitsComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SplitsComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.SplitsComponentState = SplitsComponentState;

class SumOfBestCleanerRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SumOfBestCleanerRef = SumOfBestCleanerRef;

class SumOfBestCleanerRefMut extends SumOfBestCleanerRef {
    /**
     * @return {PotentialCleanUp | null}
     */
    nextPotentialCleanUp() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new PotentialCleanUp(liveSplitCoreNative.SumOfBestCleaner_next_potential_clean_up(this.ptr));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @param {PotentialCleanUp} cleanUp
     */
    apply(cleanUp) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(cleanUp.ptr)) {
            throw "cleanUp is disposed";
        }
        liveSplitCoreNative.SumOfBestCleaner_apply(this.ptr, cleanUp.ptr);
        cleanUp.ptr = ref.NULL;
    }
}
exports.SumOfBestCleanerRefMut = SumOfBestCleanerRefMut;

class SumOfBestCleaner extends SumOfBestCleanerRefMut {
    /**
     * @param {function(SumOfBestCleaner)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SumOfBestCleaner_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.SumOfBestCleaner = SumOfBestCleaner;

class SumOfBestComponentRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    stateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.SumOfBestComponent_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @return {SumOfBestComponentState}
     */
    state(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = new SumOfBestComponentState(liveSplitCoreNative.SumOfBestComponent_state(this.ptr, timer.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SumOfBestComponentRef = SumOfBestComponentRef;

class SumOfBestComponentRefMut extends SumOfBestComponentRef {
}
exports.SumOfBestComponentRefMut = SumOfBestComponentRefMut;

class SumOfBestComponent extends SumOfBestComponentRefMut {
    /**
     * @param {function(SumOfBestComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SumOfBestComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {SumOfBestComponent}
     */
    static new() {
        const result = new SumOfBestComponent(liveSplitCoreNative.SumOfBestComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.SumOfBestComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.SumOfBestComponent = SumOfBestComponent;

class SumOfBestComponentStateRef {
    /**
     * @return {string}
     */
    text() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SumOfBestComponentState_text(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.SumOfBestComponentState_time(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.SumOfBestComponentStateRef = SumOfBestComponentStateRef;

class SumOfBestComponentStateRefMut extends SumOfBestComponentStateRef {
}
exports.SumOfBestComponentStateRefMut = SumOfBestComponentStateRefMut;

class SumOfBestComponentState extends SumOfBestComponentStateRefMut {
    /**
     * @param {function(SumOfBestComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.SumOfBestComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.SumOfBestComponentState = SumOfBestComponentState;

class TextComponentRef {
    /**
     * @return {any}
     */
    stateAsJson() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TextComponent_state_as_json(this.ptr);
        return JSON.parse(result);
    }
    /**
     * @return {TextComponentState}
     */
    state() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TextComponentState(liveSplitCoreNative.TextComponent_state(this.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TextComponentRef = TextComponentRef;

class TextComponentRefMut extends TextComponentRef {
    /**
     * @param {string} text
     */
    setCenter(text) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.TextComponent_set_center(this.ptr, text);
    }
    /**
     * @param {string} text
     */
    setLeft(text) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.TextComponent_set_left(this.ptr, text);
    }
    /**
     * @param {string} text
     */
    setRight(text) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.TextComponent_set_right(this.ptr, text);
    }
}
exports.TextComponentRefMut = TextComponentRefMut;

class TextComponent extends TextComponentRefMut {
    /**
     * @param {function(TextComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TextComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {TextComponent}
     */
    static new() {
        const result = new TextComponent(liveSplitCoreNative.TextComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.TextComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.TextComponent = TextComponent;

class TextComponentStateRef {
    /**
     * @return {string}
     */
    left() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TextComponentState_left(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    right() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TextComponentState_right(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    center() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TextComponentState_center(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    isSplit() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TextComponentState_is_split(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TextComponentStateRef = TextComponentStateRef;

class TextComponentStateRefMut extends TextComponentStateRef {
}
exports.TextComponentStateRefMut = TextComponentStateRefMut;

class TextComponentState extends TextComponentStateRefMut {
    /**
     * @param {function(TextComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TextComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.TextComponentState = TextComponentState;

class TimeRef {
    /**
     * @return {Time}
     */
    clone() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Time(liveSplitCoreNative.Time_clone(this.ptr));
        return result;
    }
    /**
     * @return {TimeSpanRef | null}
     */
    realTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeSpanRef(liveSplitCoreNative.Time_real_time(this.ptr));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @return {TimeSpanRef | null}
     */
    gameTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeSpanRef(liveSplitCoreNative.Time_game_time(this.ptr));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @param {number} timingMethod
     * @return {TimeSpanRef | null}
     */
    index(timingMethod) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeSpanRef(liveSplitCoreNative.Time_index(this.ptr, timingMethod));
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TimeRef = TimeRef;

class TimeRefMut extends TimeRef {
}
exports.TimeRefMut = TimeRefMut;

class Time extends TimeRefMut {
    /**
     * @param {function(Time)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.Time_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.Time = Time;

class TimeSpanRef {
    /**
     * @return {TimeSpan}
     */
    clone() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeSpan(liveSplitCoreNative.TimeSpan_clone(this.ptr));
        return result;
    }
    /**
     * @return {number}
     */
    totalSeconds() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TimeSpan_total_seconds(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TimeSpanRef = TimeSpanRef;

class TimeSpanRefMut extends TimeSpanRef {
}
exports.TimeSpanRefMut = TimeSpanRefMut;

class TimeSpan extends TimeSpanRefMut {
    /**
     * @param {function(TimeSpan)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TimeSpan_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @param {number} seconds
     * @return {TimeSpan}
     */
    static fromSeconds(seconds) {
        const result = new TimeSpan(liveSplitCoreNative.TimeSpan_from_seconds(seconds));
        return result;
    }
}
exports.TimeSpan = TimeSpan;

class TimerRef {
    /**
     * @return {number}
     */
    currentTimingMethod() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Timer_current_timing_method(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    currentComparison() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Timer_current_comparison(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    isGameTimeInitialized() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Timer_is_game_time_initialized(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    isGameTimePaused() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Timer_is_game_time_paused(this.ptr);
        return result;
    }
    /**
     * @return {TimeSpanRef}
     */
    loadingTimes() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimeSpanRef(liveSplitCoreNative.Timer_loading_times(this.ptr));
        return result;
    }
    /**
     * @return {number}
     */
    currentPhase() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.Timer_current_phase(this.ptr);
        return result;
    }
    /**
     * @return {RunRef}
     */
    getRun() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new RunRef(liveSplitCoreNative.Timer_get_run(this.ptr));
        return result;
    }
    /**
     */
    printDebug() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_print_debug(this.ptr);
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TimerRef = TimerRef;

class TimerRefMut extends TimerRef {
    /**
     * @param {RunRefMut} run
     * @param {boolean} updateSplits
     * @return {boolean}
     */
    replaceRun(run, updateSplits) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(run.ptr)) {
            throw "run is disposed";
        }
        const result = liveSplitCoreNative.Timer_replace_run(this.ptr, run.ptr, updateSplits);
        return result;
    }
    /**
     * @param {Run} run
     * @return {Run | null}
     */
    setRun(run) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(run.ptr)) {
            throw "run is disposed";
        }
        const result = new Run(liveSplitCoreNative.Timer_set_run(this.ptr, run.ptr));
        run.ptr = ref.NULL;
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     */
    start() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_start(this.ptr);
    }
    /**
     */
    split() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_split(this.ptr);
    }
    /**
     */
    splitOrStart() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_split_or_start(this.ptr);
    }
    /**
     */
    skipSplit() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_skip_split(this.ptr);
    }
    /**
     */
    undoSplit() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_undo_split(this.ptr);
    }
    /**
     * @param {boolean} updateSplits
     */
    reset(updateSplits) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_reset(this.ptr, updateSplits);
    }
    /**
     */
    pause() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_pause(this.ptr);
    }
    /**
     */
    resume() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_resume(this.ptr);
    }
    /**
     */
    togglePause() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_toggle_pause(this.ptr);
    }
    /**
     */
    togglePauseOrStart() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_toggle_pause_or_start(this.ptr);
    }
    /**
     */
    undoAllPauses() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_undo_all_pauses(this.ptr);
    }
    /**
     * @param {number} method
     */
    setCurrentTimingMethod(method) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_set_current_timing_method(this.ptr, method);
    }
    /**
     */
    switchToNextComparison() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_switch_to_next_comparison(this.ptr);
    }
    /**
     */
    switchToPreviousComparison() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_switch_to_previous_comparison(this.ptr);
    }
    /**
     */
    initializeGameTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_initialize_game_time(this.ptr);
    }
    /**
     */
    uninitializeGameTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_uninitialize_game_time(this.ptr);
    }
    /**
     */
    pauseGameTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_pause_game_time(this.ptr);
    }
    /**
     */
    unpauseGameTime() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        liveSplitCoreNative.Timer_unpause_game_time(this.ptr);
    }
    /**
     * @param {TimeSpanRef} time
     */
    setGameTime(time) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(time.ptr)) {
            throw "time is disposed";
        }
        liveSplitCoreNative.Timer_set_game_time(this.ptr, time.ptr);
    }
    /**
     * @param {TimeSpanRef} time
     */
    setLoadingTimes(time) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(time.ptr)) {
            throw "time is disposed";
        }
        liveSplitCoreNative.Timer_set_loading_times(this.ptr, time.ptr);
    }
}
exports.TimerRefMut = TimerRefMut;

class Timer extends TimerRefMut {
    /**
     * @param {function(Timer)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.Timer_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @param {Run} run
     * @return {Timer | null}
     */
    static new(run) {
        if (ref.isNull(run.ptr)) {
            throw "run is disposed";
        }
        const result = new Timer(liveSplitCoreNative.Timer_new(run.ptr));
        run.ptr = ref.NULL;
        if (ref.isNull(result.ptr)) {
            return null;
        }
        return result;
    }
    /**
     * @return {SharedTimer}
     */
    intoShared() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new SharedTimer(liveSplitCoreNative.Timer_into_shared(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.Timer = Timer;

class TimerComponentRef {
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {any}
     */
    stateAsJson(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = liveSplitCoreNative.TimerComponent_state_as_json(this.ptr, timer.ptr, layoutSettings.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @param {GeneralLayoutSettingsRef} layoutSettings
     * @return {TimerComponentState}
     */
    state(timer, layoutSettings) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        if (ref.isNull(layoutSettings.ptr)) {
            throw "layoutSettings is disposed";
        }
        const result = new TimerComponentState(liveSplitCoreNative.TimerComponent_state(this.ptr, timer.ptr, layoutSettings.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TimerComponentRef = TimerComponentRef;

class TimerComponentRefMut extends TimerComponentRef {
}
exports.TimerComponentRefMut = TimerComponentRefMut;

class TimerComponent extends TimerComponentRefMut {
    /**
     * @param {function(TimerComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TimerComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {TimerComponent}
     */
    static new() {
        const result = new TimerComponent(liveSplitCoreNative.TimerComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.TimerComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.TimerComponent = TimerComponent;

class TimerComponentStateRef {
    /**
     * @return {string}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TimerComponentState_time(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    fraction() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TimerComponentState_fraction(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    semanticColor() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TimerComponentState_semantic_color(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TimerComponentStateRef = TimerComponentStateRef;

class TimerComponentStateRefMut extends TimerComponentStateRef {
}
exports.TimerComponentStateRefMut = TimerComponentStateRefMut;

class TimerComponentState extends TimerComponentStateRefMut {
    /**
     * @param {function(TimerComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TimerComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.TimerComponentState = TimerComponentState;

class TimerReadLockRef {
    /**
     * @return {TimerRef}
     */
    timer() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimerRef(liveSplitCoreNative.TimerReadLock_timer(this.ptr));
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TimerReadLockRef = TimerReadLockRef;

class TimerReadLockRefMut extends TimerReadLockRef {
}
exports.TimerReadLockRefMut = TimerReadLockRefMut;

class TimerReadLock extends TimerReadLockRefMut {
    /**
     * @param {function(TimerReadLock)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TimerReadLock_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.TimerReadLock = TimerReadLock;

class TimerWriteLockRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TimerWriteLockRef = TimerWriteLockRef;

class TimerWriteLockRefMut extends TimerWriteLockRef {
    /**
     * @return {TimerRefMut}
     */
    timer() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new TimerRefMut(liveSplitCoreNative.TimerWriteLock_timer(this.ptr));
        return result;
    }
}
exports.TimerWriteLockRefMut = TimerWriteLockRefMut;

class TimerWriteLock extends TimerWriteLockRefMut {
    /**
     * @param {function(TimerWriteLock)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TimerWriteLock_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.TimerWriteLock = TimerWriteLock;

class TitleComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TitleComponentRef = TitleComponentRef;

class TitleComponentRefMut extends TitleComponentRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    stateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.TitleComponent_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @return {TitleComponentState}
     */
    state(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = new TitleComponentState(liveSplitCoreNative.TitleComponent_state(this.ptr, timer.ptr));
        return result;
    }
}
exports.TitleComponentRefMut = TitleComponentRefMut;

class TitleComponent extends TitleComponentRefMut {
    /**
     * @param {function(TitleComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TitleComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {TitleComponent}
     */
    static new() {
        const result = new TitleComponent(liveSplitCoreNative.TitleComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.TitleComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.TitleComponent = TitleComponent;

class TitleComponentStateRef {
    /**
     * @return {string | null}
     */
    iconChange() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TitleComponentState_icon_change(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    line1() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TitleComponentState_line1(this.ptr);
        return result;
    }
    /**
     * @return {string | null}
     */
    line2() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TitleComponentState_line2(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    isCentered() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TitleComponentState_is_centered(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    showsFinishedRuns() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TitleComponentState_shows_finished_runs(this.ptr);
        return result;
    }
    /**
     * @return {number}
     */
    finishedRuns() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TitleComponentState_finished_runs(this.ptr);
        return result;
    }
    /**
     * @return {boolean}
     */
    showsAttempts() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TitleComponentState_shows_attempts(this.ptr);
        return result;
    }
    /**
     * @return {number}
     */
    attempts() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TitleComponentState_attempts(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TitleComponentStateRef = TitleComponentStateRef;

class TitleComponentStateRefMut extends TitleComponentStateRef {
}
exports.TitleComponentStateRefMut = TitleComponentStateRefMut;

class TitleComponentState extends TitleComponentStateRefMut {
    /**
     * @param {function(TitleComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TitleComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.TitleComponentState = TitleComponentState;

class TotalPlaytimeComponentRef {
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TotalPlaytimeComponentRef = TotalPlaytimeComponentRef;

class TotalPlaytimeComponentRefMut extends TotalPlaytimeComponentRef {
    /**
     * @param {TimerRef} timer
     * @return {any}
     */
    stateAsJson(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = liveSplitCoreNative.TotalPlaytimeComponent_state_as_json(this.ptr, timer.ptr);
        return JSON.parse(result);
    }
    /**
     * @param {TimerRef} timer
     * @return {TotalPlaytimeComponentState}
     */
    state(timer) {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        if (ref.isNull(timer.ptr)) {
            throw "timer is disposed";
        }
        const result = new TotalPlaytimeComponentState(liveSplitCoreNative.TotalPlaytimeComponent_state(this.ptr, timer.ptr));
        return result;
    }
}
exports.TotalPlaytimeComponentRefMut = TotalPlaytimeComponentRefMut;

class TotalPlaytimeComponent extends TotalPlaytimeComponentRefMut {
    /**
     * @param {function(TotalPlaytimeComponent)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TotalPlaytimeComponent_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
    /**
     * @return {TotalPlaytimeComponent}
     */
    static new() {
        const result = new TotalPlaytimeComponent(liveSplitCoreNative.TotalPlaytimeComponent_new());
        return result;
    }
    /**
     * @return {Component}
     */
    intoGeneric() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = new Component(liveSplitCoreNative.TotalPlaytimeComponent_into_generic(this.ptr));
        this.ptr = ref.NULL;
        return result;
    }
}
exports.TotalPlaytimeComponent = TotalPlaytimeComponent;

class TotalPlaytimeComponentStateRef {
    /**
     * @return {string}
     */
    text() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TotalPlaytimeComponentState_text(this.ptr);
        return result;
    }
    /**
     * @return {string}
     */
    time() {
        if (ref.isNull(this.ptr)) {
            throw "this is disposed";
        }
        const result = liveSplitCoreNative.TotalPlaytimeComponentState_time(this.ptr);
        return result;
    }
    /**
     * @param {Buffer} ptr
     */
    constructor(ptr) {
        this.ptr = ptr;
    }
}
exports.TotalPlaytimeComponentStateRef = TotalPlaytimeComponentStateRef;

class TotalPlaytimeComponentStateRefMut extends TotalPlaytimeComponentStateRef {
}
exports.TotalPlaytimeComponentStateRefMut = TotalPlaytimeComponentStateRefMut;

class TotalPlaytimeComponentState extends TotalPlaytimeComponentStateRefMut {
    /**
     * @param {function(TotalPlaytimeComponentState)} closure
     */
    with(closure) {
        try {
            return closure(this);
        } finally {
            this.dispose();
        }
    }
    dispose() {
        if (!ref.isNull(this.ptr)) {
            liveSplitCoreNative.TotalPlaytimeComponentState_drop(this.ptr);
            this.ptr = ref.NULL;
        }
    }
}
exports.TotalPlaytimeComponentState = TotalPlaytimeComponentState;

package metrics;

import com.bitdecay.metrics.Tag;
import com.bitdecay.analytics.Bitlytics;

class Metrics {
    // tags
    public static inline var LEVEL_TAG = "level_num";

    // metrics
    public static inline var MAX_LEVEL = "max_level";
    public static inline var LEVEL_COMPLETE = "level_completed";
    public static inline var MOVE_COUNT = "move_count";

    private static var max_level_completed = -1;

    public static function levelCompleted(num:Int, steps:Int) {
        trace('level finished: ${num} in ${steps} steps');
        if (num > max_level_completed) {
            Bitlytics.Instance().Queue(MAX_LEVEL, num);
            max_level_completed = num;
        }

        // report all level completions for good aggregation metrics
        Bitlytics.Instance().Queue(LEVEL_COMPLETE, steps, [new Tag(LEVEL_TAG, '${num}')] );
    }
}
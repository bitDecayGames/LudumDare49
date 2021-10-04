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

    public static var max_level_completed(default, set) = 0;

    public static function set_max_level_completed(m:Int):Int {
        if (m > max_level_completed) {
            // new high score. Report this!
            Bitlytics.Instance().Queue(MAX_LEVEL, m);
            return m;
        }

        return max_level_completed;
    }

    public static function levelCompleted(num:Int, steps:Int) {
        // let our magic setter handle this metric
        max_level_completed = num;

        // report all level completions for good aggregation metrics
        Bitlytics.Instance().Queue(LEVEL_COMPLETE, steps, [new Tag(LEVEL_TAG, '${num}')] );
    }
}
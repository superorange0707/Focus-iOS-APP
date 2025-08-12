package com.skipfeed.android.data.database;

import android.database.Cursor;
import android.os.CancellationSignal;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.room.CoroutinesRoom;
import androidx.room.EntityInsertionAdapter;
import androidx.room.RoomDatabase;
import androidx.room.RoomSQLiteQuery;
import androidx.room.SharedSQLiteStatement;
import androidx.room.util.CursorUtil;
import androidx.room.util.DBUtil;
import androidx.sqlite.db.SupportSQLiteStatement;
import com.skipfeed.android.data.model.UsageAnalytics;
import java.lang.Class;
import java.lang.Exception;
import java.lang.Integer;
import java.lang.Long;
import java.lang.Object;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import javax.annotation.processing.Generated;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlinx.coroutines.flow.Flow;

@Generated("androidx.room.RoomProcessor")
@SuppressWarnings({"unchecked", "deprecation"})
public final class UsageAnalyticsDao_Impl implements UsageAnalyticsDao {
  private final RoomDatabase __db;

  private final EntityInsertionAdapter<UsageAnalytics> __insertionAdapterOfUsageAnalytics;

  private final Converters __converters = new Converters();

  private final SharedSQLiteStatement __preparedStmtOfClearAnalytics;

  public UsageAnalyticsDao_Impl(@NonNull final RoomDatabase __db) {
    this.__db = __db;
    this.__insertionAdapterOfUsageAnalytics = new EntityInsertionAdapter<UsageAnalytics>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "INSERT OR REPLACE INTO `usage_analytics` (`id`,`totalSearches`,`searchesByPlatform`,`dailySearches`,`timeSpentOnPlatforms`,`lastResetDate`,`averageTimePerSearch`) VALUES (?,?,?,?,?,?,?)";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final UsageAnalytics entity) {
        statement.bindLong(1, entity.getId());
        statement.bindLong(2, entity.getTotalSearches());
        final String _tmp = __converters.fromStringMap(entity.getSearchesByPlatform());
        if (_tmp == null) {
          statement.bindNull(3);
        } else {
          statement.bindString(3, _tmp);
        }
        final String _tmp_1 = __converters.fromStringMap(entity.getDailySearches());
        if (_tmp_1 == null) {
          statement.bindNull(4);
        } else {
          statement.bindString(4, _tmp_1);
        }
        final String _tmp_2 = __converters.fromStringLongMap(entity.getTimeSpentOnPlatforms());
        if (_tmp_2 == null) {
          statement.bindNull(5);
        } else {
          statement.bindString(5, _tmp_2);
        }
        statement.bindLong(6, entity.getLastResetDate());
        statement.bindLong(7, entity.getAverageTimePerSearch());
      }
    };
    this.__preparedStmtOfClearAnalytics = new SharedSQLiteStatement(__db) {
      @Override
      @NonNull
      public String createQuery() {
        final String _query = "DELETE FROM usage_analytics";
        return _query;
      }
    };
  }

  @Override
  public Object insertOrUpdateAnalytics(final UsageAnalytics analytics,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __insertionAdapterOfUsageAnalytics.insert(analytics);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object clearAnalytics(final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        final SupportSQLiteStatement _stmt = __preparedStmtOfClearAnalytics.acquire();
        try {
          __db.beginTransaction();
          try {
            _stmt.executeUpdateDelete();
            __db.setTransactionSuccessful();
            return Unit.INSTANCE;
          } finally {
            __db.endTransaction();
          }
        } finally {
          __preparedStmtOfClearAnalytics.release(_stmt);
        }
      }
    }, $completion);
  }

  @Override
  public Flow<UsageAnalytics> getUsageAnalytics() {
    final String _sql = "SELECT * FROM usage_analytics WHERE id = 0";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"usage_analytics"}, new Callable<UsageAnalytics>() {
      @Override
      @Nullable
      public UsageAnalytics call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfTotalSearches = CursorUtil.getColumnIndexOrThrow(_cursor, "totalSearches");
          final int _cursorIndexOfSearchesByPlatform = CursorUtil.getColumnIndexOrThrow(_cursor, "searchesByPlatform");
          final int _cursorIndexOfDailySearches = CursorUtil.getColumnIndexOrThrow(_cursor, "dailySearches");
          final int _cursorIndexOfTimeSpentOnPlatforms = CursorUtil.getColumnIndexOrThrow(_cursor, "timeSpentOnPlatforms");
          final int _cursorIndexOfLastResetDate = CursorUtil.getColumnIndexOrThrow(_cursor, "lastResetDate");
          final int _cursorIndexOfAverageTimePerSearch = CursorUtil.getColumnIndexOrThrow(_cursor, "averageTimePerSearch");
          final UsageAnalytics _result;
          if (_cursor.moveToFirst()) {
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final int _tmpTotalSearches;
            _tmpTotalSearches = _cursor.getInt(_cursorIndexOfTotalSearches);
            final Map<String, Integer> _tmpSearchesByPlatform;
            final String _tmp;
            if (_cursor.isNull(_cursorIndexOfSearchesByPlatform)) {
              _tmp = null;
            } else {
              _tmp = _cursor.getString(_cursorIndexOfSearchesByPlatform);
            }
            _tmpSearchesByPlatform = __converters.toStringMap(_tmp);
            final Map<String, Integer> _tmpDailySearches;
            final String _tmp_1;
            if (_cursor.isNull(_cursorIndexOfDailySearches)) {
              _tmp_1 = null;
            } else {
              _tmp_1 = _cursor.getString(_cursorIndexOfDailySearches);
            }
            _tmpDailySearches = __converters.toStringMap(_tmp_1);
            final Map<String, Long> _tmpTimeSpentOnPlatforms;
            final String _tmp_2;
            if (_cursor.isNull(_cursorIndexOfTimeSpentOnPlatforms)) {
              _tmp_2 = null;
            } else {
              _tmp_2 = _cursor.getString(_cursorIndexOfTimeSpentOnPlatforms);
            }
            _tmpTimeSpentOnPlatforms = __converters.toStringLongMap(_tmp_2);
            final long _tmpLastResetDate;
            _tmpLastResetDate = _cursor.getLong(_cursorIndexOfLastResetDate);
            final long _tmpAverageTimePerSearch;
            _tmpAverageTimePerSearch = _cursor.getLong(_cursorIndexOfAverageTimePerSearch);
            _result = new UsageAnalytics(_tmpId,_tmpTotalSearches,_tmpSearchesByPlatform,_tmpDailySearches,_tmpTimeSpentOnPlatforms,_tmpLastResetDate,_tmpAverageTimePerSearch);
          } else {
            _result = null;
          }
          return _result;
        } finally {
          _cursor.close();
        }
      }

      @Override
      protected void finalize() {
        _statement.release();
      }
    });
  }

  @Override
  public Object getUsageAnalyticsOnce(final Continuation<? super UsageAnalytics> $completion) {
    final String _sql = "SELECT * FROM usage_analytics WHERE id = 0";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    final CancellationSignal _cancellationSignal = DBUtil.createCancellationSignal();
    return CoroutinesRoom.execute(__db, false, _cancellationSignal, new Callable<UsageAnalytics>() {
      @Override
      @Nullable
      public UsageAnalytics call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfTotalSearches = CursorUtil.getColumnIndexOrThrow(_cursor, "totalSearches");
          final int _cursorIndexOfSearchesByPlatform = CursorUtil.getColumnIndexOrThrow(_cursor, "searchesByPlatform");
          final int _cursorIndexOfDailySearches = CursorUtil.getColumnIndexOrThrow(_cursor, "dailySearches");
          final int _cursorIndexOfTimeSpentOnPlatforms = CursorUtil.getColumnIndexOrThrow(_cursor, "timeSpentOnPlatforms");
          final int _cursorIndexOfLastResetDate = CursorUtil.getColumnIndexOrThrow(_cursor, "lastResetDate");
          final int _cursorIndexOfAverageTimePerSearch = CursorUtil.getColumnIndexOrThrow(_cursor, "averageTimePerSearch");
          final UsageAnalytics _result;
          if (_cursor.moveToFirst()) {
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final int _tmpTotalSearches;
            _tmpTotalSearches = _cursor.getInt(_cursorIndexOfTotalSearches);
            final Map<String, Integer> _tmpSearchesByPlatform;
            final String _tmp;
            if (_cursor.isNull(_cursorIndexOfSearchesByPlatform)) {
              _tmp = null;
            } else {
              _tmp = _cursor.getString(_cursorIndexOfSearchesByPlatform);
            }
            _tmpSearchesByPlatform = __converters.toStringMap(_tmp);
            final Map<String, Integer> _tmpDailySearches;
            final String _tmp_1;
            if (_cursor.isNull(_cursorIndexOfDailySearches)) {
              _tmp_1 = null;
            } else {
              _tmp_1 = _cursor.getString(_cursorIndexOfDailySearches);
            }
            _tmpDailySearches = __converters.toStringMap(_tmp_1);
            final Map<String, Long> _tmpTimeSpentOnPlatforms;
            final String _tmp_2;
            if (_cursor.isNull(_cursorIndexOfTimeSpentOnPlatforms)) {
              _tmp_2 = null;
            } else {
              _tmp_2 = _cursor.getString(_cursorIndexOfTimeSpentOnPlatforms);
            }
            _tmpTimeSpentOnPlatforms = __converters.toStringLongMap(_tmp_2);
            final long _tmpLastResetDate;
            _tmpLastResetDate = _cursor.getLong(_cursorIndexOfLastResetDate);
            final long _tmpAverageTimePerSearch;
            _tmpAverageTimePerSearch = _cursor.getLong(_cursorIndexOfAverageTimePerSearch);
            _result = new UsageAnalytics(_tmpId,_tmpTotalSearches,_tmpSearchesByPlatform,_tmpDailySearches,_tmpTimeSpentOnPlatforms,_tmpLastResetDate,_tmpAverageTimePerSearch);
          } else {
            _result = null;
          }
          return _result;
        } finally {
          _cursor.close();
          _statement.release();
        }
      }
    }, $completion);
  }

  @NonNull
  public static List<Class<?>> getRequiredConverters() {
    return Collections.emptyList();
  }
}

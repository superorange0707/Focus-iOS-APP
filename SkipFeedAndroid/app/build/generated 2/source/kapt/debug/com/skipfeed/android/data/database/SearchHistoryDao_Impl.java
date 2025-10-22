package com.skipfeed.android.data.database;

import android.database.Cursor;
import android.os.CancellationSignal;
import androidx.annotation.NonNull;
import androidx.room.CoroutinesRoom;
import androidx.room.EntityDeletionOrUpdateAdapter;
import androidx.room.EntityInsertionAdapter;
import androidx.room.RoomDatabase;
import androidx.room.RoomSQLiteQuery;
import androidx.room.SharedSQLiteStatement;
import androidx.room.util.CursorUtil;
import androidx.room.util.DBUtil;
import androidx.sqlite.db.SupportSQLiteStatement;
import com.skipfeed.android.data.model.SearchHistoryItem;
import java.lang.Class;
import java.lang.Exception;
import java.lang.Integer;
import java.lang.Object;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import javax.annotation.processing.Generated;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlinx.coroutines.flow.Flow;

@Generated("androidx.room.RoomProcessor")
@SuppressWarnings({"unchecked", "deprecation"})
public final class SearchHistoryDao_Impl implements SearchHistoryDao {
  private final RoomDatabase __db;

  private final EntityInsertionAdapter<SearchHistoryItem> __insertionAdapterOfSearchHistoryItem;

  private final EntityDeletionOrUpdateAdapter<SearchHistoryItem> __deletionAdapterOfSearchHistoryItem;

  private final SharedSQLiteStatement __preparedStmtOfClearAllHistory;

  private final SharedSQLiteStatement __preparedStmtOfClearHistoryByPlatform;

  private final SharedSQLiteStatement __preparedStmtOfDeleteOldEntries;

  public SearchHistoryDao_Impl(@NonNull final RoomDatabase __db) {
    this.__db = __db;
    this.__insertionAdapterOfSearchHistoryItem = new EntityInsertionAdapter<SearchHistoryItem>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "INSERT OR REPLACE INTO `search_history` (`id`,`query`,`platform`,`timestamp`,`resultCount`) VALUES (?,?,?,?,?)";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final SearchHistoryItem entity) {
        if (entity.getId() == null) {
          statement.bindNull(1);
        } else {
          statement.bindString(1, entity.getId());
        }
        if (entity.getQuery() == null) {
          statement.bindNull(2);
        } else {
          statement.bindString(2, entity.getQuery());
        }
        if (entity.getPlatform() == null) {
          statement.bindNull(3);
        } else {
          statement.bindString(3, entity.getPlatform());
        }
        statement.bindLong(4, entity.getTimestamp());
        if (entity.getResultCount() == null) {
          statement.bindNull(5);
        } else {
          statement.bindLong(5, entity.getResultCount());
        }
      }
    };
    this.__deletionAdapterOfSearchHistoryItem = new EntityDeletionOrUpdateAdapter<SearchHistoryItem>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "DELETE FROM `search_history` WHERE `id` = ?";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final SearchHistoryItem entity) {
        if (entity.getId() == null) {
          statement.bindNull(1);
        } else {
          statement.bindString(1, entity.getId());
        }
      }
    };
    this.__preparedStmtOfClearAllHistory = new SharedSQLiteStatement(__db) {
      @Override
      @NonNull
      public String createQuery() {
        final String _query = "DELETE FROM search_history";
        return _query;
      }
    };
    this.__preparedStmtOfClearHistoryByPlatform = new SharedSQLiteStatement(__db) {
      @Override
      @NonNull
      public String createQuery() {
        final String _query = "DELETE FROM search_history WHERE platform = ?";
        return _query;
      }
    };
    this.__preparedStmtOfDeleteOldEntries = new SharedSQLiteStatement(__db) {
      @Override
      @NonNull
      public String createQuery() {
        final String _query = "DELETE FROM search_history WHERE timestamp < ?";
        return _query;
      }
    };
  }

  @Override
  public Object insertSearch(final SearchHistoryItem searchHistoryItem,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __insertionAdapterOfSearchHistoryItem.insert(searchHistoryItem);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object deleteSearch(final SearchHistoryItem searchHistoryItem,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __deletionAdapterOfSearchHistoryItem.handle(searchHistoryItem);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object clearAllHistory(final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        final SupportSQLiteStatement _stmt = __preparedStmtOfClearAllHistory.acquire();
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
          __preparedStmtOfClearAllHistory.release(_stmt);
        }
      }
    }, $completion);
  }

  @Override
  public Object clearHistoryByPlatform(final String platform,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        final SupportSQLiteStatement _stmt = __preparedStmtOfClearHistoryByPlatform.acquire();
        int _argIndex = 1;
        if (platform == null) {
          _stmt.bindNull(_argIndex);
        } else {
          _stmt.bindString(_argIndex, platform);
        }
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
          __preparedStmtOfClearHistoryByPlatform.release(_stmt);
        }
      }
    }, $completion);
  }

  @Override
  public Object deleteOldEntries(final long beforeTimestamp,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        final SupportSQLiteStatement _stmt = __preparedStmtOfDeleteOldEntries.acquire();
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, beforeTimestamp);
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
          __preparedStmtOfDeleteOldEntries.release(_stmt);
        }
      }
    }, $completion);
  }

  @Override
  public Flow<List<SearchHistoryItem>> getAllSearchHistory() {
    final String _sql = "SELECT * FROM search_history ORDER BY timestamp DESC";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"search_history"}, new Callable<List<SearchHistoryItem>>() {
      @Override
      @NonNull
      public List<SearchHistoryItem> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfQuery = CursorUtil.getColumnIndexOrThrow(_cursor, "query");
          final int _cursorIndexOfPlatform = CursorUtil.getColumnIndexOrThrow(_cursor, "platform");
          final int _cursorIndexOfTimestamp = CursorUtil.getColumnIndexOrThrow(_cursor, "timestamp");
          final int _cursorIndexOfResultCount = CursorUtil.getColumnIndexOrThrow(_cursor, "resultCount");
          final List<SearchHistoryItem> _result = new ArrayList<SearchHistoryItem>(_cursor.getCount());
          while (_cursor.moveToNext()) {
            final SearchHistoryItem _item;
            final String _tmpId;
            if (_cursor.isNull(_cursorIndexOfId)) {
              _tmpId = null;
            } else {
              _tmpId = _cursor.getString(_cursorIndexOfId);
            }
            final String _tmpQuery;
            if (_cursor.isNull(_cursorIndexOfQuery)) {
              _tmpQuery = null;
            } else {
              _tmpQuery = _cursor.getString(_cursorIndexOfQuery);
            }
            final String _tmpPlatform;
            if (_cursor.isNull(_cursorIndexOfPlatform)) {
              _tmpPlatform = null;
            } else {
              _tmpPlatform = _cursor.getString(_cursorIndexOfPlatform);
            }
            final long _tmpTimestamp;
            _tmpTimestamp = _cursor.getLong(_cursorIndexOfTimestamp);
            final Integer _tmpResultCount;
            if (_cursor.isNull(_cursorIndexOfResultCount)) {
              _tmpResultCount = null;
            } else {
              _tmpResultCount = _cursor.getInt(_cursorIndexOfResultCount);
            }
            _item = new SearchHistoryItem(_tmpId,_tmpQuery,_tmpPlatform,_tmpTimestamp,_tmpResultCount);
            _result.add(_item);
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
  public Flow<List<SearchHistoryItem>> getSearchHistoryByPlatform(final String platform) {
    final String _sql = "SELECT * FROM search_history WHERE platform = ? ORDER BY timestamp DESC";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    if (platform == null) {
      _statement.bindNull(_argIndex);
    } else {
      _statement.bindString(_argIndex, platform);
    }
    return CoroutinesRoom.createFlow(__db, false, new String[] {"search_history"}, new Callable<List<SearchHistoryItem>>() {
      @Override
      @NonNull
      public List<SearchHistoryItem> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfQuery = CursorUtil.getColumnIndexOrThrow(_cursor, "query");
          final int _cursorIndexOfPlatform = CursorUtil.getColumnIndexOrThrow(_cursor, "platform");
          final int _cursorIndexOfTimestamp = CursorUtil.getColumnIndexOrThrow(_cursor, "timestamp");
          final int _cursorIndexOfResultCount = CursorUtil.getColumnIndexOrThrow(_cursor, "resultCount");
          final List<SearchHistoryItem> _result = new ArrayList<SearchHistoryItem>(_cursor.getCount());
          while (_cursor.moveToNext()) {
            final SearchHistoryItem _item;
            final String _tmpId;
            if (_cursor.isNull(_cursorIndexOfId)) {
              _tmpId = null;
            } else {
              _tmpId = _cursor.getString(_cursorIndexOfId);
            }
            final String _tmpQuery;
            if (_cursor.isNull(_cursorIndexOfQuery)) {
              _tmpQuery = null;
            } else {
              _tmpQuery = _cursor.getString(_cursorIndexOfQuery);
            }
            final String _tmpPlatform;
            if (_cursor.isNull(_cursorIndexOfPlatform)) {
              _tmpPlatform = null;
            } else {
              _tmpPlatform = _cursor.getString(_cursorIndexOfPlatform);
            }
            final long _tmpTimestamp;
            _tmpTimestamp = _cursor.getLong(_cursorIndexOfTimestamp);
            final Integer _tmpResultCount;
            if (_cursor.isNull(_cursorIndexOfResultCount)) {
              _tmpResultCount = null;
            } else {
              _tmpResultCount = _cursor.getInt(_cursorIndexOfResultCount);
            }
            _item = new SearchHistoryItem(_tmpId,_tmpQuery,_tmpPlatform,_tmpTimestamp,_tmpResultCount);
            _result.add(_item);
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
  public Object getRecentSearches(final int limit,
      final Continuation<? super List<SearchHistoryItem>> $completion) {
    final String _sql = "SELECT * FROM search_history ORDER BY timestamp DESC LIMIT ?";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    _statement.bindLong(_argIndex, limit);
    final CancellationSignal _cancellationSignal = DBUtil.createCancellationSignal();
    return CoroutinesRoom.execute(__db, false, _cancellationSignal, new Callable<List<SearchHistoryItem>>() {
      @Override
      @NonNull
      public List<SearchHistoryItem> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfQuery = CursorUtil.getColumnIndexOrThrow(_cursor, "query");
          final int _cursorIndexOfPlatform = CursorUtil.getColumnIndexOrThrow(_cursor, "platform");
          final int _cursorIndexOfTimestamp = CursorUtil.getColumnIndexOrThrow(_cursor, "timestamp");
          final int _cursorIndexOfResultCount = CursorUtil.getColumnIndexOrThrow(_cursor, "resultCount");
          final List<SearchHistoryItem> _result = new ArrayList<SearchHistoryItem>(_cursor.getCount());
          while (_cursor.moveToNext()) {
            final SearchHistoryItem _item;
            final String _tmpId;
            if (_cursor.isNull(_cursorIndexOfId)) {
              _tmpId = null;
            } else {
              _tmpId = _cursor.getString(_cursorIndexOfId);
            }
            final String _tmpQuery;
            if (_cursor.isNull(_cursorIndexOfQuery)) {
              _tmpQuery = null;
            } else {
              _tmpQuery = _cursor.getString(_cursorIndexOfQuery);
            }
            final String _tmpPlatform;
            if (_cursor.isNull(_cursorIndexOfPlatform)) {
              _tmpPlatform = null;
            } else {
              _tmpPlatform = _cursor.getString(_cursorIndexOfPlatform);
            }
            final long _tmpTimestamp;
            _tmpTimestamp = _cursor.getLong(_cursorIndexOfTimestamp);
            final Integer _tmpResultCount;
            if (_cursor.isNull(_cursorIndexOfResultCount)) {
              _tmpResultCount = null;
            } else {
              _tmpResultCount = _cursor.getInt(_cursorIndexOfResultCount);
            }
            _item = new SearchHistoryItem(_tmpId,_tmpQuery,_tmpPlatform,_tmpTimestamp,_tmpResultCount);
            _result.add(_item);
          }
          return _result;
        } finally {
          _cursor.close();
          _statement.release();
        }
      }
    }, $completion);
  }

  @Override
  public Object getRecentQueries(final int limit,
      final Continuation<? super List<String>> $completion) {
    final String _sql = "SELECT DISTINCT query FROM search_history ORDER BY timestamp DESC LIMIT ?";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    _statement.bindLong(_argIndex, limit);
    final CancellationSignal _cancellationSignal = DBUtil.createCancellationSignal();
    return CoroutinesRoom.execute(__db, false, _cancellationSignal, new Callable<List<String>>() {
      @Override
      @NonNull
      public List<String> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final List<String> _result = new ArrayList<String>(_cursor.getCount());
          while (_cursor.moveToNext()) {
            final String _item;
            if (_cursor.isNull(0)) {
              _item = null;
            } else {
              _item = _cursor.getString(0);
            }
            _result.add(_item);
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

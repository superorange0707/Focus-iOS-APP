package com.skipfeed.android.di;

import com.skipfeed.android.data.database.SearchHistoryDao;
import com.skipfeed.android.data.database.SkipFeedDatabase;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata
@QualifierMetadata
@DaggerGenerated
@Generated(
    value = "dagger.internal.codegen.ComponentProcessor",
    comments = "https://dagger.dev"
)
@SuppressWarnings({
    "unchecked",
    "rawtypes",
    "KotlinInternal",
    "KotlinInternalInJava"
})
public final class DatabaseModule_ProvideSearchHistoryDaoFactory implements Factory<SearchHistoryDao> {
  private final Provider<SkipFeedDatabase> databaseProvider;

  public DatabaseModule_ProvideSearchHistoryDaoFactory(
      Provider<SkipFeedDatabase> databaseProvider) {
    this.databaseProvider = databaseProvider;
  }

  @Override
  public SearchHistoryDao get() {
    return provideSearchHistoryDao(databaseProvider.get());
  }

  public static DatabaseModule_ProvideSearchHistoryDaoFactory create(
      Provider<SkipFeedDatabase> databaseProvider) {
    return new DatabaseModule_ProvideSearchHistoryDaoFactory(databaseProvider);
  }

  public static SearchHistoryDao provideSearchHistoryDao(SkipFeedDatabase database) {
    return Preconditions.checkNotNullFromProvides(DatabaseModule.INSTANCE.provideSearchHistoryDao(database));
  }
}

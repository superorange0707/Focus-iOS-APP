package com.skipfeed.android.di;

import com.skipfeed.android.data.database.SkipFeedDatabase;
import com.skipfeed.android.data.database.UsageAnalyticsDao;
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
public final class DatabaseModule_ProvideUsageAnalyticsDaoFactory implements Factory<UsageAnalyticsDao> {
  private final Provider<SkipFeedDatabase> databaseProvider;

  public DatabaseModule_ProvideUsageAnalyticsDaoFactory(
      Provider<SkipFeedDatabase> databaseProvider) {
    this.databaseProvider = databaseProvider;
  }

  @Override
  public UsageAnalyticsDao get() {
    return provideUsageAnalyticsDao(databaseProvider.get());
  }

  public static DatabaseModule_ProvideUsageAnalyticsDaoFactory create(
      Provider<SkipFeedDatabase> databaseProvider) {
    return new DatabaseModule_ProvideUsageAnalyticsDaoFactory(databaseProvider);
  }

  public static UsageAnalyticsDao provideUsageAnalyticsDao(SkipFeedDatabase database) {
    return Preconditions.checkNotNullFromProvides(DatabaseModule.INSTANCE.provideUsageAnalyticsDao(database));
  }
}

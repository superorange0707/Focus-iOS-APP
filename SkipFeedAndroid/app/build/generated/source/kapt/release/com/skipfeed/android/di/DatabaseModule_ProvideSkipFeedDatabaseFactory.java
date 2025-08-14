package com.skipfeed.android.di;

import android.content.Context;
import com.skipfeed.android.data.database.SkipFeedDatabase;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata("javax.inject.Singleton")
@QualifierMetadata("dagger.hilt.android.qualifiers.ApplicationContext")
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
public final class DatabaseModule_ProvideSkipFeedDatabaseFactory implements Factory<SkipFeedDatabase> {
  private final Provider<Context> contextProvider;

  public DatabaseModule_ProvideSkipFeedDatabaseFactory(Provider<Context> contextProvider) {
    this.contextProvider = contextProvider;
  }

  @Override
  public SkipFeedDatabase get() {
    return provideSkipFeedDatabase(contextProvider.get());
  }

  public static DatabaseModule_ProvideSkipFeedDatabaseFactory create(
      Provider<Context> contextProvider) {
    return new DatabaseModule_ProvideSkipFeedDatabaseFactory(contextProvider);
  }

  public static SkipFeedDatabase provideSkipFeedDatabase(Context context) {
    return Preconditions.checkNotNullFromProvides(DatabaseModule.INSTANCE.provideSkipFeedDatabase(context));
  }
}

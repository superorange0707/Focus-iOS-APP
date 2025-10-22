package com.skipfeed.android.data.repository;

import android.content.Context;
import com.skipfeed.android.data.api.RedditApiService;
import com.skipfeed.android.data.database.SearchHistoryDao;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata("javax.inject.Singleton")
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
public final class SearchRepository_Factory implements Factory<SearchRepository> {
  private final Provider<RedditApiService> redditApiServiceProvider;

  private final Provider<SearchHistoryDao> searchHistoryDaoProvider;

  private final Provider<Context> contextProvider;

  public SearchRepository_Factory(Provider<RedditApiService> redditApiServiceProvider,
      Provider<SearchHistoryDao> searchHistoryDaoProvider, Provider<Context> contextProvider) {
    this.redditApiServiceProvider = redditApiServiceProvider;
    this.searchHistoryDaoProvider = searchHistoryDaoProvider;
    this.contextProvider = contextProvider;
  }

  @Override
  public SearchRepository get() {
    return newInstance(redditApiServiceProvider.get(), searchHistoryDaoProvider.get(), contextProvider.get());
  }

  public static SearchRepository_Factory create(Provider<RedditApiService> redditApiServiceProvider,
      Provider<SearchHistoryDao> searchHistoryDaoProvider, Provider<Context> contextProvider) {
    return new SearchRepository_Factory(redditApiServiceProvider, searchHistoryDaoProvider, contextProvider);
  }

  public static SearchRepository newInstance(RedditApiService redditApiService,
      SearchHistoryDao searchHistoryDao, Context context) {
    return new SearchRepository(redditApiService, searchHistoryDao, context);
  }
}

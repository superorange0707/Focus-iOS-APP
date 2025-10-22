package com.skipfeed.android.di;

import com.skipfeed.android.data.api.RedditApiService;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;
import retrofit2.Retrofit;

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
public final class NetworkModule_ProvideRedditApiServiceFactory implements Factory<RedditApiService> {
  private final Provider<Retrofit> retrofitProvider;

  public NetworkModule_ProvideRedditApiServiceFactory(Provider<Retrofit> retrofitProvider) {
    this.retrofitProvider = retrofitProvider;
  }

  @Override
  public RedditApiService get() {
    return provideRedditApiService(retrofitProvider.get());
  }

  public static NetworkModule_ProvideRedditApiServiceFactory create(
      Provider<Retrofit> retrofitProvider) {
    return new NetworkModule_ProvideRedditApiServiceFactory(retrofitProvider);
  }

  public static RedditApiService provideRedditApiService(Retrofit retrofit) {
    return Preconditions.checkNotNullFromProvides(NetworkModule.INSTANCE.provideRedditApiService(retrofit));
  }
}

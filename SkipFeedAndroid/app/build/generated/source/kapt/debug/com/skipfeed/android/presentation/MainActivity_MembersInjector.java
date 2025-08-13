package com.skipfeed.android.presentation;

import com.skipfeed.android.data.repository.SearchRepository;
import dagger.MembersInjector;
import dagger.internal.DaggerGenerated;
import dagger.internal.InjectedFieldSignature;
import dagger.internal.QualifierMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

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
public final class MainActivity_MembersInjector implements MembersInjector<MainActivity> {
  private final Provider<SearchRepository> searchRepositoryProvider;

  public MainActivity_MembersInjector(Provider<SearchRepository> searchRepositoryProvider) {
    this.searchRepositoryProvider = searchRepositoryProvider;
  }

  public static MembersInjector<MainActivity> create(
      Provider<SearchRepository> searchRepositoryProvider) {
    return new MainActivity_MembersInjector(searchRepositoryProvider);
  }

  @Override
  public void injectMembers(MainActivity instance) {
    injectSearchRepository(instance, searchRepositoryProvider.get());
  }

  @InjectedFieldSignature("com.skipfeed.android.presentation.MainActivity.searchRepository")
  public static void injectSearchRepository(MainActivity instance,
      SearchRepository searchRepository) {
    instance.searchRepository = searchRepository;
  }
}

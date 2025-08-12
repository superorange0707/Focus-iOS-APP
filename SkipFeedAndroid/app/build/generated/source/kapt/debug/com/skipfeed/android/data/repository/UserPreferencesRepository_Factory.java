package com.skipfeed.android.data.repository;

import android.content.Context;
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
public final class UserPreferencesRepository_Factory implements Factory<UserPreferencesRepository> {
  private final Provider<Context> contextProvider;

  public UserPreferencesRepository_Factory(Provider<Context> contextProvider) {
    this.contextProvider = contextProvider;
  }

  @Override
  public UserPreferencesRepository get() {
    return newInstance(contextProvider.get());
  }

  public static UserPreferencesRepository_Factory create(Provider<Context> contextProvider) {
    return new UserPreferencesRepository_Factory(contextProvider);
  }

  public static UserPreferencesRepository newInstance(Context context) {
    return new UserPreferencesRepository(context);
  }
}

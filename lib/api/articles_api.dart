import 'package:jaguar_retrofit/annotations/annotations.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_mimetype/jaguar_mimetype.dart';
import 'dart:async';

import 'package:realworld_flutter/model/generic_error_model.dart';
import 'package:realworld_flutter/model/single_article_response.dart';
import 'package:realworld_flutter/model/new_article_request.dart';
import 'package:realworld_flutter/model/update_article_request.dart';
import 'package:realworld_flutter/model/multiple_articles_response.dart';

part 'articles_api.jretro.dart';

@GenApiClient()
class ArticlesApi extends ApiClient with _$ArticlesApiClient {
  final Route base;
  final Map<String, CodecRepo> converters;
  final Duration timeout;

  ArticlesApi(
      {this.base, this.converters, this.timeout = const Duration(minutes: 2)});

  /// Create an article
  ///
  /// Create an article. Auth is required
  @PostReq(path: "/articles", metadata: {
    "auth": [
      {
        "type": "apiKey",
        "name": "Token",
        "keyName": "Authorization",
        "where": "header"
      }
    ]
  })
  Future<SingleArticleResponse> createArticle(
      @AsJson() NewArticleRequest article) {
    return super.createArticle(article).timeout(timeout);
  }

  /// Delete an article
  ///
  /// Delete an article. Auth is required
  @DeleteReq(path: "/articles/:slug", metadata: {
    "auth": [
      {
        "type": "apiKey",
        "name": "Token",
        "keyName": "Authorization",
        "where": "header"
      }
    ]
  })
  Future<void> deleteArticle(@PathParam("slug") String slug) {
    return super.deleteArticle(slug).timeout(timeout);
  }

  /// Get an article
  ///
  /// Get an article. Auth not required
  @GetReq(path: "/articles/:slug")
  Future<SingleArticleResponse> getArticle(@PathParam("slug") String slug) {
    return super.getArticle(slug).timeout(timeout);
  }

  /// Get recent articles globally
  ///
  /// Get most recent articles globally. Use query parameters to filter results. Auth is optional
  @GetReq(path: "/articles")
  Future<MultipleArticlesResponse> getArticles(
      @QueryParam("tag") String tag,
      @QueryParam("author") String author,
      @QueryParam("favorited") String favorited,
      @QueryParam("limit") int limit,
      @QueryParam("offset") int offset) {
    return super
        .getArticles(tag, author, favorited, limit, offset)
        .timeout(timeout);
  }

  /// Get recent articles from users you follow
  ///
  /// Get most recent articles from users you follow. Use query parameters to limit. Auth is required
  @GetReq(path: "/articles/feed", metadata: {
    "auth": [
      {
        "type": "apiKey",
        "name": "Token",
        "keyName": "Authorization",
        "where": "header"
      }
    ]
  })
  Future<MultipleArticlesResponse> getArticlesFeed(
      @QueryParam("limit") int limit, @QueryParam("offset") int offset) {
    return super.getArticlesFeed(limit, offset).timeout(timeout);
  }

  /// Update an article
  ///
  /// Update an article. Auth is required
  @PutReq(path: "/articles/:slug", metadata: {
    "auth": [
      {
        "type": "apiKey",
        "name": "Token",
        "keyName": "Authorization",
        "where": "header"
      }
    ]
  })
  Future<SingleArticleResponse> updateArticle(
      @PathParam("slug") String slug, @AsJson() UpdateArticleRequest article) {
    return super.updateArticle(slug, article).timeout(timeout);
  }
}

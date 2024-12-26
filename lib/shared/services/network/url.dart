class Url {
  static const baseURL = "";

  static List<String> excludedPath = [
    auth(AuthEndpoint.login),
    auth(AuthEndpoint.register),
  ];

  static String auth(AuthEndpoint authEndpoint) {
    switch (authEndpoint) {
      case AuthEndpoint.login:
        return "users/login";
      case AuthEndpoint.register:
        return "users/register";
      case AuthEndpoint.logout:
        return "users/logout";
    }
  }

  static String news(NewsEndpoint newsEndpoint, {int? id}) {
    switch (newsEndpoint) {
      case NewsEndpoint.getDetailNews:
        return "news/$id";
      case NewsEndpoint.getAllNews:
        return "news";
    }
  }
}

enum AuthEndpoint { login, register, logout }

enum NewsEndpoint { getDetailNews, getAllNews }
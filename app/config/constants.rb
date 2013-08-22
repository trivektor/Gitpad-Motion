APP_NAME = 'Gitpad Motion'
GITHUB_API_HOST = 'https://api.github.com'
OAUTH_PARAMS = {
  scopes: ['user', 'user:follow', 'public_repo', 'repo', 'repo:status', 'delete_repo', 'notifications', 'gist'],
  client_id: ENV['GITPAD_MOTION_ID'],
  client_secret: ENV['GITPAD_MOTION_SECRET']
}
APP_KEYCHAIN_IDENTIFIER = 'GitpadMotionKeychain1'
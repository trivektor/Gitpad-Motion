APP_NAME = 'Gitpad Motion'
GITHUB_API_HOST = 'https://api.github.com'
RAW_GITHUB_HOST = 'https://raw.github.com'
OAUTH_PARAMS = {
  scopes: ['user', 'user:follow', 'public_repo', 'repo', 'repo:status', 'delete_repo', 'notifications', 'gist'],
  client_id: ENV['GITPAD_MOTION_ID'],
  client_secret: ENV['GITPAD_MOTION_SECRET']
}
APP_KEYCHAIN_IDENTIFIER = 'GitpadMotionKeychain1'
APP_KEYCHAIN_ACCOUNT = 'gitpad_motion'
GITHUB_OCTOCAT = 'http://octodex.github.com/images/original.jpg'
AVATAR_PLACEHOLDER = 'avatar-placeholder.png'
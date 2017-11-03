require 'octokit'

client = Octokit::Client.new(access_token: ENV['API_TOKEN'])

user = client.user
p user.login

client.tags('hirakiuc/octokit_test').each do |tag|
  puts tag.name
end

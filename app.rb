require_relative './repo.rb'

repo = Repo.new('hirakiuc', 'octokit_test')

=begin
# Fetch tags
puts "tags"
repo.tags.each do |tag|
  puts tag.name
end
=end

=begin
# Fetch branches
puts "branches"
repo.branches.each do |branch|
  p branch
end
=end

=begin
# Fetch a branch
puts "master branch"
branch = repo.branch 'master'
p branch

prbr = repo.branch 'tag-0.0.2'
p prbr
=end

=begin
# Create branch from the tag
puts "tag 0.0.2"
tag = repo.tag('0.0.2')
throw "tag:0.0.2 does not found." unless tag

puts tag.ref
puts tag.object.sha

prbr = repo.branch 'tag-0.0.2'
if prbr
  puts "branch:tag-0.0.2 already exists."
else
  puts "Create branch:tag-0.0.2 from tag:0.0.2"
  prbr = repo.create_branch "tag-0.0.2", tag
end
=end

=begin
# Create pull request
pr = repo.create_pull 'releases/dev', 'tag-0.0.2', 'Update releases/dev', 'pull req body'
p pr.url
p pr.number
=end

#p repo.close_pull 3

pull = repo.pull(base: 'releases/dev', head: 'tag-0.0.2', state: 'open')
if pull
  p pull.number
else
  puts "NotFound"
end

#merged = repo.merge_pull(pull.number, 'LGTM!')
#p merged

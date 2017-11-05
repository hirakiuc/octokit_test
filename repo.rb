require 'octokit'

class Repo
  def initialize(owner, repo_name)
    @owner = owner
    @repo_name = repo_name

    @client = Octokit::Client.new(access_token: ENV['API_TOKEN'])
  end

  def tag(name)
    @client.ref slug, "tags/#{name}"
  rescue Octokit::NotFound
    nil
  end

  def tags
    @client.tags slug
  end

  def create_tag(base, name)
    @client.create_ref slug, "tags/#{name}", base
  end

  def branch(name)
    @client.ref(slug, "heads/#{name}")
  rescue Octokit::NotFound
    nil
  end

  def branches
    @client.refs slug, 'heads'
  end

  def create_branch(name, ref)
    @client.create_ref slug, "heads/#{name}", ref.object.sha
  end

  # Fetch a pull request
  #
  # @param [Hash] options
  # @option options [String] :base base branch name
  # @option options [String] :head user and branch name
  # @option options [String] :state pull request state
  def pull(options = {})
    @client.pulls(slug, options).first
  end

  def create_pull(base, head, title, body = nil, options = {})
    @client.create_pull_request slug, base, head, title, body, options
  rescue Octokit::UnprocessableEntity
    # The pull request already exists.
    pull(base: base, head: head, state: 'open').first
  end

  def close_pull(pull_no)
    @client.close_pull_request slug, pull_no
    # This does not throw error if the pull already closed.
  end

  def merge_pull(pull_no, msg = '', options = {})
    @client.merge_pull_request slug, pull_no, msg, options
  end

  private

  def slug
    "#{@owner}/#{@repo_name}"
  end
end

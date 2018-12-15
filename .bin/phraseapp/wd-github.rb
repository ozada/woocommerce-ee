require 'octokit'
require_relative 'const.rb'
require_relative 'env.rb'

class WdGithub
  def initialize
    @github = Octokit::Client.new(:access_token => Env::GITHUB_TOKEN)
    @log = Logger.new(STDOUT, level: Env::DEBUG ? 'DEBUG' : 'INFO')
  end

  def create_pr(repo, base, head, title, body)
    pr = @github.create_pull_request(repo, base, head, title, body)
    @log.info("View pull request here: #{pr.html_url}")
  rescue Octokit::UnprocessableEntity
    @log.info("A pull request already exists for #{repo}:#{head}")
  rescue Octokit::Error => e
    @log.fatal('Error while creating pull request.')
    @log.debug(e)
    exit(-1)
  end
end
